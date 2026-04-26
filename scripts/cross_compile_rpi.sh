#!/usr/bin/env bash
# Cross-compile benchmark binaries for Raspberry Pi 3B, 4B, and 5.
#
# Targets:
#   rpi3b — Cortex-A53 (aarch64, in-order)
#   rpi4b — Cortex-A72 (aarch64, light OOO)
#   rpi5  — Cortex-A76 (aarch64, deep OOO)
#
# Requirements:
#   zig >= 0.12  (brew install zig)  — cross-compiler + static musl libc bundled
#   llc from LLVM build with AArch64 backend
#
# Outputs:
#   bench_outputs/<kernel>/rpi3b/<kernel>_{baseline,pass}
#   bench_outputs/<kernel>/rpi4b/<kernel>_{baseline,pass}
#   bench_outputs/<kernel>/rpi5/<kernel>_{baseline,pass}
#
# Usage:
#   bash scripts/cross_compile_rpi.sh               # all kernels, all models
#   bash scripts/cross_compile_rpi.sh rpi3b         # all kernels, one model
#   bash scripts/cross_compile_rpi.sh rpi3b dynamic_split  # one kernel, one model

set -euo pipefail

LLVM_BUILD="${LLVM_BUILD:-/Users/shravansheth/ShravsSSD/llvm-project/build}"
LLC="$LLVM_BUILD/bin/llc"
OPT="$LLVM_BUILD/bin/opt"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
MICROBENCH="$REPO_ROOT/microbench_outputs"
BENCHMARKS="$REPO_ROOT/benchmarks"
BENCH_OUT="$REPO_ROOT/bench_outputs"

# ---- target definitions -------------------------------------------------------

# Maps model name → Cortex CPU string for llc -mcpu
mcpu_for() {
    case "$1" in
        rpi3b) echo "cortex-a53" ;;
        rpi4b) echo "cortex-a72" ;;
        rpi5)  echo "cortex-a76" ;;
        *) echo "ERROR: unknown model '$1'. Valid: rpi3b rpi4b rpi5" >&2; exit 1 ;;
    esac
}

ALL_MODELS=(rpi3b rpi4b rpi5)

STANDARD_KERNELS=(
    dynamic_split
    adjacent_tiles
    matrix_row_split
    subview_noalias
    tiling_noinline
    split_accumulate
    double_invariant
)

# ---- preflight ----------------------------------------------------------------

die() { echo "ERROR: $*" >&2; exit 1; }

check_tools() {
    if ! command -v zig >/dev/null 2>&1; then
        die "zig not found. Install with: brew install zig"
    fi

    local zig_ver
    zig_ver=$(zig version 2>/dev/null | cut -d. -f1-2)
    echo "  zig $zig_ver"

    if ! "$LLC" --version 2>&1 | grep -qi "aarch64"; then
        die "llc at $LLC does not support AArch64. Rebuild LLVM with AArch64 in LLVM_TARGETS_TO_BUILD."
    fi
    echo "  llc $("$LLC" --version 2>&1 | head -1)"
}

# ---- compile helpers ----------------------------------------------------------

# compile_variant <kernel> <model> <ll_file> <out_bin>
# Compiles one .O2.ll → AArch64 object, cross-compiles C harness, links to static binary.
compile_variant() {
    local kernel=$1 model=$2 ll_file=$3 out_bin=$4
    local mcpu
    mcpu=$(mcpu_for "$model")
    local out_dir
    out_dir="$(dirname "$out_bin")"
    mkdir -p "$out_dir"

    local c_src="$BENCHMARKS/bench_${kernel}.c"
    [ -f "$c_src" ]  || { echo "    SKIP — no harness: bench_${kernel}.c"; return; }
    [ -f "$ll_file" ] || { echo "    SKIP — no IR: $(basename "$ll_file")"; return; }

    # MLIR kernel IR → AArch64 ELF object.
    # -mtriple overrides any target triple baked into the .ll by the macOS opt run.
    "$LLC" \
        -mtriple=aarch64-linux-gnu \
        -mcpu="$mcpu" \
        -filetype=obj \
        "$ll_file" \
        -o "${out_bin}.k.o"

    # C harness → static AArch64 binary with musl libc bundled (no sysroot needed).
    zig cc \
        --target=aarch64-linux-musl \
        -static \
        -O2 \
        -I "$BENCHMARKS" \
        "$c_src" \
        "${out_bin}.k.o" \
        -o "$out_bin"

    rm -f "${out_bin}.k.o"
    echo "    OK  $(basename "$out_bin")  [mcpu=$mcpu]"
}

