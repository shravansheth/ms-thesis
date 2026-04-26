#!/usr/bin/env bash
# Baseline pipeline for linalg kernels.
# Adds --convert-linalg-to-loops before the standard CPU lowering steps.
#
# Usage: bash linalg_benchmarks/scripts/run_linalg_baseline.sh \
#            linalg_benchmarks/kernels/<name>.mlir \
#            linalg_benchmarks/outputs/<name>/<name>
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input.mlir> <output_prefix>"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LLVM_BUILD="${LLVM_BUILD:-/Users/shravansheth/ShravsSSD/llvm-project/build}"
MLIR_OPT="$LLVM_BUILD/bin/mlir-opt"
MLIR_TRANSLATE="$LLVM_BUILD/bin/mlir-translate"
OPT="$LLVM_BUILD/bin/opt"

INPUT=$1
PREFIX=$2
OUTDIR="$(dirname "$PREFIX")"
BASENAME="$(basename "$PREFIX")"
mkdir -p "$OUTDIR"

# Step 1: lower linalg.generic → scf loops (mlir-opt has linalg dialect)
"$MLIR_OPT" "$INPUT" --convert-linalg-to-loops \
  -o "${PREFIX}.loops.mlir"

# Step 2: standard CPU lowering (no linalg in alias-meta-opt — handled by mlir-opt here)
"$MLIR_OPT" "${PREFIX}.loops.mlir" \
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

# Step 3: LLVM dialect → LLVM IR
"$MLIR_TRANSLATE" --mlir-to-llvmir \
  "${PREFIX}.llvm_dialect.mlir" \
  -o "${PREFIX}.ll"

echo "Baseline IR written to ${PREFIX}.ll"
