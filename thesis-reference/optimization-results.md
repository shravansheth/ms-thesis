# Optimization Results Reference

## Interpretation Guide

### What is the Baseline

The baseline is the standard MLIR lowering pipeline run without our passes: `mlir-opt` applies the standard dialect conversion sequence (`-convert-scf-to-cf`, `-finalize-memref-to-llvm`, etc.), `mlir-translate` produces LLVM IR, and `opt -O2` optimizes with remarks. No alias metadata is injected at any step. LLVM sees only flat GEP pointer arithmetic; it has no knowledge of the structural disjointness encoded in the original `memref.subview` ops.

The pass version inserts our two passes before the standard lowering step and is otherwise identical.

### Remark Types

Remarks are collected from `opt -pass-remarks=licm,gvn -pass-remarks-analysis=licm,gvn`.

**Hoisted** (from `licm`): LICM moved a load out of the loop to the preheader. This is a successful optimization. Higher is better.

**Misses** (from `licm`/`gvn`): Either LICM or GVN found a loop-invariant load address but could not prove the intervening store did not alias it, so the load stayed in the loop. Key miss names:
- `LoadWithLoopInvariantAddressInvalidated`: LICM blocked a hoist
- `LoadClobbered`: GVN blocked redundant-load elimination

A single blocked load generates multiple miss remarks: LICM runs more than once in the O2 pipeline (early LICM, post-inliner LICM, post-simplification LICM), and GVN runs independently. Each failed attempt emits its own remark. This is why 7 misses appear for `dynamic_split` even though there is only one physically blocked load.

**Pass Misses = 0 does not by itself measure speedup.** It confirms the alias uncertainty is gone. The actual runtime benefit shows up in the hoisted count and the instruction reduction.

### Hoisted Count Caveats

The `Hoisted` count includes ALL successful LICM hoists in the module: GEP computations, loop bounds, pointer arithmetic, and data loads. Most baseline hoists are of GEP/pointer arithmetic that has nothing to do with alias disambiguation. Only the newly enabled hoists (delta from baseline to pass) are attributable to our metadata.

In `dynamic_split` and `matrix_row_split`, the pass-enabled hoist of `lo[0]` is immediately followed by SCCP constant-folding that value to `1.000000e+00`. The hoist then fold sequence means the load disappears from the IR entirely, producing no `Hoisted` remark for it. The improvement is real (visible in the loop body IR as a removed load) but invisible in the remark count. This is why `dynamic_split` and `matrix_row_split` show equal hoisted counts in baseline and pass.

## Results Table

| Kernel | Baseline Hoisted | Pass Hoisted | Baseline Misses | Pass Misses |
|---|---|---|---|---|
| `dynamic_split` | 1 | 1 | 7 | **0** |
| `adjacent_tiles` | 2 | 3 | 4 | **0** |
| `matrix_row_split` | 5 | 5 | 5 | **0** |
| `subview_noalias` | 2 | 3 | 5 | **0** |
| `tiling_noinline` | 2 | 3 | 4 | **0** |
| `vectorize_split` | 1 | 1† | 7 | **0** |
| **Total** | **13** | **16** | **32** | **0** |

†Same hoist count as baseline (GEP hoist); the lo[0] data load hoist is immediately folded by SCCP and does not appear as a remark. The primary contribution of this case is vectorization enabling, not LICM count.

Three kernels gain one explicit extra hoist (`adjacent_tiles`, `subview_noalias`, `tiling_noinline`). Two kernels have equal hoisted counts but real improvements in IR load count (`dynamic_split`, `matrix_row_split`). `vectorize_split` also has an equal hoist count, but uniquely enables SIMD vectorization as its primary outcome.

## Hot Loop Instruction Reduction

In all 5 kernels, the baseline hot loop body has the same structure: one load of a loop-invariant value (`lo[0]`) whose address never changes, and one load of the varying element (`hi[i]`). The invariant load should execute once before the loop, not once per iteration. The alias uncertainty prevents LICM from hoisting it.

