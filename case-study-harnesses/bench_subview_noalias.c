// Benchmark: subview_noalias
// MLIR: @caller() allocates 1024xf32, splits at 512, calls @kernel (noinline).
// In the pass binary, @caller() calls @kernel.__alias_meta_0 (the tagged clone).
// The hot loop in @kernel does 512 iters of: q[i] = p[i] + p[0]
// p[0] is loop-invariant but blocked by q[i] stores at baseline.
//
// @caller() takes no arguments — allocation and deallocation are internal.
// Both baseline and pass versions have identical malloc/free overhead per call.

#include "bench.h"

#define NITERS  50000
#define NWARMUP 200
#define NROUNDS 5

extern void caller(void);

int main(void) {
    BENCH_RUN("ns_per_call:", NITERS, NWARMUP, NROUNDS, caller());
    return 0;
}
