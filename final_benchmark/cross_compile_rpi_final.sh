#!/usr/bin/env bash
# Cross-compile the five final benchmark candidates for Raspberry Pi boards.
#
# Outputs:
#   final_benchmark/bench_outputs/<candidate>/<model>/<candidate>_{baseline,pass}
#
# Usage:
#   bash final_benchmark/cross_compile_rpi_final.sh
#   bash final_benchmark/cross_compile_rpi_final.sh rpi3b
#   bash final_benchmark/cross_compile_rpi_final.sh rpi3b polybench_atax

set -euo pipefail

LLVM_BUILD="${LLVM_BUILD:-/Users/shravansheth/ShravsSSD/llvm-project/build}"
LLC="$LLVM_BUILD/bin/llc"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
OUT_ROOT="$SCRIPT_DIR/bench_outputs"
export ZIG_GLOBAL_CACHE_DIR="$OUT_ROOT/.zig-cache/global"
export ZIG_LOCAL_CACHE_DIR="$OUT_ROOT/.zig-cache/local"

ALL_MODELS=(rpi3b rpi4b rpi5)
FINAL_BENCHES=(
  polybench_atax
  polybench_bicg
  imex_softmax
  polybench_mvt
  iree_bias_add
)

die() { echo "ERROR: $*" >&2; exit 1; }

mcpu_for() {
  case "$1" in
    rpi3b) echo "cortex-a53" ;;
    rpi4b) echo "cortex-a72" ;;
    rpi5)  echo "cortex-a76" ;;
    *) die "unknown model '$1'. Valid: rpi3b rpi4b rpi5" ;;
  esac
}

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
  command -v zig >/dev/null 2>&1 || die "zig not found. Install with: brew install zig"
  [ -x "$LLC" ] || die "llc not found at $LLC"
  "$LLC" --version 2>&1 | grep -qi aarch64 || \
    die "llc at $LLC does not support AArch64"
  echo "  zig $(zig version)"
  echo "  llc $("$LLC" --version 2>&1 | head -1)"
}

compile_one() {
  local bench=$1 model=$2 variant=$3 ll_file=$4 out_bin=$5
  local mcpu
  mcpu="$(mcpu_for "$model")"

  [ -f "$HARNESS" ] || die "missing harness: $HARNESS"
  [ -f "$ll_file" ] || die "missing $variant IR: $ll_file"

  mkdir -p "$(dirname "$out_bin")"

  "$LLC" \
    -mtriple=aarch64-linux-gnu \
    -mcpu="$mcpu" \
    -filetype=obj \
    "$ll_file" \
    -o "${out_bin}.k.o"

  zig cc \
    --target=aarch64-linux-musl \
    -static \
    -O2 \
    -I "$REPO_ROOT/benchmarks" \
    "$HARNESS" \
    "${out_bin}.k.o" \
    -o "$out_bin"

  rm -f "${out_bin}.k.o"
  echo "    OK  ${bench}_${variant}  [mcpu=$mcpu]"
}

compile_bench() {
  local bench=$1 model=$2 out_dir
  out_dir="$OUT_ROOT/$bench/$model"
  bench_paths "$bench"

  echo "  $bench"
  compile_one "$bench" "$model" baseline "$BASE_LL" "$out_dir/${bench}_baseline"
  compile_one "$bench" "$model" pass "$PASS_LL" "$out_dir/${bench}_pass"
}

echo "=== cross_compile_rpi_final.sh ==="
check_tools
echo ""

TARGET_MODELS=("${ALL_MODELS[@]}")
TARGET_BENCHES=("${FINAL_BENCHES[@]}")

if [ $# -ge 1 ]; then
  TARGET_MODELS=("$1")
fi
if [ $# -ge 2 ]; then
  TARGET_BENCHES=("$2")
fi

for model in "${TARGET_MODELS[@]}"; do
  echo "=== $model  (mcpu=$(mcpu_for "$model")) ==="
  for bench in "${TARGET_BENCHES[@]}"; do
    compile_bench "$bench" "$model"
  done
  echo ""
done

echo "Binaries in $OUT_ROOT/<candidate>/<model>/"
echo "Next: bash final_benchmark/run_rpi_final_benchmarks.sh"
