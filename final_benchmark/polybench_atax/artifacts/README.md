# PolyBench ATAX ClangIR Source-Diff Candidate

This folder tests whether a real benchmark source can be changed by a small,
semantics-preserving storage rewrite and then run through the ClangIR subview
pipeline.

## Full PolyBench Source Diff

`atax_packed.c` is copied from:

```text
benchmark_exploration/PolyBenchC/linear-algebra/kernels/atax/atax.c
```

The diff keeps the original `kernel_atax` math and changes only storage in
`main`:

```diff
-  POLYBENCH_1D_ARRAY_DECL(y, DATA_TYPE, N, n);
-  POLYBENCH_1D_ARRAY_DECL(tmp, DATA_TYPE, M, m);
+  DATA_TYPE *work = (DATA_TYPE *) polybench_alloc_data(m + n, sizeof(DATA_TYPE));

-	       POLYBENCH_ARRAY(y),
-	       POLYBENCH_ARRAY(tmp));
+	       work + m,
+	       work);

-  polybench_prevent_dce(print_array(n, POLYBENCH_ARRAY(y)));
+  polybench_prevent_dce(print_array(n, work + m));

-  POLYBENCH_FREE_ARRAY(y);
-  POLYBENCH_FREE_ARRAY(tmp);
+  polybench_free_data((void*)work);
```

That is the benchmark manipulation: pack `tmp[M]` and `y[N]` into one
allocation, with `tmp = work[0:m]` and `y = work[m:m+n]`.

Current status:

- Native C build succeeds.
- ClangIR emits the useful call shape:
  `kernel_atax(..., subview(work, m), work)`.
- `alias-meta-opt --materialize-prefix-subviews --mark-alias-groups --lower-with-alias-meta`
  rewrites the call to `kernel_atax.__alias_meta_0` and emits alias metadata.
- Full PolyBench `main` still exposes a lowering-script issue because the
  DCE/printing code leaves multi-block control flow inside `memref.alloca_scope`.

## Kernel-Derived Executable Test

`atax_kernel_packed.c` extracts the original ATAX kernel computation and adds a
small wrapper:

```c
void run_atax_packed(float A[M][N], float x[N], float *work, int m, int n) {
  kernel_atax(m, n, A, x, work + m, work);
}
```

Pipeline:

```text
clang -fclangir -emit-cir
cir-opt --cir-to-mlir
mlir-opt --mem2reg --canonicalize --cse

baseline:
  run_pipeline_cpu.sh
  run_opt_emit_ll.sh
  llc
  clang harness + object

with metadata:
  alias-meta-opt --materialize-prefix-subviews --mark-alias-groups --lower-with-alias-meta
  run_pipeline_cpu.sh
  run_opt_emit_ll.sh
  llc
  clang harness + object
```

Correctness:

```text
baseline checksum: 30296.125168
metadata checksum: 30296.125168
```

Local timing, best of the harness rounds:

```text
baseline: 11262.33 ns/call
metadata:  7709.56 ns/call
speedup:   1.46x
```

O2 evidence:

- baseline `run_atax_packed` keeps more runtime alias-conflict checks around
  the packed workspace accesses
- metadata `run_atax_packed` adds `!noalias` on the `y` side and `!alias.scope`
  on the `tmp` side
- metadata path turns y-zeroing into a noalias `llvm.memset`
- metadata path vectorizes the update of `y[j] += A[i][j] * tmp[i]` with the
  noalias metadata attached

This is the strongest source-diff candidate found so far.
