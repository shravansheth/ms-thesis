#!/usr/bin/env bash
# Build and run all alias-metadata benchmarks.
#
# For each kernel:
#   1. Compile baseline and pass O2.ll → native object files via llc
#   2. Link with the C harness → two binaries (baseline, pass)
#   3. Run both, report ns/call and speedup
#
# Outputs go to bench_outputs/<kernel>/
#
# Special case — vectorize_split:
#   Uses -force-vector-width=4 for the pass version to demonstrate that alias
#   metadata enables SIMD vectorization. The baseline remains scalar even with
#   forced VF because UnsafeDep blocks vectorization at the safety-check level.
#
# Usage:
#   bash benchmarks/run_benchmarks.sh
#   bash benchmarks/run_benchmarks.sh dynamic_split   # single kernel
#   bash benchmarks/run_benchmarks.sh vectorize_split # vectorization case

set -euo pipefail

LLVM_BUILD="${LLVM_BUILD:-/Users/shravansheth/ShravsSSD/llvm-project/build}"
LLC="$LLVM_BUILD/bin/llc"
OPT="$LLVM_BUILD/bin/opt"
CC="${CC:-clang}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
MICROBENCH="$REPO_ROOT/microbench_outputs"
BENCH_OUT="$REPO_ROOT/bench_outputs"

mkdir -p "$BENCH_OUT"

# ---- helpers ----------------------------------------------------------------

die() { echo "ERROR: $*" >&2; exit 1; }

check_tools() {
    [ -x "$LLC" ] || die "llc not found at $LLC"
    command -v "$CC" >/dev/null || die "C compiler not found: $CC"
}

# Compile one .ll file to a native object file.
compile_ll() {
    local ll=$1 obj=$2
    "$LLC" -O0 -filetype=obj "$ll" -o "$obj"
}

# Run a benchmark binary, extract the ns/call number from its stdout.
run_bench() {
    local bin=$1
    "$bin" | awk '/ns_per_call:/ { print $2 }'
}

# Print a formatted result line and compute speedup.
report() {
    local kernel=$1 base_ns=$2 pass_ns=$3
    local speedup
    speedup=$(awk "BEGIN { printf \"%.2f\", $base_ns / $pass_ns }")
    printf "  baseline: %8.2f ns/call\n" "$base_ns"
    printf "  pass:     %8.2f ns/call\n" "$pass_ns"
    printf "  speedup:  %8.2fx\n"         "$speedup"
    # append to summary file
    echo "$kernel baseline=$base_ns pass=$pass_ns speedup=$speedup" \
        >> "$BENCH_OUT/summary.txt"
}

# Build and run one kernel.
bench_kernel() {
    local k=$1
    local c_src="$SCRIPT_DIR/bench_${k}.c"
    local out_dir="$BENCH_OUT/$k"

    [ -f "$c_src" ] || { echo "  SKIP $k (no harness at $c_src)"; return; }

    mkdir -p "$out_dir"

    local base_ll="$MICROBENCH/$k/baseline/${k}.O2.ll"
    local pass_ll="$MICROBENCH/$k/with_meta/${k}.O2.ll"

    [ -f "$base_ll" ] || die "Missing baseline O2 IR: $base_ll"

    # Generate pass O2.ll if not present (idempotent).
    if [ ! -f "$pass_ll" ]; then
        local raw_ll="$MICROBENCH/$k/with_meta/${k}.ll"
        [ -f "$raw_ll" ] || die "Missing pass raw IR: $raw_ll"
        echo "  Generating pass O2 IR for $k..."
        "$OPT" "$raw_ll" -passes="default<O2>" -S -o "$pass_ll" \
            -pass-remarks-output="$MICROBENCH/$k/with_meta/remarks.O2.yml" \
            -pass-remarks=licm,gvn -pass-remarks-analysis=licm,gvn
    fi

    local base_obj="$out_dir/${k}_baseline.o"
    local pass_obj="$out_dir/${k}_pass.o"
    local base_bin="$out_dir/${k}_baseline"
    local pass_bin="$out_dir/${k}_pass"

    compile_ll "$base_ll" "$base_obj"
    compile_ll "$pass_ll" "$pass_obj"

    "$CC" -O0 "$c_src" "$base_obj" -o "$base_bin"
    "$CC" -O0 "$c_src" "$pass_obj" -o "$pass_bin"

    local base_ns pass_ns
    base_ns=$(run_bench "$base_bin")
    pass_ns=$(run_bench "$pass_bin")

    echo "=== $k ==="
    report "$k" "$base_ns" "$pass_ns"
}

