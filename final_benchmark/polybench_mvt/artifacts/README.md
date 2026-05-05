# PolyBench MVT ClangIR Source-Diff Probe

This probes whether PolyBench MVT benefits from packing one output vector and
one input vector into a single workspace:

```diff
-  DATA_TYPE x1[N];
-  DATA_TYPE y_1[N];
+  DATA_TYPE work[2 * N];

-  kernel_mvt(n, x1, x2, y_1, y_2, A);
+  kernel_mvt(n, work, x2, work + n, y_2, A);
```

The original kernel math is unchanged.

Results:

```text
baseline checksum: 3730.629051
metadata checksum: 3730.629051

baseline: 9192.73 ns/call
metadata: 8987.38 ns/call
speedup:  1.02x
```

The pass does fire: the wrapper call is rewritten to
`kernel_mvt.__alias_meta_0`, and the cloned callee receives LLVM alias metadata
on `x1`/`y_1` accesses.

This is weaker than ATAX and BICG. It is useful as pattern evidence, but not as
the main thesis evaluation benchmark.
