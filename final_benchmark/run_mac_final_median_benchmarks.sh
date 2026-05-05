#!/usr/bin/env bash
# Build and run the five final benchmark candidates locally on macOS.
#
# Outputs:
#   final_benchmark/bench_outputs/mac_final_median_raw.tsv
#   final_benchmark/bench_outputs/mac_final_median_summary.txt
#
# Usage:
#   bash final_benchmark/run_mac_final_median_benchmarks.sh
#   bash final_benchmark/run_mac_final_median_benchmarks.sh polybench_atax
#   REPEATS=7 bash final_benchmark/run_mac_final_median_benchmarks.sh

set -euo pipefail

LLVM_BUILD="${LLVM_BUILD:-/Users/shravansheth/ShravsSSD/llvm-project/build}"
LLC="$LLVM_BUILD/bin/llc"
CC="${CC:-clang}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
OUT_ROOT="$SCRIPT_DIR/bench_outputs"
BUILD_DIR="$OUT_ROOT/mac_median_build"
REPEATS="${REPEATS:-5}"

FINAL_BENCHES=(
  polybench_atax
  polybench_bicg
  imex_softmax
  polybench_mvt
  iree_bias_add
)

die() { echo "ERROR: $*" >&2; exit 1; }

bench_paths() {
  case "$1" in
    polybench_atax)
      HARNESS="$SCRIPT_DIR/polybench_atax/modified/bench_atax_kernel_packed.c"
      BASE_LL="$SCRIPT_DIR/polybench_atax/artifacts/kernel_baseline/atax_kernel_packed.O2.ll"
      PASS_LL="$SCRIPT_DIR/polybench_atax/artifacts/kernel_with_meta/atax_kernel_packed.meta.O2.ll"
      ;;
    polybench_bicg)
      HARNESS="$SCRIPT_DIR/polybench_bicg/modified/bench_bicg_kernel_packed.c"
      BASE_LL="$SCRIPT_DIR/polybench_bicg/artifacts/baseline/bicg_kernel_packed.O2.ll"
      PASS_LL="$SCRIPT_DIR/polybench_bicg/artifacts/with_meta/bicg_kernel_packed.meta.O2.ll"
      ;;
    imex_softmax)
      HARNESS="$SCRIPT_DIR/imex_softmax/modified/bench_imex_softmax_scale_packed.c"
      BASE_LL="$SCRIPT_DIR/imex_softmax/artifacts/baseline/imex_softmax_scale_packed.O2.ll"
      PASS_LL="$SCRIPT_DIR/imex_softmax/artifacts/pass/imex_softmax_scale_packed.meta.O2.ll"
      ;;
    polybench_mvt)
      HARNESS="$SCRIPT_DIR/polybench_mvt/modified/bench_mvt_kernel_packed.c"
      BASE_LL="$SCRIPT_DIR/polybench_mvt/artifacts/baseline/mvt_kernel_packed.O2.ll"
      PASS_LL="$SCRIPT_DIR/polybench_mvt/artifacts/with_meta/mvt_kernel_packed.meta.O2.ll"
      ;;
    iree_bias_add)
      HARNESS="$SCRIPT_DIR/iree_bias_add/modified/bench_iree_bias_add_packed.c"
      BASE_LL="$SCRIPT_DIR/iree_bias_add/artifacts/baseline/iree_bias_add_packed.O2.ll"
      PASS_LL="$SCRIPT_DIR/iree_bias_add/artifacts/pass/iree_bias_add_packed.meta.O2.ll"
      ;;
    *) die "unknown final benchmark '$1'" ;;
  esac
}

check_tools() {
  [ -x "$LLC" ] || die "llc not found at $LLC"
  command -v "$CC" >/dev/null 2>&1 || die "C compiler not found: $CC"
  echo "  llc $("$LLC" --version 2>&1 | head -1)"
  echo "  cc  $("$CC" --version 2>&1 | head -1)"
}

compile_one() {
  local bench=$1 variant=$2 ll_file=$3 out_bin=$4
  local obj="$out_bin.k.o"

  [ -f "$HARNESS" ] || die "missing harness: $HARNESS"
  [ -f "$ll_file" ] || die "missing $variant IR: $ll_file"

  "$LLC" -filetype=obj "$ll_file" -o "$obj"
  "$CC" -O2 -I "$REPO_ROOT/benchmarks" "$HARNESS" "$obj" -o "$out_bin"
  rm -f "$obj"
  echo "    OK  ${bench}_${variant}"
}

compile_bench() {
  local bench=$1 out_dir="$BUILD_DIR/$bench"
  bench_paths "$bench"
  mkdir -p "$out_dir"

  echo "  $bench"
  compile_one "$bench" baseline "$BASE_LL" "$out_dir/${bench}_baseline"
  compile_one "$bench" pass "$PASS_LL" "$out_dir/${bench}_pass"
}

