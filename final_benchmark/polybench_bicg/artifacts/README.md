# PolyBench BICG ClangIR Source-Diff Candidate

This is a second PolyBench/C kernel-derived candidate using the same ClangIR
pipeline as the ATAX candidate.

## Benchmark Change

Original BICG has two live-out vectors:

```c
s[M]
q[N]
```

The semantic-preserving source rewrite is:

```diff
-  DATA_TYPE s[M];
-  DATA_TYPE q[N];
+  DATA_TYPE work[M + N];

-  kernel_bicg(m, n, A, s, q, p, r);
+  kernel_bicg(m, n, A, work, work + m, p, r);
```

The arithmetic inside `kernel_bicg` is unchanged. The only change is storage:
`s = work[0:m]`, `q = work[m:m+n]`.

## Current Test

`bicg_kernel_packed.c` extracts the original PolyBench BICG kernel and adds:

```c
void run_bicg_packed(float A[N][M], float p[M], float r[N],
                     float *work, int m, int n) {
  kernel_bicg(m, n, A, work, work + m, p, r);
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
baseline checksum: 3727.792479
metadata checksum: 3727.792479
```

Local timing:

```text
baseline: 8947.77 ns/call
metadata: 8270.02 ns/call
speedup:  1.08x
```

O2 evidence:

- The pass rewrites the wrapper call to `kernel_bicg.__alias_meta_0`.
- The cloned callee carries `alias_scopes` on the `s` side and
  `noalias_scopes` on the `q` side.
- Baseline has `UnsafeDep` loop-vectorizer remarks in the packed hot loop.
- Metadata enables an additional vectorized loop in the cloned callee.

This is a viable secondary PolyBench candidate. It is not as strong as ATAX,
but it is source-derived, correct, and shows a real local speedup.
