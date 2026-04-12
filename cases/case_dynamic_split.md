# Case — Dynamically-split subview disjointness lost during lowering; LICM, GVN, and vectorization blocked

## Kernel
`kernels/mlir/dynamic_split.mlir`

Intent: Receive a buffer `%A` and a runtime split index `%n`. Create two non-overlapping subviews:
- `lo = A[0 .. n-1]`  (offset 0, dynamic size n)
- `hi = A[n .. 2047]` (dynamic offset n, dynamic size 2048-n)

These subviews are **structurally disjoint at the MLIR level** by construction: `hi` starts exactly where `lo` ends. Inside the loop, read the loop-invariant `lo[0]` and store to `hi[i]`.

## Key MLIR structural fact
`memref.subview %A[0][%n][1]` and `memref.subview %A[%n][%hi_size][1]` tile the same base buffer end-to-end.
MLIR guarantees they are non-overlapping as long as `n >= 1` — a typical pre-condition imposed by the caller (e.g., a tiling pass).

## Baseline lowering (no alias metadata)
Artifacts:
- `outputs/dynamic_split/dynamic_split.ll`
- `outputs/dynamic_split/dynamic_split.O2.ll`
- `outputs/dynamic_split/remarks.O2.yml`

LLVM IR structure (baseline):
- Function arg `%5` = `n` (the runtime split index).
- `lo[0]` load  = `gep ptr %1, 0`          (load from base + 0)
- `hi[i]` store = `gep ptr %1, (%5 + %16)` (store to base + n + i)

Without knowing `n >= 1`, LLVM cannot prove `n + i ≠ 0` for all loop iterations,
so it conservatively treats the store as a potential clobber of the load.

Observed behavior:
- In `dynamic_split.O2.ll`, the invariant load `%12 = load float, ptr %1` **remains inside the loop** — it is **not hoisted** to the preheader.
- Remarks show `licm: LoadWithLoopInvariantAddressInvalidated` (×3 across pipeline runs).
- Remarks show `gvn: LoadClobbered` (×2) — GVN also cannot eliminate the redundant load.
- Remarks show `loop-vectorize: UnsafeDep` — vectorization is blocked by the unknown data dependence.

This is a **three-pronged miss**: LICM, GVN, and vectorization all fail due to the same root cause — missing alias disambiguation for dynamically-computed GEP offsets.

## Root cause
After lowering, the subview offset `n` becomes an `i64` function argument (`%5`). Both `lo` and `hi` accesses use the same base pointer (`ptr %1`). LLVM sees:
```
load  float, ptr (%1 + 0)
store float,       ptr (%1 + %5 + %16)
```
Without a lower bound on `%5`, LLVM cannot rule out `%5 + %16 = 0` (which would require `%5 = -i ≤ 0`). The structural MLIR invariant `n >= 1` is simply not present in the LLVM IR.

## Manual oracle: add `!alias.scope` / `!noalias` metadata
Artifacts:
- `outputs/dynamic_split/dynamic_split.oracle.ll`
- `outputs/dynamic_split/dynamic_split.oracle.O2.ll`
- `outputs/dynamic_split/remarks.oracle.O2.yml`

Oracle transformation:
- Assign an alias scope `!lo_scope` (under domain `!lo_domain`) representing all accesses to the `lo` subview region.
- Tag the invariant load (`lo[0]`) with `!alias.scope !{!lo_scope}`.
- Tag all `hi` loads and stores with `!noalias !{!lo_scope}`.

This encodes at the LLVM IR level what the MLIR structural split guarantees:
> "No access through `hi` can alias any access through `lo`."

Observed behavior after oracle:
- Remarks: `licm: Hoisted` — LICM **successfully hoists** the invariant load.
- The invariant load is folded away entirely by constant propagation (lo[0] holds the pre-stored value 1.0).
- The loop body simplifies to `hi[i] = hi[i] + 1.0` (a simpler, inlinable expression).
- Remarks: `loop-vectorize: VectorizationNotBeneficial` — the aliasing uncertainty is **resolved**; vectorization is now only blocked by cost model, not by an unknown data dependence.

## Comparison: what was blocked vs what is enabled
| Optimization | Baseline              | Oracle                    |
|:-------------|:----------------------|:--------------------------|
| LICM         | Missed (InvalidatedAddr) | **Passed (Hoisted)**   |
| GVN          | LoadClobbered (×2)    | LoadClobbered (×1, expected) |
| Vectorization | UnsafeDep (aliasing)  | VectorizationNotBeneficial (cost model only) |

## Conclusion
This case demonstrates a **dynamic-offset disjointness gap**: when a buffer is split at a runtime index `%n`, MLIR structurally guarantees the two halves are non-overlapping, but LLVM sees only two GEP computations from the same base pointer with a runtime offset. Without an explicit lower bound on `%n`, all three optimization passes (LICM, GVN, vectorization) are blocked.

The oracle shows that adding `!alias.scope` / `!noalias` metadata — encoding the structural MLIR disjointness guarantee at the LLVM IR level — fully resolves the aliasing uncertainty and enables the blocked optimizations.

This is the type of metadata our future MLIR-to-LLVM propagation pass would emit automatically for any pair of `memref.subview` operations that are provably disjoint at the MLIR structural level, even when their offsets are runtime values.
