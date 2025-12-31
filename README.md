# MLIR → LLVM Alias Metadata Thesis

This repository contains the experimental harness, kernels, scripts, and notes
for my M.S. thesis on propagating alias and memory metadata from MLIR to LLVM IR
to improve LLVM middle-end optimizations for GPU-oriented code.

## What this repo contains
- `kernels/`   : Test kernels (C, MLIR, GPU)
- `pipelines/`: MLIR pass pipelines used in experiments
- `scripts/`  : Reproducible scripts for lowering and analysis
- `outputs/`  : Generated IR and optimization remarks (not tracked)
- `notes/`    : Lab notebook and experiment logs

## What this repo does NOT contain
- The LLVM/MLIR source tree (`llvm-project`)
- Any compiled binaries or generated IR

LLVM/MLIR version info is recorded in `llvm-version.txt`.
