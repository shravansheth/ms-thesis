#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 3 ]; then
  echo "Usage: $0 <input.ll> <output.ll> <remarks.yml>"
  exit 1
fi

INPUT=$1
OUTPUT=$2
REMARKS=$3

OUTDIR="$(dirname "$OUTPUT")"
BASENAME="$(basename "$OUTPUT" .ll)"

# ---- Run O2 pipeline ----
opt "$INPUT" \
  -passes="default<O2>" \
  -S \
  -o "$OUTPUT" \
  -pass-remarks-output="$REMARKS" \
  -pass-remarks=licm,gvn,dse,cse,sccp,loops  \
  -pass-remarks-analysis=licm,gvn,dse,cse,sccp,loops


# ---- CFG generation----
cd "$OUTDIR"

opt -passes=dot-cfg -disable-output "$(basename "$OUTPUT")"

for dotfile in *.dot .*.dot; do
  [ -f "$dotfile" ] || continue

  funcname="$(basename "$dotfile" .dot)"
  funcname="${funcname#.}"   # strip leading dot

  dot -Tpng "$dotfile" -o "${funcname}.O2.png"
done

echo "O2 CFG PNGs written"
