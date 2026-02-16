# Case 2 — Disjoint memref.subview halves reduced to pointer arithmetic; alias uncertainty blocks simplification

## Kernel
`kernels/mlir/subview_hoist_static.mlir`

Intent: Create two disjoint slices of a single buffer A - first half `[0..511]` and second half `[512..1023]`. Inside the loop, read from the first half (including an invariant read from A[0]) and store results into the second half.

## Baseline lowering (no explicit alias disambiguation)
Artifacts:
- `outputs/subview_memref_static/subview_memref_static.ll`
- `outputs/subview_memref_static/subview_memref_static.O2.ll`
- `outputs/subview_memref_static/remarks.O2.yml`

Observed behavior:
- In `subview_memref_static.ll`, both slices are represented as GEP/index arithmetic off the same malloc base pointer.
- In `subview_memref_static.O2.ll`, the loop still contains a repeated load from the base pointer `(load float, ptr %1)`, corresponding to A[0], even though A[0] was initialized before the loop.
- LLVM emits missed LICM/GVN-style remarks (e.g., invariant load not moved / load not eliminated) consistent with conservative aliasing: the store into the second half may clobber the first-half load when both are derived from the same base object.

## Manual oracle: add scoped alias metadata (!alias.scope)
Artifacts (generated, not tracked):
- `outputs/subview_memref_static/subview_memref_static_metadata.ll`
- `outputs/subview_memref_static/subview_memref_static_metadata.O2.ll`
- `outputs/subview_memref_static/remarks_metadata.O2.yml`

Observed behavior:
- In the oracle O2 output, the repeated invariant load from A[0] is eliminated and the loop body is simplified.
- Baseline loop includes: `load float, ptr %1` each iteration.
- Oracle loop removes that load and folds the invariant contribution (in this kernel it becomes + 0.0).
- This shows LLVM can optimize once it is given disjointness information in an encoding it understands at the memory-instruction level, rather than being forced to infer non-overlap from pointer arithmetic alone.

## Conclusion
This case demonstrates the `subview-to-pointer-arithmetic` gap: disjoint regions that are conceptually separate at the MLIR level become accesses through a shared base pointer in LLVM IR. Without explicit disambiguation, LLVM stays conservative and misses simplifications. Providing LLVM scoped alias metadata enables additional optimizations (here, elimination of the repeated invariant load and simplification of the loop body).
