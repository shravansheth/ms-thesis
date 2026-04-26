// Benchmark: dynamic_split
// MLIR signature: @dynamic_split(%A: memref<2048xf32>, %n: index)
// Lowered:        void dynamic_split(float* alloc, float* aligned,
//                                   int64_t offset, int64_t size,
//                                   int64_t stride, int64_t n)
//
// The hot loop does: hi[i] += lo[0]   (i in [0, 2048-n))
// lo[0] is loop-invariant but blocked by hi[i] stores at baseline.

#include "bench.h"

#define ARRAY_SIZE 2048
#define N          1024   // split point; hi side runs 1024 iters
#define NITERS     100000
#define NWARMUP    500
#define NROUNDS    5

extern void dynamic_split(float* alloc, float* aligned,
                           int64_t offset, int64_t size,
                           int64_t stride, int64_t n);

int main(void) {
    float* A = (float*)malloc(ARRAY_SIZE * sizeof(float));
    if (!A) { perror("malloc"); return 1; }
    for (int i = 0; i < ARRAY_SIZE; i++) A[i] = (float)(i + 1);

    BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
              dynamic_split(A, A, 0, ARRAY_SIZE, 1, N));

    volatile float sink = A[ARRAY_SIZE - 1];
    (void)sink;
    free(A);
    return 0;
}
