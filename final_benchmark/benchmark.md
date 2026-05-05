# Final Benchmark Suite

This directory contains the benchmark suite used for the final thesis
evaluation. The goal is to measure whether the alias metadata pass unlocks
LLVM optimizations that baseline `-O2` misses when two logical arrays are
represented as disjoint slices of one packed workspace.

The source modification is not the optimization being measured. Baseline and
pass runs both use the same modified benchmark. The comparison is:

```text
baseline = modified benchmark + normal lowering + LLVM -O2
pass     = modified benchmark + alias metadata pass + same lowering + LLVM -O2
```

The modification is intentionally small in spirit: replace two independent
logical buffers with two non-overlapping regions of one larger buffer. This
preserves the benchmark computation while creating the packed subview pattern
the thesis pass is designed to recover.

## Benchmarks

```text
Benchmark          Source Suite   Source Language   Final Timing Unit
-----------------  -------------  ----------------  -------------------------
PolyBench ATAX     PolyBench/C    C                 extracted kernel + harness
PolyBench BICG     PolyBench/C    C                 extracted kernel + harness
IMEX Softmax       IMEX           MLIR              extracted scale stage
PolyBench MVT      PolyBench/C    C                 extracted kernel + harness
IREE Bias Add      IREE/Torch     Torch MLIR        extracted bias-add stage
```

ATAX, BICG, and MVT have full-main packed source files so the source
modification can be shown with a direct diff against the original PolyBench/C
benchmark. The actual timed binaries still use extracted-kernel paths, because
the full PolyBench drivers expose unrelated ClangIR lowering issues in the
printing/DCE code. The kernel computations and storage rewrites are the same.

IMEX Softmax and IREE Bias Add are MLIR-suite-derived candidates. They are not
C source diffs. They isolate relevant stages from larger benchmark templates:
softmax row scaling for IMEX and post-matmul bias addition for IREE. A literal
full-file diff for those two would mostly show stage extraction rather than a
small full-benchmark storage rewrite, so the document shows the extracted MLIR
stage that is timed.

## Pipeline

For the PolyBench/C candidates:

```text
C source
  -> clang -fclangir -emit-cir
  -> cir-opt --cir-to-mlir
  -> mlir-opt --mem2reg --canonicalize --cse

baseline:
  -> scripts/run_pipeline_cpu.sh
  -> scripts/run_opt_emit_ll.sh
  -> llc
  -> clang/zig harness + object

pass:
  -> alias-meta-opt --materialize-prefix-subviews --mark-alias-groups --lower-with-alias-meta
  -> scripts/run_pipeline_cpu.sh
  -> scripts/run_opt_emit_ll.sh
  -> llc
  -> clang/zig harness + object
```

For IMEX/IREE MLIR candidates:

```text
MLIR benchmark candidate
  -> baseline path above
  -> pass path above, with alias-meta-opt inserted before lowering
```

Mac Mini M4 timing uses local object generation and `clang -O2` through:

```text
final_benchmark/run_mac_final_median_benchmarks.sh
```

Raspberry Pi timing uses:

```text
final_benchmark/cross_compile_rpi_final.sh
final_benchmark/run_rpi_final_median_benchmarks.sh
```

The RPi script cross-compiles static AArch64 binaries for:

```text
RPi 3B: cortex-a53
RPi 4B: cortex-a72
RPi 5:  cortex-a76
```

Tool paths used for generating the packaged artifacts:

```text
ClangIR clang:
  /Volumes/ShravsSSD/llvm-project/clangir-memref-subview/build/bin/clang

ClangIR cir-opt:
  /Volumes/ShravsSSD/llvm-project/clangir-memref-subview/build/bin/cir-opt

Thesis MLIR/LLVM tools:
  /Users/shravansheth/ShravsSSD/llvm-project/build/bin/mlir-opt
  /Users/shravansheth/ShravsSSD/llvm-project/build/bin/mlir-translate
  /Users/shravansheth/ShravsSSD/llvm-project/build/bin/opt
  /Users/shravansheth/ShravsSSD/llvm-project/build/bin/llc

Thesis pass driver:
  /Volumes/ShravsSSD/ms-thesis-copy/pass/build/bin/alias-meta-opt

RPi linker/compiler:
  zig cc --target=aarch64-linux-musl -static -O2
```

