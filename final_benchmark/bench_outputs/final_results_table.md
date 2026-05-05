# Final Benchmark Median Timing Table

Times are `ns/call`. Mac values are medians of 5 full benchmark invocations
from `final_benchmark/bench_outputs/mac_final_median_summary.txt`. RPi values
are medians of 5 full benchmark invocations from
`final_benchmark/bench_outputs/rpi_final_median_summary.txt`. The reported
speedup is:

```text
median(baseline runtime) / median(pass runtime)
```

```text
Benchmark             Mac Base       Mac Pass       Mac Spd   RPi3 Base        RPi3 Pass        RPi3 Spd   RPi4 Base       RPi4 Pass       RPi4 Spd   RPi5 Base       RPi5 Pass       RPi5 Spd
------------------  ------------  ------------  ----------  --------------  --------------  ----------  -------------  -------------  ----------  -------------  -------------  ----------
PolyBench ATAX          11005.69       7522.15      1.463x       227974.45       182025.05      1.252x       60899.98       41423.90      1.470x       27788.82       18417.06      1.509x
PolyBench BICG           8764.25       8105.40      1.081x       291970.05       291982.97      1.000x      106128.54       50655.76      2.095x       46999.28       22051.73      2.131x
IMEX Softmax            63769.50      62416.25      1.022x      3933246.82      3932602.40      1.000x      892511.78      807051.83      1.106x      226943.70      202007.39      1.123x
PolyBench MVT            9050.65       8992.33      1.006x       230021.46       230054.04      1.000x       62273.12       62288.04      1.000x       28303.89       28304.19      1.000x
IREE Bias Add         5084722.90    5031425.00      1.011x    213779104.05    208461218.65      1.026x    79222053.65    75150564.80      1.054x    27963592.55    29509433.30      0.948x
```

## Correctness

Correctness was checked by comparing baseline/pass checksums for each benchmark
on Mac, RPi3B, RPi4B, and RPi5. All checksum pairs matched.

## Consistency Notes

- The Mac median output is complete: 5 benchmarks x 5 repeats = 25 raw
  measurements, plus one header row in `mac_final_median_raw.tsv`.
- The RPi median output is complete: 5 benchmarks x 3 boards x 5 repeats = 75
  raw measurements, plus one header row in `rpi_final_median_raw.tsv`.
- ATAX is consistently positive on all boards: `1.252x`, `1.470x`, `1.509x`.
- BICG remains consistently strong on RPi4B/RPi5: `2.095x`, `2.131x`.
- RPi3B BICG, IMEX, and MVT are effectively flat. Their median speedups round
  to `1.000x`.
- IMEX RPi4B is noisy in individual runs, but the median is positive:
  `1.106x`.
- IREE remains a supporting mixed candidate: small median gains on Mac, RPi3B,
  and RPi4B, with a median regression on RPi5.
