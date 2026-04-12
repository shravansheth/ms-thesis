#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input.mlir> <output_prefix>"
  exit 1
fi

LLVM_BUILD="${LLVM_BUILD:-/Users/shravansheth/ShravsSSD/llvm-project/build}"

MLIR_OPT="$LLVM_BUILD/bin/mlir-opt"

MLIR_TRANSLATE="$LLVM_BUILD/bin/mlir-translate"
OPT="$LLVM_BUILD/bin/opt"

INPUT=$1
PREFIX=$2

OUTDIR="$(dirname "$PREFIX")"
BASENAME="$(basename "$PREFIX")"

mkdir -p "$OUTDIR"

# ---- MLIR → LLVM dialect ----
"$MLIR_OPT" "$INPUT" \
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
  > "${PREFIX}.llvm_dialect.mlir"

# ---- LLVM dialect → LLVM IR ----
"$MLIR_TRANSLATE" --mlir-to-llvmir \
  "${PREFIX}.llvm_dialect.mlir" \
  > "${PREFIX}.ll"

# ---- Generate CFG DOT files ----
cd "$OUTDIR"

"$OPT" -passes=dot-cfg -disable-output "${BASENAME}.ll"

for dotfile in *.dot .*.dot; do
  [ -f "$dotfile" ] || continue
  funcname="$(basename "$dotfile" .dot)"
  funcname="${funcname#.}"   # strip leading dot
  dot -Tpng "$dotfile" -o "${funcname}.png"
done

echo "CFG DOTs and PNGs written"

