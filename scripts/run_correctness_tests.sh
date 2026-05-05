#!/usr/bin/env bash
# run_correctness_tests.sh
#
# Verifies that the pass-compiled kernels produce identical numeric output
# to the baseline-compiled kernels. For each case study kernel:
#   1. Compile C test harness with baseline .O2.ll  -> test_baseline_<kernel>
#   2. Compile C test harness with pass .meta.O2.ll -> test_pass_<kernel>
#   3. Run both, compare stdout checksums.
#   4. Report PASS or FAIL.
#
# Usage: bash scripts/run_correctness_tests.sh
#
# Requires: clang on PATH.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TESTS="$ROOT/tests"
PASS_OUT="$ROOT/pass_outputs"
BIN="$TESTS/bin"
LLC="${LLC:-/Users/shravansheth/ShravsSSD/llvm-project/build/bin/llc}"

mkdir -p "$BIN"

CC="${CC:-clang}"
CFLAGS="-O0"   # No optimisation on the test harness itself - only the kernel IR is pre-optimised

# Verify llc exists
if [ ! -x "$LLC" ]; then
    echo "ERROR: llc not found at $LLC"
    echo "Set LLC=/path/to/llvm22/llc and re-run."
    exit 1
fi

PASS=0
FAIL=0

# ── helpers ────────────────────────────────────────────────────────────────

compile() {
    local name="$1"   # kernel name
    local variant="$2"  # "baseline" or "pass"
    local src_c="$3"
    local src_ll="$4"
    local out="$5"
    local obj="${out}.o"

    # Use llc to compile .ll -> .o (handles LLVM 22 IR syntax that system clang may not understand)
    # Then link .o + C harness with system clang
    if ! "$LLC" "$src_ll" -filetype=obj -o "$obj" 2>/dev/null; then
        echo "  [LLC FAIL] $name ($variant)"
        return 1
    fi
    if ! "$CC" $CFLAGS "$src_c" "$obj" -o "$out" 2>/dev/null; then
        echo "  [LINK FAIL] $name ($variant)"
        return 1
    fi
}

check_kernel() {
    local name="$1"
    local src_c="$TESTS/test_${name}.c"
    local baseline_ll="$PASS_OUT/${name}/baseline/${name}.O2.ll"
    local pass_ll="$PASS_OUT/${name}/with_meta/${name}.meta.O2.ll"
    local bin_base="$BIN/test_baseline_${name}"
    local bin_pass="$BIN/test_pass_${name}"

    printf "  %-22s  " "$name"

    # Verify source files exist
    for f in "$src_c" "$baseline_ll" "$pass_ll"; do
        if [ ! -f "$f" ]; then
            echo "SKIP (missing: $(basename "$f"))"
            return
        fi
    done

    # Build
    if ! compile "$name" "baseline" "$src_c" "$baseline_ll" "$bin_base"; then
        FAIL=$((FAIL + 1)); return
    fi
    if ! compile "$name" "pass" "$src_c" "$pass_ll" "$bin_pass"; then
        FAIL=$((FAIL + 1)); return
    fi

    # Run and capture output
    out_base=$("$bin_base" 2>&1)
    out_pass=$("$bin_pass" 2>&1)

    if [ "$out_base" = "$out_pass" ]; then
        echo "PASS  ($out_base)"
        PASS=$((PASS + 1))
    else
        echo "FAIL"
        echo "    baseline: $out_base"
        echo "    pass:     $out_pass"
        FAIL=$((FAIL + 1))
    fi
}

check_noalias() {
    local name="subview_noalias"
    local src_c="$TESTS/test_${name}.c"
    local baseline_ll="$PASS_OUT/${name}/baseline/${name}.O2.ll"
    local pass_ll="$PASS_OUT/${name}/with_meta/${name}.meta.O2.ll"
    local bin_base="$BIN/test_baseline_${name}"
    local bin_pass="$BIN/test_pass_${name}"

    printf "  %-22s  " "$name"

    for f in "$src_c" "$baseline_ll" "$pass_ll"; do
        if [ ! -f "$f" ]; then
            echo "SKIP (missing: $(basename "$f"))"
            return
        fi
    done

    if ! compile "$name" "baseline" "$src_c" "$baseline_ll" "$bin_base"; then
        FAIL=$((FAIL + 1)); return
    fi
    if ! compile "$name" "pass" "$src_c" "$pass_ll" "$bin_pass"; then
        FAIL=$((FAIL + 1)); return
    fi

    # Both must exit 0 and produce identical stdout
    out_base=$("$bin_base" 2>&1); rc_base=$?
    out_pass=$("$bin_pass" 2>&1); rc_pass=$?

    if [ $rc_base -ne 0 ] || [ $rc_pass -ne 0 ]; then
        echo "FAIL (non-zero exit: base=$rc_base pass=$rc_pass)"
        FAIL=$((FAIL + 1))
    elif [ "$out_base" = "$out_pass" ]; then
        echo "PASS  (run-without-fault x100; no numeric comparison - see test comment)"
        PASS=$((PASS + 1))
    else
        echo "FAIL (output mismatch)"
        echo "    baseline: $out_base"
        echo "    pass:     $out_pass"
        FAIL=$((FAIL + 1))
    fi
}

# ── main ───────────────────────────────────────────────────────────────────

echo "=== Alias Metadata Pass - Correctness Tests ==="
echo "Compiler: $($CC --version | head -1)"
echo ""
echo "Each kernel is compiled twice: once with baseline O2 IR, once with"
echo "pass-annotated O2 IR. Checksums must be identical."
echo ""

check_kernel "dynamic_split"
check_kernel "adjacent_tiles"
check_kernel "matrix_row_split"
check_kernel "tiling_noinline"
check_kernel "vectorize_split"
check_noalias

echo ""
echo "Results: $PASS passed, $FAIL failed"
if [ $FAIL -eq 0 ]; then
    echo "ALL PASS - pass produces numerically identical output to baseline."
    exit 0
else
    echo "FAILURES DETECTED - alias metadata may be incorrect."
    exit 1
fi
