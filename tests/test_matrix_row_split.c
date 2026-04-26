// Correctness test: matrix_row_split
// Kernel: bot[i][j] = top[i][j] + top[0][0]   for i in [0,m), j in [0,512)
//   top = A[0..m-1, 0..511], bot = A[m..2m-1, 0..511]
//   Kernel also sets top[0][0] = 1.0 before the loops.

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define M          64
#define TOTAL_ROWS (2 * M)
#define COLS       512
#define ARRAY_SIZE (TOTAL_ROWS * COLS)

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
    matrix_row_split(A, A, 0, M, COLS, COLS, 1, M);

    double sum = 0.0;
    for (int i = 0; i < ARRAY_SIZE; i++) sum += (double)A[i];
    printf("checksum: %.6f\n", sum);

    free(A);
    return 0;
}
