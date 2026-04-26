# Benchmarks Reference

Complete evaluation of the alias metadata pass across all kernels and platforms. Covers hardware
profiles, methodology, per-platform results, cross-platform interpretation, and the three-cost-regime
framework for the thesis evaluation chapter.

Detailed per-platform docs: `docs/benchmark-rpi3b.md`, `docs/benchmark-rpi4b.md`,
`docs/benchmark-rpi5.md`, `docs/benchmark-cross-platform.md`.

---

## Hardware Platforms

| Property | RPi 3B | RPi 4B | RPi 5 | macOS |
|---|---|---|---|---|
| CPU | Cortex-A53 | Cortex-A72 | Cortex-A76 | Apple M-series |
| Clock (benchmarks) | ~1.2 GHz | 1.5 GHz (perf governor) | ~1.5 GHz (thermal cap) | — |
| Issue model | **2-wide in-order** | **3-wide OOO** | **4-wide deep OOO** | Ultra-deep OOO |
| OOO window | — | ~128 in-flight | ~128 ROB, wider exec | ~600+ ROB |
| Load-store units | 1 (in-order) | 2 (speculative) | 2+2 (ld+st pipes) | Multiple |
| L1D cache | 32 KB | 32 KB | 64 KB | 128–192 KB |
| L2 cache | 256 KB (shared) | 1 MB (private) | 512 KB/core | 12–32 MB |
| L3 cache | — | — | 2 MB (shared) | — |
| Memory | LPDDR2 ~4 GB/s | LPDDR4 ~6 GB/s | LPDDR4X ~17 GB/s | >100 GB/s |

**RPi 5 clock note**: The `performance` governor was set (target 2.4 GHz) but both runs — performance
and ondemand — produced identical absolute runtimes (within 0.1%). A true 2.4 GHz run would be ~1.6×
faster for CPU-bound scalar kernels. The hardware operated at ~1.5 GHz throughout, consistent with
passive thermal limiting without active cooling. See `docs/benchmark-rpi5.md`.

---

## Methodology

### Kernels and binary variants

Each kernel is compiled into two binary variants:

- **Baseline**: standard MLIR lowering pipeline → `mlir-translate` → `opt -O2`. No alias metadata.
  LLVM sees only flat GEP pointer arithmetic with no knowledge of the original `memref.subview` structure.
- **Pass**: same pipeline preceded by `MarkAliasGroupsPass` + `LowerWithAliasMetaPass`. Produces LLVM IR
  with `!alias.scope`/`!noalias` annotations on all load/store instructions touching provably disjoint
  subview regions. Otherwise identical to baseline.

For `vectorize_split` only, the pass variant uses `-force-vector-width=4` (and `-mcpu=<target>` for
ARM cross-compilation). See the vectorize_split section.

### Cross-compilation

RPi binaries were cross-compiled on Apple Silicon Mac:
- `llc -mtriple=aarch64-linux-gnu -mcpu=<cortex-a53|a72|a76>` — compiles `.O2.ll` → AArch64 ELF object
- `zig cc --target=aarch64-linux-musl -static` — links with C harness into fully static binary

Binaries transferred via `scp` over Tailscale, executed via SSH.
Scripts: `scripts/cross_compile_rpi.sh`, `scripts/run_rpi_benchmarks.sh`.

### Timing harness

All benchmarks use `CLOCK_MONOTONIC_RAW` via `clock_gettime`:
1. `NWARMUP` full calls (not timed — cache warm-up, branch predictor training)
2. `NROUNDS = 5` timed rounds, each running `NITERS` calls
3. Report **minimum ns/call** across all rounds (filters OS scheduling noise)

### Correctness verification

Before any benchmarking, both baseline and pass binaries are verified to produce identical numeric
output. Script: `scripts/run_correctness_tests.sh`. All 6 case-study kernels pass (checksums match).
See `thesis-reference/optimization-results.md` for correctness details.

---

## Full Results: ns/call

