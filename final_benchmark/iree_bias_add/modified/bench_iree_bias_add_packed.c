#include "../../bench.h"

#define ROWS 1024
#define COLS 1024
#define NITERS 20
#define NWARMUP 3
#define NROUNDS 5

extern void iree_bias_add_packed(
    float *input_alloc, float *input_aligned, int64_t input_offset,
    int64_t input_size0, int64_t input_stride0,
    float *work_alloc, float *work_aligned, int64_t work_offset,
    int64_t work_size0, int64_t work_stride0,
    int64_t rows, int64_t cols);

static void init(float *input, float *work) {
  for (int i = 0; i < ROWS * COLS; ++i)
    input[i] = (float)((i % 23) + 1);
  for (int j = 0; j < COLS; ++j)
    work[j] = (float)(j % 11);
  for (int i = COLS; i < COLS + ROWS * COLS; ++i)
    work[i] = 0.0f;
}

static double checksum(const float *work) {
  double sum = 0.0;
  for (int i = 0; i < COLS + ROWS * COLS; ++i)
    sum += work[i];
  return sum;
}

int main(void) {
  float *input = (float *)malloc((size_t)ROWS * COLS * sizeof(float));
  float *work = (float *)malloc((size_t)(COLS + ROWS * COLS) * sizeof(float));
  if (!input || !work) {
    perror("malloc");
    return 1;
  }
  init(input, work);

  BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS,
            iree_bias_add_packed(input, input, 0, ROWS * COLS, 1,
                                 work, work, 0, COLS + ROWS * COLS, 1,
                                 ROWS, COLS));

  volatile float sink = work[COLS + ROWS * COLS - 1];
  (void)sink;
  printf("checksum: %.6f\n", checksum(work));
  free(input);
  free(work);
  return 0;
}