## Pass Structure

The pass pipeline has three parts:

```text
alias-meta-opt
  --materialize-prefix-subviews
  --mark-alias-groups
  --lower-with-alias-meta
```

`--materialize-prefix-subviews` is the small pre-pass added for the ClangIR
pipeline. ClangIR can emit a suffix subview for an expression such as
`work + n`, while leaving the unoffset pointer argument as the original base
buffer:

```mlir
%hi_sv = memref.subview %work[%n] [...]
call @kernel(%work, %hi_sv, ...)
```

The alias pass needs both arguments to be explicit subviews of the same source.
The pre-pass rewrites the call into the equivalent shape:

```mlir
%lo_sv = memref.subview %work[0] [%n] [1]
%hi_sv = memref.subview %work[%n] [...]
call @kernel(%lo_sv, %hi_sv, ...)
```

It preserves the call ABI with a `memref.reinterpret_cast` when needed. This
does not introduce the optimization itself; it only exposes the prefix/suffix
relationship so the next pass can reason about it.

`--mark-alias-groups` detects adjacent subviews of the same source. The core
proof is:

```text
hi.offset == lo.offset + lo.size
```

When that holds, the two subviews are disjoint. For noinline kernel calls, the
pass clones the callee for that call site and tags loads/stores in the clone,
instead of tagging the original callee globally.

`--lower-with-alias-meta` partially lowers the tagged `memref.load` and
`memref.store` operations to LLVM loads/stores carrying `alias.scope` and
`noalias` metadata. The rest of the module is lowered normally by the existing
pipeline.

## PolyBench ATAX

Path:

```text
final_benchmark/polybench_atax
```

Files:

```text
original/atax.c
modified/atax_packed.c
modified/atax_kernel_packed.c
modified/bench_atax_kernel_packed.c
modified/test_atax_kernel_packed.c
```

ATAX has two logical arrays, `tmp[M]` and `y[N]`. The full-source modification
packs them into one workspace:

```text
tmp = work[0:m]
y   = work[m:m+n]
```

The original kernel math is unchanged. The final live-out array is still `y`,
now addressed as `work + m`.

Actual full-source diff:

```diff
--- final_benchmark/polybench_atax/original/atax.c
+++ final_benchmark/polybench_atax/modified/atax_packed.c
@@ -95,8 +95,7 @@
   /* Variable declaration/allocation. */
   POLYBENCH_2D_ARRAY_DECL(A, DATA_TYPE, M, N, m, n);
   POLYBENCH_1D_ARRAY_DECL(x, DATA_TYPE, N, n);
-  POLYBENCH_1D_ARRAY_DECL(y, DATA_TYPE, N, n);
-  POLYBENCH_1D_ARRAY_DECL(tmp, DATA_TYPE, M, m);
+  DATA_TYPE *work = (DATA_TYPE *) polybench_alloc_data(m + n, sizeof(DATA_TYPE));
 
   /* Initialize array(s). */
   init_array (m, n, POLYBENCH_ARRAY(A), POLYBENCH_ARRAY(x));
@@ -108,8 +107,8 @@
   kernel_atax (m, n,
 	       POLYBENCH_ARRAY(A),
 	       POLYBENCH_ARRAY(x),
-	       POLYBENCH_ARRAY(y),
-	       POLYBENCH_ARRAY(tmp));
+	       work + m,
+	       work);
 
   /* Stop and print timer. */
   polybench_stop_instruments;
@@ -117,13 +116,12 @@
 
   /* Prevent dead-code elimination. All live-out data must be printed
      by the function call in argument. */
-  polybench_prevent_dce(print_array(n, POLYBENCH_ARRAY(y)));
+  polybench_prevent_dce(print_array(n, work + m));
 
   /* Be clean. */
   POLYBENCH_FREE_ARRAY(A);
   POLYBENCH_FREE_ARRAY(x);
-  POLYBENCH_FREE_ARRAY(y);
-  POLYBENCH_FREE_ARRAY(tmp);
+  polybench_free_data((void*)work);
 
   return 0;
 }
```

