#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define N 124
#define WORK_SIZE (2 * N)

extern void run_mvt_packed(float *A_alloc, float *A_aligned,
                           int64_t A_offset, int64_t A_size,
                           int64_t A_stride, float *x2_alloc,
                           float *x2_aligned, int64_t x2_offset,
                           int64_t x2_size, int64_t x2_stride,
                           float *y2_alloc, float *y2_aligned,
                           int64_t y2_offset, int64_t y2_size,
                           int64_t y2_stride, float *work_alloc,
                           float *work_aligned, int64_t work_offset,
                           int64_t work_size, int64_t work_stride, int32_t n);

static void init(float *A, float *x2, float *y2, float *work) {
  for (int i = 0; i < N; ++i) {
    work[i] = (float)(i % N) / (float)N;
    x2[i] = (float)((i + 1) % N) / (float)N;
    work[N + i] = (float)((i + 3) % N) / (float)N;
    y2[i] = (float)((i + 4) % N) / (float)N;
    for (int j = 0; j < N; ++j)
      A[i * N + j] = (float)(i * (j + 1) % N) / (float)N;
  }
}

int main(void) {
  float *A = (float *)malloc((size_t)N * N * sizeof(float));
  float *x2 = (float *)malloc((size_t)N * sizeof(float));
  float *y2 = (float *)malloc((size_t)N * sizeof(float));
  float *work = (float *)malloc((size_t)WORK_SIZE * sizeof(float));
  if (!A || !x2 || !y2 || !work) {
    perror("malloc");
    return 1;
  }

  init(A, x2, y2, work);
  run_mvt_packed(A, A, 0, N, 1, x2, x2, 0, N, 1, y2, y2, 0, N, 1, work, work,
                 0, WORK_SIZE, 1, N);

  double checksum = 0.0;
  for (int i = 0; i < WORK_SIZE; ++i)
    checksum += work[i];
  for (int i = 0; i < N; ++i)
    checksum += x2[i];
  printf("checksum: %.6f\n", checksum);

  free(A);
  free(x2);
  free(y2);
  free(work);
  return 0;
}
