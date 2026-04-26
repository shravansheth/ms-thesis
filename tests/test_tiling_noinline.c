// Correctness test: tiling_noinline
// tiling_caller calls tile_stencil (noinline).
// In pass binary, the call is routed to tile_stencil.__alias_meta_0.
// Kernel: dst[j] = src[j] + src[0]   for j in [0, N)
//   src = A[tile*N .. (tile+1)*N - 1]
//   dst = A[(tile+1)*N .. (tile+2)*N - 1]

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define ARRAY_SIZE 4096
#define TILE       0
#define TILE_N     512

extern void tiling_caller(float* alloc, float* aligned,
                           int64_t offset, int64_t size, int64_t stride,
                           int64_t tile, int64_t tile_n);

int main(void) {
    float* A = (float*)malloc(ARRAY_SIZE * sizeof(float));
    if (!A) { perror("malloc"); return 1; }

    for (int i = 0; i < ARRAY_SIZE; i++) A[i] = (float)(i + 1);

    tiling_caller(A, A, 0, ARRAY_SIZE, 1, TILE, TILE_N);

    double sum = 0.0;
    for (int i = 0; i < ARRAY_SIZE; i++) sum += (double)A[i];
    printf("checksum: %.6f\n", sum);

    free(A);
    return 0;
}
