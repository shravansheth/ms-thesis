# MLIR → LLVM Alias Metadata Thesis

This repository contains the experimental infrastructure, kernels, scripts, and documentation
for a master's thesis on propagating alias metadata from MLIR to LLVM IR to improve middle-end
optimizations on CPU targets.

The core contribution is a two-pass out-of-tree MLIR system (`pass/`) that detects structurally
disjoint `memref.subview` pairs before the MLIR-to-LLVM lowering boundary and emits LLVM
`!alias.scope`/`!noalias` metadata, enabling LICM, GVN, and vectorization that LLVM cannot
perform without this information.

LLVM/MLIR version: see `llvm-version.txt`.

---

## Repository Structure

```
ms-thesis/
├── pass/                          # Out-of-tree MLIR pass (main contribution)
│   ├── lib/                       # MarkAliasGroupsPass.cpp, LowerWithAliasMetaPass.cpp
│   ├── include/                   # Passes.h, Passes.td
│   ├── tools/                     # alias-meta-opt.cpp (standalone driver binary)
│   ├── plugin/                    # AliasMetaPlugin.cpp (not used — ODR issues on macOS)
│   └── build/                     # Build output (gitignored)
│       └── bin/alias-meta-opt     # Standalone pass binary
├── kernels/mlir/                  # MLIR kernel sources (case-study + exploratory)
├── outputs/                       # Baseline, oracle, and pass artifacts per case-study kernel
├── pass_outputs/                  # Pass pipeline outputs organized by kernel
├── microbenchmark/                # Microbenchmark MLIR kernels (10 kernels)
├── microbench_outputs/            # Microbenchmark IR (baseline/ and with_meta/ per kernel)
├── benchmarks/                    # C timing harnesses (bench_<name>.c, bench.h)
├── bench_outputs/                 # Compiled benchmark binaries per platform (rpi3b/, rpi4b/, rpi5/)
├── linalg_benchmarks/             # Linalg benchmark kernels, scripts, and outputs
├── tests/                         # Correctness test harnesses
├── cases/                         # 6 valid case-study documents
├── invalid_cases/                 # 5 invalidated case documents with rationale
├── prev_cases/                    # Earlier case drafts (superseded)
├── docs/                          # Project documentation
│   ├── thesis-summary.md          # Concise project summary with results
│   ├── project-brief.md           # Full technical context and pass design
│   ├── implementation-log.md      # Implementation decisions and validation
│   ├── pass-build-notes.md        # Build instructions and API reference
│   ├── benchmark-rpi3b.md         # RPi 3B (Cortex-A53) benchmark analysis
│   ├── benchmark-rpi4b.md         # RPi 4B (Cortex-A72) benchmark analysis
│   ├── benchmark-rpi5.md          # RPi 5 (Cortex-A76) benchmark analysis
│   └── benchmark-cross-platform.md
├── thesis-reference/              # Per-topic reference docs for thesis writing
├── scripts/                       # Pipeline and benchmark scripts
├── pipelines/                     # Documented MLIR lowering pipelines
├── cgeist-tests/                  # Polygeist (cgeist) exploration
├── notes/                         # Lab notes and scratch
├── case_exploration_log.md        # Chronological case exploration log
├── workflow.md                    # Experiment workflow reference
├── thesis_stmt.txt                # Thesis statement
├── mlir-opt-passes.txt            # mlir-opt pass list reference
└── llvm-version.txt               # LLVM commit and version used
```

---

## Build Prerequisites

A local LLVM/MLIR build is required. The following tools must be on your PATH or referenced
by absolute path in the scripts:

- `mlir-opt`, `mlir-translate` — from the LLVM build
- `opt`, `llc` — from the LLVM build
- `alias-meta-opt` — the standalone pass binary (built below)

Paths are set in the scripts. See `docs/pass-build-notes.md` for full details.

---

## Building the Pass

CMake is already configured. From the repo root:

```bash
cd pass/build
make -j4
```

Binary: `pass/build/bin/alias-meta-opt`

To reconfigure from scratch (only needed if `CMakeLists.txt` changes):

```bash
cd pass/build
cmake .. \
  -DMLIR_DIR=/Users/shravansheth/ShravsSSD/llvm-project/build/lib/cmake/mlir \
  -DLLVM_DIR=/Users/shravansheth/ShravsSSD/llvm-project/build/lib/cmake/llvm
make -j4
```

---

## Running Experiments

### Baseline pipeline (no alias metadata)

```bash
bash scripts/run_pipeline_cpu.sh kernels/mlir/<name>.mlir outputs/<name>/<name>
bash scripts/run_opt_emit_ll.sh \
    outputs/<name>/<name>.ll \
    outputs/<name>/<name>.O2.ll \
    outputs/<name>/remarks.O2.yml
```

### With alias metadata pass

```bash
bash scripts/run_pipeline_cpu_with_meta.sh kernels/mlir/<name>.mlir outputs/<name>/<name>.meta
bash scripts/run_opt_emit_ll.sh \
    outputs/<name>/<name>.meta.ll \
    outputs/<name>/<name>.meta.O2.ll \
    outputs/<name>/remarks.meta.O2.yml
```

### Correctness tests

```bash
bash scripts/run_correctness_tests.sh
```

All 6 case-study kernels pass (checksums match baseline for all observable kernels).

---

## Results

32 baseline alias-related optimization misses across 6 kernels → 0 with the pass.

Key results: ~1.12× on in-order (A53), ~1.16–1.28× on OOO (A72), 3.76× vectorization
speedup on macOS. See `docs/thesis-summary.md` for the full summary and
`thesis-reference/benchmarks.md` for detailed per-platform analysis.
