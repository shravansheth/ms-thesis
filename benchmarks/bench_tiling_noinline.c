// Benchmark: tiling_noinline
// MLIR signature: @tiling_caller(%A: memref<4096xf32>, %tile: index, %N: index)
// Lowered:        void tiling_caller(float* alloc, float* aligned,
//                                   int64_t offset, int64_t size,
//                                   int64_t stride, int64_t tile, int64_t N)
//
// @tiling_caller calls @tile_stencil (noinline).
// In the pass binary, the call is routed to @tile_stencil.__alias_meta_0.
// The hot loop in the callee: dst[j] = src[j] + src[0]   (j in [0, N))
// src[0] is loop-invariant but blocked by dst stores at baseline.

#include "bench.h"

#define ARRAY_SIZE 4096
#define TILE       0
#define TILE_N     512
#define NITERS     50000
#define NWARMUP    200
#define NROUNDS    5

extern void tiling_caller(float* alloc, float* aligned,
                           int64_t offset, int64_t size, int64_t stride,
                           int64_t tile, int64_t tile_n);

int main(void) {
    float* A = (float*)malloc(ARRAY_SIZE * sizeof(float));
    if (!A) { perror("malloc"); return 1; }
    for (int i = 0; i < ARRAY_SIZE; i++) A[i] = (float)(i + 1);

    BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
              tiling_caller(A, A, 0, ARRAY_SIZE, 1, TILE, TILE_N));

    volatile float sink = A[ARRAY_SIZE - 1];
    (void)sink;
    free(A);
    return 0;
}