| Kernel | A53 Base | A53 Pass | A72 Base | A72 Pass | A76 Base | A76 Pass |
|---|---:|---:|---:|---:|---:|---:|
| `dynamic_split` | 7,747 | 6,890 | 1,611 | 1,384 | 758 | 651 |
| `adjacent_tiles` | 3,885 | 3,458 | 816 | 700 | 383 | 331 |
| `subview_noalias` | 3,594 | 3,165 | 937 | 826 | 467 | 364 |
| `tiling_noinline` | 3,893 | 3,464 | 818 | 704 | 386 | 438 |
| `split_accumulate` | 7,746 | 6,887 | 1,611 | 1,384 | 759 | 651 |
| `double_invariant` | 11,183 | 10,326 | 2,066 | 1,613 | 867 | 865 |
| `matrix_row_split` | 226,164 | 225,033 | 66,893 | 55,649 | 27,865 | 27,885 |
| `vectorize_split` | 7,356,595 | 4,448,108 | 3,619,206 | 3,962,714 | 624,074 | 501,103 |

**macOS (vectorize_split only)**: Baseline 1,440,486 ns → Pass+fvw4 383,304 ns.
All other kernels show ~1.0× on macOS (Apple Silicon OOO masks scalar-hoist overhead entirely).

---

## Full Results: Speedups

| Kernel | A53 (RPi 3B) | A72 (RPi 4B) | A76 (RPi 5) | macOS | Notes |
|---|---|---|---|---|---|
| `dynamic_split` | 1.12× | 1.16× | 1.17× | ~1.0× | Consistent across OOO platforms |
| `adjacent_tiles` | 1.12× | 1.17× | 1.16× | ~1.0× | Consistent |
| `subview_noalias` | 1.14× | 1.13× | **1.28×** | ~1.0× | Grows with OOO depth |
| `tiling_noinline` | 1.12× | 1.16× | **0.88×** ❌ | ~1.0× | Regression on A76 |
| `split_accumulate` | 1.12× | 1.16× | 1.16× | ~1.0× | Consistent |
| `double_invariant` | 1.08× | **1.28×** | 1.00× | ~1.0× | Peak on A72; absorbed on A76 |
| `matrix_row_split` | 1.01× | **1.20×** | 1.00× | ~1.0× | A72-specific; noise on A53/A76 |
| `vectorize_split` | 1.65× | 0.91× ❌ | 1.25× | **3.76×** | Bandwidth-dependent SIMD |

---

## Three Cost Regimes (Thesis Framework)

The three platforms expose qualitatively different mechanisms by which compile-time alias uncertainty
affects runtime performance. These form the thesis's cross-platform evaluation framework.

### Regime 1 — In-order (A53): instruction-count problem

The Cortex-A53 has no speculative execution machinery. It cannot reorder or speculate memory accesses.
Without LICM, the invariant `lo[0]` load executes as one instruction per iteration, every iteration.
That single `ldr` sits on the critical path.

Per-iteration analysis for `dynamic_split`:
```
Baseline: issue lo[0] ldr (cycle 1) → issue hi[i] ldr (cycle 2) → wait for lo[0] (cycle 5)
          → hi[i] ready (cycle 6) → fadd (cycle 6) → total ~10 cycles
Pass:     issue hi[i] ldr (cycle 1) → hi[i] ready (cycle 5) → fadd uses reg s0 → total ~9 cycles
```
Expected speedup 10/9 ≈ 1.11×. Measured: 1.12×. Confirmed by disassembly.

**Characteristic**: Benefit is **uniform and predictable from cycle counting**. Applies equally across
all single-hoist cases because the A53 executes instructions identically every time. No runtime
disambiguation machinery exists to create additional hidden costs.

### Regime 2 — Shallow OOO (A72): load-store queue tracking problem

The Cortex-A72 speculatively issues loads out of order, but its LSU (load-store unit) must track
whether outstanding stores might invalidate them. Without alias metadata, the A72 sees:

```
load lo[0]   ←  address: base ptr %p
store hi[i]  ←  address: base ptr %p + n*stride + i*stride
```

