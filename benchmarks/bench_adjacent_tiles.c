// Benchmark: adjacent_tiles
// MLIR signature: @adjacent_tiles(%A: memref<4096xf32>, %tile: index, %N: index)
// Lowered:        void adjacent_tiles(float* alloc, float* aligned,
//                                    int64_t offset, int64_t size,
//                                    int64_t stride, int64_t tile, int64_t N)
//
// The hot loop does: dst[j] = src[j] + src[0]   (j in [0, N))
// src[0] is loop-invariant but blocked by dst[j] stores at baseline.
// dst.offset = src.offset + N  →  Form B detection.

#include "bench.h"

#define ARRAY_SIZE 4096
#define TILE       0
#define TILE_N     512    // tile size; loop runs TILE_N iters
#define NITERS     100000
#define NWARMUP    500
#define NROUNDS    5

extern void adjacent_tiles(float* alloc, float* aligned,
                            int64_t offset, int64_t size, int64_t stride,
                            int64_t tile, int64_t tile_n);

int main(void) {
    float* A = (float*)malloc(ARRAY_SIZE * sizeof(float));
    if (!A) { perror("malloc"); return 1; }
    for (int i = 0; i < ARRAY_SIZE; i++) A[i] = (float)(i + 1);

    BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
              adjacent_tiles(A, A, 0, ARRAY_SIZE, 1, TILE, TILE_N));

    volatile float sink = A[ARRAY_SIZE - 1];
    (void)sink;
    free(A);
    return 0;
}
