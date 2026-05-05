#!/usr/bin/env bash
# Run the alias-metadata passes then hand off to the existing run_pipeline_cpu.sh.
#
# Usage:  scripts/run_pipeline_cpu_with_meta.sh <input.mlir> <output_prefix>
#
# Produces the same output files as run_pipeline_cpu.sh:
#   <prefix>.llvm_dialect.mlir
#   <prefix>.ll
#   <prefix>.*.png
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input.mlir> <output_prefix>"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ALIAS_META_OPT="${ALIAS_META_OPT:-$SCRIPT_DIR/../pass/build/bin/alias-meta-opt}"

INPUT=$1
PREFIX=$2

mkdir -p "$(dirname "$PREFIX")"

# Step 1: alias-meta-opt passes
# For ClangIR-lowered benchmarks add --materialize-prefix-subviews as the first flag.
# Case-study kernels (hand-written SCF) do not need it.
"$ALIAS_META_OPT" \
  --mark-alias-groups \
  --lower-with-alias-meta \
  "$INPUT" \
  -o "${PREFIX}.meta.mlir"

# Step 2: standard lowering + translate + CFG (reuse existing script)
bash "$SCRIPT_DIR/run_pipeline_cpu.sh" "${PREFIX}.meta.mlir" "$PREFIX"