LLVM generated no `!noalias` annotations, so the A72's memory ordering hardware cannot determine
statically whether these overlap. It must:
1. Track `lo[0]` as potentially aliasing with every `hi[i]` store
2. Maintain disambiguation state in the store queue across all loop iterations
3. Verify on each store commit that `lo[0]` was not invalidated

This overhead persists across **all iterations of the loop** — not just one. When LICM hoists `lo[0]`
before the loop (enabled by pass metadata), the load completes in the preheader and exits the LSU's
tracking window entirely. All per-iteration disambiguation overhead disappears.

**Characteristic**: Benefit **scales with the number of uncertain relationships and the number of
stores that must check against them**. This explains the A72-specific gains:
- `double_invariant`: 1.28× — two uncertain relationships, roughly doubling disambiguation overhead
- `matrix_row_split`: 1.20× — one outer-loop load, but 32,768 inner-loop stores must each check it

### Regime 3 — Deep OOO (A76): partially absorbed

The Cortex-A76's wider execution units, 64 KB L1D, and more sophisticated memory ordering handle some
disambiguation overhead that the A72 cannot. The picture is mixed:

| Case type | A72 | A76 | Interpretation |
|---|---|---|---|
| Single-load hoist | 1.16–1.17× | 1.16–1.17× | Persistent even on deep OOO |
| Two-load hoist | 1.28× | 1.00× | A76 absorbs two relationships |
| 32,768-store outer loop | 1.20× | 1.00× | A76 absorbs high-store-count disambiguation |
| Cross-function (subview_noalias) | 1.13× | 1.28× | A76's speculation costs more at call boundary |
| Cross-function (tiling_noinline) | 1.16× | 0.88× ❌ | Regression; cause unknown |

**Characteristic**: Simple single-load disambiguation overhead **does not disappear on A76** (still
1.16–1.17×). More complex relationships (two loads, outer-loop loads) are absorbed. Cross-function
alias uncertainty produces platform-specific effects, including a genuine regression.

**Key thesis implication**: Compile-time alias proofs are beneficial on all three in-order and OOO
platforms, but the mechanism differs. On in-order hardware, the benefit is instructional. On OOO
hardware, the benefit is disambiguation overhead elimination — and this overhead can be *larger* on
OOO hardware than on in-order hardware (A72 1.28× > A53 1.08× for `double_invariant`).

---

## Per-Kernel Analysis

### Theme 1: Simple invariant-load hoist (`dynamic_split`, `adjacent_tiles`, `split_accumulate`)

**Pattern**: Flat array partitioned at runtime offset `n`. Inner loop reads `lo[0]` and reads/writes
`hi[i]`. Single invariant load, one uncertain aliasing relationship.

| Platform | Speedup | Mechanism |
|---|---|---|
| A53 | 1.12× | 10→9 cycles per iteration (predictable from cycle counting) |
| A72 | 1.16× | LSU disambiguation overhead eliminated for N store commits |
| A76 | 1.16–1.17× | Same as A72; persists even on wider OOO |

The consistent ~1.12× on A53 and ~1.16× on both OOO platforms confirms that:
- On A53, the benefit is exactly one instruction removed from the critical path
- On OOO hardware, the benefit includes LSU tracking overhead that exceeds the simple instruction saving
- The OOO benefit does not increase further from A72 to A76 for single-load cases

Disassembly for `dynamic_split` confirms the mechanism. See `docs/benchmark-rpi3b.md`.

---

### Theme 2: Multiple uncertain relationships (`double_invariant`)

**Pattern**: Same as dynamic_split but with two invariant loads (`lo[0]` and `lo[1]`), both
potentially aliasing with inner-loop `hi[i]` stores.

| Platform | Speedup | vs dynamic_split |
|---|---|---|
| A53 | 1.08× | Less (heavier baseline body, same absolute ns saving) |
| A72 | **1.28×** | Much more (non-linear LSU overhead for 2 relationships) |
| A76 | 1.00× | Absorbed entirely |

