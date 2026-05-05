#!/usr/bin/env bash
# Run final benchmarks repeatedly on Raspberry Pi boards and report medians.
#
# This does not modify rpi_final_summary.txt. It writes:
#   final_benchmark/bench_outputs/rpi_final_median_raw.tsv
#   final_benchmark/bench_outputs/rpi_final_median_summary.txt
#
# Usage:
#   bash final_benchmark/run_rpi_final_median_benchmarks.sh
#   bash final_benchmark/run_rpi_final_median_benchmarks.sh rpi4b
#   bash final_benchmark/run_rpi_final_median_benchmarks.sh rpi4b imex_softmax
#   REPEATS=7 bash final_benchmark/run_rpi_final_median_benchmarks.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
OUT_ROOT="$SCRIPT_DIR/bench_outputs"
REPEATS="${REPEATS:-5}"

source "$REPO_ROOT/scripts/rpi_config.sh"

ALL_MODELS=(rpi3b rpi4b rpi5)
FINAL_BENCHES=(
  polybench_atax
  polybench_bicg
  imex_softmax
  polybench_mvt
  iree_bias_add
)

die() { echo "ERROR: $*" >&2; exit 1; }

host_for() {
  case "$1" in
    rpi3b) echo "$RPI3B_HOST" ;;
    rpi4b) echo "$RPI4B_HOST" ;;
    rpi5)  echo "$RPI5_HOST" ;;
    *) die "unknown model '$1'" ;;
  esac
}

cpu_desc_for() {
  case "$1" in
    rpi3b) echo "Cortex-A53 in-order" ;;
    rpi4b) echo "Cortex-A72 OOO" ;;
    rpi5)  echo "Cortex-A76 OOO" ;;
  esac
}

ssh_run() {
  local host=$1
  shift
  ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "${RPI_USER}@${host}" "$@"
}

check_reachable() {
  local model=$1 host
  host="$(host_for "$model")"
  if ssh_run "$host" "true" 2>/dev/null; then
    echo "  $model ($host): reachable"
  else
    echo "  $model ($host): UNREACHABLE - skipping"
    return 1
  fi
}

deploy_bench() {
  local bench=$1 model=$2 host=$3
  local bin_dir="$OUT_ROOT/$bench/$model"
  local base_bin="$bin_dir/${bench}_baseline"
  local pass_bin="$bin_dir/${bench}_pass"

  if [ ! -f "$base_bin" ] || [ ! -f "$pass_bin" ]; then
    echo "    SKIP $bench - binaries missing; run cross_compile_rpi_final.sh first"
    return 1
  fi

  ssh_run "$host" "mkdir -p '$RPI_BENCH_DIR/final/$bench' && rm -f '$RPI_BENCH_DIR/final/$bench/${bench}_baseline' '$RPI_BENCH_DIR/final/$bench/${bench}_pass'"
  scp -q "$base_bin" "$pass_bin" \
    "${RPI_USER}@${host}:${RPI_BENCH_DIR}/final/${bench}/"
  ssh_run "$host" "chmod +x '$RPI_BENCH_DIR/final/$bench/${bench}_baseline' '$RPI_BENCH_DIR/final/$bench/${bench}_pass'"
}

run_binary() {
  local host=$1 path=$2 out ns checksum
  out="$(ssh_run "$host" "$path")"
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
      key = $1 SUBSEP $2
      model[key] = $1
      bench[key] = $2
      base_count[key]++
      pass_count[key]++
      base_vals[key, base_count[key]] = $4 + 0
      pass_vals[key, pass_count[key]] = $5 + 0
      base_checksum[key] = $6
      pass_checksum[key] = $7
    }

    END {
      for (key in model) {
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

        printf "%s %s repeats=%d baseline_median=%.2f pass_median=%.2f speedup=%.3f checksum_baseline=%s checksum_pass=%s\n", \
          model[key], bench[key], base_count[key], base_med, pass_med, speedup, \
          base_checksum[key], pass_checksum[key]
      }
    }
  ' "$raw" | sort > "$summary"
}

TARGET_MODELS=("${ALL_MODELS[@]}")
TARGET_BENCHES=("${FINAL_BENCHES[@]}")

if [ $# -ge 1 ]; then
  TARGET_MODELS=("$1")
fi
if [ $# -ge 2 ]; then
  TARGET_BENCHES=("$2")
fi

[[ "$REPEATS" =~ ^[0-9]+$ ]] || die "REPEATS must be a positive integer"
[ "$REPEATS" -ge 1 ] || die "REPEATS must be >= 1"

mkdir -p "$OUT_ROOT"
RAW="$OUT_ROOT/rpi_final_median_raw.tsv"
SUMMARY="$OUT_ROOT/rpi_final_median_summary.txt"
printf "model\tbenchmark\trepeat\tbaseline_ns\tpass_ns\tchecksum_baseline\tchecksum_pass\n" > "$RAW"

echo "=== run_rpi_final_median_benchmarks.sh ==="
echo "Repeats per benchmark: $REPEATS"
echo "Checking connectivity..."
ACTIVE_MODELS=()
for model in "${TARGET_MODELS[@]}"; do
  if check_reachable "$model" 2>/dev/null; then
    ACTIVE_MODELS+=("$model")
  fi
done

if [ ${#ACTIVE_MODELS[@]} -eq 0 ]; then
  die "No Pis reachable. Check local-network SSH and scripts/rpi_config.sh."
fi

echo ""
for model in "${ACTIVE_MODELS[@]}"; do
  host="$(host_for "$model")"
  echo "=== $model - $(cpu_desc_for "$model") ($host) ==="
  echo "  Deploying binaries..."
  for bench in "${TARGET_BENCHES[@]}"; do
    deploy_bench "$bench" "$model" "$host" || continue
  done

  echo "  Running..."
  for bench in "${TARGET_BENCHES[@]}"; do
    bin_dir="$RPI_BENCH_DIR/final/$bench"
    for repeat in $(seq 1 "$REPEATS"); do
      echo "    $bench repeat $repeat/$REPEATS ..."
      base_result="$(run_binary "$host" "$bin_dir/${bench}_baseline")"
      pass_result="$(run_binary "$host" "$bin_dir/${bench}_pass")"
      base_ns="${base_result%% *}"
      base_checksum="${base_result#* }"
      pass_ns="${pass_result%% *}"
      pass_checksum="${pass_result#* }"
      speedup="$(awk "BEGIN { printf \"%.3f\", $base_ns / $pass_ns }")"
      printf "      base=%10.2f ns  pass=%10.2f ns  speedup=%sx  checksum=%s/%s\n" \
        "$base_ns" "$pass_ns" "$speedup" "$base_checksum" "$pass_checksum"
      printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
        "$model" "$bench" "$repeat" "$base_ns" "$pass_ns" "$base_checksum" "$pass_checksum" \
        >> "$RAW"
    done
  done
  echo ""
done

write_medians "$RAW" "$SUMMARY"
echo "Raw runs written to $RAW"
echo "Median summary written to $SUMMARY"
