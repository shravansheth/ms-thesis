# Pass Implementation Log

This document records every decision, problem, and resolution encountered during
the implementation of the two-pass alias metadata propagation pipeline. It is
written as a technical narrative and is the authoritative record of what was
built and why.

---

## Phase Overview

The pass system has three components:

| Pass | Name | Role |
|---|---|---|
| Pre-pass | `MaterializePrefixSubviews` | ClangIR normalization: synthesize explicit prefix subview at call sites where the base memref is passed unchanged alongside a suffix subview |
| Pass 1 | `MarkAliasGroups` | Static analysis: walk `memref.subview` ops, detect disjoint pairs, tag loads/stores with discardable attributes |
| Pass 2 | `LowerWithAliasMeta` | Targeted lowering: convert tagged `memref.load`/`memref.store` -> `llvm.load`/`llvm.store` with LLVM alias scope metadata |

The pre-pass was added later to support the ClangIR-lowered benchmark path in `final_benchmark/`. The six hand-written case-study kernels do not require it. The final state of each file is described below.

---

## Pass 1: MarkAliasGroups

**File:** `pass/lib/MarkAliasGroupsPass.cpp`

### What it does

Walks every `func.func` in the module. For each function, it:

1. Collects all `memref.subview` ops grouped by their source (base) memref SSA value into a `DenseMap<Value, SmallVector<SubViewOp>>`.
2. For each base, tries all `(a, b)` pairs. Determines which is `lo` and which is `hi` by checking if `isPartitionByEndpoint(a, b)` or `isPartitionByEndpoint(b, a)`.
3. Assigns group IDs: `lo = 2N`, `hi = 2N+1` for pair N (monotonically incrementing `nextPairId`).
4. Calls `tagUsesOfValue(lo.getResult(), loId, "lo", ...)` and `tagUsesOfValue(hi.getResult(), hiId, "hi", ...)`.

### Disjointness check: `isPartitionByEndpoint`

The core structural invariant:
```
hi.offset[d] == lo.offset[d] + lo.size[d]
```

Three forms are recognized in any subview dimension:

**Form A - SSA identity when lo.offset == 0:**
```
lo.offset == 0  AND  hi.offset IS lo.size (same Value or same constant)
```
This covers `dynamic_split`: lo = `subview base[0][n][1]`, hi = `subview base[n][2048-n][1]`. Here hi.offset is the same SSA value as lo.size.

**Form B - `arith.addi` chain:**
```
hi.offset = arith.addi(lo.offset, lo.size)  (in either operand order)
```
This covers `adjacent_tiles`: lo = `subview base[tile*N][N][1]`, hi = `subview base[tile*N+N][N][1]` where `tile*N+N = addi(tile*N, N)`.

**Form C - all compile-time constants satisfying the equation:**
```
hi_off == lo_off + lo_size  (all OpFoldResult constant integers)
```
This is a catch-all for cases where everything is statically known.

`isPartitionByEndpoint` also checks same base (`lo.getSource() == hi.getSource()`) and same rank.

### Tagging: `tagUsesOfValue`

A worklist-based def-use traversal starting from the subview result:

- `memref.load` / `memref.store` -> call `tagOp(user, groupId, role, ctx)` which attaches `alias_meta.group_id` (i32 IntegerAttr) and `alias_meta.role` (StringAttr "lo"/"hi") as discardable attributes.
- `memref.cast` -> follow through to the cast result (continue traversal).
- `memref.reinterpret_cast` -> follow through (ClangIR ABI compatibility pattern).
- `memref.subview` (as source) -> follow through to the subview result (subview-of-subview: any access within a proven sub-region is still within the proven region).
- `memref.store` (as value operand for a MemRef-typed value) -> follow the descriptor traffic: find the alloca slot, then all reloads from it, and push their results onto the worklist (ClangIR one-slot alloca pattern).
- `func.call` that is noinline -> perform function specialization (see below). The clone's argument is then tagged via a recursive call to `tagUsesOfValue`, applying the same chain-following rules inside the clone body.

