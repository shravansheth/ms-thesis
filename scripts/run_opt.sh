#!/usr/bin/env bash
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input.ll>"
  exit 1
fi

INPUT=$1

opt "$INPUT" \
  -passes="licm,gvn,dse" \
  -pass-remarks=licm,gvn,dse \
  -disable-output
