# Pass Design Reference

## Thesis Argument in One Paragraph

MLIR's `memref.subview` op encodes structural disjointness (partition-by-endpoint) between two regions of the same allocation. This structural proof is completely discarded during lowering to LLVM IR: both subviews become GEP arithmetic from the same base pointer, and LLVM has no basis to prove that their index ranges are non-overlapping when those ranges are determined by runtime values. As a result, LLVM's alias analysis conservatively assumes the regions may overlap, blocking LICM, GVN, and vectorization. The pass propagates the structural proof as LLVM `!alias.scope`/`!noalias` metadata, re-enabling the missed optimizations without introducing a new alias analysis.

## Why Two Passes

A single pass cannot detect disjointness (at the `memref.subview` level) and emit LLVM metadata (at the `llvm.load`/`llvm.store` level) simultaneously, because:

- Structural disjointness is visible only while `memref.subview` ops are in the IR. After `finalize-memref-to-llvm`, everything is flat GEP arithmetic and the subview relationships are gone.
- LLVM alias scope attributes must be attached to `llvm.load`/`llvm.store` ops, which do not exist until lowering happens.
- Discardable attributes on `memref.load`/`memref.store` do NOT survive `finalize-memref-to-llvm`. The standard conversion framework creates fresh `llvm.*` ops and does not copy discardable attrs from the source ops. Verified empirically.

Solution: run both passes before `finalize-memref-to-llvm`.
- Pass 1 tags `memref.load`/`memref.store` with discardable attributes encoding group ID and role.
- Pass 2 immediately converts only the tagged ops to `llvm.load`/`llvm.store` with alias metadata attached.
- The remaining untagged `memref.*` ops are then handled by the standard `finalize-memref-to-llvm`.

## Pass Interface: Attribute Contract

The two passes communicate exclusively via discardable attributes on `memref.load`/`memref.store` ops. No custom dialect is needed.

| Attribute | Type | Meaning |
|---|---|---|
| `alias_meta.group_id` | `IntegerAttr (i32)` | Alias group number. Pair N: lo = 2N, hi = 2N+1. |
| `alias_meta.role` | `StringAttr ("lo"/"hi")` | Which region of the pair this op accesses. |

These constants are defined in `pass/include/AliasMetaPropagation/Passes.h`:
```cpp
constexpr llvm::StringLiteral kAliasGroupAttr = "alias_meta.group_id";
constexpr llvm::StringLiteral kAliasRoleAttr  = "alias_meta.role";
constexpr llvm::StringLiteral kDisjointArgsAttr = "alias_meta.disjoint_args";  // defined, not used
```

Pass 1 writes `kAliasGroupAttr` and `kAliasRoleAttr`. Pass 2 reads them, emits LLVM metadata, and implicitly removes them (by replacing the tagged ops with fresh `llvm.*` ops that don't carry the attrs). `kDisjointArgsAttr` is defined in the header as a vestige of an earlier design but is not written or read by either pass.

## Pass Scope: ModuleOp

Both passes operate at `ModuleOp` scope (not `FuncOp`). This is required because the noinline callee handling involves cloning functions and inserting new `func.func` ops into the module — operations that cannot happen from within a single-function walk.

## Pipeline Position

```
alias-meta-opt --mark-alias-groups --lower-with-alias-meta input.mlir
                     ↓
              [tagged memref.load/store ops with alias_meta.* attrs]
              [llvm.load/store ops with !alias.scope/!noalias for tagged ops]
                     ↓
mlir-opt -convert-scf-to-cf -memref-expand ... -finalize-memref-to-llvm ...
                     ↓
              [all memref ops lowered; unrealized_conversion_casts resolved]
                     ↓
mlir-translate --mlir-to-llvmir
                     ↓
              [LLVM IR with !alias.scope/!noalias metadata nodes]
                     ↓
opt -passes="default<O2>"
                     ↓
              [optimized IR: LICM hoisted, GVN eliminated, vectorized]
```

Pass 2 must come before `finalize-memref-to-llvm` in the pipeline. The standard pass handles all untagged ops; Pass 2 handles only the tagged ones. The two passes cooperate and don't interfere.

## LLVM Alias Metadata Structure Produced

For each disjoint pair N, the output contains:

```llvm
; lo-region accesses
load float, ptr %x, !alias.scope !<lo_scope_list>
store float %v, ptr %y, !alias.scope !<lo_scope_list>

; hi-region accesses
load float, ptr %a, !noalias !<lo_scope_list>
store float %w, ptr %b, !noalias !<lo_scope_list>

; Metadata nodes
!<domain> = distinct !{!<domain>, !"pair_N_domain"}
!<lo_scope> = distinct !{!<lo_scope>, !<domain>, !"pair_N_lo"}
!<lo_scope_list> = !{!<lo_scope>}
```

The structure is asymmetric: lo-region ops declare membership in the lo scope; hi-region ops declare they are NOT in the lo scope. There is no explicit hi scope. This is the minimal form sufficient to encode "no hi access aliases any lo access," and it exactly matches the structure of all hand-written oracle files.

LLVM's LICM uses this to determine that a store with `!noalias {lo_scope}` cannot clobber a load with `!alias.scope {lo_scope}`, enabling the hoist.

## Why Not noalias on Function Parameters

For the noinline callee case, a natural instinct is to add `noalias` to the callee's pointer parameters. This is incorrect and constitutes undefined behaviour in LLVM IR.

After MLIR lowering, both subview descriptors carry the same `ptr aligned` field — both point to the start of the parent allocation. The distinction between the subviews is in the `i64 offset` field of the memref descriptor struct, not in the pointer value itself. At the LLVM IR level, both arguments have equal pointer values at the call site. Marking two parameters `noalias` when their pointer values are equal is LLVM IR undefined behaviour, regardless of whether the index ranges accessed through them overlap.

`llvm.assume ["separate_storage"(ptr A, ptr B)]` has the same problem: it asserts the pointers come from distinct allocations, which is false for subviews of the same buffer.

Alias scope metadata on individual loads/stores is the only correct mechanism for intra-allocation disjointness.

## Why Cloning for Noinline Callees

The naive approach for noinline callees — descend into the original callee and tag its loads/stores directly — is unsound. The original callee may be called from other sites where the disjointness property does not hold. Tagging the original callee's loads/stores would apply the metadata to all invocations, including those where the aliasing relationship is unknown.

Function specialization solves this: clone the callee into `@callee.__alias_meta_N`, redirect only the proven-disjoint call site to the clone, and tag the clone's loads/stores. The original callee is untouched and correctly handles any other call sites.

When both lo and hi of the same disjoint pair pass through the same call site, the pass shares a single clone (tracked in a `DenseMap<Operation*, func::FuncOp>` keyed on the call-site operation). Only one clone is created per call site regardless of how many subview pairs route through it.
