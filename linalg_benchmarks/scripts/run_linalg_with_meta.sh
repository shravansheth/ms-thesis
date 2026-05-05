#!/usr/bin/env bash
# Pass pipeline for linalg kernels.
# Adds --convert-linalg-to-loops before alias-meta-opt, then standard CPU lowering.
#
# Usage: bash linalg_benchmarks/scripts/run_linalg_with_meta.sh \
#            linalg_benchmarks/kernels/<name>.mlir \
#            linalg_benchmarks/pass_outputs/<name>/<name>
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input.mlir> <output_prefix>"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LLVM_BUILD="${LLVM_BUILD:-/Users/shravansheth/ShravsSSD/llvm-project/build}"
MLIR_OPT="$LLVM_BUILD/bin/mlir-opt"
MLIR_TRANSLATE="$LLVM_BUILD/bin/mlir-translate"
ALIAS_META_OPT="${ALIAS_META_OPT:-$REPO_ROOT/pass/build/bin/alias-meta-opt}"

INPUT=$1
PREFIX=$2
OUTDIR="$(dirname "$PREFIX")"
BASENAME="$(basename "$PREFIX")"
mkdir -p "$OUTDIR"

# Step 1: lower linalg.generic -> scf loops
"$MLIR_OPT" "$INPUT" --convert-linalg-to-loops \
  -o "${PREFIX}.loops.mlir"

# Step 2: alias metadata passes (mark-alias-groups + lower-with-alias-meta)
# Must run BEFORE finalize-memref-to-llvm.
"$ALIAS_META_OPT" \
  --mark-alias-groups \
  --lower-with-alias-meta \
  "${PREFIX}.loops.mlir" \
  -o "${PREFIX}.meta.mlir"

# Step 3: standard CPU lowering (tagged memref ops already lowered by pass 2;
#          finalize-memref-to-llvm handles the rest)
"$MLIR_OPT" "${PREFIX}.meta.mlir" \
  -convert-scf-to-cf \
  -memref-expand \
  -fold-memref-alias-ops \
  -expand-strided-metadata \
  -lower-affine \
  -convert-arith-to-llvm \
  -convert-index-to-llvm \
  -convert-math-to-llvm \
  -convert-cf-to-llvm \
  -convert-func-to-llvm \
  -finalize-memref-to-llvm \
  -reconcile-unrealized-casts \
  -o "${PREFIX}.llvm_dialect.mlir"

# Step 4: LLVM dialect -> LLVM IR
"$MLIR_TRANSLATE" --mlir-to-llvmir \
  "${PREFIX}.llvm_dialect.mlir" \
  -o "${PREFIX}.ll"

echo "Pass IR written to ${PREFIX}.ll"
