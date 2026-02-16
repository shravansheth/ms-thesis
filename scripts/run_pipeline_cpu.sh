#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input.mlir> <output_prefix>"
  exit 1
fi

INPUT=$1
PREFIX=$2

OUTDIR="$(dirname "$PREFIX")"
BASENAME="$(basename "$PREFIX")"

mkdir -p "$OUTDIR"

# ---- MLIR → LLVM dialect ----
mlir-opt "$INPUT" \
  -convert-scf-to-cf \
  -memref-expand \
  -fold-memref-alias-ops \
  -lower-affine \
  -convert-arith-to-llvm \
  -convert-index-to-llvm \
  -convert-math-to-llvm \
  -convert-cf-to-llvm \
  -convert-func-to-llvm \
  -finalize-memref-to-llvm \
  -reconcile-unrealized-casts \
  > "${PREFIX}.llvm_dialect.mlir"

# ---- LLVM dialect → LLVM IR ----
mlir-translate --mlir-to-llvmir \
  "${PREFIX}.llvm_dialect.mlir" \
  > "${PREFIX}.ll"

# ---- Generate CFG DOT files ----
cd "$OUTDIR"

opt -passes=dot-cfg -disable-output "${BASENAME}.ll"

for dotfile in *.dot .*.dot; do
  [ -f "$dotfile" ] || continue
  funcname="$(basename "$dotfile" .dot)"
  funcname="${funcname#.}"   # strip leading dot
  dot -Tpng "$dotfile" -o "${funcname}.png"
done

echo "CFG DOTs and PNGs written"

