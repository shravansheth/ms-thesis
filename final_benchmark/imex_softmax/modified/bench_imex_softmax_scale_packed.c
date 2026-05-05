#include "../../bench.h"

#define ROWS 256
#define COLS 2048
#define K 1
#define NITERS 1000
#define NWARMUP 50
#define NROUNDS 5

extern void imex_softmax_scale_packed(
    float *work_alloc, float *work_aligned, int64_t work_offset,
    int64_t work_size0, int64_t work_size1,
    int64_t work_stride0, int64_t work_stride1,
    int64_t rows, int64_t k);

static void init(float *work) {
  for (int r = 0; r < ROWS; ++r) {
    work[(size_t)r * COLS] = 2.0f;
    for (int c = 1; c < COLS; ++c)
      work[(size_t)r * COLS + c] = (float)((r + c) % 17 + 1);
  }
}

static double checksum(const float *work) {
  double sum = 0.0;
  for (int r = 0; r < ROWS; ++r)
    for (int c = 0; c < K + 1024; ++c)
      sum += work[(size_t)r * COLS + c];
  return sum;
}

int main(void) {
  float *work = (float *)malloc((size_t)ROWS * COLS * sizeof(float));
  if (!work) {
    perror("malloc");
    return 1;
  }
  init(work);

  BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
            imex_softmax_scale_packed(work, work, 0, ROWS, COLS, COLS, 1,
                                      ROWS, K));

  volatile float sink = work[(size_t)(ROWS - 1) * COLS + K + 1023];
  (void)sink;
  printf("checksum: %.6f\n", checksum(work));
  free(work);
  return 0;
}