| Kernel | Baseline loads/iter | Pass loads/iter | What happens to the invariant load |
|---|---|---|---|
| `dynamic_split` | 2 | 1 | Hoisted, then constant-folded to 1.0 by SCCP |
| `adjacent_tiles` | 2 | 1 | Hoisted to loop preheader |
| `matrix_row_split` | 2 | 1 | Hoisted, then constant-folded to 1.0 by SCCP |
| `subview_noalias` | 2 | 1 | Hoisted to preheader of cloned callee |
| `tiling_noinline` | 2 | 1 | Hoisted to preheader of cloned callee |

All 5 kernels achieve a **50% reduction in hot-loop memory reads**.

For a loop running N iterations: baseline executes 2N loads; the pass version executes N + 1 (variant load per iteration plus one pre-loop load of the invariant). For large N this halves the load pressure on the memory subsystem.

## Constant-Folding Cascade (dynamic_split, matrix_row_split)

In two kernels, the benefit goes beyond load elimination. The invariant load, once hoisted, is immediately folded to a compile-time constant by SCCP because `lo[0]` was unconditionally stored as `1.0` before the loop. The result is that the load disappears from the IR entirely and the `fadd` inside the loop uses an immediate operand with no memory dependency:

```llvm
; baseline: loads lo[0] every iteration
%12 = load float, ptr %1, align 4      ; lo[0] — redundant load
%14 = load float, ptr %13, align 4     ; hi[i]
%15 = fadd float %12, %14
store float %15, ptr %13, align 4

; pass: lo[0] constant-folded to 1.0, no load
%13 = load float, ptr %12, align 4, !noalias !1  ; hi[i]
%14 = fadd float %13, 1.000000e+00               ; immediate operand, no memory dep
store float %14, ptr %12, align 4, !noalias !1
```

The constant-folding cascade is a kernel-specific artifact (lo[0] was initialized to 1.0). In real workloads where `lo[0]` holds a computed (non-constant) value, the benefit is LICM hoisting alone, not folding. The evaluation should call this out explicitly.

## Vectorization Unblocking

### dynamic_split (partial: safety resolved, cost model declines)

Before the pass: `loop-vectorize: UnsafeDep`
After the pass: `loop-vectorize: VectorizationNotBeneficial`

The alias concern was the root blocker, not a cost or trip-count issue. The dynamic trip count (`%hi_size`) causes the vectorizer to decline on cost grounds after the alias safety block is removed. A statically-known trip count would allow full vectorization.

### vectorize_split (full: safety resolved → SIMD vectorized)

This is the canonical vectorization demonstration. The kernel has a **static 1M trip count** and the same partition-by-endpoint pattern as `dynamic_split`.

Before the pass (any variant including `-force-vector-width=4`):
```
Pass: loop-vectorize   Name: UnsafeDep
```
`UnsafeDep` is a safety check — it cannot be overridden by `-force-vector-width=4`. The baseline+fvw4 binary is fully scalar. See `outputs/vectorize_split/vectorize_split.baseline.fvw4.O2.ll`.

After the pass + `-force-vector-width=4`:
```
Pass: licm              Name: Hoisted
Pass: loop-vectorize    Name: Vectorized   VectorizationFactor: 4   InterleaveCount: 1
```

The vectorized loop body:
```llvm
%wide.load = load <4 x float>, ptr %7, align 4, !noalias !1
%8 = fadd <4 x float> %wide.load, splat (float 1.000000e+00)
store <4 x float> %8, ptr %7, align 4, !noalias !1
```

Wall-clock speedup: **3.76× on Apple M2** (1,440,486 → 383,304 ns/call). See `cases/case_vectorize_split.md` for full analysis and cross-platform results.

## Microbenchmark Results

Additional kernels were created to probe the pass further. Results below.

### Valid new cases (remarks-based)

| Kernel | Baseline Misses | Pass Misses | Pattern |
|---|---|---|---|
| `split_accumulate` | 6 | **0** | Roles reversed from `dynamic_split`: hi[0] is the invariant read, lo[i] are write targets. Form A. |
| `double_invariant` | 11 | **0** | Same partition as `dynamic_split` but two invariant loads (lo[0] and lo[1]). Both hoisted. |