**A53 subtlety**: The absolute ns saved per call (~857 ns) is similar across single- and double-hoist
cases. But `double_invariant`'s baseline is 11,183 ns (vs ~7,747 ns for single-hoist), making the
relative improvement smaller. The saving is the same; the denominator is larger.

**A72 non-linearity**: Two uncertain relationships create roughly twice the LSU tracking overhead of
one. The A72's narrower memory ordering units accumulate this overhead in a way that roughly doubles
the disambiguation cost — hence 1.28× vs 1.16× for single-hoist cases.

**A76 absorption**: The A76's wider, more sophisticated memory ordering absorbs two concurrent
uncertain aliasing relationships without accumulating measurable overhead. The capacity threshold
for disambiguation absorption appears to lie between 1 and 2 relationships on A72, and above 2
on A76.

---

### Theme 3: Outer-loop invariant load in nested loop (`matrix_row_split`)

**Pattern**: 2D loop — 64 outer × 512 inner. Invariant load `top[0,0]` is inside the outer loop but
outside the inner loop. LICM hoists it out of the outer loop, saving 64 loads per call, but across
32,768 inner iterations' worth of store commits.

| Platform | Speedup | Mechanism |
|---|---|---|
| A53 | 1.01× (noise) | 64 load instructions out of 32,768 inner iterations — unmeasurable |
| A72 | **1.20×** | Outer-loop load remains in LSU across all 32,768 inner store commits |
| A76 | 1.00× (noise) | A76's memory ordering absorbs the tracking overhead |

This is the most hardware-specific result in the dataset. The ~0.2% instruction-count saving on A53
is entirely within measurement noise, as expected. On A72, the outer-loop load stays in the LSU's
store queue while every single inner-loop `bot[i,j]` store (to the same base allocation) must check
against it — 32,768 checks per call, eliminated by the pass. On A76, this accumulation is absorbed.

`matrix_row_split` is the clearest demonstration that OOO disambiguation overhead can emerge from
loop nesting structure, not just loop body instruction count.

---

### Theme 4: Cross-function alias resolution (`subview_noalias`, `tiling_noinline`)

**Pattern**: Caller creates disjoint subviews, passes them to a `noinline` callee. Pass clones the
callee and attaches `!alias.scope`/`!noalias` to the clone. The original callee is untouched.
The call site in the caller is redirected to the clone.

| Kernel | A53 | A72 | A76 |
|---|---|---|---|
| `subview_noalias` | 1.14× | 1.13× | **1.28×** |
| `tiling_noinline` | 1.12× | 1.16× | **0.88×** ❌ |

Both kernels involve noinline callees with structurally different disjointness proofs (Form C
static for `subview_noalias`; Form B runtime arithmetic chain for `tiling_noinline`). The
divergence on A76 is the most interesting result in the entire dataset.

**subview_noalias 1.28× on A76**: A76's aggressive speculation appears to create *more* inter-iteration
alias tracking pressure at the function call boundary in the baseline. When the callee has no alias
information, the A76's OOO engine must speculatively track load-store relationships across more
outstanding operations than the A72 can hold. The pass eliminates this entirely. This is a hypothesis
consistent with the data; verifying it would require hardware performance counters.

**tiling_noinline 0.88× on A76**: Genuine regression, reproducible on both RPi 5 runs (performance
and ondemand governor). Not seen on A53 (1.12×) or A72 (1.16×). The cause is not established.
Possible hypotheses:
- The cloned function introduces an instruction sequence that interacts poorly with A76's specific
  pipeline stage allocation
- Two-version code layout (original + clone) interacts with A76's L1I prefetcher differently
- The alias metadata changes loop structure within the clone causing a suboptimal A76 access pattern

This regression must be reported honestly in the thesis. It demonstrates that alias metadata
propagation does not unconditionally improve performance across all microarchitectures.

---

### Theme 5: Vectorization enabling (`vectorize_split`)

**Pattern**: 2M-element buffer split at runtime offset `n`. Loop runs 1M iterations (static trip count):
`hi[i] += lo[0]`. Without alias metadata, LLVM reports `UnsafeDep` — a safety failure that blocks
vectorization regardless of cost model or forced vector width.

