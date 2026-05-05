# Case - Dead store elimination (DSE) blocked by alias uncertainty on function arguments
# INVALIDATED: The pass has no structural basis for knowing the two function-argument memrefs
# are disjoint. Unlike subview_noalias, there is no caller providing subview-derived disjointness
# evidence. The DSE miss is real, but the root cause is identical to distinct_args_hoist_base
# (arbitrary function arguments that may alias). Not a new structural scenario.

## Kernel
`kernels/mlir/dse_blocked_alias.mlir`

Intent: A function receives two memref arguments `%A` (write target) and `%B` (read source).
Inside the loop, the body follows the pattern:
1. `A[i] = 0.0`    <- default initialisation (potentially dead)
2. `b = B[i]`      <- load from B (may observe the 0.0 if B aliases A)
3. `A[i] = b * b`  <- overwrite - this kills the first store if A and B don't alias

If the caller guarantees `%A` and `%B` are distinct allocations, the first `store 0.0` is a
**dead store**: `A[i]` is always overwritten in the same iteration before any observable read.
LLVM would normally eliminate it via DSE. But without alias disambiguation, it cannot.

## Baseline lowering
Artifacts:
- `outputs/dse_blocked_alias/dse_blocked_alias.ll`
- `outputs/dse_blocked_alias/dse_blocked_alias.O2.ll`
- `outputs/dse_blocked_alias/remarks.O2.yml`

Observed behavior:
- The O2 loop body contains **both** stores to `A[i]`:
  ```llvm
  store float 0.000000e+00, ptr %13   ; dead init - kept because B might alias A
  %15 = load float, ptr %14           ; load B[i]
  %16 = fmul float %15, %15
  store float %16, ptr %13            ; final store
  ```
- If `B = A`, the load from `B[i]` reads the `0.0` just stored, producing `0.0 * 0.0 = 0.0`
  instead of `old_A[i]^2`. The first store is therefore observable - LLVM must keep it.
- Remarks: `gvn: LoadClobbered` - the B[i] load cannot be simplified because the preceding
  store to A[i] is a potential clobber of B[i].
- DSE emits no remark (it simply doesn't fire; no "DSE: Missed" is emitted for this pattern).

## Manual oracle: add `noalias` to function pointer parameters
Artifacts:
- `outputs/dse_blocked_alias/dse_blocked_alias.noalias.ll`
- `outputs/dse_blocked_alias/dse_blocked_alias.noalias.O2.ll`
- `outputs/dse_blocked_alias/remarks.noalias.O2.yml`

Oracle transformation:
- Mark the aligned-pointer parameters for `%A` (`ptr %1`) and `%B` (`ptr %6`) as `noalias`.
- This is equivalent to what MLIR's lowering would emit if it propagated
  `memref.distinct_objects` to `llvm.assume("separate_storage", ...)`, or if the function
  signature carried MLIR's `restrict`-equivalent.

Observed behavior after oracle:
- The dead `store float 0.0` is **entirely eliminated**:
  ```llvm
  %15 = load float, ptr %14           ; load B[i]  (B cannot alias A)
  %16 = fmul float %15, %15
  store float %16, ptr %13            ; only store - A[i] = B[i]^2
  ```
- Remarks: no `gvn: LoadClobbered` - the B[i] load is no longer considered clobbered.

## What makes this case distinct
This is a **DSE (dead store elimination) miss**, unlike the other cases which show LICM/GVN misses.
- LICM misses are about loop-invariant loads that can't be hoisted.
- GVN misses are about redundant loads that can't be eliminated.
- DSE misses are about stores whose written value is **never observed** (because it is overwritten
  before any read), but can't be removed due to potential aliasing.

The pattern `init -> load-other -> overwrite` is common in ML kernels:
- Initialize output buffer to identity (0.0 for addition, 1.0 for multiplication, etc.)
- Accumulate or compute from source buffer
- The init store is dead if source != destination, but LLVM doesn't know this

Without alias information:
1. `store 0.0 -> A[i]`: LLVM cannot remove (might be observed by `B[i]` load).
2. `load B[i]`: LLVM cannot simplify (might be reading the just-stored 0.0).
This creates a two-pass problem: keeping the dead store also blocks GVN on the load.

## Conclusion
This case demonstrates that missing alias metadata in MLIR's function-argument lowering blocks
**dead store elimination**, not just LICM/GVN. The root cause is identical to the `distinct_args`
case - two separate memref function arguments lower to plain `ptr` parameters with no
`noalias`/`separate_storage` annotations - but the observable effect is on DSE rather than LICM.

This broadens the thesis claim: MLIR-to-LLVM alias metadata propagation is needed not only for
loop optimization (LICM, GVN) but also for eliminating unnecessary initialization stores, which
is critical for performance in elementwise kernel pipelines where buffers are initialized before
use.
