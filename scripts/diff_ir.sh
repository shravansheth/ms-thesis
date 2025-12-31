#!/usr/bin/env bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <before.ll> <after.ll>"
  exit 1
fi

diff -u "$1" "$2" | less
