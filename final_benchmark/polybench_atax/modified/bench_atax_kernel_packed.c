#include "../../bench.h"

#define M 116
#define N 124
#define WORK_SIZE (M + N)
#define NITERS 2000
#define NWARMUP 50
#define NROUNDS 5

extern void run_atax_packed(float *A_alloc, float *A_aligned,
                            int64_t A_offset, int64_t A_size,
                            int64_t A_stride, float *x_alloc,
                            float *x_aligned, int64_t x_offset,
                            int64_t x_size, int64_t x_stride,
                            float *work_alloc, float *work_aligned,
                            int64_t work_offset, int64_t work_size,
                            int64_t work_stride, int32_t m, int32_t n);

static void init(float *A, float *x, float *work) {
  float fn = (float)N;
  for (int i = 0; i < N; ++i)
    x[i] = 1.0f + (float)i / fn;
  for (int i = 0; i < M; ++i)
    for (int j = 0; j < N; ++j)
      A[i * N + j] = (float)((i + j) % N) / (float)(5 * M);
  for (int i = 0; i < WORK_SIZE; ++i)
    work[i] = 0.0f;
}

static double checksum(const float *work) {
  double sum = 0.0;
  for (int i = 0; i < N; ++i)
    sum += (double)work[M + i];
  return sum;
}

int main(void) {
  float *A = (float *)malloc((size_t)M * N * sizeof(float));
  float *x = (float *)malloc((size_t)N * sizeof(float));
  float *work = (float *)malloc((size_t)WORK_SIZE * sizeof(float));
  if (!A || !x || !work) {
    perror("malloc");
    return 1;
  }

  init(A, x, work);

  BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
            run_atax_packed(A, A, 0, N, 1, x, x, 0, N, 1, work, work, 0,
                            WORK_SIZE, 1, M, N));

  volatile float sink = work[M + N - 1];
  (void)sink;
  printf("checksum: %.6f\n", checksum(work));
  free(A);
  free(x);
  free(work);
  return 0;
}