The noinline check looks for `no_inline` attribute on either the call site or the callee function symbol (`isNoinlineCall`).

### Key header fix

`mlir/IR/OpFoldResult.h` does not exist in LLVM 22. The correct headers are:
- `mlir/Dialect/Utils/StaticValueUtils.h` - for `getConstantIntValue`, `isConstantIntValue`
- `mlir/IR/OperationSupport.h` - for the `OpFoldResult` type

### Verified output (all 6 kernels)

All 6 kernels produce correct tagging when run through `alias-meta-opt --mark-alias-groups`:

| Kernel | lo ops tagged | hi ops tagged | Notes |
|---|---|---|---|
| `subview_noalias` | 2 loads + 1 store | 1 store | Callee body ops tagged (noinline) |
| `dynamic_split` | 1 store + 1 load | 1 load + 1 store | Form A detection |
| `adjacent_tiles` | 2 loads | 1 store | Form B detection |
| `matrix_row_split` | 1 store + 2 loads (2D) | 1 store | Form A detection |
| `tiling_noinline` | 2 loads | 1 store | Callee body ops tagged (noinline) |

---

## Pass 2: LowerWithAliasMeta

**File:** `pass/lib/LowerWithAliasMetaPass.cpp`

### Design decisions

**Decision 1: Run before `finalize-memref-to-llvm`, not after.**

Discardable attributes on `memref.load`/`memref.store` do NOT survive the standard `finalize-memref-to-llvm` DialectConversion - the conversion framework creates new `llvm.load`/`llvm.store` ops and does not copy attrs from the source op. Verified empirically.

Therefore Pass 2 must run BEFORE `finalize-memref-to-llvm`, converting only the tagged ops itself. The remaining untagged ops are then handled by the standard pass.

**Decision 2: Use `applyPartialConversion` with `LLVMTypeConverter`.**

This is the standard MLIR mechanism for targeted pre-lowering. The `ConversionTarget` marks tagged `memref.load`/`memref.store` as illegal (they must be converted), and everything else as dynamically legal. The `LLVMTypeConverter` provides type conversion and the `adaptor` mechanism - which inserts `unrealized_conversion_cast` ops to bridge from `MemRefType` to the LLVM struct type. These casts are resolved at the end of the pipeline by `reconcile-unrealized-casts`.

**Decision 3: Use `ConvertOpToLLVMPattern` + `getStridedElementPtr`.**

`ConvertOpToLLVMPattern` (from `mlir/Conversion/LLVMCommon/Pattern.h`) provides `getStridedElementPtr(rewriter, loc, memRefType, adaptorMemref, indices, noWrapFlags)`. This computes the linearized GEP (base + offset + sum(idx_i * stride_i)) correctly for strided/offset memrefs, exactly matching what `finalize-memref-to-llvm`'s own `LoadOpLowering` does.

**Decision 4: One `AliasScopeDomainAttr` + one `AliasScopeAttr` (lo scope) per pair.**

The oracle structure is asymmetric: lo-region accesses get `alias_scopes = [lo_scope]` and hi-region accesses get `noalias_scopes = [lo_scope]`. There is no explicit hi scope. This is the minimal form that tells LLVM "hi stores never alias lo loads." The pair scopes are built once in `buildPairScopes()` before the conversion runs.

### What it does

1. **`buildPairScopes()`**: walks the module, collects every unique `pairId = groupId / 2`, creates one `AliasScopeDomainAttr` and one `AliasScopeAttr` (lo scope) per pair. These attrs use `DistinctAttr::create(UnitAttr::get(ctx))` internally for unique identity - this is what makes them translate to distinct `!N` nodes in the final LLVM IR.

2. **`TaggedLoadLowering`**: `ConvertOpToLLVMPattern<memref::LoadOp>`, only matches ops with `kAliasGroupAttr`. Calls `getStridedElementPtr` to get the address, creates `LLVM::LoadOp`, then calls `setAliasScopesAttr` (lo) or `setNoaliasScopesAttr` (hi) with `ArrayAttr::get(ctx, {loScope})`.

