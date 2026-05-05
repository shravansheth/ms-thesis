#define M 116
#define N 124

typedef float DATA_TYPE;

__attribute__((noinline))
void kernel_bicg(int m, int n,
                 DATA_TYPE A[N][M],
                 DATA_TYPE s[M],
                 DATA_TYPE q[N],
                 DATA_TYPE p[M],
                 DATA_TYPE r[N]) {
  int i, j;

  for (i = 0; i < m; i++)
    s[i] = 0.0f;
  for (i = 0; i < n; i++) {
    q[i] = 0.0f;
    for (j = 0; j < m; j++) {
      s[j] = s[j] + r[i] * A[i][j];
      q[i] = q[i] + A[i][j] * p[j];
    }
  }
}

void run_bicg_packed(DATA_TYPE A[N][M],
                     DATA_TYPE p[M],
                     DATA_TYPE r[N],
                     DATA_TYPE *work,
                     int m,
                     int n) {
  kernel_bicg(m, n, A, work, work + m, p, r);
}
