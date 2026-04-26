// Correctness test: dynamic_split
// Calls the kernel once with known initial state, prints checksum of entire array.
// Compiled twice: once with baseline .O2.ll, once with pass .meta.O2.ll
// Expected: both produce identical checksums.
//
// Kernel: hi[i] += lo[0]   for i in [0, 2048-N)
//   lo = A[0..N-1], hi = A[N..2047]
//   Kernel also sets lo[0] = 1.0 before the loop.

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define ARRAY_SIZE 2048
#define N          1024

extern void dynamic_split(float* alloc, float* aligned,
                           int64_t offset, int64_t size,
                           int64_t stride, int64_t n);

int main(void) {
    float* A = (float*)malloc(ARRAY_SIZE * sizeof(float));
    if (!A) { perror("malloc"); return 1; }

    // Deterministic init: same as benchmark harness
    for (int i = 0; i < ARRAY_SIZE; i++) A[i] = (float)(i + 1);

    // Single call with known input
    dynamic_split(A, A, 0, ARRAY_SIZE, 1, N);

    // Checksum: sum of all elements
    double sum = 0.0;
    for (int i = 0; i < ARRAY_SIZE; i++) sum += (double)A[i];
    printf("checksum: %.6f\n", sum);

    free(A);
    return 0;
}