3. **`TaggedStoreLowering`**: same but for `memref::StoreOp`, calls `setAliasScopesAttr` or `setNoaliasScopesAttr`, then `rewriter.eraseOp`.

4. **`runOnOperation()`**: builds pair scopes, sets up `LLVMTypeConverter` + `ConversionTarget` + `RewritePatternSet`, runs `applyPartialConversion`.

### API details

| What | API |
|---|---|
| Create domain | `LLVM::AliasScopeDomainAttr::get(ctx, StringAttr description)` |
| Create scope | `LLVM::AliasScopeAttr::get(domain, StringAttr description)` |
| Set alias_scopes on load | `llvmLoad.setAliasScopesAttr(ArrayAttr::get(ctx, {loScope}))` |
| Set noalias_scopes on load | `llvmLoad.setNoaliasScopesAttr(ArrayAttr::get(ctx, {loScope}))` |
| Set alias_scopes on store | `llvmStore.setAliasScopesAttr(...)` |
| Set noalias_scopes on store | `llvmStore.setNoaliasScopesAttr(...)` |
| Address computation | `getStridedElementPtr(rewriter, loc, memRefType, adaptor.getMemref(), adaptor.getIndices(), kNoWrapFlags)` |

Note: the setter names are `setAliasScopesAttr` and `setNoaliasScopesAttr` (lowercase 'a' in noalias - matching the `$noalias_scopes` TableGen field name).

Note: `rewriter.create<LLVM::LoadOp>()` is deprecated in LLVM 22 - use `LLVM::LoadOp::create(rewriter, ...)` instead.

---

## Pipeline Script

**File:** `scripts/run_pipeline_cpu_with_meta.sh`

Mirrors `run_pipeline_cpu.sh` but inserts our two passes before the standard lowering:

```
# Case-study kernels:
1. alias-meta-opt --mark-alias-groups --lower-with-alias-meta input.mlir -> prefix.meta.mlir

# ClangIR benchmarks (pre-pass needed):
1. alias-meta-opt --materialize-prefix-subviews --mark-alias-groups --lower-with-alias-meta input.mlir -> prefix.meta.mlir

2. mlir-opt [standard lowering pipeline] prefix.meta.mlir -> prefix.llvm_dialect.mlir
3. mlir-translate --mlir-to-llvmir -> prefix.ll
4. opt -passes=dot-cfg -> CFG PNGs
```

Then use the existing `run_opt_emit_ll.sh` to run O2 and collect remarks:
```bash
bash scripts/run_pipeline_cpu_with_meta.sh kernels/mlir/<name>.mlir outputs/<name>/<name>.meta
bash scripts/run_opt_emit_ll.sh outputs/<name>/<name>.meta.ll \
    outputs/<name>/<name>.meta.O2.ll \
    outputs/<name>/remarks.meta.O2.yml
```

---

## Problems Encountered and Resolved

### Problem 1: `mlir/IR/OpFoldResult.h` not found

`OpFoldResult` was added as an include in Pass 1 but this header doesn't exist in LLVM 22. Fix: use `mlir/Dialect/Utils/StaticValueUtils.h` (for `getConstantIntValue`/`isConstantIntValue`) and `mlir/IR/OperationSupport.h` (for `OpFoldResult` type, via transitive include).

### Problem 2: Plugin ODR violation crash

The plugin (`AliasMetaPropagationPlugin.dylib`) loaded into `mlir-opt` crashes with:
```
Assertion failed: (passState && "pass state was never initialized")
```
at `mlir::Pass::getPassState()` inside the plugin. This is a classic macOS ODR (One Definition Rule) violation: inline functions like `Pass::getPassState()` have separate copies in the plugin and host binary. The `-flat_namespace -undefined suppress` linker option in `plugin/CMakeLists.txt` is supposed to fix this but does not fully eliminate all inline copies.

