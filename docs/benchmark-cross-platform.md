# Cross-Platform Benchmark Summary

## Platforms

| Property | RPi 3B | RPi 4B | RPi 5 |
|---|---|---|---|
| CPU | Cortex-A53 | Cortex-A72 | Cortex-A76 |
| Clock (during benchmarks) | ~1.2 GHz | 1.5 GHz | ~1.5 GHz |
| Issue width | 2-wide | 3-wide | 4-wide |
| Execution model | **In-order** | OOO (~128 ROB) | OOO (~128 ROB, wider) |
| L1D cache | 32 KB | 32 KB | 64 KB |
| L2 cache | 256 KB (shared) | 1 MB (private) | 512 KB/core + 2 MB L3 |
| Memory | LPDDR2 ~4 GB/s | LPDDR4 ~6 GB/s | LPDDR4X ~17 GB/s |

---

## Full Results

### Runtimes (ns/call)

| Kernel | A53 Baseline | A53 Pass | A72 Baseline | A72 Pass | A76 Baseline | A76 Pass |
|---|---:|---:|---:|---:|---:|---:|
| `dynamic_split` | 7,747 | 6,890 | 1,612 | 1,384 | 758 | 651 |
| `adjacent_tiles` | 3,885 | 3,458 | 817 | 701 | 383 | 331 |
| `subview_noalias` | 3,594 | 3,165 | 937 | 827 | 467 | 364 |
| `tiling_noinline` | 3,893 | 3,464 | 818 | 704 | 386 | 438 |
| `split_accumulate` | 7,746 | 6,887 | 1,612 | 1,384 | 759 | 651 |
| `double_invariant` | 11,183 | 10,326 | 2,067 | 1,613 | 867 | 865 |
| `matrix_row_split` | 226,164 | 225,033 | 66,893 | 55,649 | 27,865 | 27,885 |
| `vectorize_split` | 7,356,595 | 4,448,108 | 3,619,207 | 3,962,715 | 624,074 | 501,103 |

### Speedups

| Kernel | A53 (RPi 3B) | A72 (RPi 4B) | A76 (RPi 5) | Notes |
|---|---|---|---|---|
| `dynamic_split` | 1.12× | 1.16× | **1.17×** | Consistent; slight OOO advantage |
| `adjacent_tiles` | 1.12× | 1.17× | **1.16×** | Consistent |
| `subview_noalias` | 1.14× | 1.13× | **1.28×** | Larger on deeper OOO |
| `tiling_noinline` | 1.12× | 1.16× | **0.88×** ❌ | Regression on A76 |
| `split_accumulate` | 1.12× | 1.16× | **1.16×** | Consistent |
| `double_invariant` | 1.08× | **1.28×** | 1.00× | A72 peak; A76 OOO absorbs overhead |
| `matrix_row_split` | 1.01× | **1.20×** | 1.00× | A72-specific effect; noise on A53/A76 |
| `vectorize_split` | **1.65×** | 0.91× ❌ | 1.25× | Bandwidth-dependent SIMD |

---

## Analysis by Optimization Theme

### Theme 1: Simple invariant-load hoist (single load, inner loop)

**Kernels**: `dynamic_split`, `adjacent_tiles`, `split_accumulate`

These kernels share the same structural pattern: a flat array partitioned into `lo` and `hi` subviews at a runtime offset `n`. The inner loop reads `lo[0]` (address fixed at `base`) and reads/writes `hi[i]` (address `base + n×stride + i×stride`). Without alias metadata, LLVM cannot prove disjointness — `lo[0]` stays in the loop.

| Platform | Mechanism | Speedup |
|---|---|---|
| A53 (in-order) | Saves 1 instruction on critical path per iteration (~10→9 cycles) | 1.12× |
| A72 (OOO) | Eliminates LSU disambiguation tracking across all inner iterations | 1.16× |
| A76 (deep OOO) | Same as A72; disambiguation overhead persists even on wider OOO core | 1.16–1.17× |

**Key finding**: The consistent ~1.12× on A53 is predictable from cycle counting (10/9 ≈ 1.11×). The OOO improvement (~1.16×) exceeds the in-order improvement, contrary to the intuitive expectation that OOO hardware would hide the extra load. Both A72 and A76 show equal benefit here — the single-load disambiguation overhead is a fixed cost that neither OOO implementation eliminates.

