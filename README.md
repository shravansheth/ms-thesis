# MLIR -> LLVM Alias Metadata Thesis

Out-of-tree MLIR pass pipeline that detects structurally disjoint `memref.subview` pairs at the
MLIR-to-LLVM lowering boundary and emits `!alias.scope`/`!noalias` metadata into LLVM IR -
unlocking LICM, GVN, and vectorization that LLVM cannot perform without this information.

LLVM/MLIR version: see `llvm-version.txt` (LLVM 22.0.0git).

---

## Pass Pipeline

Three passes, run via `alias-meta-opt` before the standard `mlir-opt` lowering:

| Pass | Flag | Purpose |
|---|---|---|
| `MaterializePrefixSubviews` | `--materialize-prefix-subviews` | ClangIR only - synthesizes explicit prefix subview at call sites where the base memref is passed alongside a suffix subview |
| `MarkAliasGroups` | `--mark-alias-groups` | Detects partition-by-endpoint disjoint subview pairs; tags `memref.load`/`memref.store` with discardable attributes |
| `LowerWithAliasMeta` | `--lower-with-alias-meta` | Partial dialect conversion: converts tagged ops to `llvm.load`/`llvm.store` with `!alias.scope`/`!noalias` metadata |

The pre-pass is only needed for ClangIR-lowered benchmarks (`final_benchmark/`). The six
hand-written case-study kernels use only `--mark-alias-groups --lower-with-alias-meta`.

---

## Build

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
  -DMLIR_DIR=${LLVM_BUILD:-/Users/shravansheth/ShravsSSD/llvm-project/build}/lib/cmake/mlir \
  -DLLVM_DIR=${LLVM_BUILD:-/Users/shravansheth/ShravsSSD/llvm-project/build}/lib/cmake/llvm
make -j4
```

See `docs/pass-build-notes.md` for full build and API reference.

---

## Running the Pipeline

### Baseline (no alias metadata)

```bash
bash scripts/run_pipeline_cpu.sh kernels/mlir/<name>.mlir outputs/<name>/<name>
bash scripts/run_opt_emit_ll.sh \
    outputs/<name>/<name>.ll \
    outputs/<name>/<name>.O2.ll \
    outputs/<name>/remarks.O2.yml
```

### With alias metadata pass

```bash
# Case-study kernels (hand-written SCF):
bash scripts/run_pipeline_cpu_with_meta.sh kernels/mlir/<name>.mlir pass_outputs/<name>/<name>
bash scripts/run_opt_emit_ll.sh \
    pass_outputs/<name>/<name>.meta.ll \
    pass_outputs/<name>/<name>.meta.O2.ll \
    pass_outputs/<name>/remarks.meta.O2.yml

