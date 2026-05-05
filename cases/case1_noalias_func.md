# Case 3 - Caller-known disjoint subviews are lost across a noinline boundary; callee misses LICM/GVN

## Kernel
`kernels/mlir/subview_noalias.mlir`

Intent: In the caller, create two disjoint `memref.subview` halves of a single buffer `A`:
- `slice0 = A[0..511]`
- `slice1 = A[512..1023]`

Then call a **noinline** callee `@kernel(p, q)` where:
- `p` refers to `slice0`
- `q` refers to `slice1`

Inside `@kernel`, the loop repeatedly loads an invariant value from `p[0]` and stores into `q[i]`.

## Baseline lowering (no interprocedural alias disambiguation)
Artifacts:
- `outputs/subview_noalias/subview_noalias.ll`
- `outputs/subview_noalias/subview_noalias.O2.ll`
- `outputs/subview_noalias/remarks.O2.yml`

Observed behavior:
- At the caller site, MLIR constructs `slice0` and `slice1` via `memref.subview` with constant offsets/sizes. At this level, disjointness is explicit.
- However, `@kernel` is marked `noinline`, so the callee does not “see” how `p` and `q` were derived. After lowering, the callee’s parameters are just pointer-like arguments (memref descriptors / base pointers + offsets) with **no proven relationship** between them.
- In the optimized O2 output, the callee’s loop still contains a repeated load corresponding to `p[0]` (the invariant load). LLVM must conservatively assume the store to `q[i]` might alias `p[0]` because the function must be correct for arbitrary callers (including overlapping `p` and `q`).
- This is a missed LICM/GVN opportunity: the invariant load from `p[0]` is not hoisted to a preheader, even though at the call site `p` and `q` originate from disjoint subviews.

## Manual oracle: specialize the callee via cloning (`@kernel.noalias`) and rewrite the call site
Artifacts:
- `outputs/subview_noalias/subview_noalias_dup.ll`
- `outputs/subview_noalias/subview_noalias_dup.O2.ll`

Oracle transformation:
1. Clone the callee: `@kernel` -> `@kernel.noalias`.
2. Restrict the specialized clone to call sites where we can prove the arguments come from disjoint subviews (here, `slice0` and `slice1` are non-overlapping ranges of `A`).
3. In `@kernel.noalias`, attach disambiguation that LLVM understands, either:
   - argument-level `noalias` on the specialized function (when applicable)
4. Rewrite the call site: `call @kernel(p, q)` -> `call @kernel.noalias(p, q)` only when the proof holds.

Observed behavior after specialization:
- In the manual oracle O2 output, the invariant load from `p[0]` is now hoisted, because LLVM is allowed to assume `p`-accesses do not alias `q`-accesses for this specialized version.
- The callee loop becomes simpler, demonstrating that the missed optimization in the baseline was due to missing interprocedural alias information rather than an intrinsic inability of LLVM to optimize the pattern.

## Conclusion
This case demonstrates an **metadata-loss / propagation gap**:
- MLIR has explicit structure at the caller (`memref.subview`) that proves `p` and `q` refer to disjoint regions of the same base buffer.
- Because the callee is `noinline`, that structure is not available inside the callee, and LLVM must assume `p` and `q` may alias.
- As a result, LLVM misses optimizations like LICM/GVN in the callee (failure to hoist or eliminate an invariant load from `p[0]`).
- Cloning `@kernel` into `@kernel.noalias` and rewriting proven call sites makes the alias relationship explicit to LLVM and enables the missed optimizations.