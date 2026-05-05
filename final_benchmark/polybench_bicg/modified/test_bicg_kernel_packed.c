#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define M 116
#define N 124
#define WORK_SIZE (M + N)

extern void run_bicg_packed(float *A_alloc, float *A_aligned,
                            int64_t A_offset, int64_t A_size,
                            int64_t A_stride, float *p_alloc,
                            float *p_aligned, int64_t p_offset,
                            int64_t p_size, int64_t p_stride,
                            float *r_alloc, float *r_aligned,
                            int64_t r_offset, int64_t r_size,
                            int64_t r_stride, float *work_alloc,
                            float *work_aligned, int64_t work_offset,
                            int64_t work_size, int64_t work_stride, int32_t m,
                            int32_t n);

static void init(float *A, float *p, float *r, float *work) {
  for (int i = 0; i < M; ++i)
    p[i] = (float)(i % M) / (float)M;
  for (int i = 0; i < N; ++i) {
    r[i] = (float)(i % N) / (float)N;
    for (int j = 0; j < M; ++j)
      A[i * M + j] = (float)(i * (j + 1) % N) / (float)N;
  }
  for (int i = 0; i < WORK_SIZE; ++i)
    work[i] = 0.0f;
}

int main(void) {
  float *A = (float *)malloc((size_t)N * M * sizeof(float));
  float *p = (float *)malloc((size_t)M * sizeof(float));
  float *r = (float *)malloc((size_t)N * sizeof(float));
  float *work = (float *)malloc((size_t)WORK_SIZE * sizeof(float));
  if (!A || !p || !r || !work) {
    perror("malloc");
    return 1;
  }

  init(A, p, r, work);
  run_bicg_packed(A, A, 0, M, 1, p, p, 0, M, 1, r, r, 0, N, 1, work, work, 0,
                  WORK_SIZE, 1, M, N);

  double checksum = 0.0;
  for (int i = 0; i < WORK_SIZE; ++i)
    checksum += work[i];
  printf("checksum: %.6f\n", checksum);

  free(A);
  free(p);
  free(r);
  free(work);
  return 0;
}
