// Benchmark: matrix_row_split
// MLIR signature: @matrix_row_split(%A: memref<?x512xf32>, %m: index)
// Lowered:        void matrix_row_split(float* alloc, float* aligned,
//                                      int64_t offset,
//                                      int64_t size0, int64_t size1,
//                                      int64_t stride0, int64_t stride1,
//                                      int64_t m)
//
// The hot inner loop does: bot[i][j] = top[i][j] + top[0][0]   (j in [0,512))
// top[0][0] is loop-invariant but blocked by bot stores at baseline.
// With m=64, the kernel runs 64 outer * 512 inner = 32768 iterations per call.
// Total array: 2*m rows * 512 cols = 65536 floats = 256KB (fits in L2).

#include "bench.h"

#define M          64     // rows per half; total array 2*M rows * 512 cols
#define TOTAL_ROWS (2 * M)
#define COLS       512
#define ARRAY_SIZE (TOTAL_ROWS * COLS)
#define NITERS     2000
#define NWARMUP    20
#define NROUNDS    5

extern void matrix_row_split(float* alloc, float* aligned,
                              int64_t offset,
                              int64_t size0, int64_t size1,
                              int64_t stride0, int64_t stride1,
                              int64_t m);

int main(void) {
    float* A = (float*)malloc(ARRAY_SIZE * sizeof(float));
    if (!A) { perror("malloc"); return 1; }
    for (int i = 0; i < ARRAY_SIZE; i++) A[i] = (float)(i + 1);

    // size0=M (rows in top half), size1=512, stride0=512, stride1=1, m=M
    BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
              matrix_row_split(A, A, 0, M, COLS, COLS, 1, M));

    volatile float sink = A[ARRAY_SIZE - 1];
    (void)sink;
    free(A);
    return 0;
}
