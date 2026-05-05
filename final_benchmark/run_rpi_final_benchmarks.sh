#!/usr/bin/env bash
# Deploy and run the five final benchmark candidates on Raspberry Pi boards over
# local-network SSH. Configure hostnames/IPs in scripts/rpi_config.sh.
#
# Usage:
#   bash final_benchmark/run_rpi_final_benchmarks.sh
#   bash final_benchmark/run_rpi_final_benchmarks.sh rpi3b
#   bash final_benchmark/run_rpi_final_benchmarks.sh rpi3b polybench_atax

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
OUT_ROOT="$SCRIPT_DIR/bench_outputs"

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
    return
  fi

  ssh_run "$host" "mkdir -p '$RPI_BENCH_DIR/final/$bench' && rm -f '$RPI_BENCH_DIR/final/$bench/${bench}_baseline' '$RPI_BENCH_DIR/final/$bench/${bench}_pass'"
  scp -q "$base_bin" "$pass_bin" \
    "${RPI_USER}@${host}:${RPI_BENCH_DIR}/final/${bench}/"
  ssh_run "$host" "chmod +x '$RPI_BENCH_DIR/final/$bench/${bench}_baseline' '$RPI_BENCH_DIR/final/$bench/${bench}_pass'"
}

run_bench() {
  local bench=$1 model=$2 host=$3
  local base_out pass_out base_ns pass_ns speedup base_checksum pass_checksum

  base_out="$(ssh_run "$host" "$RPI_BENCH_DIR/final/$bench/${bench}_baseline")"
  pass_out="$(ssh_run "$host" "$RPI_BENCH_DIR/final/$bench/${bench}_pass")"

  base_ns="$(printf "%s\n" "$base_out" | awk '/ns_per_call:/ { print $2; exit }')"
  pass_ns="$(printf "%s\n" "$pass_out" | awk '/ns_per_call:/ { print $2; exit }')"
  base_checksum="$(printf "%s\n" "$base_out" | awk '/checksum:/ { print $2; exit }')"
  pass_checksum="$(printf "%s\n" "$pass_out" | awk '/checksum:/ { print $2; exit }')"

  if [ -z "$base_ns" ] || [ -z "$pass_ns" ]; then
    echo "    $bench: FAILED (missing ns_per_call)"
    return
  fi

  speedup="$(awk "BEGIN { printf \"%.2f\", $base_ns / $pass_ns }")"
  printf "    %-18s  base=%10.2f ns  pass=%10.2f ns  speedup=%sx" \
    "$bench" "$base_ns" "$pass_ns" "$speedup"
  if [ -n "$base_checksum" ] || [ -n "$pass_checksum" ]; then
    printf "  checksum=%s/%s" "${base_checksum:-n/a}" "${pass_checksum:-n/a}"
  fi
  printf "\n"

  update_summary "$model" "$bench" "$base_ns" "$pass_ns" "$speedup" \
    "${base_checksum:-n/a}" "${pass_checksum:-n/a}"
}

update_summary() {
  local model=$1 bench=$2 base_ns=$3 pass_ns=$4 speedup=$5 base_checksum=$6 pass_checksum=$7
  local summary="$OUT_ROOT/rpi_final_summary.txt"
  local tmp="$summary.tmp"
  local line

  line="$model $bench baseline=$base_ns pass=$pass_ns speedup=$speedup checksum_baseline=$base_checksum checksum_pass=$pass_checksum"

  mkdir -p "$OUT_ROOT"
  if [ -f "$summary" ]; then
    awk -v model="$model" -v bench="$bench" \
      '!($1 == model && $2 == bench)' "$summary" > "$tmp"
  else
    : > "$tmp"
  fi

  printf "%s\n" "$line" >> "$tmp"
  mv "$tmp" "$summary"
}

TARGET_MODELS=("${ALL_MODELS[@]}")
TARGET_BENCHES=("${FINAL_BENCHES[@]}")

if [ $# -ge 1 ]; then
  TARGET_MODELS=("$1")
fi
if [ $# -ge 2 ]; then
  TARGET_BENCHES=("$2")
fi

mkdir -p "$OUT_ROOT"
touch "$OUT_ROOT/rpi_final_summary.txt"

echo "=== run_rpi_final_benchmarks.sh ==="
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
    deploy_bench "$bench" "$model" "$host"
  done

  echo "  Running..."
  for bench in "${TARGET_BENCHES[@]}"; do
    echo "    running $bench ..."
    run_bench "$bench" "$model" "$host"
  done
  echo ""
done

echo "Summary written to $OUT_ROOT/rpi_final_summary.txt"
