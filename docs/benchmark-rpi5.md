# Benchmark Results — Raspberry Pi 5 (Cortex-A76)

## Hardware

| Property | Value |
|---|---|
| Board | Raspberry Pi 5 |
| SoC | BCM2712 |
| CPU | ARM Cortex-A76 @ 2.4 GHz (rated) |
| Issue | 4-wide, **deep out-of-order** |
| OOO window | ~128-entry ROB, wider execution than A72 |
| L1D cache | 64 KB per core |
| L1I cache | 64 KB per core |
| L2 cache | 512 KB per core |
| L3 cache | 2 MB shared system cache |
| Memory | LPDDR4X-4267, ~17 GB/s practical bandwidth |
| OS | Raspberry Pi OS Lite (64-bit, no desktop) |

The Cortex-A76 is ARM's most aggressive OOO design in this test series — 4-wide decode, two dedicated load pipes and two dedicated store pipes, 64 KB L1D (vs A72's 32 KB), and much higher memory bandwidth than both earlier platforms. It represents the transition point at which the OOO engine becomes sophisticated enough to absorb some of the disambiguation overhead that the A72 pays for, while still being unable to fully mask simple per-iteration load costs.

---

## Methodology

### Clock frequency

All benchmarks were run in two modes: with the CPU governor set to `performance` (attempting to pin at 2.4 GHz) and with the default `ondemand` governor (observed by the user to remain at 1.5 GHz). Both runs produced **essentially identical absolute runtimes** (within 0.1%):

```
dynamic_split baseline: 758.00 ns (performance) vs 758.26 ns (ondemand)
vectorize_split:        624,419 ns              vs 624,074 ns
```

A genuine 2.4 GHz run would produce runtimes ~1.6× faster than a 1.5 GHz run for CPU-bound scalar kernels. The identical absolute times indicate the CPU operated at approximately **1.5 GHz during both runs**, consistent with passive thermal limiting on the RPi 5 without active cooling. The `performance` governor setting did not result in sustained 2.4 GHz operation under load.

All results in this document reflect benchmarks run at approximately 1.5 GHz.

### Cross-compilation

Binaries were cross-compiled on an Apple Silicon Mac using:

- `llc -mtriple=aarch64-linux-gnu -mcpu=cortex-a76` to compile LLVM IR to AArch64 ELF objects
- `zig cc --target=aarch64-linux-musl -static` to compile C harnesses and link into fully static binaries

For `vectorize_split`, `opt -mtriple=aarch64-linux-gnu -mcpu=cortex-a76` was used to re-optimise the raw IR targeting the A76 directly, producing VF=4 interleave=2 with `ldp/stp` instructions.

### Timing harness

Same as other Pi benchmarks: `CLOCK_MONOTONIC_RAW`, `NWARMUP` calls before timing, best of `NROUNDS=5` timed rounds each running `NITERS` calls. Results are minimum ns/call across all rounds.

---

## Results

### Scalar invariant-load hoist cases

| Kernel | Baseline (ns/call) | Pass (ns/call) | Speedup | vs RPi 4B (A72) |
|---|---|---|---|---|
| `dynamic_split` | 758 | 651 | **1.17×** | +0.01× |
| `adjacent_tiles` | 383 | 331 | **1.16×** | −0.01× |
| `subview_noalias` | 467 | 364 | **1.28×** | +0.15× |
| `tiling_noinline` | 386 | 438 | **0.88×** ❌ | −0.28× |
| `split_accumulate` | 759 | 651 | **1.16×** | same |
| `double_invariant` | 867 | 865 | **1.00×** | −0.28× |

---

## Analysis of individual cases

### Consistent scalar hoists: 1.16–1.17×

