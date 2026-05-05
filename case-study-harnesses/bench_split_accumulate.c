// Benchmark: split_accumulate
// MLIR signature: @split_accumulate(%A: memref<2048xf32>, %n: index)
// Lowered:        void split_accumulate(float* alloc, float* aligned,
//                                      int64_t offset, int64_t size,
//                                      int64_t stride, int64_t n)
//
// Roles reversed from dynamic_split: hi[0] is the invariant read,
// lo[i] are the write targets.  Loop: lo[i] += hi[0]   (i in [0, n))
// hi[0] is loop-invariant but blocked by lo[i] stores at baseline.

#include "bench.h"

#define ARRAY_SIZE 2048
#define N          1024
#define NITERS     100000
#define NWARMUP    500
#define NROUNDS    5

extern void split_accumulate(float* alloc, float* aligned,
                              int64_t offset, int64_t size,
                              int64_t stride, int64_t n);

int main(void) {
    float* A = (float*)malloc(ARRAY_SIZE * sizeof(float));
    if (!A) { perror("malloc"); return 1; }
    for (int i = 0; i < ARRAY_SIZE; i++) A[i] = (float)(i + 1);

    BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
              split_accumulate(A, A, 0, ARRAY_SIZE, 1, N));

    volatile float sink = A[ARRAY_SIZE - 1];
    (void)sink;
    free(A);
    return 0;
}