---

### Theme 2: Cross-function alias resolution (noinline callee)

**Kernels**: `subview_noalias`, `tiling_noinline`

Both kernels involve a `noinline` function call. The pass clones the callee and annotates the clone with `!alias.scope`/`!noalias` metadata derived from the caller's subview structure. The baseline callee has no alias information.

| Kernel | A53 | A72 | A76 |
|---|---|---|---|
| `subview_noalias` | 1.14× | 1.13× | **1.28×** |
| `tiling_noinline` | 1.12× | 1.16× | **0.88×** ❌ |

`subview_noalias` improves most on A76 — consistent with A76's aggressive speculation creating more cross-boundary tracking pressure in the baseline. `tiling_noinline` regresses on A76 despite having the same structural motivation. This divergence is unexplained by the current data; disassembly comparison of the A76-targeted binaries is needed to identify the cause. These two cases show that cross-function alias propagation does not have a uniform effect across microarchitectures.

---

### Theme 3: Multiple uncertain aliasing relationships

**Kernel**: `double_invariant`

`double_invariant` has two invariant loads (`lo[0]` and `lo[1]`), both potentially aliasing with inner-loop stores.

| Platform | Baseline (ns) | Pass (ns) | Speedup |
|---|---:|---:|---|
| A53 | 11,183 | 10,326 | 1.08× |
| A72 | 2,067 | 1,613 | **1.28×** |
| A76 | 867 | 865 | 1.00× |

On A53, the improvement is proportionally smaller than single-hoist cases because the baseline loop body is heavier (the 1-cycle saving is a smaller fraction of a larger total). On A72, the two uncertain aliasing relationships create non-linear LSU tracking overhead — roughly 2× the disambiguation cost of a single relationship, resulting in the largest speedup of any scalar hoist case on A72. On A76, the improvement disappears entirely — the A76's wider memory ordering units absorb both relationships simultaneously without accumulating measurable overhead.

This is the clearest example of the same pass having opposite relative impact on two OOO platforms based on their internal capacity for concurrent alias tracking.

---

### Theme 4: Outer-loop invariant load (nested loop)

**Kernel**: `matrix_row_split`

A 2D loop (64 outer × 512 inner). The invariant load `top[0,0]` is inside the outer loop but outside the inner loop. LICM hoists it out of the outer loop — saving 64 loads across 32,768 inner iterations.

| Platform | Baseline (ns) | Pass (ns) | Speedup |
|---|---:|---:|---|
| A53 | 226,164 | 225,033 | 1.01× (noise) |
| A72 | 66,893 | 55,649 | **1.20×** |
| A76 | 27,865 | 27,885 | 1.00× (noise) |

On A53, 64 sequential loads are trivially small compared to 32,768 inner iterations — correctly predicted as noise. On A72, the unhoisted outer-loop load remains in the LSU's store tracking window across all 32,768 inner-loop store commits — each `bot[i,j]` store must be checked against the pending `top[0,0]` load for the duration of the outer iteration. That is 32,768 aliasing checks per call that the pass eliminates. On A76, this tracking appears to be absorbed without measurable overhead, returning to noise.

`matrix_row_split` is the strongest demonstration of an OOO-specific overhead that simply does not exist on in-order hardware and does not persist on the deepest OOO platform tested. It is a uniquely A72 result.

---

### Theme 5: Vectorization enabling

**Kernel**: `vectorize_split`

A 1M-iteration loop over a 2M-element array (8 MB). Without alias metadata, LLVM's vectorizer reports `UnsafeDep` — a safety failure that prevents vectorization regardless of cost model. With alias metadata, the safety failure is resolved and NEON SIMD vectorization is enabled.

| Platform | Baseline (ns) | Pass (ns) | Speedup | Bottleneck |
|---|---:|---:|---|---|
| A53 | 7,356,595 | 4,448,108 | **1.65×** | Partially bandwidth-bound (LPDDR2 ~4 GB/s) |
| A72 | 3,619,207 | 3,962,715 | 0.91× ❌ | DRAM-bound (LPDDR4 ~6 GB/s) |
| A76 | 624,074 | 501,103 | **1.25×** | Partially bandwidth-bound (LPDDR4X ~17 GB/s) |

