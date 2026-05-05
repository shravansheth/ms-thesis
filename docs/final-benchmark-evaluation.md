# Final Benchmark Evaluation

This document records the final benchmark suite used to evaluate the alias metadata pass on
benchmark-derived kernels. The goal is different from the original handwritten case studies:
instead of only showing that the pass removes missed-optimization remarks, this evaluation measures
whether the pass produces wall-clock speedup on benchmark-derived code.

The source modification is held constant across the comparison. Both baseline and pass variants use
the same modified benchmark.

```text
baseline = modified benchmark + standard lowering + LLVM -O2
pass     = modified benchmark + alias metadata pass + same lowering + LLVM -O2
```

The source changes are storage-layout rewrites: two logical arrays are represented as two
non-overlapping slices of one packed workspace. The kernel arithmetic is unchanged. This exposes the
same adjacent-subview structure studied in the handwritten kernels while keeping the benchmark
semantics intact.

---

## Benchmark Suite

| Benchmark | Source suite | Source language | Timed unit | Modification |
|---|---|---|---|---|
| PolyBench ATAX | PolyBench/C | C | extracted kernel + harness | pack `tmp[M]` and `y[N]` into `work[M+N]` |
| PolyBench BICG | PolyBench/C | C | extracted kernel + harness | pack `s[M]` and `q[N]` into `work[M+N]` |
| IMEX Softmax | IMEX | MLIR | extracted scale stage | pack row stats and row data into adjacent workspace columns |
| PolyBench MVT | PolyBench/C | C | extracted kernel + harness | pack `x1[N]` and `y_1[N]` into `work[2*N]` |
| IREE Bias Add | IREE/Torch | Torch MLIR | extracted bias-add stage | pack `bias[cols]` and `out[rows*cols]` into one workspace |

ATAX, BICG, and MVT include full-main packed PolyBench sources under `final_benchmark/*/modified/`
so the storage rewrite can be diffed directly against the original PolyBench/C source. The timed
binaries use extracted kernels plus harnesses because the full PolyBench drivers expose unrelated
ClangIR lowering issues in the printing/DCE code. The kernel computations and storage rewrites are
the same.

IMEX Softmax and IREE Bias Add are extracted MLIR stages rather than full-benchmark source diffs.
The timed IMEX candidate is the final softmax scale stage:

```text
data[row, col] = data[row, col] / stats[row, 0]
```

The timed IREE candidate is the post-matmul bias-add stage:

```text
out[row, col] = input[row, col] + bias[col]
```

Full candidate sources, generated artifacts, harnesses, and result summaries are under
`final_benchmark/`.

---

## Pipeline

For PolyBench/C candidates:

```text
C source
  -> clang -fclangir -emit-cir
  -> cir-opt --cir-to-mlir
  -> mlir-opt --mem2reg --canonicalize --cse

baseline:
  -> scripts/run_pipeline_cpu.sh
  -> scripts/run_opt_emit_ll.sh
  -> llc
  -> harness + object

pass:
  -> alias-meta-opt --materialize-prefix-subviews --mark-alias-groups --lower-with-alias-meta
  -> scripts/run_pipeline_cpu.sh
  -> scripts/run_opt_emit_ll.sh
  -> llc
  -> harness + object
```

For IMEX/IREE MLIR candidates:

```text
MLIR candidate
  -> baseline path above
  -> pass path above, with alias-meta-opt inserted before standard lowering
```

The ClangIR-specific pre-pass is `--materialize-prefix-subviews`. ClangIR can emit a suffix subview
for an expression like `work + n` while leaving the unoffset argument as the original base buffer:

```mlir
%hi = memref.subview %work[%n] [...]
call @kernel(%work, %hi, ...)
```

The alias pass needs both arguments to be explicit subviews of the same source. The pre-pass rewrites
the call into an equivalent prefix/suffix form:

```mlir
%lo = memref.subview %work[0] [%n] [1]
%hi = memref.subview %work[%n] [...]
call @kernel(%lo, %hi, ...)
```

This does not add alias metadata by itself. It only exposes the structural proof needed by
`--mark-alias-groups`.

---

## Timing Methodology

Mac Mini M4 timing:

```text
final_benchmark/run_mac_final_median_benchmarks.sh
```

Raspberry Pi timing:

```text
final_benchmark/cross_compile_rpi_final.sh
final_benchmark/run_rpi_final_median_benchmarks.sh
```

