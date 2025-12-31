# MLIR → LLVM Alias Metadata Thesis

This repository contains the experimental harness, kernels, scripts, and notes
for my M.S. thesis on propagating alias and memory metadata from MLIR to LLVM IR
to improve LLVM middle-end optimizations for GPU-oriented code.

## What this repo contains
- `kernels/`   : Test kernels (C, MLIR, GPU)
- `pipelines/`: MLIR pass pipelines used in experiments
- `scripts/`  : Reproducible scripts for lowering and analysis
- `outputs/`  : Generated IR and optimization remarks
- `notes/`    : Lab notebook and experiment logs

## What this repo does NOT contain
- The LLVM/MLIR source tree (`llvm-project`)
- Any compiled binaries or generated IR

LLVM/MLIR version info is recorded in `llvm-version.txt`.

## Repository Structure
This repository contains the experimental harness and documentation for the thesis.
It does not contain the LLVM/MLIR source tree.
```
mlir-alias-thesis/
├── kernels/          # Input kernels (MLIR, C, GPU)
├── scripts/          # Reproducible pipelines and analysis scripts
├── pipelines/        # Documented MLIR lowering pipelines
├── outputs/          # Generated IR and remarks
├── cases/            # Tracked writeups of diagnostic evidence
├── notes/            # Lab notes / scratch
├── llvm-version.txt  # LLVM commit + version used
└── README.md
```

## Build Prerequisites
You must have a local build of LLVM + MLIR.

This repo assumes the following tools are available on your PATH:
- mlir-opt
- mlir-translate
- opt
- llc

The exact LLVM version and commit used are recorded in llvm-version.txt.

## Workflow: Running Experiments
Each experiment follows the same three-stage flow:
1. Lower MLIR → LLVM dialect → LLVM IR
2. Run LLVM optimizations
3. Inspect optimized IR and/or optimization remarks

All steps are scripted for reproducibility.

### Step 1: Lower MLIR to LLVM IR (CPU Pipeline)
From the repo root:
```
scripts/run_pipeline_cpu.sh \
  kernels/mlir/<kernel>.mlir \
  outputs/<name>/<name>
```

This produces:
- outputs/<name>/<name>.llvm_dialect.mlir
- outputs/<name>/<name>.ll

Example:
```
scripts/run_pipeline_cpu.sh \
  kernels/mlir/hoist_candidate.mlir \
  outputs/hoist/hoist
```

### Step 2: Run LLVM optimizations and emit optimized IR
To run the default -O2 pipeline and emit optimized LLVM IR:
```
scripts/run_opt_emit_ll.sh \
  outputs/<name>/<name>.ll \
  outputs/<name>/<name>.O2.ll \
  outputs/<name>/remarks.O2.yml
```
Example:
```
scripts/run_opt_emit_ll.sh \
  outputs/hoist/hoist.ll \
  outputs/hoist/hoist.O2.ll \
  outputs/hoist/remarks.O2.yml
```

This produces:
- optimized LLVM IR (*.O2.ll)
- YAML optimization remarks (remarks.O2.yml)

## Optional: Manual Oracle Test (LLVM IR)

For diagnostic purposes, it is sometimes useful to manually add aliasing metadata to LLVM IR to confirm that missing metadata is the root cause of a missed optimization.

Workflow:
1. Copy the baseline IR:
```
cp outputs/<name>/<name>.ll outputs/<name>/<name>.noalias.ll
```

2. Edit the function signature to add noalias where appropriate.
3. Re-run optimization:
```
scripts/run_opt_emit_ll.sh \
  outputs/<name>/<name>.noalias.ll \
  outputs/<name>/<name>.noalias.O2.ll \
  outputs/<name>/remarks.noalias.O2.yml
```

Comparing <name>.O2.ll vs <name>.noalias.O2.ll isolates the effect of alias disambiguation.

## Adding a new kernel
1. Add the kernel under `kernels/mlir/`
2. Run the CPU pipeline:
```
scripts/run_pipeline_cpu.sh \
  kernels/mlir/my_kernel.mlir \
  outputs/my_kernel/my_kernel
```

3. Run LLVM optimization:
```
scripts/run_opt_emit_ll.sh \
  outputs/my_kernel/my_kernel.ll \
  outputs/my_kernel/my_kernel.O2.ll \
  outputs/my_kernel/remarks.O2.yml
```

4. If the kernel reveals an interesting optimization behavior, document it under: `cases/caseX_my_kernel.md`