# ClangIR benchmarks (add --materialize-prefix-subviews inside the script):
# See scripts/run_pipeline_cpu_with_meta.sh for the flag.
```

### Correctness tests

```bash
bash scripts/run_correctness_tests.sh
```

All 6 case-study kernels pass - checksums match baseline on all observable kernels.

---

## Results

### Optimization Remarks

32 alias-related optimization misses (`LoadWithLoopInvariantAddressInvalidated`, `LoadClobbered`)
across all 6 case-study kernels drop to **0** with the pass. LICM hoist count improves from 13
to 16 across the suite. `vectorize_split` additionally resolves an `UnsafeDep` vectorization
safety block that cannot be overridden by `-force-vector-width`.

| Kernel | Baseline misses | Pass misses | Additional hoists |
|---|---|---|---|
| `dynamic_split` | 7 | 0 | - |
| `adjacent_tiles` | 4 | 0 | +1 |
| `matrix_row_split` | 5 | 0 | - |
| `subview_noalias` | 5 | 0 | +1 |
| `tiling_noinline` | 4 | 0 | +1 |
| `vectorize_split` | 7 | 0 | - (vectorization enabled) |
| **Total** | **32** | **0** | |

### Case-Study Wall-Clock Benchmarks

Eight hand-written SCF kernels cross-compiled for three Raspberry Pi platforms. Three qualitatively
distinct performance patterns identified:

| Kernel | RPi 3B (A53) | RPi 4B (A72) | RPi 5 (A76) | macOS |
|---|---|---|---|---|
| `dynamic_split` | 1.12× | 1.16× | 1.17× | ~1.0× |
| `adjacent_tiles` | 1.12× | 1.17× | 1.16× | ~1.0× |
| `subview_noalias` | 1.14× | 1.13× | 1.28× | ~1.0× |
| `tiling_noinline` | 1.12× | 1.16× | 0.88× (regr.) | ~1.0× |
| `split_accumulate` | 1.12× | 1.16× | 1.16× | ~1.0× |
| `double_invariant` | 1.08× | 1.28× | 1.00× | ~1.0× |
| `matrix_row_split` | 1.01× | 1.20× | 1.00× | ~1.0× |
| `vectorize_split` | 1.65× | 0.91× (excl.) | 1.25× | **3.76×** |

- **A53 (in-order):** One instruction removed from critical path - uniform 1.12× across all scalar hoist cases.
- **A72 (shallow OOO):** LSU disambiguation overhead eliminated - scales with relationship count (`double_invariant` 1.28×) and store count (`matrix_row_split` 1.20×).
- **A76 (deep OOO):** Partially absorbed - simple hoists persist (1.16-1.17×), complex cases absorbed, cross-function results microarchitecture-sensitive.

Full analysis: `thesis-reference/case-study-evaluation.md`.

### Final Benchmark Suite

Five benchmark-derived kernels (PolyBench/C, IMEX, IREE) run on four platforms. The PolyBench/C
candidates use the ClangIR C-source path; the IMEX and IREE candidates are MLIR-stage extracts.
Medians of 5 repeats each.

| Benchmark | Mac Mini M4 | RPi 3B | RPi 4B | RPi 5 |
|---|---|---|---|---|
| PolyBench ATAX | 1.46× | 1.25× | 1.47× | 1.51× |
| PolyBench BICG | 1.08× | 1.00× | **2.10×** | **2.13×** |
| IMEX Softmax | 1.02× | 1.00× | 1.11× | 1.12× |
| PolyBench MVT | 1.01× | 1.00× | 1.00× | 1.00× |
| IREE Bias Add | 1.01× | 1.03× | 1.05× | 0.95× |

ATAX is the lead result - positive on every target. BICG shows 2× on OOO ARM cores.
Full source diffs, MLIR snippets, and raw data: `final_benchmark/benchmark.md`.

---

## Repository Structure

```
ms-thesis/
├── pass/                          # Out-of-tree MLIR pass (main contribution)
│   ├── lib/                       # Pass sources: MarkAliasGroupsPass.cpp,
│   │                              #   MaterializePrefixSubviewsPass.cpp,
│   │                              #   LowerWithAliasMetaPass.cpp
│   ├── include/                   # Passes.h, Passes.td
│   ├── tools/                     # alias-meta-opt.cpp (standalone driver binary)
│   ├── plugin/                    # AliasMetaPlugin.cpp (not used - ODR issues on macOS)
│   └── build/                     # Build output (gitignored)
│       └── bin/alias-meta-opt     # Standalone pass binary
│
├── kernels/mlir/                  # MLIR kernel sources (case-study + exploratory)
├── outputs/                       # Baseline, oracle, and pass artifacts per case-study kernel
├── pass_outputs/                  # Pass pipeline outputs organized by kernel
├── cases/                         # 6 valid case-study documents
├── invalid_cases/                 # 5 invalidated case documents with rationale
│
├── case-study-kernels/            # MLIR sources for the 10 case-study benchmark kernels
├── case-study-kernel-outputs/     # Compiled LLVM IR (baseline/ and with_meta/ per kernel)
├── case-study-harnesses/          # C timing harnesses (bench_<name>.c, bench.h)
├── case-study-binaries/           # Cross-compiled RPi binaries (rpi3b/, rpi4b/, rpi5/)
│
├── final_benchmark/               # Final evaluation suite (ATAX, BICG, IMEX, MVT, IREE)
│   ├── benchmark.md               # Full results, source diffs, MLIR snippets
│   └── bench_outputs/             # Raw timing data and median summaries
│
├── scripts/                       # Pipeline and benchmark scripts
│   ├── run_pipeline_cpu.sh        # Baseline MLIR -> LLVM IR lowering
│   ├── run_pipeline_cpu_with_meta.sh  # Pass pipeline (alias-meta-opt -> mlir-opt)
│   ├── run_opt_emit_ll.sh         # O2 optimization + remarks collection
│   ├── run_correctness_tests.sh   # Checksum-based correctness verification
│   ├── cross_compile_rpi.sh       # Cross-compile for RPi (A53/A72/A76)
│   ├── run_rpi_benchmarks.sh      # Run benchmarks on connected RPi over SSH
│   ├── rpi_config.sh              # RPi SSH host configuration
│   └── diff_ir.sh                 # Diff baseline vs pass LLVM IR
│
├── docs/                          # Project documentation
│   ├── pass-build-notes.md        # Build instructions and API reference
│   ├── implementation-log.md      # Implementation decisions and validation
│   ├── project-brief.md           # Full technical context and pass design
│   ├── thesis-summary.md          # Concise project summary with results
│   └── final-benchmark-evaluation.md  # Final benchmark evaluation record
│
├── thesis-reference/              # Per-topic reference docs for thesis writing
│   ├── case-study-evaluation.md   # Case-study benchmarks + cross-platform performance analysis
│   ├── final-benchmark-evaluation.md  # Final benchmark results reference
│   ├── optimization-results.md    # LICM/GVN/vectorization remark analysis
│   ├── pass-design.md             # Pass architecture and design decisions
│   ├── pass1-implementation.md    # MarkAliasGroups implementation details
│   ├── pass2-implementation.md    # LowerWithAliasMeta implementation details
│   ├── llvm-alias-metadata.md     # LLVM alias scope metadata reference
│   ├── mlir-to-llvm-lowering.md   # Standard lowering pipeline reference
│   ├── case-studies.md            # Case-study summary reference
│   ├── invalidated-cases.md       # Invalidated cases and rationale
│   ├── thesis-argument.md         # Core thesis argument structure
│   └── infrastructure.md          # Infrastructure and artifact locations
│
├── benchmark_exploration/         # External-suite exploration and discarded candidates
├── linalg_benchmarks/             # Linalg-derived kernels (remark-level validation only)
├── cgeist-tests/                  # Polygeist/cgeist exploration
├── tests/                         # Correctness test harnesses
├── case_exploration_log.md        # Chronological case exploration log
├── mlir-opt-passes.txt            # mlir-opt available passes reference
├── llvm_passes.txt                # LLVM opt available passes reference
└── llvm-version.txt               # LLVM commit and version used
```

---

## Key Reference Documents

| Document | Purpose |
|---|---|
| `docs/pass-build-notes.md` | Build instructions, pass architecture, attribute contract |
| `docs/implementation-log.md` | Full record of implementation decisions and problems |
| `thesis-reference/case-study-evaluation.md` | Case-study benchmark results and cross-platform performance analysis |
| `final_benchmark/benchmark.md` | Final evaluation suite results, source diffs, and raw data |