# compile_kernel <kernel> <model>
# Compiles baseline and pass variants for one kernel+model combination.
compile_kernel() {
    local kernel=$1 model=$2

    local out_dir="$BENCH_OUT/$kernel/$model"

    echo "  $kernel"

    # vectorize_split: re-run opt targeting AArch64 directly so the cost model
    # naturally vectorizes with ldp/stp (VF=4, interleave=2). All three Pi CPUs
    # (A53, A72, A76) vectorize naturally when alias uncertainty is resolved.
    # The macOS fvw4 IR is NOT used for Pi builds — it lacks interleaving and is
    # suboptimal for ARM memory pipelines.
    if [ "$kernel" = "vectorize_split" ]; then
        local mcpu
        mcpu=$(mcpu_for "$model")
        mkdir -p "$out_dir"

        local aarch64_base_ll="$out_dir/${kernel}_baseline_aarch64.O2.ll"
        local aarch64_pass_ll="$out_dir/${kernel}_pass_aarch64.O2.ll"

        "$OPT" "$MICROBENCH/$kernel/baseline/${kernel}.ll" \
            -mtriple=aarch64-linux-gnu -mcpu="$mcpu" \
            -passes="default<O2>" -S -o "$aarch64_base_ll"

        "$OPT" "$MICROBENCH/$kernel/with_meta/${kernel}.ll" \
            -mtriple=aarch64-linux-gnu -mcpu="$mcpu" \
            -passes="default<O2>" -S -o "$aarch64_pass_ll"

        compile_variant "$kernel" "$model" "$aarch64_base_ll" "$out_dir/${kernel}_baseline"
        compile_variant "$kernel" "$model" "$aarch64_pass_ll" "$out_dir/${kernel}_pass"
    else
        # Standard kernels: baseline and pass both use macOS-generated O2.ll.
        # Scalar code is target-independent; llc handles AArch64 backend lowering.
        compile_variant "$kernel" "$model" \
            "$MICROBENCH/$kernel/baseline/${kernel}.O2.ll" \
            "$out_dir/${kernel}_baseline"
        compile_variant "$kernel" "$model" \
            "$MICROBENCH/$kernel/with_meta/${kernel}.O2.ll" \
            "$out_dir/${kernel}_pass"
    fi
}

# ---- main ---------------------------------------------------------------------

echo "=== cross_compile_rpi.sh ==="
check_tools
echo ""

# Optional args: [model] [kernel]
TARGET_MODELS=("${ALL_MODELS[@]}")
TARGET_KERNELS=("${STANDARD_KERNELS[@]}" vectorize_split)

if [ $# -ge 1 ]; then
    TARGET_MODELS=("$1")
fi
if [ $# -ge 2 ]; then
    TARGET_KERNELS=("$2")
fi

for model in "${TARGET_MODELS[@]}"; do
    mcpu=$(mcpu_for "$model")
    echo "=== $model  (mcpu=$mcpu) ==="
    for kernel in "${TARGET_KERNELS[@]}"; do
        compile_kernel "$kernel" "$model"
    done
    echo ""
done

echo "Binaries in $BENCH_OUT/<kernel>/<model>/"
echo ""
echo "Next: edit scripts/rpi_config.sh with your Tailscale hostnames,"
echo "      then run:  bash scripts/run_rpi_benchmarks.sh"
