# LLVM Alias Metadata Reference

## Alias Analysis in LLVM

LLVM's alias analysis answers the question: "Can two memory accesses refer to the same location?" Conservatively, any two accesses to the same base pointer may alias. LLVM uses several sources of information to narrow this:

- **Type-based alias analysis (TBAA):** Uses IR type metadata to assert that accesses through different types cannot alias (C strict-aliasing rules).
- **BasicAA:** Checks constant GEP offsets, object sizes, and other syntactic properties.
- **SCEV-based AA:** Uses scalar evolution to reason about loop induction variables and prove GEP expressions are non-overlapping.
- **Scoped alias metadata (`!alias.scope`/`!noalias`):** Explicit programmer/compiler annotations on individual load/store instructions.

For the thesis, SCEV-based AA is what LLVM 22 uses to prove disjointness of *static* GEP offsets, and scoped alias metadata is what our pass provides for *dynamic* offsets.

## LLVM 22: What It CAN Prove Without Metadata

LLVM 22 can prove disjointness in these cases (so our pass adds no value for them):
- Two GEPs with constant, non-overlapping offset ranges (e.g., `gep base, 0` vs `gep base, 512` when the first access covers at most 512 bytes).
- Stride-2 even/odd patterns when GEP constant offsets are distinct and SCEV can apply modular arithmetic.
- SSA-derived constants (e.g., `128 + 128 = 256`) via constant folding at compile time.

LLVM 22 CANNOT prove disjointness for:
- **Dynamic offset disjointness:** `gep base, n+i` vs `gep base, 0` when `n` is a runtime-unknown value. Even if the MLIR-level structural proof says `n >= 1`, that constraint does not survive lowering.
- **Function arg aliasing:** Two `ptr` parameters with no `noalias`/`separate_storage` annotations — LLVM conservatively assumes any caller could pass the same buffer for both.
- **Cross-function (noinline) alias info:** The callee has no access to the caller's structural proof that the two arguments were created from disjoint subviews.

## Scoped Alias Metadata: !alias.scope / !noalias

Scoped alias metadata explicitly encodes disjointness relationships between groups of memory accesses. It does not assert that two specific pointers cannot alias; it asserts that accesses *within one scope* cannot alias accesses that *declare they are outside that scope*.

### Structure

```llvm
; Domain: unique identity anchor
!domain = distinct !{!domain, !"domain_description"}

; Scope: belongs to a domain
!scope = distinct !{!scope, !domain, !"scope_description"}

; Scope list (used as the metadata operand)
!scope_list = !{!scope}
```

`distinct` is crucial: without it, two metadata nodes with the same content would be deduplicated and treated as the same scope. `distinct` forces a unique identity.

### Usage on Instructions

```llvm
; Access belongs to scope (lo region)
load float, ptr %x, !alias.scope !scope_list

; Access is NOT in scope (hi region — does not alias lo)
store float %v, ptr %y, !noalias !scope_list
```

**Semantics:** A load with `!alias.scope {S}` cannot alias a store with `!noalias {S}` (or any store that declares it is not in scope S). In the LICM use case: the store has `!noalias {lo_scope}`, so LICM can prove the store does not clobber the load with `!alias.scope {lo_scope}`, enabling the hoist.

### Asymmetric Structure Used by the Pass

The pass uses a single lo scope per pair. Lo-region accesses get `!alias.scope {lo_scope}`; hi-region accesses get `!noalias {lo_scope}`. There is no explicit hi scope. This is sufficient to encode "hi stores never alias lo loads," which is exactly what LICM needs.

A symmetric structure (lo scope + hi scope, each with the other in their noalias list) would also be correct and slightly more informative for other optimizations, but the asymmetric form is minimal and correct.

## Other LLVM Alias Mechanisms

### noalias on Function Parameters

```llvm
define void @f(ptr noalias %A, ptr noalias %B) { ... }
```

`noalias` on a function parameter asserts that the pointer does not alias any other pointer accessible from the function. This is correct when:
- The two pointers come from distinct allocations (e.g., `malloc` vs `malloc`)
- The pointed-to memory is not accessible through any other parameter

**Why this is wrong for subviews of the same allocation:** After MLIR lowering, both `lo` and `hi` subview descriptors carry the same `ptr aligned` field — both point to the start of the parent allocation. Only the `i64 offset` field differs. At the LLVM call site, both arguments have the same pointer value. Marking two parameters `noalias` when they have equal pointer values is undefined behaviour in LLVM IR.

### separate_storage (llvm.assume operand bundle)

```llvm
call void @llvm.assume(i1 true) ["separate_storage"(ptr %A, ptr %B)]
```

Asserts that `%A` and `%B` come from distinct allocations (equivalent to `noalias` on the parameters, but at a specific point in the IR). MLIR's `memref.distinct_objects` lowers to this.

**Why this is wrong for subviews:** Same reason as `noalias` on params — asserts distinct allocations, which is false for subviews of the same buffer. Using `separate_storage` on two pointers that have the same value is UB.

### noalias (allocation result)

```llvm
%p = call ptr @malloc(i64 100)  ; implied noalias on malloc result
```

New allocations are automatically `noalias` in LLVM IR. Not applicable for subviews.

## Remark Types Relevant to the Thesis

Emitted by `opt -pass-remarks=licm,gvn -pass-remarks-analysis=licm,gvn`:

| Remark | Pass | Meaning |
|---|---|---|
| `Hoisted` | `licm` | A load was successfully moved to the loop preheader |
| `LoadWithLoopInvariantAddressInvalidated` | `licm` | LICM found a load with a loop-invariant address but a store could alias it — hoist blocked |
| `LoadClobbered` | `gvn` | GVN attempted to eliminate a redundant load but a store could alias it — elimination blocked |
| `UnsafeDep` | `loop-vectorize` | Vectorization blocked due to unresolved data dependence (alias uncertainty) |
| `VectorizationNotBeneficial` | `loop-vectorize` | Vectorization considered but not applied due to cost model (alias is NOT the blocker) |
| `NeverInline` | `inline` | Function was not inlined due to `noinline` attribute |

Multiple miss remarks for the same instruction are expected: LICM runs more than once in the O2 pipeline (early LICM, post-inliner LICM, post-simplification LICM), and GVN runs independently. Each failed attempt emits its own remark.

## How LICM Uses Alias Scope Metadata

LICM's hoist condition (simplified):
1. The load address is loop-invariant.
2. No store inside the loop can write to the same address.

For condition 2, LICM calls the alias analysis oracle for each store-load pair. With scoped metadata:
- A store with `!noalias {S}` and a load with `!alias.scope {S}` → the oracle returns `NoAlias` → LICM can hoist.
- Without metadata → the oracle returns `MayAlias` → LICM cannot hoist.

The key: alias scope metadata makes the oracle return `NoAlias` for pairs that share the asymmetric scope structure, which is the case for all our lo-load/hi-store pairs.