**Resolution:** Use `alias-meta-opt` (the standalone binary) instead of the plugin approach for running and testing. The standalone binary links everything together, avoiding any ODR issues. The plugin still exists for completeness but should not be used for execution.

Note: `alias-meta-opt` only has our three passes registered (not the full suite of standard MLIR passes). It is used exclusively for the two-step pipeline:
1. `alias-meta-opt` runs our passes (pre-pass optional, then mark-alias-groups, then lower-with-alias-meta)
2. `mlir-opt` runs the standard passes

### Problem 3: `alias-meta-opt` uses single-dash pass flags

The standalone binary registers passes as plain CLI boolean flags (`--mark-alias-groups`, `--lower-with-alias-meta`), not via the MLIR pass pipeline mechanism. So use:
```bash
alias-meta-opt --mark-alias-groups --lower-with-alias-meta input.mlir
```
NOT the `--pass-pipeline=...` form (which is for `mlir-opt` with MLIR pass registration).

### Problem 4: Discardable attrs don't survive `finalize-memref-to-llvm`

Verified empirically: attaching `{alias_meta.group_id = 0 : i32}` to a `memref.load` and running `finalize-memref-to-llvm` produces a plain `llvm.load` with no attrs. The standard conversion patterns do not copy discardable attrs. This is why Pass 2 must run before `finalize-memref-to-llvm` as a partial conversion that handles the tagged ops itself.

### Problem 5: `rewriter.create<>()` deprecation

In LLVM 22, `OpBuilder::create<OpTy>()` is deprecated. Use `OpTy::create(rewriter, ...)` instead. Affected: `LLVM::LoadOp::create(rewriter, loc, ...)` and `LLVM::StoreOp::create(rewriter, loc, ...)`.

---

## Validation Results

Full pipeline run on all 5 kernels: `run_pipeline_cpu_with_meta.sh` -> `run_opt_emit_ll.sh`.

### LICM and vectorization results (remarks.meta.O2.yml vs remarks.O2.yml)

| Kernel | Baseline hoisted | Pass hoisted | Baseline misses | Pass misses |
|---|---|---|---|---|
| `dynamic_split` | 1 | 1 | 7 | **0** |
| `adjacent_tiles` | 2 | **3** | 4 | **0** |
| `matrix_row_split` | 5 | 5 | 5 | **0** |
| `subview_noalias` | 2 | **3** | 5 | **0** |
| `tiling_noinline` | 2 | **3** | 4 | **0** |
| `vectorize_split` | 1 | 1† | 7 | **0** |
| **Total** | **13** | **16** | **32** | **0** |

†Same explicit hoist count as baseline; the lo[0] data load hoist is immediately folded by SCCP.
The primary contribution of `vectorize_split` is vectorization enabling, not hoist count.

"Misses" counts: `LoadWithLoopInvariantAddressInvalidated` + `LoadClobbered` from LICM/GVN
passes - cases where LLVM sees a loop-invariant address but cannot hoist because it cannot
prove the store doesn't alias.

**With our metadata, all 32 misses across 6 kernels drop to 0.** Three kernels gain an additional
explicit LICM hoist. `vectorize_split` additionally resolves the `UnsafeDep` vectorization
safety block - the baseline loop remains scalar even with `-force-vector-width=4`; the pass
variant vectorizes cleanly with fvw4 (3.76× on Apple M-series).

### LLVM IR alias metadata structure produced

Example from `dynamic_split.meta.ll` (after `mlir-translate`):

```llvm
; lo store (initial store outside loop)
store float 1.000000e+00, ptr %44, align 4, !alias.scope !1

; lo load (inside loop - invariant address, now hoistable)
%51 = load float, ptr %50, align 4, !alias.scope !1

; hi load (inside loop)
%56 = load float, ptr %55, align 4, !noalias !1

; hi store (inside loop)
store float %57, ptr %61, align 4, !noalias !1

!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
```

This matches the structure of the hand-written oracle files (`dynamic_split.oracle.ll`, etc.) that were used to validate the thesis hypothesis.

---