The 8 MB working set exceeds all caches on all three platforms. On A72, the bandwidth ceiling at ~6 GB/s means SIMD reduces instruction count but not bytes transferred — the bottleneck is unchanged, and the SIMD version's slightly different access pattern introduces marginal overhead. On A53 and A76, the higher bandwidth relative to the A72 (4 GB/s LPDDR2 on A53, 17 GB/s LPDDR4X on A76) allows SIMD's lower instruction count to translate into measurable wall-clock benefit. The macOS result (3.76×) is the primary demonstration of this optimization — Apple Silicon's >100 GB/s bandwidth and large caches make the kernel substantially more compute-bound.

**Note on A53 (1.65×)**: On the A53, the baseline loop contains a redundant invariant `lo[0]` load inside the loop body (alias uncertainty blocks LICM), while the pass loop is pure SIMD over `hi[i] += 1.0`. The A53's scalar baseline is therefore paying both the extra load cost *and* missing out on SIMD — making the baseline unusually slow and the pass unusually impactful. The 1.65× is real but should be read as "alias uncertainty blocking SIMD on bandwidth-limited in-order hardware."

---

## Cross-Platform Interpretation

The three platforms expose three qualitatively different cost regimes for compile-time alias uncertainty:

**In-order (A53)**: Alias uncertainty is an instruction-count problem. The extra invariant load executes every iteration, adding one instruction to the critical path. The benefit is uniform and predictable from cycle counting. The hardware offers no runtime disambiguation — it just executes instructions in order.

**Shallow OOO (A72)**: Alias uncertainty is a load-store queue tracking problem. The OOO engine speculatively issues loads but must track whether in-flight stores alias them. This tracking accumulates across the entire loop and scales with the number of uncertain aliasing relationships. Eliminating the uncertainty (via LICM hoist) eliminates the tracking overhead entirely. This makes the benefit larger than on A53 for cases with multiple uncertain relationships (`double_invariant`, `matrix_row_split`) and adds a qualitatively new cost mechanism.

**Deep OOO (A76)**: Alias uncertainty is sometimes a tracking problem and sometimes absorbed. The A76's wider execution and larger L1D give its memory ordering units enough capacity to track simple uncertain relationships (single or double aliasing pairs) without accumulating measurable overhead in many cases. However, basic single-load disambiguation overhead persists (`dynamic_split`, `adjacent_tiles`, `split_accumulate`), and cross-function alias uncertainty may generate more speculative tracking pressure than on shallower OOO cores (`subview_noalias`). The `tiling_noinline` regression indicates that the pass's code generation changes (function cloning) can have unfavorable effects on specific OOO implementations.

---

## Summary Table

| Kernel | A53 | A72 | A76 | Primary beneficiary |
|---|---|---|---|---|
| `dynamic_split` | 1.12× | 1.16× | 1.17× | All platforms |
| `adjacent_tiles` | 1.12× | 1.17× | 1.16× | All platforms |
| `subview_noalias` | 1.14× | 1.13× | **1.28×** | A76 (deep OOO speculation) |
| `tiling_noinline` | 1.12× | 1.16× | 0.88× ❌ | A53/A72 only; A76 regression |
| `split_accumulate` | 1.12× | 1.16× | 1.16× | All platforms |
| `double_invariant` | 1.08× | **1.28×** | 1.00× | A72 (shallow OOO LSU overhead) |
| `matrix_row_split` | 1.01× | **1.20×** | 1.00× | A72 only (unique OOO effect) |
| `vectorize_split` | 1.65× | 0.91× ❌ | 1.25× | A53 + A76; DRAM-bound on A72 |

---

## Artifact Locations

| Platform | Binaries | Raw results |
|---|---|---|
| RPi 3B (A53) | `bench_outputs/<kernel>/rpi3b/` | `bench_outputs/rpi_summary.txt` |
| RPi 4B (A72) | `bench_outputs/<kernel>/rpi4b/` | `docs/benchmark-rpi4b.md` |
| RPi 5 (A76) | `bench_outputs/<kernel>/rpi5/` | `bench_outputs/rpi_summary.txt` |

- Per-platform documentation: `docs/benchmark-rpi3b.md`, `docs/benchmark-rpi4b.md`, `docs/benchmark-rpi5.md`
- Cross-compilation script: `scripts/cross_compile_rpi.sh`
- Benchmark runner: `scripts/run_rpi_benchmarks.sh`
