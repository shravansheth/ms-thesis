# Pass 1: MarkAliasGroups — Implementation Reference

**File:** `pass/lib/MarkAliasGroupsPass.cpp`

## What It Does

Walks every `func.func` in the module. For each function:
1. Collects all `memref.subview` ops, grouped by their source (base) SSA value into a `DenseMap<Value, SmallVector<SubViewOp>>`.
2. For each base memref with two or more subviews, tries all unordered pairs `(a, b)`. Determines which is `lo` and which is `hi` by checking `isPartitionByEndpoint(a, b)` or `isPartitionByEndpoint(b, a)`.
3. Assigns group IDs: pair N gets `lo = 2N`, `hi = 2N+1`. `nextPairId` increments monotonically across all functions in the module.
4. Calls `tagUsesOfValue(lo.getResult(), loId, "lo", ...)` and `tagUsesOfValue(hi.getResult(), hiId, "hi", ...)` to walk def-use chains and tag memory ops.

## Disjointness Check: isPartitionByEndpoint

Core invariant:
```
hi.offset[d] == lo.offset[d] + lo.size[d]
```

Checked on dimension 0 only (covers all 5 case-study kernels).

`isPartitionByEndpoint(lo, hi)` first verifies:
- `lo.getSource() == hi.getSource()` — same base memref
- `lo.getMixedOffsets().size() == hi.getMixedOffsets().size()` — same rank

Then calls `isPartitionByEndpointDim(lo, hi, 0)`.

### Three Recognized Forms (isPartitionByEndpointDim)

All three are checked in order. Uses `OpFoldResult` (which can hold either a `Value` or a constant `IntegerAttr`).

**Form A — SSA identity when lo.offset == 0:**
```
lo.offset[0] == 0  AND  (hi.offset[0] IS lo.size[0] as same SSA Value
                         OR hi.offset[0] == lo.size[0] as same constant)
```
Uses `isConstantIntValue(loOff, 0)` and then either `hiOff == loSize` (same `OpFoldResult` → same SSA Value) or matching `getConstantIntValue`. Covers `dynamic_split`: `lo = A[0..n-1]`, `hi = A[n..]` where `n` is the same SSA value for both lo.size and hi.offset.

**Form B — arith.addi chain:**
```
hi.offset[0] = arith.addi(lo.offset[0], lo.size[0])  (either operand order)
```
Casts `hiOff`, `loOff`, `loSize` to `Value` (fails if any are folded constants), then looks for a defining `arith::AddIOp` with the right operands. Covers `adjacent_tiles`: `dst_off = addi(src_off, N)` where `src_off = muli(tile, N)` and `src.size = N`.

**Form C — all compile-time constants:**
```
getConstantIntValue(hi.offset) == getConstantIntValue(lo.offset) + getConstantIntValue(lo.size)
```
Catch-all for the all-static case. Note: when all offsets are statically known, LLVM 22 can already prove disjointness via GEP constant arithmetic, so Form C may not produce observable improvements in practice.

**Known gap:** Form B fails when `lo.offset` or `lo.size` is a folded constant in an `OpFoldResult` (i.e., an `IntegerAttr` rather than a `Value`). The mixed case (one live, one constant) is not covered. This is an incompleteness (missed optimization), not a miscompilation. Form C does not rescue this because Form C requires all three to be constants.

## Tagging: tagUsesOfValue

```cpp
static void tagUsesOfValue(Value startVal, uint32_t groupId, StringRef role,
                            MLIRContext *ctx, ModuleOp moduleOp,
                            DenseMap<Operation *, func::FuncOp> &callSiteClones,
                            uint32_t &cloneCounter)
```

Worklist-based def-use traversal starting from the subview result. Uses `SmallPtrSet<Value, 8>` to avoid revisiting.

For each user of a worklist value:
- **`memref.load` / `memref.store`**: call `tagOp(user, groupId, role, ctx)` which attaches `alias_meta.group_id` (i32) and `alias_meta.role` ("lo"/"hi") as discardable attrs.
- **`memref.cast`**: push the cast result onto the worklist and continue. This handles the `memref.cast` that appears in the noinline case when static-offset subviews are cast to dynamic-offset memrefs before the call.
- **`func.call` (noinline)**: perform function specialization (see below).

### Noinline Callee Specialization

Triggered when `isNoinlineCall(callOp, moduleOp)` returns true. Checks for `no_inline` attribute on the call-site op or on the callee function symbol.

```
Get-or-create clone for this specific call site:
  key = callOp.getOperation()  (raw Operation*, stable identity)
  
  if key in callSiteClones:
    use existing clone
  else:
    clonedFn = calleeFn.clone()           // copies entire function body
    cloneName = calleeFn.getName() + ".__alias_meta_" + cloneCounter++
    clonedFn.setName(cloneName)
    insert clonedFn into module (push_back into front block of module region)
    callOp.setCallee(cloneName)           // redirect this call site
    callSiteClones[key] = clonedFn
```

After obtaining the clone, tag the clone's argument uses:
```
for each (idx, arg) in enumerate(callOp.getArgOperands()):
  if arg != v: continue
  cloneArg = clonedFn.getArgument(idx)
  if cloneArg.getType() is not MemRefType: continue
  for each user of cloneArg:
    if user is memref.load or memref.store:
      tagOp(user, groupId, role, ctx)
```

Note: tagging goes one level deep into the clone. There is no further recursion (e.g., if the clone itself has a noinline call). This is sufficient for all 5 case-study kernels.

The DenseMap `callSiteClones` is shared across both `tagUsesOfValue` calls (lo and hi of the same pair). This ensures both calls contribute tags to the SAME clone rather than creating two separate clones for the same call site.

## tagOp Helper

```cpp
static void tagOp(Operation *op, uint32_t groupId, StringRef role, MLIRContext *ctx) {
  op->setDiscardableAttr(kAliasGroupAttr,
      IntegerAttr::get(IntegerType::get(ctx, 32), groupId));
  op->setDiscardableAttr(kAliasRoleAttr, StringAttr::get(ctx, role));
}
```

Uses `setDiscardableAttr` — this is the MLIR mechanism for attaching out-of-dialect attributes that are safe to strip. No dialect registration required.

## Key Headers (LLVM 22)

`mlir/IR/OpFoldResult.h` does not exist in LLVM 22. Use:
- `mlir/Dialect/Utils/StaticValueUtils.h` — for `getConstantIntValue`, `isConstantIntValue`
- `mlir/IR/OperationSupport.h` — for `OpFoldResult` type (transitively)

## Verified Tagging (All 6 Kernels)

| Kernel | lo ops tagged | hi ops tagged | Detection form |
|---|---|---|---|
| `dynamic_split` | 1 store + 1 load | 1 load + 1 store | Form A |
| `adjacent_tiles` | 2 loads | 1 store | Form B |
| `matrix_row_split` | 1 store + 2 loads (2D) | 1 store | Form A |
| `subview_noalias` | 2 loads + 1 store (in clone `@kernel.__alias_meta_0`) | 1 store (in clone) | Form C (static offsets) |
| `tiling_noinline` | 2 loads (in clone `@tile_stencil.__alias_meta_0`) | 1 store (in clone) | Form B |
| `vectorize_split` | 1 store + 1 load | 1 load + 1 store | Form A |