`dynamic_split`, `adjacent_tiles`, and `split_accumulate` show consistent improvement on A76 — essentially the same as A72 (1.16–1.17×) and better than A53 (1.12×). These kernels have a single invariant load of the form `lo[0]` potentially aliasing with inner-loop stores `hi[i]`. Even on a 4-wide OOO core, the load-store disambiguation machinery must track this uncertain aliasing relationship across all loop iterations. When LICM hoists the load out of the loop (enabled by the pass's alias metadata), that tracking overhead disappears.

The fact that A76 and A72 show essentially the same improvement here, while both exceed A53, confirms that the benefit on OOO hardware is not primarily about saving one instruction per iteration (as on A53) but about eliminating persistent LSU disambiguation overhead — and this overhead persists even on the A76.

### subview_noalias: 1.28× (A72: 1.13×, A53: 1.14×)

`subview_noalias` involves a cross-function alias resolution: the caller creates two statically disjoint subviews and passes them to a `noinline` callee. The pass clones the callee with `!alias.scope`/`!noalias` annotations that the original has no access to.

The A76 shows the largest improvement of all three platforms — 1.28× vs 1.13× on A72. This is consistent with a hypothesis that A76's more aggressive speculative execution creates *more* inter-iteration alias tracking pressure across the call boundary in the baseline. When the callee cannot see alias information from the caller, the A76's OOO engine must speculatively track load-store relationships across more outstanding operations than the A72 can hold in flight simultaneously. The pass eliminates this uncertainty entirely.

This result should be noted as a hypothesis consistent with the data, not a proven mechanism — direct measurement would require hardware performance counters.

### tiling_noinline: 0.88× — regression

The pass version is 14% *slower* than baseline on A76. This was not observed on A53 (1.12×) or A72 (1.16×). Both RPi 5 runs confirmed this result reproducibly.

`tiling_noinline` is structurally similar to `subview_noalias` — it involves a `noinline` callee with a partition-by-endpoint pattern. The pass clones the callee and annotates the clone with alias metadata. The divergence from `subview_noalias`'s result is unexplained by the current data alone. Possible hypotheses:

- The clone introduces a different instruction sequence in the pass version that aligns poorly with A76's specific pipeline stages or branch predictor state
- The two-version code layout (original + clone in binary) interacts with A76's L1I prefetcher differently than on A72
- The alias metadata changes the loop structure within the clone in a way that causes a less efficient access pattern on A76's two-load-pipe configuration

This regression is an honest result. It indicates that alias metadata propagation does not unconditionally improve performance on all microarchitectures. Disassembly comparison of the A76-targeted binaries would be needed to identify the exact cause.

### double_invariant: 1.00× (A72: 1.28×, A53: 1.08×)

`double_invariant` has two invariant loads (`lo[0]` and `lo[1]`) that LICM hoists out of the loop. On A72, the two uncertain aliasing relationships created non-linear overhead in the LSU — 1.28× improvement, larger than any single-hoist case. On A76, the improvement disappears entirely.

The A76's wider execution and more sophisticated memory ordering units appear to absorb two concurrent uncertain aliasing relationships without accumulating the overhead that the A72's narrower design pays. This is consistent with A76's larger L1D (64 KB vs 32 KB) and wider issue width providing more headroom to handle concurrent in-flight load-store tracking. At two uncertain relationships, the A76's OOO engine has enough capacity to resolve them without creating a measurable bottleneck.

This is the clearest example in the dataset of a deeper OOO processor *hiding* what a shallower one cannot.

### matrix_row_split: 1.00× (A72: 1.20×, A53: 1.01×)

The outer-loop invariant load that forced 32,768 aliasing checks in A72's LSU produces no measurable overhead on A76. The A76's wider, more efficient memory ordering unit handles the per-store disambiguation for the outer-loop load without accumulating the kind of persistent overhead that the A72 paid. The result is identical to the A53 case — but for a different reason: A53 had no such overhead mechanism to begin with, while A76 has the mechanism but enough capacity to absorb it.

---

## vectorize_split: 1.25× on A76

| Version | ns/call | Speedup |
|---|---|---|
| Baseline (scalar) | 624,074 | 1.00× |
| Pass (NEON SIMD, ldp/stp VF=4×2) | 501,103 | **1.25×** |

The RPi 5 shows a genuine SIMD benefit for `vectorize_split`, unlike the RPi 4B which showed a regression (0.91×). The explanation is bandwidth: LPDDR4X at ~17 GB/s is roughly 3× the RPi 4B's ~6 GB/s. The 8 MB working set (2M floats) still exceeds total cache (512 KB × 4 cores + 2 MB L3 = ~4 MB), so the workload is still DRAM-bound — but at 17 GB/s, the SIMD version's lower instruction count and loop overhead yield a measurable benefit that the RPi 4B's bandwidth ceiling prevents.

The A76-native IR generated by `opt -mtriple=aarch64-linux-gnu -mcpu=cortex-a76` uses VF=4 with interleave=2, producing `ldp q1,q2 / fadd×2 / stp q1,q2` (8 floats per iteration). This is the correct ARM vectorization pattern and is what produces the 1.25× result. The macOS-generated fvw4 IR (used for macOS benchmarks) is not used for RPi builds.

The macOS result (3.76×) remains larger because Apple Silicon has >100 GB/s bandwidth and large cache hierarchies, making the kernel far more compute-bound there.

---

## Summary

| Kernel | RPi 3B (A53) | RPi 4B (A72) | RPi 5 (A76) | Trend |
|---|---|---|---|---|
| `dynamic_split` | 1.12× | 1.16× | **1.17×** | Consistent improvement OOO→deeper OOO |
| `adjacent_tiles` | 1.12× | 1.17× | **1.16×** | Consistent |
| `subview_noalias` | 1.14× | 1.13× | **1.28×** | Larger on deeper OOO |
| `tiling_noinline` | 1.12× | 1.16× | **0.88×** ❌ | Regression on A76 |
| `split_accumulate` | 1.12× | 1.16× | **1.16×** | Consistent |
| `double_invariant` | 1.08× | 1.28× | **1.00×** | OOO fully hides on A76 |
| `matrix_row_split` | 1.01× (noise) | 1.20× | **1.00×** (noise) | A72-specific effect |
| `vectorize_split` | 1.65× | 0.91× (DRAM-bound) | **1.25×** | Bandwidth-dependent |

The A76 results reveal two competing effects as OOO depth increases:

1. **OOO absorption**: For cases with multiple uncertain aliasing relationships (`double_invariant`) or a persistent outer-loop uncertainty (`matrix_row_split`), the A76's wider memory ordering unit absorbs what the A72 cannot. These cases lose the gains seen on A72.

2. **OOO speculation cost**: For cases with cross-function alias uncertainty (`subview_noalias`), the A76's more aggressive speculation creates more tracking pressure in the baseline, making the pass's benefit *larger* on A76 than on any other platform.

The `tiling_noinline` regression is an anomaly requiring further investigation. The simple scalar hoist cases (1.16–1.17×) remain consistent across both OOO platforms.

---

## Artifact locations

- Cross-compiled binaries: `bench_outputs/<kernel>/rpi5/`
- AArch64-native vectorize_split IR: `bench_outputs/vectorize_split/rpi5/*_aarch64.O2.ll`
- Scripts: `scripts/cross_compile_rpi.sh`, `scripts/run_rpi_benchmarks.sh`
- Raw results: `bench_outputs/rpi_summary.txt`