Final timing uses `modified/bench_atax_kernel_packed.c` linked against either:

```text
artifacts/kernel_baseline/atax_kernel_packed.O2.ll
artifacts/kernel_with_meta/atax_kernel_packed.meta.O2.ll
```

Optimization unlocked:

```text
Baseline keeps more conservative alias handling around tmp/y workspace accesses.
Pass path gives LLVM noalias metadata for the packed tmp/y split.
This removes alias checks and enables stronger vectorization in the y update.
```

## PolyBench BICG

Path:

```text
final_benchmark/polybench_bicg
```

Files:

```text
original/bicg.c
modified/bicg_packed.c
modified/bicg_kernel_packed.c
modified/bench_bicg_kernel_packed.c
modified/test_bicg_kernel_packed.c
```

BICG has two live-out vectors, `s[M]` and `q[N]`. The kernel-derived
modification packs them into one workspace:

```text
s = work[0:m]
q = work[m:m+n]
```

The original kernel math is unchanged. The two live-out arrays are still
printed in the same order, now addressed as `work` and `work + m`.

Actual full-source diff:

```diff
--- final_benchmark/polybench_bicg/original/bicg.c
+++ final_benchmark/polybench_bicg/modified/bicg_packed.c
@@ -104,8 +104,7 @@
 
   /* Variable declaration/allocation. */
   POLYBENCH_2D_ARRAY_DECL(A, DATA_TYPE, N, M, n, m);
-  POLYBENCH_1D_ARRAY_DECL(s, DATA_TYPE, M, m);
-  POLYBENCH_1D_ARRAY_DECL(q, DATA_TYPE, N, n);
+  DATA_TYPE *work = (DATA_TYPE *) polybench_alloc_data(m + n, sizeof(DATA_TYPE));
   POLYBENCH_1D_ARRAY_DECL(p, DATA_TYPE, M, m);
   POLYBENCH_1D_ARRAY_DECL(r, DATA_TYPE, N, n);
 
@@ -121,8 +120,8 @@
   /* Run kernel. */
   kernel_bicg (m, n,
 	       POLYBENCH_ARRAY(A),
-	       POLYBENCH_ARRAY(s),
-	       POLYBENCH_ARRAY(q),
+	       work,
+	       work + m,
 	       POLYBENCH_ARRAY(p),
 	       POLYBENCH_ARRAY(r));
 
@@ -132,12 +131,11 @@
 
   /* Prevent dead-code elimination. All live-out data must be printed
      by the function call in argument. */
-  polybench_prevent_dce(print_array(m, n, POLYBENCH_ARRAY(s), POLYBENCH_ARRAY(q)));
+  polybench_prevent_dce(print_array(m, n, work, work + m));
 
   /* Be clean. */
   POLYBENCH_FREE_ARRAY(A);
-  POLYBENCH_FREE_ARRAY(s);
-  POLYBENCH_FREE_ARRAY(q);
+  polybench_free_data((void*)work);
   POLYBENCH_FREE_ARRAY(p);
   POLYBENCH_FREE_ARRAY(r);
```

The actual wrapper in the timed source is:

```c
void run_bicg_packed(DATA_TYPE A[N][M],
                     DATA_TYPE p[M],
                     DATA_TYPE r[N],
                     DATA_TYPE *work,
                     int m,
                     int n) {
  kernel_bicg(m, n, A, work, work + m, p, r);
}
```

Final timing uses `modified/bench_bicg_kernel_packed.c` linked against:

```text
artifacts/baseline/bicg_kernel_packed.O2.ll
artifacts/with_meta/bicg_kernel_packed.meta.O2.ll
```

Optimization unlocked:

```text
Baseline reports unsafe-dependence style vectorization misses in the packed loop.
Pass path clones the call target and tags s/q accesses with alias metadata.
The metadata enables an additional vectorized loop in the cloned callee.
```

## IMEX Softmax Scale

Path:

```text
final_benchmark/imex_softmax
```

Files:

```text
original/softmax_cpu.mlir.in
original/softmax.shapes.in
original/softmax.dtypes.in
modified/imex_softmax_scale_packed.mlir
modified/bench_imex_softmax_scale_packed.c
```

The original IMEX template computes full softmax. The final softmax stage is a
row-wise scale:

```text
data[row, col] = data[row, col] / stats[row, 0]
```

The storage manipulation packs per-row stats and row data into adjacent column
partitions of one workspace:

```text
stats = work[:, 0:k]
data  = work[:, k:k+1024]
```

The candidate represents that linalg stage as explicit `scf.for` loops over
the same row/column iteration space. The loops are not additional work; they
are the extracted scale computation written in a form that exposes explicit
`memref.subview`, `memref.load`, and `memref.store` operations to the pass.

Extracted MLIR stage used for timing:

```diff
-  %10 = linalg.generic ... ins(%7, %9) outs(%5) {
-    %11 = arith.divf %in, %in_1 : f32
-    linalg.yield %11 : f32
-  }
+  %stats = memref.subview %work[0, 0][%rows, %k][1, 1]
+  %data = memref.subview %work[0, %k][%rows, 1024][1, 1]
+
+  scf.for %r = %c0 to %rows step %c1 {
+    scf.for %c = %c0 to %c1024 step %c1 {
+      %scale = memref.load %stats[%r, %c0]
+      %x = memref.load %data[%r, %c]
+      %y = arith.divf %x, %scale : f32
+      memref.store %y, %data[%r, %c]
+    }
+  }
```

Final timing uses `modified/bench_imex_softmax_scale_packed.c` linked against:

```text
artifacts/baseline/imex_softmax_scale_packed.O2.ll
artifacts/pass/imex_softmax_scale_packed.meta.O2.ll
```

Optimization unlocked:

```text
Baseline misses some LICM/GVN/vectorization opportunities because stats and data
come from the same workspace. The pass proves the stats/data subviews are
disjoint and attaches metadata so the row statistic load can be treated
independently from stores to the data partition.
```

## PolyBench MVT

Path:

```text
final_benchmark/polybench_mvt
```

Files:

```text
original/mvt.c
modified/mvt_packed.c
modified/mvt_kernel_packed.c
modified/bench_mvt_kernel_packed.c
modified/test_mvt_kernel_packed.c
```

MVT has vectors `x1[N]`, `x2[N]`, `y_1[N]`, and `y_2[N]`. This candidate
packs `x1` and `y_1` into one workspace:

```text
x1  = work[0:n]
y_1 = work[n:2*n]
```

The original kernel math is unchanged. `x1` remains the first live-out vector,
now addressed as `work`.

Actual full-source diff:

