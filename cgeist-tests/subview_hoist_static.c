#include <stdlib.h>

void subview_hoist_static() {
    float *A = (float *)malloc(1024 * sizeof(float));
    if (!A) return;

    // Two disjoint halves: [0..511] and [512..1023]
    float *slice0 = A;
    float *slice1 = A + 512;

    // Initialize one element so the invariant load is non-trivial
    slice0[0] = 0.0f;

    for (int i = 0; i < 512; i++) {
        float inv = slice0[0];   // invariant load
        float x   = slice0[i];
        float y   = x + inv;
        slice1[i] = y;
    }

    free(A);
}
