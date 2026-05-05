# Thesis Summary
## MLIR -> LLVM Alias Metadata Propagation for Middle-End Optimization

### What This Thesis Is

MLIR's `memref.subview` operation encodes explicit structural disjointness between regions of
the same allocation. This partition-by-endpoint proof is visible in the SSA graph at the MLIR
level. During lowering to LLVM IR it is discarded: both subviews become GEP arithmetic from a
shared base pointer, and LLVM conservatively assumes they may alias. The result is blocked LICM,
GVN, and vectorization on kernels where those optimizations are provably safe.

The thesis implements an out-of-tree MLIR pass pipeline that detects the partition-by-endpoint
invariant before structural information is lost and re-encodes it as LLVM `!alias.scope`/`!noalias`
metadata on the lowered `llvm.load`/`llvm.store` operations. No new alias analysis is introduced.
The pass carries an existing structural proof across the lowering boundary in a form LLVM already
understands. The core MLIR path uses marker and lowering passes; the ClangIR benchmark path adds a
small prefix-subview materialization pre-pass.

The work targets CPU code generation. The MLIR-to-LLVM CPU lowering pipeline is the scope;
GPU lowering is out of scope.

---

### What Was Built

**Pass 1: `MarkAliasGroups`** (`pass/lib/MarkAliasGroupsPass.cpp`)

Walks every `func.func` in the module. Groups `memref.subview` ops by their base SSA value and
checks each unordered pair for partition-by-endpoint disjointness in three forms:

- **Form A**: hi.offset is the same SSA value as lo.size (lo.offset == 0)
- **Form B**: hi.offset = arith.addi(lo.offset, lo.size)
- **Form C**: all compile-time constants satisfying hi\_off == lo\_off + lo\_size

Assigns group IDs (2N = lo, 2N+1 = hi per pair N) and walks def-use chains from each subview
result to tag `memref.load`/`memref.store` ops with discardable attributes `alias_meta.group_id`
(i32) and `alias_meta.role` ("lo"/"hi"). For noinline callees, clones the callee into
`@name.__alias_meta_N` and tags the clone's memory ops. The original callee is untouched.

**Pass 2: `LowerWithAliasMeta`** (`pass/lib/LowerWithAliasMetaPass.cpp`)

Partial dialect conversion using `applyPartialConversion` with `LLVMTypeConverter`. Converts only
the tagged `memref.load`/`memref.store` ops to `llvm.load`/`llvm.store`. Builds one
`AliasScopeDomainAttr` and one `AliasScopeAttr` per disjoint pair. Lo-region ops receive
`alias_scopes = [lo_scope]`; hi-region ops receive `noalias_scopes = [lo_scope]`. All untagged
ops are left for the standard `finalize-memref-to-llvm` pass.

Pass 2 must run before `finalize-memref-to-llvm`: discardable attributes do not survive the
standard conversion framework. Verified empirically.

**Standalone binary**: `pass/build/bin/alias-meta-opt`. The plugin approach
(`AliasMetaPropagationPlugin.dylib`) was abandoned due to macOS ODR violations with static
MLIR builds. The two-step pipeline (`alias-meta-opt` -> `mlir-opt`) is the supported workflow.

---

### Validation Results

Six case-study kernels. 32 baseline alias-related optimization misses. All resolved to 0 by the
pass. All 6 kernels pass correctness tests (numeric checksums match baseline).

| Kernel | Pattern | Baseline Misses | Pass Misses | Notes |
|---|---|---|---|---|
| `dynamic_split` | 1D runtime partition (Form A) | 7 | **0** | LICM hoist + SCCP fold |
| `adjacent_tiles` | Tile boundary via addi chain (Form B) | 4 | **0** | +1 explicit hoist |
| `matrix_row_split` | 2D row split (Form A, dim 0) | 5 | **0** | LICM hoist + SCCP fold |
| `subview_noalias` | Noinline callee, static offsets (Form C) | 5 | **0** | +1 explicit hoist |
| `tiling_noinline` | Noinline callee, runtime addi chain (Form B) | 4 | **0** | +1 explicit hoist |
| `vectorize_split` | 1D runtime partition enabling SIMD (Form A) | 7 | **0** | LICM+SCCP cascade -> vectorized |
| **Total** | | **32** | **0** | |

All 5 original case-study kernels achieve a 50% reduction in hot-loop memory reads (2 -> 1
loads/iter). `vectorize_split` additionally unlocks SIMD vectorization.

---

### Benchmark Results

Wall-clock benchmarks on four platforms. RPi binaries cross-compiled on Apple Silicon via
`zig cc --target=aarch64-linux-musl -static` with `llc -mcpu=<cortex-a53|a72|a76>`.

**macOS (Apple M-series)**

Scalar hoist cases show ~1.0× - Apple Silicon's deep OOO window fully masks the disambiguation
overhead. The vectorization case is the primary macOS result:

| Kernel | Baseline (ns) | Pass (ns) | Speedup |
|---|---:|---:|---|
| `vectorize_split` | 1,440,486 | 383,304 | **3.76×** |

**RPi 3B (Cortex-A53, in-order, ~1.2 GHz)**

Benefit is instructional: one `ldr` removed from the critical path per iteration. Cycle math
10->9 cycles ≈ 1.11× predicted; 1.12× measured. Confirmed by disassembly.

