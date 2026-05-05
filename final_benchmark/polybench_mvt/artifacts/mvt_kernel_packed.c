#define N 124

typedef float DATA_TYPE;

__attribute__((noinline))
void kernel_mvt(int n,
                DATA_TYPE x1[N],
                DATA_TYPE x2[N],
                DATA_TYPE y_1[N],
                DATA_TYPE y_2[N],
                DATA_TYPE A[N][N]) {
  int i, j;

  for (i = 0; i < n; i++)
    for (j = 0; j < n; j++)
      x1[i] = x1[i] + A[i][j] * y_1[j];
  for (i = 0; i < n; i++)
    for (j = 0; j < n; j++)
      x2[i] = x2[i] + A[j][i] * y_2[j];
}

void run_mvt_packed(DATA_TYPE A[N][N],
                    DATA_TYPE x2[N],
                    DATA_TYPE y_2[N],
                    DATA_TYPE *work,
                    int n) {
  kernel_mvt(n, work, x2, work + n, y_2, A);
}
