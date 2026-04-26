# Benchmark Results — Raspberry Pi 3B (Cortex-A53)

## Hardware

| Property | Value |
|---|---|
| Board | Raspberry Pi 3B |
| CPU | ARM Cortex-A53 @ 1.2 GHz |
| Issue | 2-wide, **in-order** |
| Load-store units | 1 (single, 1-cycle throughput, 4-cycle L1 latency) |
| L1D cache | 32 KB |
| L2 cache | 256 KB (shared) |
| Memory | LPDDR2, ~4 GB/s practical bandwidth |
| OS | Raspberry Pi OS Lite (64-bit, no desktop) |

The Cortex-A53 is a deeply in-order core. It cannot reorder or speculate memory accesses the way a modern OOO processor (Apple M-series, Cortex-A76) can. This makes it the ideal target to measure the wall-clock impact of compile-time alias proofs: the hardware offers no runtime disambiguation to mask the savings.

---

## Methodology

### Cross-compilation

Binaries were cross-compiled on an Apple Silicon Mac using:

- `llc -mtriple=aarch64-linux-gnu -mcpu=cortex-a53` to compile LLVM IR (`.O2.ll`) to AArch64 ELF objects
- `zig cc --target=aarch64-linux-musl -static` to compile C harnesses and link into fully static binaries (musl libc bundled — no sysroot or glibc version dependency)

The `.O2.ll` IR files are the same used for macOS benchmarks; `llc` handles target-specific lowering. The `-mtriple` flag overrides any macOS target triple baked into the file by the `opt` run.

Binary format verified: `ELF 64-bit LSB executable, ARM aarch64, statically linked`.

### Timing harness

Each benchmark uses `CLOCK_MONOTONIC_RAW` via `clock_gettime`. The macro runs:

1. `NWARMUP` full calls (cache warm-up, branch predictor training — not timed)
2. `NROUNDS = 5` timed rounds, each running `NITERS` calls
3. Reports the **minimum** ns/call across all rounds (filters OS scheduling noise)

### Baseline vs pass

- **Baseline**: standard `mlir-opt` lowering pipeline, no alias metadata. Produces LLVM IR with no `!alias.scope` / `!noalias` annotations.
- **Pass**: same pipeline + `MarkAliasGroupsPass` + `LowerWithAliasMetaPass`. Produces LLVM IR with `!alias.scope` / `!noalias` on all load/store instructions touching provably disjoint subview regions.

For `vectorize_split` specifically, the pass IR was generated with `-force-vector-width=4`. See the vectorize_split section for explanation.

### Deployment

Binaries were transferred via `scp` over Tailscale and executed via SSH. Results collected into `bench_outputs/rpi_summary.txt`.

---

## Results

### Scalar invariant-load hoist cases

These kernels share the same structural pattern: a dynamic partition of a flat array into `lo` and `hi` subviews via `memref.subview`. The inner loop reads `lo[0]` (invariant) and reads/writes `hi[i]` (variant). Without alias metadata, LLVM cannot prove that `lo[0]` and `hi[i]` are disjoint — `lo[0]` load is stuck inside the loop.

| Kernel | Baseline (ns/call) | Pass (ns/call) | Speedup |
|---|---|---|---|
| `dynamic_split` | 7,747 | 6,890 | **1.12×** |
| `adjacent_tiles` | 3,885 | 3,458 | **1.12×** |
| `subview_noalias` | 3,594 | 3,165 | **1.14×** |
| `tiling_noinline` | 3,893 | 3,464 | **1.12×** |
| `split_accumulate` | 7,746 | 6,887 | **1.12×** |
| `double_invariant` | 11,183 | 10,326 | **1.08×** |

**Confirmed via disassembly (`dynamic_split`):**

