#!/usr/bin/env bash
# Deploy and run alias-metadata benchmarks on Raspberry Pi devices via Tailscale SSH.
#
# Prerequisites:
#   - SSH key auth set up for each Pi (ssh-copy-id pi@<host>)
#   - scripts/rpi_config.sh filled in with correct Tailscale hostnames
#   - Cross-compiled binaries in bench_outputs/<kernel>/<model>/
#     (run scripts/cross_compile_rpi.sh first)
#
# Usage:
#   bash scripts/run_rpi_benchmarks.sh              # all models, all kernels
#   bash scripts/run_rpi_benchmarks.sh rpi3b        # one model, all kernels
#   bash scripts/run_rpi_benchmarks.sh rpi3b dynamic_split  # one model, one kernel

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
BENCH_OUT="$REPO_ROOT/bench_outputs"

source "$SCRIPT_DIR/rpi_config.sh"

# ---- target definitions -------------------------------------------------------

ALL_MODELS=(rpi3b rpi4b rpi5)

host_for() {
    case "$1" in
        rpi3b) echo "$RPI3B_HOST" ;;
        rpi4b) echo "$RPI4B_HOST" ;;
        rpi5)  echo "$RPI5_HOST"  ;;
        *) echo "ERROR: unknown model '$1'" >&2; exit 1 ;;
    esac
}

cpu_desc_for() {
    case "$1" in
        rpi3b) echo "Cortex-A53 in-order" ;;
        rpi4b) echo "Cortex-A72 OOO" ;;
        rpi5)  echo "Cortex-A76 OOO" ;;
    esac
}

STANDARD_KERNELS=(
    dynamic_split
    adjacent_tiles
    matrix_row_split
    subview_noalias
    tiling_noinline
    split_accumulate
    double_invariant
)

# ---- helpers ------------------------------------------------------------------

die() { echo "ERROR: $*" >&2; exit 1; }

ssh_run() {
    local host=$1; shift
    ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no \
        "${RPI_USER}@${host}" "$@"
}

# Check that a Pi is reachable.
check_reachable() {
    local model=$1
    local host
    host=$(host_for "$model")
    if ssh_run "$host" "true" 2>/dev/null; then
        echo "  $model ($host): reachable"
    else
        echo "  $model ($host): UNREACHABLE — skipping"
        return 1
    fi
}

# Deploy binaries for one kernel to one Pi.
deploy_kernel() {
    local kernel=$1 model=$2 host=$3
    local bin_dir="$BENCH_OUT/$kernel/$model"

    local base_bin="$bin_dir/${kernel}_baseline"
    local pass_bin="$bin_dir/${kernel}_pass"

    if [ ! -f "$base_bin" ] || [ ! -f "$pass_bin" ]; then
        echo "    SKIP $kernel — binaries missing (run cross_compile_rpi.sh first)"
        return
    fi

    ssh_run "$host" "mkdir -p $RPI_BENCH_DIR/$kernel"
    scp -q "$base_bin" "$pass_bin" \
        "${RPI_USER}@${host}:${RPI_BENCH_DIR}/${kernel}/"
    ssh_run "$host" "chmod +x ${RPI_BENCH_DIR}/${kernel}/${kernel}_baseline \
                               ${RPI_BENCH_DIR}/${kernel}/${kernel}_pass"
}

# Run one kernel on one Pi, print and return results.
run_kernel() {
    local kernel=$1 host=$2

    local base_ns pass_ns speedup
    base_ns=$(ssh_run "$host" \
        "${RPI_BENCH_DIR}/${kernel}/${kernel}_baseline" \
        | awk '/ns_per_call:/ { print $2 }')
    pass_ns=$(ssh_run "$host" \
        "${RPI_BENCH_DIR}/${kernel}/${kernel}_pass" \
        | awk '/ns_per_call:/ { print $2 }')

    if [ -z "$base_ns" ] || [ -z "$pass_ns" ]; then
        echo "    $kernel: FAILED (no output)"
        return
    fi

    speedup=$(awk "BEGIN { printf \"%.2f\", $base_ns / $pass_ns }")
    printf "    %-28s  base=%10.2f ns  pass=%10.2f ns  speedup=%sx\n" \
        "$kernel" "$base_ns" "$pass_ns" "$speedup"

    # Append to summary
    echo "$model $kernel baseline=$base_ns pass=$pass_ns speedup=$speedup" \
        >> "$BENCH_OUT/rpi_summary.txt"
}

# ---- main ---------------------------------------------------------------------

# Optional args: [model] [kernel]
TARGET_MODELS=("${ALL_MODELS[@]}")
TARGET_KERNELS=("${STANDARD_KERNELS[@]}" vectorize_split)

if [ $# -ge 1 ]; then
    TARGET_MODELS=("$1")
fi
if [ $# -ge 2 ]; then
    TARGET_KERNELS=("$2")
fi

# Clear summary from previous run (or start fresh).
> "$BENCH_OUT/rpi_summary.txt"

echo "=== run_rpi_benchmarks.sh ==="
echo "Checking connectivity..."
ACTIVE_MODELS=()
for model in "${TARGET_MODELS[@]}"; do
    if check_reachable "$model" 2>/dev/null; then
        ACTIVE_MODELS+=("$model")
    fi
done

if [ ${#ACTIVE_MODELS[@]} -eq 0 ]; then
    die "No Pis reachable. Check Tailscale and rpi_config.sh."
fi

echo ""

for model in "${ACTIVE_MODELS[@]}"; do
    host=$(host_for "$model")
    cpu=$(cpu_desc_for "$model")
    echo "=== $model — $cpu ($host) ==="

    # Deploy all kernels
    echo "  Deploying binaries..."
    for kernel in "${TARGET_KERNELS[@]}"; do
        deploy_kernel "$kernel" "$model" "$host"
    done

    # Run all kernels
    echo "  Running..."
    for kernel in "${TARGET_KERNELS[@]}"; do
        run_kernel "$kernel" "$host"
    done
    echo ""
done

echo "Summary written to $BENCH_OUT/rpi_summary.txt"
echo ""
echo "Tip: compare against macOS results in $BENCH_OUT/summary.txt"