run_binary() {
  local path=$1 out ns checksum
  out="$("$path")"
  ns="$(printf "%s\n" "$out" | awk '/ns_per_call:/ { print $2; exit }')"
  checksum="$(printf "%s\n" "$out" | awk '/checksum:/ { print $2; exit }')"
  [ -n "$ns" ] || return 1
  printf "%s %s\n" "$ns" "${checksum:-n/a}"
}

write_medians() {
  local raw=$1 summary=$2
  awk -F '\t' '
    function median(values, count, sorted, i, j, tmp) {
      for (i = 1; i <= count; ++i)
        sorted[i] = values[i]
      for (i = 1; i <= count; ++i) {
        for (j = i + 1; j <= count; ++j) {
          if (sorted[j] < sorted[i]) {
            tmp = sorted[i]
            sorted[i] = sorted[j]
            sorted[j] = tmp
          }
        }
      }
      if (count % 2)
        return sorted[(count + 1) / 2]
      return (sorted[count / 2] + sorted[count / 2 + 1]) / 2.0
    }

    NR == 1 { next }
    {
      key = $1
      bench[key] = $1
      base_count[key]++
      pass_count[key]++
      base_vals[key, base_count[key]] = $3 + 0
      pass_vals[key, pass_count[key]] = $4 + 0
      base_checksum[key] = $5
      pass_checksum[key] = $6
    }

    END {
      for (key in bench) {
        delete tmp_base
        delete tmp_pass
        for (i = 1; i <= base_count[key]; ++i)
          tmp_base[i] = base_vals[key, i]
        for (i = 1; i <= pass_count[key]; ++i)
          tmp_pass[i] = pass_vals[key, i]

        base_med = median(tmp_base, base_count[key], sorted_base)
        delete sorted_base
        pass_med = median(tmp_pass, pass_count[key], sorted_pass)
        delete sorted_pass
        speedup = base_med / pass_med

        printf "mac %s repeats=%d baseline_median=%.2f pass_median=%.2f speedup=%.3f checksum_baseline=%s checksum_pass=%s\n", \
          bench[key], base_count[key], base_med, pass_med, speedup, \
          base_checksum[key], pass_checksum[key]
      }
    }
  ' "$raw" | sort > "$summary"
}

TARGET_BENCHES=("${FINAL_BENCHES[@]}")

if [ $# -ge 1 ]; then
  TARGET_BENCHES=("$1")
fi

[[ "$REPEATS" =~ ^[0-9]+$ ]] || die "REPEATS must be a positive integer"
[ "$REPEATS" -ge 1 ] || die "REPEATS must be >= 1"

mkdir -p "$BUILD_DIR"
RAW="$OUT_ROOT/mac_final_median_raw.tsv"
SUMMARY="$OUT_ROOT/mac_final_median_summary.txt"
printf "benchmark\trepeat\tbaseline_ns\tpass_ns\tchecksum_baseline\tchecksum_pass\n" > "$RAW"

echo "=== run_mac_final_median_benchmarks.sh ==="
echo "Repeats per benchmark: $REPEATS"
check_tools
echo ""

echo "Building..."
for bench in "${TARGET_BENCHES[@]}"; do
  compile_bench "$bench"
done

echo ""
echo "Running..."
for bench in "${TARGET_BENCHES[@]}"; do
  bin_dir="$BUILD_DIR/$bench"
  for repeat in $(seq 1 "$REPEATS"); do
    echo "  $bench repeat $repeat/$REPEATS ..."
    base_result="$(run_binary "$bin_dir/${bench}_baseline")"
    pass_result="$(run_binary "$bin_dir/${bench}_pass")"
    base_ns="${base_result%% *}"
    base_checksum="${base_result#* }"
    pass_ns="${pass_result%% *}"
    pass_checksum="${pass_result#* }"
    speedup="$(awk "BEGIN { printf \"%.3f\", $base_ns / $pass_ns }")"
    printf "    base=%10.2f ns  pass=%10.2f ns  speedup=%sx  checksum=%s/%s\n" \
      "$base_ns" "$pass_ns" "$speedup" "$base_checksum" "$pass_checksum"
    printf "%s\t%s\t%s\t%s\t%s\t%s\n" \
      "$bench" "$repeat" "$base_ns" "$pass_ns" "$base_checksum" "$pass_checksum" \
      >> "$RAW"
  done
done

write_medians "$RAW" "$SUMMARY"
echo ""
echo "Raw runs written to $RAW"
echo "Median summary written to $SUMMARY"