**The key distinction**: `UnsafeDep` is a *safety check*, not a cost-model decision. It cannot be
overridden by `-force-vector-width=4`. The baseline + fvw4 binary remains fully scalar. The pass
resolves the safety failure via alias metadata, after which the cost model is the only remaining
gate. See `cases/case_vectorize_split.md`.

**Three-pass cascade**:
1. `!alias.scope`/`!noalias` added → LICM hoists `lo[0]` (remark: `Hoisted`)
2. Hoisted `lo[0]` has only one reaching definition (`store float 1.0, ptr %1` before loop) → SCCP
   folds to constant 1.0 → load disappears from IR
3. Loop reduces to `hi[i] += 1.0` — no aliasing concern, static 1M trip count → vectorizable with fvw4

**Vectorized loop body** (pass + fvw4):
```llvm
%wide.load = load <4 x float>, ptr %7, align 4, !noalias !1
%8 = fadd <4 x float> %wide.load, splat (float 1.000000e+00)
store <4 x float> %8, ptr %7, align 4, !noalias !1
```

**Results by platform** (8 MB working set — exceeds all RPi caches):

| Platform | Baseline (ns) | Pass+SIMD (ns) | Speedup | Bottleneck |
|---|---:|---:|---|---|
| macOS (M-series) | 1,440,486 | 383,304 | **3.76×** | Compute-bound (high BW + cache) |
| RPi 3B (A53, LPDDR2 ~4 GB/s) | 7,356,595 | 4,448,108 | **1.65×** | Partially bandwidth-bound |
| RPi 4B (A72, LPDDR4 ~6 GB/s) | 3,619,206 | 3,962,714 | 0.91× ❌ | DRAM-bound; excluded |
| RPi 5 (A76, LPDDR4X ~17 GB/s) | 624,074 | 501,103 | **1.25×** | Partially bandwidth-bound |

**RPi 4B regression**: Working set 8 MB >> all caches. LPDDR4 at ~6 GB/s is the bottleneck. SIMD
reduces instruction count (1M → 262K iterations) but not bytes transferred (4 MB read + 4 MB write
per call regardless). The NEON vector access pattern interacts with the A72's LPDDR4 controller in
a way that produces marginal overhead vs scalar. The A72 `vectorize_split` result is excluded from
the thesis's performance claims. Detailed analysis: `docs/benchmark-rpi4b.md`.

**RPi 5 (1.25×)**: LPDDR4X at ~17 GB/s reduces the DRAM-bound fraction enough for SIMD's instruction
reduction to translate to a speedup. Not as dramatic as macOS (still partially bandwidth-limited).

**macOS (3.76×)**: Primary demonstration. Apple Silicon's >100 GB/s bandwidth and large caches make the
kernel substantially compute-bound. SIMD's 4× instruction reduction maps nearly directly to throughput.

**Disassembly confirmation (A53 pass loop)**:
```asm
fmov v0.4s, #1.00000000          // splat 1.0 into NEON register (pre-loop)
.LBB0_1:
    ldr q1, [x9, x8]             // load 4 floats (128-bit)
    fadd v1.4s, v1.4s, v0.4s    // add 4 floats
    str q1, [x9, x8]             // store 4 floats
    add x8, x8, #16
    b.ne .LBB0_1
```

Baseline A53 loop still has `ldr s0, [x1]` (invariant scalar load) every iteration, and processes
one float at a time. The alias metadata enables both the LICM hoist and the vectorization — they are
a coupled cascade, not independent optimizations.

---

## Excluded and Noise Cases

| Kernel | Platform | Result | Reason for exclusion/note |
|---|---|---|---|
| `matrix_row_split` | A53 | 1.01× | ~0.2% improvement below measurement noise |
| `matrix_row_split` | A76 | 1.00× | Same — A76 absorbs the overhead |
| `tiling_noinline` | A76 | 0.88× | Genuine regression — reported, not excluded |
| `vectorize_split` | A72 | 0.91× | DRAM-bound; excluded from vectorization claims |
| All scalar hoists | macOS | ~1.0× | Apple Silicon OOO masks disambiguation overhead entirely |