# Build and benchmark the vectorize_split kernel.
# Baseline uses standard O2 (scalar, blocked by UnsafeDep).
# Pass uses O2 + force-vector-width=4 to demonstrate that alias metadata
# enables SIMD; the baseline cannot vectorize even with forced VF because
# the UnsafeDep safety check fires before the cost model.
bench_vectorize_split() {
    local k="vectorize_split"
    local c_src="$SCRIPT_DIR/bench_${k}.c"
    local out_dir="$BENCH_OUT/$k"

    [ -f "$c_src" ] || { echo "  SKIP $k (no harness at $c_src)"; return; }

    mkdir -p "$out_dir"

    local base_ll="$MICROBENCH/$k/baseline/${k}.O2.ll"
    local pass_fvw4_ll="$MICROBENCH/$k/with_meta_fvw4/${k}.O2.ll"

    [ -f "$base_ll" ] || die "Missing baseline O2 IR: $base_ll"

    # Generate pass fvw4 O2.ll if not present (idempotent).
    if [ ! -f "$pass_fvw4_ll" ]; then
        local raw_ll="$MICROBENCH/$k/with_meta/${k}.ll"
        [ -f "$raw_ll" ] || die "Missing pass raw IR: $raw_ll"
        mkdir -p "$MICROBENCH/$k/with_meta_fvw4"
        echo "  Generating pass O2+fvw4 IR for $k..."
        "$OPT" "$raw_ll" -passes="default<O2>" -force-vector-width=4 \
            -S -o "$pass_fvw4_ll" \
            -pass-remarks-output="$MICROBENCH/$k/with_meta_fvw4/remarks.O2.yml" \
            -pass-remarks=loop-vectorize,licm,gvn \
            -pass-remarks-missed=loop-vectorize,licm,gvn
    fi

    local base_obj="$out_dir/${k}_baseline.o"
    local pass_obj="$out_dir/${k}_pass_fvw4.o"
    local base_bin="$out_dir/${k}_baseline"
    local pass_bin="$out_dir/${k}_pass_fvw4"

    compile_ll "$base_ll" "$base_obj"
    compile_ll "$pass_fvw4_ll" "$pass_obj"

    "$CC" -O0 "$c_src" "$base_obj" -o "$base_bin"
    "$CC" -O0 "$c_src" "$pass_obj" -o "$pass_bin"

    local base_ns pass_ns
    base_ns=$(run_bench "$base_bin")
    pass_ns=$(run_bench "$pass_bin")

    echo "=== $k (baseline=scalar[UnsafeDep], pass=SIMD[fvw4]) ==="
    report "$k" "$base_ns" "$pass_ns"
}

# ---- main -------------------------------------------------------------------

check_tools

# Clear summary from previous run.
> "$BENCH_OUT/summary.txt"

KERNELS=(
    dynamic_split
    adjacent_tiles
    matrix_row_split
    subview_noalias
    tiling_noinline
    split_accumulate
    double_invariant
)

# If a specific kernel is given, run only that one.
if [ $# -ge 1 ]; then
    if [ "$1" = "vectorize_split" ]; then
        bench_vectorize_split
        echo ""
        echo "Summary written to $BENCH_OUT/summary.txt"
        exit 0
    fi
    KERNELS=("$@")
fi

for k in "${KERNELS[@]}"; do
    bench_kernel "$k"
done

# Vectorization-enabling benchmark always runs.
bench_vectorize_split

echo ""
echo "Summary written to $BENCH_OUT/summary.txt"
