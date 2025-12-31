# Case 1 — Loop-invariant load hoisting blocked by alias uncertainty

## Kernel
`kernels/mlir/hoist_candidate.mlir`

Intent: Load `B[0]` inside a loop and store to `A[i]`. The address of `B[0]` is loop-invariant.

## Baseline lowering (no explicit alias disambiguation)
Artifacts (generated, not tracked):
- `outputs/hoist/hoist.ll`
- `outputs/hoist/hoist.O2.ll`
- `outputs/hoist/remarks.yml` / `outputs/hoist/remarks.O2.yml`

Observed behavior:
- In `hoist.O2.ll`, the load from `%6` remains inside the loop body.
- LLVM emits a missed LICM remark indicating the loop may invalidate the load’s value.

## Manual oracle: add `noalias`
Artifacts (generated, not tracked):
- `outputs/hoist/hoist.noalias.ll`
- `outputs/hoist/hoist.noalias.O2.ll`
- `outputs/hoist/remarks.noalias.yml` / `outputs/hoist/remarks.noalias.O2.yml`

Observed behavior:
- LICM reports `Passed: Hoisted`.
- In `hoist.noalias.O2.ll`, the load from `%6` is hoisted to the loop preheader.

## Conclusion
This case demonstrates that LLVM’s inability to prove non-aliasing between the store through `A[i]` and the load from `B[0]` blocks LICM hoisting. Providing standard LLVM alias disambiguation (`noalias`) enables the expected optimization.