```diff
--- final_benchmark/polybench_mvt/original/mvt.c
+++ final_benchmark/polybench_mvt/modified/mvt_packed.c
@@ -103,17 +103,16 @@
 
   /* Variable declaration/allocation. */
   POLYBENCH_2D_ARRAY_DECL(A, DATA_TYPE, N, N, n, n);
-  POLYBENCH_1D_ARRAY_DECL(x1, DATA_TYPE, N, n);
+  DATA_TYPE *work = (DATA_TYPE *) polybench_alloc_data(2 * n, sizeof(DATA_TYPE));
   POLYBENCH_1D_ARRAY_DECL(x2, DATA_TYPE, N, n);
-  POLYBENCH_1D_ARRAY_DECL(y_1, DATA_TYPE, N, n);
   POLYBENCH_1D_ARRAY_DECL(y_2, DATA_TYPE, N, n);
 
 
   /* Initialize array(s). */
   init_array (n,
-	      POLYBENCH_ARRAY(x1),
+	      work,
 	      POLYBENCH_ARRAY(x2),
-	      POLYBENCH_ARRAY(y_1),
+	      work + n,
 	      POLYBENCH_ARRAY(y_2),
 	      POLYBENCH_ARRAY(A));
 
@@ -122,9 +121,9 @@
 
   /* Run kernel. */
   kernel_mvt (n,
-	      POLYBENCH_ARRAY(x1),
+	      work,
 	      POLYBENCH_ARRAY(x2),
-	      POLYBENCH_ARRAY(y_1),
+	      work + n,
 	      POLYBENCH_ARRAY(y_2),
 	      POLYBENCH_ARRAY(A));
 
@@ -134,13 +133,12 @@
 
   /* Prevent dead-code elimination. All live-out data must be printed
      by the function call in argument. */
-  polybench_prevent_dce(print_array(n, POLYBENCH_ARRAY(x1), POLYBENCH_ARRAY(x2)));
+  polybench_prevent_dce(print_array(n, work, POLYBENCH_ARRAY(x2)));
 
   /* Be clean. */
   POLYBENCH_FREE_ARRAY(A);
-  POLYBENCH_FREE_ARRAY(x1);
+  polybench_free_data((void*)work);
   POLYBENCH_FREE_ARRAY(x2);
-  POLYBENCH_FREE_ARRAY(y_1);
   POLYBENCH_FREE_ARRAY(y_2);
```

The actual wrapper in the timed source is:

```c
void run_mvt_packed(DATA_TYPE A[N][N],
                    DATA_TYPE x2[N],
                    DATA_TYPE y_2[N],
                    DATA_TYPE *work,
                    int n) {
  kernel_mvt(n, work, x2, work + n, y_2, A);
}
```

Final timing uses `modified/bench_mvt_kernel_packed.c` linked against:

```text
artifacts/baseline/mvt_kernel_packed.O2.ll
artifacts/with_meta/mvt_kernel_packed.meta.O2.ll
```

Optimization unlocked:

```text
The pass fires and tags x1/y_1 accesses in a cloned callee. Runtime effect is
small because LLVM already handles much of the useful loop optimization in this
kernel, so MVT is supporting evidence rather than the main result.
```

## IREE Bias Add

Path:

```text
final_benchmark/iree_bias_add
```

Files:

```text
original/tests.py
original/InterestingShapesBiasAdd_997x997xf32_TN_bias.mlir
original/run_module_io.json
modified/iree_bias_add_packed.mlir
modified/bench_iree_bias_add_packed.c
```

The original IREE/Torch generated benchmark is:

```text
matmul(A, B) + C
```

The candidate isolates the post-matmul bias-add stage:

```text
out[row, col] = input[row, col] + bias[col]
```

The storage manipulation packs `bias` and `out` into one workspace:

```text
bias = work[0:cols]
out  = work[cols:cols + rows*cols]
```

The loop nest is the explicit implementation of the extracted bias-add stage.
It is not added on top of the full matmul benchmark. The timed candidate takes
the already-produced matrix as `input`, reads the packed `bias` slice, and
writes the packed `out` slice. The chosen loop order makes `bias[col]`
loop-invariant inside the inner row loop, which matches the LICM pattern being
tested.

Extracted MLIR stage used for timing:

```diff
-  %1 = torch.aten.mm %arg0, %arg1
-  %2 = torch.aten.copy %0, %1
-  %3 = torch.aten.add.Tensor %2, %arg2, %int1
+  %bias = memref.subview %work[0][%cols][1]
+  %out = memref.subview %work[%cols][%total][1]
+
+  scf.for %j = %c0 to %cols step %c1 {
+    scf.for %i = %c0 to %rows step %c1 {
+      %idx = ...
+      %b = memref.load %bias[%j]
+      %x = memref.load %input[%idx]
+      %y = arith.addf %x, %b : f32
+      memref.store %y, %out[%idx]
+    }
+  }
```

