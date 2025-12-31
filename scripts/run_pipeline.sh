#!/usr/bin/env bash
set -e

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input.mlir> <output_prefix>"
  exit 1
fi

INPUT=$1
PREFIX=$2

mlir-opt "$INPUT" \
  -gpu-kernel-outlining \
  -gpu-lower-to-nvvm-pipeline \
  -convert-memref-to-llvm \
  -convert-func-to-llvm \
  -convert-scf-to-cf \
  -reconcile-unrealized-casts \
  > "${PREFIX}.llvm_dialect.mlir"

mlir-translate --mlir-to-llvmir \
  "${PREFIX}.llvm_dialect.mlir" \
  > "${PREFIX}.ll"
