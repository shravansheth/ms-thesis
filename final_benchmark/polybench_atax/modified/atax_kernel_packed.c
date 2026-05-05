#define M 116
#define N 124

typedef float DATA_TYPE;

__attribute__((noinline))
void kernel_atax(int m, int n,
                 DATA_TYPE A[M][N],
                 DATA_TYPE x[N],
                 DATA_TYPE y[N],
                 DATA_TYPE tmp[M]) {
  int i, j;

  for (i = 0; i < n; i++)
    y[i] = 0;
  for (i = 0; i < m; i++) {
    tmp[i] = 0.0f;
    for (j = 0; j < n; j++)
      tmp[i] = tmp[i] + A[i][j] * x[j];
    for (j = 0; j < n; j++)
      y[j] = y[j] + A[i][j] * tmp[i];
  }
}

void run_atax_packed(DATA_TYPE A[M][N],
                     DATA_TYPE x[N],
                     DATA_TYPE *work,
                     int m,
                     int n) {
  kernel_atax(m, n, A, x, work + m, work);
}
