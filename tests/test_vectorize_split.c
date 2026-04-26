// Correctness test: vectorize_split
// Kernel: hi[i] += lo[0]   for i in [0, 1048576)
//   lo = A[0 .. n-1], hi = A[n .. n+1048576-1]
//   lo[0] is seeded to 1.0 before the loop.
//   After the kernel: A[n+i] = A[n+i]_init + 1.0  for all i in [0, 1048576).
//
// Note on "pass" variant: the pass+fvw4 binary (vectorized) is used for the
// correctness check. The pass without fvw4 is scalar and also correct; we test
// the fvw4 variant because it is the one that demonstrates the optimization.

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define ARRAY_ELEMS 2097152   // 2M elements = 8 MB
#define N           524288    // split point (1/4 of array)

extern void vectorize_split(float* alloc, float* aligned,
                             int64_t offset, int64_t size,
                             int64_t stride, int64_t n);

int main(void) {
    float* A = (float*)malloc((size_t)ARRAY_ELEMS * sizeof(float));
    if (!A) { perror("malloc"); return 1; }

    for (int i = 0; i < ARRAY_ELEMS; i++) A[i] = (float)(i + 1);

    vectorize_split(A, A, 0, ARRAY_ELEMS, 1, (int64_t)N);

    // Sum all elements. hi region (A[N .. N+1M-1]) should each be 1.0 higher
    // than their initial value; lo region (A[0 .. N-1]) is unchanged except
    // A[0] which was seeded to 1.0.
    double sum = 0.0;
    for (int i = 0; i < ARRAY_ELEMS; i++) sum += (double)A[i];
    printf("checksum: %.6f\n", sum);

    free(A);
    return 0;
}