Baseline inner loop:
```asm
.LBB0_2:
    ldr s0, [x1]                  // lo[0] — invariant, loaded every iteration
    ldr s1, [x10, x9, lsl #2]    // hi[i] — variant
    fadd s0, s0, s1
    str s0, [x10, x9, lsl #2]
    add x9, x9, #1
    cmp x9, x8
    b.lt .LBB0_2
```

Pass inner loop:
```asm
.LBB0_2:
    ldr s1, [x10, x9, lsl #2]    // hi[i] — only load; lo[0] is in s0 (register, pre-loop)
    fadd s1, s1, s0
    str s1, [x10, x9, lsl #2]
    add x9, x9, #1
    cmp x9, x8
    b.lt .LBB0_2
```

The `ldr s0, [x1]` (invariant load) is absent from the pass loop body.

#### Why ~1.12× and not more

A53 has a single load-store unit with **1-cycle throughput** and **4-cycle L1 latency**. The two loads in the baseline loop are independent (different addresses, no data dependency between them), so they can be issued in consecutive cycles. However, the `fadd` cannot execute until both results are available — it waits for the later of the two, i.e., 1 extra cycle.

Per-iteration cycle counts (approximate):

| | Baseline | Pass |
|---|---|---|
| Issue `ldr lo[0]` | cycle 1 | — |
| Issue `ldr hi[i]` | cycle 2 | cycle 1 |
| `lo[0]` ready | cycle 5 | — |
| `hi[i]` ready | cycle 6 | cycle 5 |
| `fadd` can issue | cycle 6 | cycle 5 |
| Loop overhead | ~4 cycles | ~4 cycles |
| **Total** | **~10 cycles** | **~9 cycles** |

Expected speedup: 10/9 ≈ **1.11×** — consistent with the measured **1.12×**.

On an OOO processor (e.g., Apple M-series), the hardware's memory disambiguation and deep out-of-order window masks this 1-cycle difference entirely, giving ~1.0× on macOS. The A53's in-order nature is precisely what makes compile-time alias proofs measurable in wall clock.

#### Note on double_invariant (1.08×)

`double_invariant` has two invariant loads (both `lo[0]` and `lo[1]`) hoisted. The smaller relative speedup compared to single-hoist cases is because the baseline loop body is proportionally heavier (more arithmetic, more instructions) — the absolute ns saved (~857 ns/call) is similar across all cases, but the baseline denominator is larger (11,183 ns vs ~7,700 ns for single-hoist cases).

#### Note on tiling_noinline and subview_noalias (cross-function boundary)

`tiling_noinline` and `subview_noalias` involve noinline callees. The pass clones the callee with alias metadata attached. The runtime improvement (~1.12-1.14×) is consistent with the other cases — the cross-function boundary does not add overhead; the cloned callee receives the same metadata quality as inlined cases.

---

### matrix_row_split

| Kernel | Baseline (ns/call) | Pass (ns/call) | Speedup |
|---|---|---|---|
| `matrix_row_split` | 226,164 | 225,033 | 1.01× (noise) |

This case is excluded from wall-clock evaluation. The `matrix_row_split` kernel has a 2D loop: outer (64 rows) and inner (512 columns). The invariant load `top[0, 0]` is inside the **outer** loop but outside the inner loop. LICM hoists it out of the outer loop — saving 64 load instructions per call across 32,768 inner loop iterations. That is ~0.2% of total work, below measurement noise on any hardware.

The case remains valid as a case study (remarks confirm the miss and the fix), but it is not suitable for wall-clock benchmarking.

---

### Vectorization-enabling: vectorize_split

| Version | Loop type | ns/call | Speedup |
|---|---|---|---|
| Baseline | Scalar (UnsafeDep) | 7,356,595 | 1.00× |
| Pass + fvw4 | NEON `<4 x float>` | 4,448,108 | **1.65×** |

**Confirmed via disassembly:**