| Kernel | Baseline (ns) | Pass (ns) | Speedup |
|---|---:|---:|---|
| `dynamic_split` | 7,747 | 6,890 | **1.12×** |
| `adjacent_tiles` | 3,885 | 3,458 | **1.12×** |
| `subview_noalias` | 3,594 | 3,165 | **1.14×** |
| `tiling_noinline` | 3,893 | 3,464 | **1.12×** |
| `split_accumulate` | 7,746 | 6,887 | **1.12×** |
| `double_invariant` | 11,183 | 10,326 | **1.08×** |
| `matrix_row_split` | 226,164 | 225,033 | 1.01× (noise) |
| `vectorize_split` | 7,356,595 | 4,448,108 | **1.65×** |

**RPi 4B (Cortex-A72, OOO, 1.5 GHz, perf governor)**

Benefit is LSU disambiguation overhead elimination. The A72 must track potentially-aliasing stores
against outstanding loads across all loop iterations; LICM hoisting removes the load from LSU
tracking entirely. Non-linear: two uncertain relationships (double\_invariant) give 1.28× vs 1.16×
for single-load cases. `matrix_row_split` 1.20× because 32,768 inner stores each check the
outer-loop load.

| Kernel | Baseline (ns) | Pass (ns) | Speedup |
|---|---:|---:|---|
| `dynamic_split` | 1,612 | 1,384 | **1.16×** |
| `adjacent_tiles` | 817 | 701 | **1.17×** |
| `subview_noalias` | 937 | 827 | **1.13×** |
| `tiling_noinline` | 818 | 704 | **1.16×** |
| `split_accumulate` | 1,612 | 1,384 | **1.16×** |
| `double_invariant` | 2,067 | 1,613 | **1.28×** |
| `matrix_row_split` | 66,893 | 55,649 | **1.20×** |
| `vectorize_split` | 3,619,207 | 3,962,715 | 0.91× (DRAM-bound, excluded) |

**RPi 5 (Cortex-A76, ~1.5 GHz - thermal cap, not rated 2.4 GHz)**

Mixed results. Simple single-load hoists persist (1.16-1.17×). More complex disambiguation
relationships are absorbed by the wider OOO engine. One genuine regression (`tiling_noinline` 0.88×,
reproducible, cause not established).

| Kernel | Baseline (ns) | Pass (ns) | Speedup |
|---|---:|---:|---|
| `dynamic_split` | 758 | 651 | **1.17×** |
| `adjacent_tiles` | 383 | 331 | **1.16×** |
| `subview_noalias` | 467 | 364 | **1.28×** |
| `tiling_noinline` | 386 | 438 | **0.88×**  |
| `split_accumulate` | 759 | 651 | **1.16×** |
| `double_invariant` | 867 | 865 | 1.00× |
| `matrix_row_split` | 27,865 | 27,885 | 1.00× (noise) |
| `vectorize_split` | 624,074 | 501,103 | **1.25×** |

Full cross-platform analysis and the cross-platform performance framework are in
`thesis-reference/case-study-evaluation.md`.

**Final benchmark-derived suite**

The final evaluation adds five benchmark-derived candidates under `final_benchmark/`. Baseline and
pass variants both use the same semantics-preserving packed benchmark; the pass variant only inserts
alias metadata before the same lowering and LLVM `-O2` pipeline.

| Benchmark | Mac Mini M4 | RPi3B | RPi4B | RPi5 |
|---|---:|---:|---:|---:|
| PolyBench ATAX | 1.463× | 1.252× | 1.470× | 1.509× |
| PolyBench BICG | 1.081× | 1.000× | 2.095× | 2.131× |
| IMEX Softmax | 1.022× | 1.000× | 1.106× | 1.123× |
| PolyBench MVT | 1.006× | 1.000× | 1.000× | 1.000× |
| IREE Bias Add | 1.011× | 1.026× | 1.054× | 0.948× |

ATAX is the lead final benchmark because it is positive on every target and has a compact
PolyBench/C source diff. BICG is the strongest out-of-order ARM result. IMEX is a smaller
MLIR-suite-derived positive result. MVT and IREE define important neutral/mixed limits.

---

### Current Status

Implementation complete. Thesis writing in progress.

---

### Key Files

| File | Purpose |
|---|---|
| `pass/lib/MarkAliasGroupsPass.cpp` | Pass 1 source |
| `pass/lib/MaterializePrefixSubviewsPass.cpp` | ClangIR prefix-subview pre-pass |
| `pass/lib/LowerWithAliasMetaPass.cpp` | Pass 2 source |
| `pass/build/bin/alias-meta-opt` | Standalone pass binary |
| `scripts/run_pipeline_cpu.sh` | Baseline lowering pipeline |
| `scripts/run_pipeline_cpu_with_meta.sh` | Pass pipeline (alias-meta-opt -> mlir-opt) |
| `scripts/run_correctness_tests.sh` | Correctness verification (6/6 pass) |
| `docs/project-brief.md` | Full technical context and pass design spec |
| `docs/implementation-log.md` | Implementation decisions, problems, validation |
| `docs/pass-build-notes.md` | Build instructions and API reference |
| `thesis-reference/` | Per-topic reference docs for thesis writing |
| `cases/case_*.md` | Six valid case-study documents |
| `invalid_cases/` | Five invalidated cases with rationale |
| `thesis-reference/case-study-evaluation.md` | Case-study kernel benchmarks and cross-platform performance framework |
| `final_benchmark/README.md` | Final benchmark suite, source diffs, and median results |
| `docs/final-benchmark-evaluation.md` | Final benchmark evaluation record |
| `thesis-reference/final-benchmark-evaluation.md` | Thesis-writing reference for final benchmark results |
