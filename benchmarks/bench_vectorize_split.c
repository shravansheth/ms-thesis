// Benchmark: vectorize_split
// MLIR signature: @vectorize_split(%A: memref<2097152xf32>, %n: index)
// Lowered:        void vectorize_split(float* alloc, float* aligned,
//                                     int64_t offset, int64_t size,
//                                     int64_t stride, int64_t n)
//
// A[0..n-1] = lo (dynamic size), A[n..n+1M-1] = hi (static size 1M).
// Baseline: lo[0] load inside loop, UnsafeDep blocks vectorization.
// Pass:     alias.scope/noalias resolves UnsafeDep; LICM hoists lo[0];
//           SCCP folds to 1.0; loop becomes hi[i] += 1.0.

#include "bench.h"

#define ARRAY_ELEMS 2097152    // 2M floats = 8MB
#define N           524288     // split point: lo=[0..N-1], hi=[N..N+1M-1]
#define NITERS      500
#define NWARMUP     10
#define NROUNDS     5

extern void vectorize_split(float* alloc, float* aligned,
                             int64_t offset, int64_t size,
                             int64_t stride, int64_t n);

int main(void) {
    float* A = (float*)malloc(ARRAY_ELEMS * sizeof(float));
    if (!A) { perror("malloc"); return 1; }
    for (int i = 0; i < ARRAY_ELEMS; i++) A[i] = (float)(i + 1);

    BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
              vectorize_split(A, A, 0, ARRAY_ELEMS, 1, N));

    volatile float sink = A[ARRAY_ELEMS - 1];
    (void)sink;
    free(A);
    return 0;
}