RPi binaries are statically cross-compiled with `zig cc`:

| Target | CPU passed to `llc` |
|---|---|
| RPi 3B | `cortex-a53` |
| RPi 4B | `cortex-a72` |
| RPi 5 | `cortex-a76` |

Each reported value is the median of 5 full benchmark invocations. Speedup is computed from median
runtimes:

```text
speedup = median(baseline runtime) / median(pass runtime)
```

Correctness was checked by comparing baseline/pass checksums for every benchmark on Mac Mini M4,
RPi3B, RPi4B, and RPi5. All checksum pairs matched.

---

## Results

### Speedup Summary

| Benchmark | Mac Mini M4 | RPi3B | RPi4B | RPi5 |
|---|---:|---:|---:|---:|
| PolyBench ATAX | 1.463× | 1.252× | 1.470× | 1.509× |
| PolyBench BICG | 1.081× | 1.000× | 2.095× | 2.131× |
| IMEX Softmax | 1.022× | 1.000× | 1.106× | 1.123× |
| PolyBench MVT | 1.006× | 1.000× | 1.000× | 1.000× |
| IREE Bias Add | 1.011× | 1.026× | 1.054× | 0.948× |

### Mac Mini M4 Runtimes

| Benchmark | Baseline (ns/call) | Pass (ns/call) | Speedup |
|---|---:|---:|---:|
| PolyBench ATAX | 11,005.69 | 7,522.15 | 1.463× |
| PolyBench BICG | 8,764.25 | 8,105.40 | 1.081× |
| IMEX Softmax | 63,769.50 | 62,416.25 | 1.022× |
| PolyBench MVT | 9,050.65 | 8,992.33 | 1.006× |
| IREE Bias Add | 5,084,722.90 | 5,031,425.00 | 1.011× |

### RPi3B Runtimes

| Benchmark | Baseline (ns/call) | Pass (ns/call) | Speedup |
|---|---:|---:|---:|
| PolyBench ATAX | 227,974.45 | 182,025.05 | 1.252× |
| PolyBench BICG | 291,970.05 | 291,982.97 | 1.000× |
| IMEX Softmax | 3,933,246.82 | 3,932,602.40 | 1.000× |
| PolyBench MVT | 230,021.46 | 230,054.04 | 1.000× |
| IREE Bias Add | 213,779,104.05 | 208,461,218.65 | 1.026× |

### RPi4B Runtimes

| Benchmark | Baseline (ns/call) | Pass (ns/call) | Speedup |
|---|---:|---:|---:|
| PolyBench ATAX | 60,899.98 | 41,423.90 | 1.470× |
| PolyBench BICG | 106,128.54 | 50,655.76 | 2.095× |
| IMEX Softmax | 892,511.78 | 807,051.83 | 1.106× |
| PolyBench MVT | 62,273.12 | 62,288.04 | 1.000× |
| IREE Bias Add | 79,222,053.65 | 75,150,564.80 | 1.054× |

### RPi5 Runtimes

| Benchmark | Baseline (ns/call) | Pass (ns/call) | Speedup |
|---|---:|---:|---:|
| PolyBench ATAX | 27,788.82 | 18,417.06 | 1.509× |
| PolyBench BICG | 46,999.28 | 22,051.73 | 2.131× |
| IMEX Softmax | 226,943.70 | 202,007.39 | 1.123× |
| PolyBench MVT | 28,303.89 | 28,304.19 | 1.000× |
| IREE Bias Add | 27,963,592.55 | 29,509,433.30 | 0.948× |

---

## Per-Benchmark Interpretation

### PolyBench ATAX

ATAX is the strongest source-diff candidate. The full-source rewrite replaces two arrays:

```text
tmp[M], y[N]  ->  work[M+N]
tmp = work[0:m]
y   = work[m:m+n]
```

The pass exposes the `tmp`/`y` split as alias metadata. Baseline remains more conservative around
the packed workspace and keeps more runtime alias handling. The pass path enables stronger
optimization of the `y[j] += A[i][j] * tmp[i]` update. ATAX improves on every target:

```text
Mac Mini M4: 1.463×
RPi3B:       1.252×
RPi4B:       1.470×
RPi5:        1.509×
```

This is the primary final benchmark result.

### PolyBench BICG