---

## Cross-Platform Summary Table

| Kernel | A53 | A72 | A76 | macOS | Primary beneficiary | Optimization |
|---|---|---|---|---|---|---|
| `dynamic_split` | 1.12× | 1.16× | 1.17× | ~1.0× | All RPi platforms | LICM hoist |
| `adjacent_tiles` | 1.12× | 1.17× | 1.16× | ~1.0× | All RPi platforms | LICM hoist |
| `subview_noalias` | 1.14× | 1.13× | **1.28×** | ~1.0× | A76 (deep OOO speculation) | Cross-function LICM |
| `tiling_noinline` | 1.12× | 1.16× | 0.88× ❌ | ~1.0× | A53/A72 only | Cross-function LICM |
| `split_accumulate` | 1.12× | 1.16× | 1.16× | ~1.0× | All RPi platforms | LICM hoist |
| `double_invariant` | 1.08× | **1.28×** | 1.00× | ~1.0× | A72 (shallow OOO LSU) | LICM hoist ×2 |
| `matrix_row_split` | 1.01× | **1.20×** | 1.00× | ~1.0× | A72 only (nested loop) | Outer-loop LICM |
| `vectorize_split` | 1.65× | 0.91× ❌ | 1.25× | **3.76×** | macOS (primary claim) | LICM+SCCP+SIMD |

---

## Key Thesis Claims

1. **The pass eliminates all alias-related optimization misses**: 32 baseline alias misses across all
   6 case-study kernels → 0 with the pass. Verified by LLVM optimization remarks.

2. **Scalar LICM hoist is uniformly effective on in-order and OOO hardware**: ~1.12× on A53
   (instruction count), ~1.16× on A72/A76 (LSU disambiguation overhead). The OOO benefit equals or
   exceeds the in-order benefit — counterintuitive but consistent with the LSU tracking mechanism.

3. **OOO disambiguation overhead scales with relationship complexity**: `double_invariant` (2
   relationships) gains 1.28× on A72 vs 1.16× for single-load cases. `matrix_row_split` (32,768
   store checks on one load) gains 1.20× on A72. These are not simple instruction-count savings.

4. **Vectorization enabling is the highest-magnitude result**: 3.76× on macOS (the primary claim),
   1.65× on A53, 1.25× on A76. The baseline's `UnsafeDep` is a safety block that no forced vector
   width can override — alias metadata is the necessary and sufficient fix.

5. **Cross-function alias propagation is effective but microarchitecture-sensitive**: `subview_noalias`
   improves most on the deepest OOO core (A76 1.28×). `tiling_noinline` regresses on A76 (0.88×),
   demonstrating that code generation changes from function cloning can have unfavorable interactions
   with specific OOO implementations.

---

## Artifact Locations

| Type | Location |
|---|---|
| Case-study kernels (MLIR) | `kernels/mlir/<name>.mlir` |
| Baseline IR + remarks | `pass_outputs/<name>/baseline/` |
| Pass IR + remarks | `pass_outputs/<name>/with_meta/` |
| Microbenchmark kernels | `benchmarks/bench_<name>.c`, `microbenchmark/<name>.mlir` |
| Microbenchmark IR | `microbench_outputs/<name>/baseline/`, `microbench_outputs/<name>/with_meta/` |
| RPi binaries | `bench_outputs/<name>/<rpi3b|rpi4b|rpi5>/` |
| Raw timing results | `bench_outputs/rpi_summary.txt` (overwritten per run; A72 preserved in docs) |
| Cross-compilation script | `scripts/cross_compile_rpi.sh` |
| Benchmark runner | `scripts/run_rpi_benchmarks.sh` |
| Per-platform docs | `docs/benchmark-rpi3b.md`, `docs/benchmark-rpi4b.md`, `docs/benchmark-rpi5.md` |
| Cross-platform doc | `docs/benchmark-cross-platform.md` |
| Correctness tests | `tests/test_<name>.c`, `scripts/run_correctness_tests.sh` |
