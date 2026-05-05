// Benchmark: double_invariant
// MLIR signature: @double_invariant(%A: memref<2048xf32>, %n: index)
// Lowered:        void double_invariant(float* alloc, float* aligned,
//                                      int64_t offset, int64_t size,
//                                      int64_t stride, int64_t n)
//
// Two invariant loads per iteration: lo[0] and lo[1].
// Loop: hi[i] = hi[i] + lo[0] + lo[1]   (i in [n, 2048))
// Both lo[0] and lo[1] are blocked by hi[i] stores at baseline.
// Pass hoists both.

#include "bench.h"

#define ARRAY_SIZE 2048
#define N          1024
#define NITERS     100000
#define NWARMUP    500
#define NROUNDS    5

extern void double_invariant(float* alloc, float* aligned,
                              int64_t offset, int64_t size,
                              int64_t stride, int64_t n);

int main(void) {
    float* A = (float*)malloc(ARRAY_SIZE * sizeof(float));
    if (!A) { perror("malloc"); return 1; }
    for (int i = 0; i < ARRAY_SIZE; i++) A[i] = (float)(i + 1);

    BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
              double_invariant(A, A, 0, ARRAY_SIZE, 1, N));

    volatile float sink = A[ARRAY_SIZE - 1];
    (void)sink;
    free(A);
    return 0;
}