BICG packs `s[M]` and `q[N]` into one workspace. The pass clones the call target and attaches alias
metadata to the `s`/`q` accesses. This removes alias uncertainty in a loop that baseline handles
conservatively.

The result is architecture-sensitive:

```text
Mac Mini M4: 1.081×
RPi3B:       1.000×
RPi4B:       2.095×
RPi5:        2.131×
```

The strong RPi4B/RPi5 speedups indicate that the optimized code maps much better to the larger
out-of-order cores. The RPi3B result is flat: on Cortex-A53, the changed code path does not translate
into measurable throughput improvement.

### IMEX Softmax Scale

The IMEX candidate isolates the final row-wise scale stage of softmax and packs row statistics and
row data into adjacent workspace columns. The explicit loop form makes the invariant row statistic
load visible to the alias pass.

Results are modest but positive on the larger platforms:

```text
Mac Mini M4: 1.022×
RPi3B:       1.000×
RPi4B:       1.106×
RPi5:        1.123×
```

This is a useful MLIR-suite-derived supporting benchmark. It demonstrates the same alias-proof
mechanism outside PolyBench/C, but its runtime gains are smaller than ATAX and BICG.

### PolyBench MVT

MVT packs `x1[N]` and `y_1[N]` into one workspace. The pass fires and tags the cloned callee's
accesses, but the runtime effect is effectively flat:

```text
Mac Mini M4: 1.006×
RPi3B:       1.000×
RPi4B:       1.000×
RPi5:        1.000×
```

MVT is useful as pattern evidence, not as a main speedup result. LLVM already optimizes most of the
useful work in this kernel, so the additional alias metadata does not substantially change the final
runtime.

### IREE Bias Add

The IREE candidate isolates the post-matmul bias-add stage and packs `bias` and `out` into one
workspace. The loop order makes `bias[col]` invariant inside the inner row loop, matching the LICM
pattern studied in the case kernels.

Runtime is mixed:

```text
Mac Mini M4: 1.011×
RPi3B:       1.026×
RPi4B:       1.054×
RPi5:        0.948×
```

The pass removes alias-related missed optimizations, but the final code is not uniformly faster.
This benchmark should be framed as supporting evidence for optimization behavior, with the RPi5
regression called out explicitly.

---

## Cross-Platform Notes

The final benchmark suite does not produce the uniform A53 speedups seen in the original
handwritten microbenchmarks. The benchmark-derived kernels are larger and more varied, so the alias
metadata sometimes changes the optimization pipeline without changing the dominant bottleneck.

The most important cross-platform observations:

- ATAX is consistently positive on every platform and is the cleanest primary benchmark.
- BICG is flat on RPi3B but very strong on RPi4B/RPi5, suggesting that the optimization is most useful
  on the out-of-order ARM cores for this kernel.
- IMEX Softmax is a smaller but positive MLIR-suite-derived result on RPi4B/RPi5.
- MVT is effectively neutral across all targets.
- IREE Bias Add demonstrates optimization enabling but has mixed runtime behavior, including a
  regression on RPi5.

The RPi3B flat results for BICG/IMEX/MVT are likely architectural. Cortex-A53 is a small in-order
core with limited vector and scheduling resources. If the pass changes metadata and final code shape
without reducing the A53's dominant critical path, the measured speedup rounds to 1.000×. The larger
out-of-order cores have more ability to convert improved alias information into vectorization,
scheduling freedom, and reduced load-store dependency overhead.

---

## Artifact Locations

| Artifact | Path |
|---|---|
| Final benchmark package | `final_benchmark/` |
| Benchmark overview and source diffs | `final_benchmark/README.md` |
| Snapshot of benchmark note | `final_benchmark/benchmark.md` |
| Mac median raw data | `final_benchmark/bench_outputs/mac_final_median_raw.tsv` |
| Mac median summary | `final_benchmark/bench_outputs/mac_final_median_summary.txt` |
| RPi median raw data | `final_benchmark/bench_outputs/rpi_final_median_raw.tsv` |
| RPi median summary | `final_benchmark/bench_outputs/rpi_final_median_summary.txt` |
| RPi cross-compile script | `final_benchmark/cross_compile_rpi_final.sh` |
| RPi median runner | `final_benchmark/run_rpi_final_median_benchmarks.sh` |
| Mac median runner | `final_benchmark/run_mac_final_median_benchmarks.sh` |