### Limitation demonstrations (not valid evaluation cases)

| Kernel | Baseline Misses | Pass Misses | What it shows |
|---|---|---|---|
| `three_way_split` | 16 | 10 | Mid subview is hi of pair 0 and lo of pair 1. Second `tagUsesOfValue` call overwrites pair 0's hi-tags on all mid ops with pair 1's lo-tags. Loop 1 hoist fails; Loop 2 succeeds. Tag-overwrite limitation. |
| `column_split` | 5 | 5 | 2D matrix split on columns (dim 1). Pass only checks dim 0. No tagging occurs. Dim-0-only limitation confirmed. |
| `noinline_two_pairs` | 8* | 8* | Pass correctly creates clones (`@stencil_a.__alias_meta_0`, `@stencil_b.__alias_meta_1`) with 0 misses. The 8 reported misses come from the dead original functions (`@stencil_a`, `@stencil_b`) which remain in the IR until GlobalDCE. Remarks grep confirms misses are in the originals, not the clones. |

*Remarks from dead original functions, not the clones.

### Wall-clock benchmark: vectorize_split (formal case study)

Kernel: `kernels/mlir/vectorize_split.mlir` — 2M-element array, split at runtime offset `%n`.
`lo = A[0..n-1]` (dynamic), `hi = A[n..n+1M-1]` (static size 1M). Loop: `hi[i] += lo[0]`.

The pass adds `alias.scope`/`noalias` metadata → LICM hoists `lo[0]` → SCCP folds to constant 1.0
→ the loop body reduces to `hi[i] += 1.0` with no alias uncertainty → vectorizable.

**Why `-force-vector-width=4`:** After alias resolution, LLVM's cost model rates the resulting
`hi[i] += 1.0` loop as "not beneficial" to vectorize (cost model conservatism, not a safety
issue). Using `-force-vector-width=4` overrides the cost estimate to demonstrate the actual
capability: the baseline's `UnsafeDep` is a safety-check failure that no forced width can
override, while the pass version vectorizes cleanly.

| Version | Loop type | ns/call | Speedup |
|---|---|---|---|
| Baseline | Scalar (UnsafeDep blocks even forced VF=4) | 1,440,486 | 1.00× |
| Pass + fvw4 | SIMD `<4 x float>` (LICM+SCCP+vectorize) | 383,304 | **3.76×** |

The SIMD loop: `wide.load = load <4 x float>; fadd <4 x float> %wide.load, splat(1.0); store <4 x float>`

**Correctness**: `tests/test_vectorize_split.c` — both baseline and pass produce checksum `2199025352704.000000` (verified by `scripts/run_correctness_tests.sh`; 6/6 pass).

Full case study: `cases/case_vectorize_split.md`. Cross-platform results: `docs/benchmark-cross-platform.md`.

## Artifact Locations

**Case-study kernels** — artifacts in `outputs/<kernel>/`:
- `<name>.ll` — baseline LLVM IR (from `run_pipeline_cpu.sh`)
- `<name>.O2.ll` — baseline after O2
- `<name>.oracle.ll` — hand-written oracle LLVM IR with correct metadata structure
- `<name>.oracle.O2.ll` — oracle after O2
- `<name>.meta.ll` — pass LLVM IR (from `run_pipeline_cpu_with_meta.sh` with prefix `<name>.meta`)
- `<name>.meta.O2.ll` — pass output after O2
- `<name>.meta.meta.mlir` — intermediate MLIR after our two passes, before standard lowering (the double `.meta` is a naming artifact from using `<name>.meta` as the output prefix)

**Microbenchmark kernels** — artifacts in `microbench_outputs/<kernel>/`:
- `baseline/<name>.ll`, `baseline/<name>.O2.ll`, `baseline/remarks.O2.yml`
- `with_meta/<name>.ll`, `with_meta/<name>.O2.ll`, `with_meta/remarks.O2.yml`