Final timing uses `modified/bench_iree_bias_add_packed.c` linked against:

```text
artifacts/baseline/iree_bias_add_packed.O2.ll
artifacts/pass/iree_bias_add_packed.meta.O2.ll
```

Optimization unlocked:

```text
Baseline has alias-related LICM/GVN misses for the packed bias/output layout.
The pass proves the bias and output partitions are disjoint and removes those
alias misses. Runtime is mixed across machines, so this is supporting evidence
rather than the primary speedup benchmark.
```

## Correctness

Correctness was checked by comparing baseline/pass checksums for every final
benchmark on Mac Mini M4, RPi3B, RPi4B, and RPi5. All checksum pairs matched.

## Results

Times are `ns/call`. Mac Mini M4 values are medians of 5 full benchmark
invocations from `final_benchmark/bench_outputs/mac_final_median_summary.txt`.
RPi values are medians of 5 full benchmark invocations from
`final_benchmark/bench_outputs/rpi_final_median_summary.txt`.

Speedup is computed as:

```text
median(baseline runtime) / median(pass runtime)
```

Speedup summary:

```text
Benchmark          Mac Mini M4   RPi3B    RPi4B    RPi5
-----------------  -----------  -------  -------  -------
PolyBench ATAX          1.463x   1.252x   1.470x   1.509x
PolyBench BICG          1.081x   1.000x   2.095x   2.131x
IMEX Softmax            1.022x   1.000x   1.106x   1.123x
PolyBench MVT           1.006x   1.000x   1.000x   1.000x
IREE Bias Add           1.011x   1.026x   1.054x   0.948x
```

Mac Mini M4 runtimes:

```text
Benchmark             Baseline        Pass    Speedup
------------------  ----------  ----------  ---------
PolyBench ATAX        11005.69     7522.15     1.463x
PolyBench BICG         8764.25     8105.40     1.081x
IMEX Softmax          63769.50    62416.25     1.022x
PolyBench MVT          9050.65     8992.33     1.006x
IREE Bias Add       5084722.90  5031425.00     1.011x
```

RPi3B runtimes:

```text
Benchmark             Baseline          Pass    Speedup
------------------  ------------  ------------  ---------
PolyBench ATAX        227974.45     182025.05     1.252x
PolyBench BICG        291970.05     291982.97     1.000x
IMEX Softmax         3933246.82    3932602.40     1.000x
PolyBench MVT         230021.46     230054.04     1.000x
IREE Bias Add      213779104.05  208461218.65     1.026x
```

RPi4B runtimes:

```text
Benchmark             Baseline         Pass    Speedup
------------------  -----------  -----------  ---------
PolyBench ATAX         60899.98     41423.90     1.470x
PolyBench BICG        106128.54     50655.76     2.095x
IMEX Softmax          892511.78    807051.83     1.106x
PolyBench MVT          62273.12     62288.04     1.000x
IREE Bias Add       79222053.65  75150564.80     1.054x
```

RPi5 runtimes:

```text
Benchmark             Baseline         Pass    Speedup
------------------  -----------  -----------  ---------
PolyBench ATAX         27788.82     18417.06     1.509x
PolyBench BICG         46999.28     22051.73     2.131x
IMEX Softmax          226943.70    202007.39     1.123x
PolyBench MVT          28303.89     28304.19     1.000x
IREE Bias Add       27963592.55  29509433.30     0.948x
```

The strongest speedup candidates are ATAX and BICG. ATAX is positive on all
targets. BICG is especially strong on RPi4B and RPi5. IMEX Softmax gives a
smaller but still positive result on RPi4B and RPi5. MVT is mostly flat and is
best treated as supporting pattern evidence. IREE Bias Add demonstrates that
the pass removes alias-related missed optimizations, but runtime is mixed and
it regresses on RPi5.
