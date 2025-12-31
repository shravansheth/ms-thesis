#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input.mlir> <output_prefix>"
  exit 1
fi

INPUT=$1
PREFIX=$2

mlir-opt "$INPUT" \
  -convert-scf-to-cf \
  -memref-expand \
  -convert-arith-to-llvm \
  -convert-index-to-llvm \
  -convert-math-to-llvm \
  -convert-cf-to-llvm \
  -convert-func-to-llvm \
  -finalize-memref-to-llvm \
  -reconcile-unrealized-casts \
  > "${PREFIX}.llvm_dialect.mlir"

mlir-translate --mlir-to-llvmir \
  "${PREFIX}.llvm_dialect.mlir" \
  > "${PREFIX}.ll"
