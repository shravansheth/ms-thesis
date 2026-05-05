# Final Benchmark Evaluation Plan

This folder packages the five current benchmark candidates for thesis
evaluation. Each candidate has:

- `original/`: the original benchmark source or source-suite input used for
  provenance.
- `modified/`: the benchmark variant we actually run through the thesis pass.
- `artifacts/`: generated MLIR/LLVM IR/object/harness artifacts from local
  exploration.

The local timings below are macOS pre-screening numbers. The final thesis
numbers should be collected on RPi 3B, RPi 4B, and RPi 5 using the same
baseline/pass definitions.

## Baseline And Pass Definitions

Baseline means the modified benchmark is compiled normally through the existing
MLIR-to-LLVM pipeline and then optimized with LLVM `-O2`, with no thesis alias
metadata pass.

Pass means the exact same modified benchmark is first run through:

```text
alias-meta-opt \
  --materialize-prefix-subviews \
  --mark-alias-groups \
  --lower-with-alias-meta
```

and then through the same MLIR-to-LLVM pipeline and LLVM `-O2`.

The benchmark source change is not the optimization being measured. The source
change creates a semantics-preserving packed storage layout so the benchmark
contains the same kind of adjacent subview structure as the case studies. The
measured speedup is baseline packed storage versus packed storage plus the pass.

## Common Pipeline

For PolyBench/C ClangIR candidates:

```text
C source
  -> clang -fclangir -emit-cir
  -> cir-opt --cir-to-mlir
  -> mlir-opt --mem2reg --canonicalize --cse

baseline:
  -> scripts/run_pipeline_cpu.sh
  -> scripts/run_opt_emit_ll.sh
  -> llc
  -> clang harness + object

pass:
  -> alias-meta-opt --materialize-prefix-subviews --mark-alias-groups --lower-with-alias-meta
  -> scripts/run_pipeline_cpu.sh
  -> scripts/run_opt_emit_ll.sh
  -> llc
  -> clang harness + object
```

For IMEX/IREE MLIR-suite candidates:

```text
candidate MLIR
  -> baseline path above
  -> pass path above, with alias-meta-opt inserted before lowering
```

Tooling note: ClangIR source emission uses:

```text
/Volumes/ShravsSSD/llvm-project/clangir-memref-subview/build/bin
```

The rest of the MLIR/LLVM scripts use the thesis LLVM build configured in the
existing scripts.

## Candidate 1: PolyBench ATAX

Path:

```text
final_benchmark/polybench_atax
```

Original benchmark:

```text
original/atax.c
original/atax.h
```

Modified benchmark:

```text
modified/atax_packed.c
modified/atax_kernel_packed.c
modified/test_atax_kernel_packed.c
modified/bench_atax_kernel_packed.c
```

Source change:

```text
tmp = work[0:m]
y   = work[m:m+n]
kernel_atax(m, n, A, x, work + m, work)
```

Status:

- Strongest C/source-diff candidate.
- Full `atax_packed.c` shows the small original-source diff.
- `atax_kernel_packed.c` is the executable kernel-derived path used for
  end-to-end compilation and timing.
- Checksums match: `30296.125168`.

Local timing:

| Variant | Time |
|---|---:|
| Baseline | 11262.33 ns/call |
| Pass | 7709.56 ns/call |
| Speedup | 1.46x |

Optimization unlocked:

- The pass rewrites the call to `kernel_atax.__alias_meta_0`.
- LLVM receives `alias.scope` / `noalias` metadata for the packed `tmp` and
  `y` partitions.
- Baseline keeps more runtime alias-conflict checks.
- Pass path gives noalias metadata to `y` zeroing and vectorizes the
  `y[j] += A[i][j] * tmp[i]` update that baseline handles more conservatively.

Important caveat:

- Full PolyBench `main` still exposes ClangIR lowering issues in PolyBench
  DCE/printing code. The kernel-derived executable path isolates the benchmark
  computation and works end to end.

## Candidate 2: PolyBench BICG

Path:

```text
final_benchmark/polybench_bicg
```

Original benchmark:

```text
original/bicg.c
original/bicg.h
```

Modified benchmark:

```text
modified/bicg_kernel_packed.c
modified/test_bicg_kernel_packed.c
modified/bench_bicg_kernel_packed.c
```

Source change:

```text
s = work[0:m]
q = work[m:m+n]
kernel_bicg(m, n, A, work, work + m, p, r)
```

Status:

- Best second PolyBench source-derived candidate.
- Kernel math is the original BICG computation.
- Checksums match: `3727.792479`.

Local timing:

| Variant | Time |
|---|---:|
| Baseline | 8947.77 ns/call |
| Pass | 8270.02 ns/call |
| Speedup | 1.08x |

Optimization unlocked:

- The pass rewrites the call to `kernel_bicg.__alias_meta_0`.
- Metadata is attached to `s`/`q` accesses in the cloned callee.
- Baseline reports `UnsafeDep` loop-vectorizer misses in the packed hot loop.
- Pass path enables an additional vectorized loop in the cloned callee.

## Candidate 3: IMEX Softmax Scale

Path:

```text
final_benchmark/imex_softmax
```

Original benchmark inputs:

```text
original/softmax_cpu.mlir.in
original/softmax.shapes.in
original/softmax.dtypes.in
```

Modified benchmark:

```text
modified/imex_softmax_scale_packed.mlir
modified/bench_imex_softmax_scale_packed.c
```

Source-suite derivation:

- IMEX softmax computes row-wise reductions and row-wise normalization.
- The candidate isolates the row-wise scale stage:

```text
data[row, col] = data[row, col] / stats[row, 0]
```

Storage change:

```text
stats = work[:, 0:k]
data  = work[:, k:k+1024]
```

Status:

- Strongest MLIR-suite candidate.
- This is not a C source diff; it is an MLIR benchmark-template adaptation from
  IMEX.
- Checksums match: `512.000000`.

Local timing:

| Variant | Time |
|---|---:|
| Baseline | 363309.08 ns/call |
| Pass | 240004.92 ns/call |
| Speedup | 1.51x |

Optimization unlocked:

- Baseline has LICM/GVN alias misses and an `UnsafeDep` vectorization miss.
- Pass removes the alias-related misses for this candidate.
- The invariant row-statistic load can be treated independently from stores to
  the row-data partition.

## Candidate 4: PolyBench MVT

Path:

```text
final_benchmark/polybench_mvt
```

Original benchmark:

```text
original/mvt.c
original/mvt.h
```

Modified benchmark:

```text
modified/mvt_kernel_packed.c
modified/test_mvt_kernel_packed.c
modified/bench_mvt_kernel_packed.c
```

Source change:

```text
x1  = work[0:n]
y_1 = work[n:2*n]
kernel_mvt(n, work, x2, work + n, y_2, A)
```

Status:

- Correct and pass fires, but weaker than ATAX and BICG.
- Checksums match: `3730.629051`.

Local timing:

| Variant | Time |
|---|---:|
| Baseline | 9192.73 ns/call |
| Pass | 8987.38 ns/call |
| Speedup | 1.02x |

Optimization unlocked:

- The pass rewrites the call to `kernel_mvt.__alias_meta_0`.
- Metadata is attached to `x1`/`y_1` accesses.
- The effect is small because LLVM already vectorizes much of the useful work;
  some alias/vectorization misses remain.

Recommendation:

- Use as supporting pattern evidence, not as the primary thesis benchmark.

## Candidate 5: IREE Bias Add

Path:

```text
final_benchmark/iree_bias_add
```

Original benchmark inputs:

```text
original/tests.py
original/InterestingShapesBiasAdd_997x997xf32_TN_bias.mlir
original/run_module_io.json
```

Modified benchmark:

```text
modified/iree_bias_add_packed.mlir
modified/bench_iree_bias_add_packed.c
```

Source-suite derivation:

- IREE generated Torch benchmark: `InterestingShapesBiasAdd`.
- Original semantics are `matmul(A, B) + C`.
- The candidate isolates the post-matmul bias-add stage:

```text
out[row, col] = input[row, col] + bias[col]
```

Storage change:

```text
bias = work[0:cols]
out  = work[cols:cols + rows*cols]
```

Status:

- Useful as supporting evidence, not a primary timing benchmark.
- Checksums match: `17825736.000000`.

Local timing:

| Variant | Time |
|---|---:|
| Baseline | 4527977.67 ns/call |
| Pass | 4797506.75 ns/call |
| Speedup | 0.94x |

Optimization unlocked:

- Baseline has LICM/GVN alias misses for the packed bias/output layout.
- Pass removes those alias misses and produces extra hoists.
- Local macOS runtime regresses, so this should be framed as optimization
  behavior evidence rather than a speedup result.

## RPi Evaluation Plan

Run all five candidates on:

```text
RPi 3B
RPi 4B
RPi 5
```

For each board and candidate:

1. Build baseline and pass variants from the packaged modified benchmark.
2. Run correctness harness first and confirm checksum equality.
3. Run timing harness for baseline and pass.
4. Repeat enough rounds to report stable best or median timing, matching the
   methodology used in prior RPi experiments.
5. Record:

```text
board
candidate
baseline ns/call
pass ns/call
speedup = baseline / pass
checksum baseline
checksum pass
optimization evidence from O2 remarks
```

Primary expected thesis candidates:

1. PolyBench ATAX
2. PolyBench BICG
3. IMEX softmax scale

Secondary/supporting candidates:

1. PolyBench MVT
2. IREE bias add
