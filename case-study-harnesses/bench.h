#pragma once

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static inline double now_ns(void) {
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC_RAW, &t);
    return (double)t.tv_sec * 1e9 + (double)t.tv_nsec;
}

// Run NITERS calls of fn, repeat NROUNDS times, return best ns/call.
// fn_call should be a void expression (use a lambda-style macro at call site).
#define BENCH_RUN(label, niters, nwarmup, nrounds, call_expr)              \
    do {                                                                    \
        for (int _w = 0; _w < (nwarmup); _w++) { call_expr; }             \
        double _best = 1e18;                                               \
        for (int _r = 0; _r < (nrounds); _r++) {                          \
            double _t0 = now_ns();                                         \
            for (int _i = 0; _i < (niters); _i++) { call_expr; }          \
            double _t1 = now_ns();                                         \
            double _ns = (_t1 - _t0) / (niters);                          \
            if (_ns < _best) _best = _ns;                                  \
        }                                                                  \
        printf("%s %.2f\n", (label), _best);                              \
    } while (0)