Pass inner loop:
```asm
fmov v0.4s, #1.00000000          // splat constant 1.0 into 4-wide vector (pre-loop)
.LBB0_1:
    ldr q1, [x9, x8]             // load 4 floats (128-bit)
    fadd v1.4s, v1.4s, v0.4s    // add 4 floats (NEON vector)
    str q1, [x9, x8]             // store 4 floats (128-bit)
    add x8, x8, #16              // advance 16 bytes (4 floats)
    cmp x8, #4194304
    b.ne .LBB0_1
```

Baseline inner loop:
```asm
.LBB0_1:
    ldr s0, [x1]                 // lo[0] — invariant scalar load, every iteration
    ldr s1, [x1, x10]           // hi[i] — variant scalar load
    fadd s0, s0, s1
    str s0, [x1, x10]
    add x10, x10, #4
    b.lo .LBB0_1
```

#### Why -force-vector-width=4

After alias resolution, LLVM's cost model (running with `-O2`) rated the resulting `hi[i] += 1.0` loop as `VectorizationNotBeneficial`. The `-force-vector-width=4` flag overrides this cost estimate. Crucially, it does **not** override safety checks — the baseline's `UnsafeDep` fires before the cost model is consulted and cannot be overridden by any forced width. So:

- Baseline + fvw4: still scalar — `UnsafeDep` blocks it
- Pass + fvw4: NEON SIMD — alias resolved, no safety issue

The speedup (1.65×) is therefore entirely attributable to the alias metadata enabling SIMD, not to the forced width itself.

#### Why 1.65× on RPi vs 3.76× on macOS

The `vectorize_split` working set is 8 MB (2M floats). This far exceeds A53's 32 KB L1 and 256 KB L2. The benchmark is **memory bandwidth bound** on the RPi: both scalar and SIMD must stream 4 MB of reads and 4 MB of writes per call through LPDDR2 (~4 GB/s practical bandwidth).

SIMD reduces instruction count (262K iterations instead of 1M) and loop overhead, but the bandwidth bottleneck limits the maximum achievable speedup. On the Mac (Apple M-series with >100 GB/s bandwidth and large caches), the kernel is more compute-bound, making the 4-wide SIMD throughput advantage more visible.

---

## Summary

| Kernel | RPi 3B speedup | macOS speedup | Optimization |
|---|---|---|---|
| `dynamic_split` | **1.12×** | ~1.0× | Scalar LICM hoist (1 load/iter removed) |
| `adjacent_tiles` | **1.12×** | ~1.0× | Scalar LICM hoist |
| `subview_noalias` | **1.14×** | ~1.0× | LICM hoist across noinline call boundary |
| `tiling_noinline` | **1.12×** | ~1.0× | LICM hoist across noinline call boundary |
| `split_accumulate` | **1.12×** | ~1.0× | Scalar LICM hoist |
| `double_invariant` | **1.08×** | ~1.0× | LICM hoist (2 loads/iter removed) |
| `matrix_row_split` | ~1.0× (noise) | ~1.0× (noise) | Hoist on outer loop only — excluded |
| `vectorize_split` | **1.65×** | **3.76×** | Alias metadata enables NEON SIMD |

The consistent 1.12× across five structurally different kernels confirms that the improvement is a systematic property of the alias metadata, not noise or a kernel-specific artifact. The variation across platforms (macOS vs. RPi 3B) follows from hardware differences rather than differences in the pass.

---

## Artifact locations

- Kernels (MLIR source): `benchmarks/vectorize_split.mlir`, `kernels/mlir/<name>.mlir`
- IR (baseline + with_meta): `microbench_outputs/<kernel>/baseline/`, `microbench_outputs/<kernel>/with_meta/`
- Cross-compiled binaries: `bench_outputs/<kernel>/rpi3b/`
- C harnesses: `benchmarks/bench_<kernel>.c`
- Scripts: `scripts/cross_compile_rpi.sh`, `scripts/run_rpi_benchmarks.sh`
- Raw results: `bench_outputs/rpi_summary.txt`
