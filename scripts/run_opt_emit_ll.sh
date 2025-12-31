#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 3 ]; then
  echo "Usage: $0 <input.ll> <output.ll> <remarks.yml>"
  exit 1
fi

INPUT=$1
OUTPUT=$2
REMARKS=$3

opt "$INPUT" \
  -passes="default<O2>" \
  -S \
  -o "$OUTPUT" \
  -pass-remarks-output="$REMARKS" \
  -pass-remarks=licm,gvn,dse \
  -pass-remarks-analysis=licm,gvn,dse
