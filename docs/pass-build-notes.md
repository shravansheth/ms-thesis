# Pass Build Notes

## Project Structure

The pass lives in `pass/` at the repo root. It is an **out-of-tree MLIR pass project**
- it does not touch the LLVM/MLIR source tree and does not require rebuilding mlir-opt.

```
pass/
├── CMakeLists.txt                          # Root cmake, finds MLIR from existing build
├── include/
│   └── AliasMetaPropagation/
│       ├── Passes.h                        # Public header: attr name constants + pass decls
│       └── Passes.td                       # TableGen: defines MaterializePrefixSubviews,
│                                           #            MarkAliasGroups, LowerWithAliasMeta
├── lib/
│   ├── CMakeLists.txt                      # Links AliasMetaPropagation static library
│   ├── MaterializePrefixSubviewsPass.cpp   # Pre-pass (ClangIR call-site normalization)
│   ├── MarkAliasGroupsPass.cpp             # Pass 1 implementation
│   └── LowerWithAliasMetaPass.cpp          # Pass 2 implementation
├── plugin/
│   ├── CMakeLists.txt                      # Builds .dylib plugin for --load-pass-plugin
│   └── AliasMetaPlugin.cpp                 # Plugin entry point (mlirGetPassPluginInfo)
├── tools/
│   ├── CMakeLists.txt
│   └── alias-meta-opt.cpp                  # Standalone alias-meta-opt binary (all 3 passes)
└── build/                                  # CMake build directory (gitignored)
    ├── bin/alias-meta-opt                  # Standalone binary
    └── lib/AliasMetaPropagationPlugin.dylib  # Plugin for mlir-opt
```

## LLVM / MLIR Paths

| Item | Path |
|---|---|
| LLVM build | `/Users/shravansheth/ShravsSSD/llvm-project/build` |
| mlir-opt binary | `/Users/shravansheth/ShravsSSD/llvm-project/build/bin/mlir-opt` |
| LLVM version | 22.0.0git |
| Plugin | `pass/build/lib/AliasMetaPropagationPlugin.dylib` |

## How to Build

CMake is already configured. From the repo root:

```bash
cd pass/build
make -j4
```

To reconfigure from scratch (only needed if CMakeLists.txt changes significantly):

```bash
cd pass/build
cmake .. \
  -DMLIR_DIR=/Users/shravansheth/ShravsSSD/llvm-project/build/lib/cmake/mlir \
  -DLLVM_DIR=/Users/shravansheth/ShravsSSD/llvm-project/build/lib/cmake/llvm
make -j4
```

**Do NOT run `ninja` in the LLVM build directory.** That rebuilds all of mlir-opt from
source (thousands of files) and is not needed. Our project builds in seconds.

## How to Run

**Via standalone binary** (recommended - no ODR issues):

```bash
# Case-study kernels (pre-pass not needed):
pass/build/bin/alias-meta-opt \
  --mark-alias-groups \
  --lower-with-alias-meta \
  input.mlir -o output.mlir

# ClangIR benchmarks (pre-pass needed):
pass/build/bin/alias-meta-opt \
  --materialize-prefix-subviews \
  --mark-alias-groups \
  --lower-with-alias-meta \
  input.mlir -o output.mlir
```

Note: `alias-meta-opt` only has our three passes. Feed the output to `mlir-opt` for
the remaining standard lowering passes. Use `scripts/run_pipeline_cpu_with_meta.sh`
which handles the full two-step pipeline automatically.

**Via plugin** (do NOT use - crashes with ODR assertion failure on macOS):

The plugin (`AliasMetaPropagationPlugin.dylib`) loads into `mlir-opt` via
`--load-pass-plugin` but crashes at runtime because inline MLIR functions
(e.g., `Pass::getPassState()`) have separate copies in the plugin and host binary.
The `-flat_namespace -undefined suppress` linker option does not fully resolve this.
The plugin is built but should not be used for execution.

## Attribute Conventions (Pass 1 -> Pass 2 Interface)

Pass 1 (`MarkAliasGroups`) communicates with Pass 2 (`LowerWithAliasMeta`) via
**discardable attributes** attached to IR ops. These require no custom dialect.

| Attribute key | Attached to | Value | Meaning |
|---|---|---|---|
| `alias_meta.group_id` | `memref.load`, `memref.store` | `IntegerAttr` (i32) | Alias group number. Even = lo subview, odd = hi subview of the same pair. Pair N: lo=2N, hi=2N+1. |
| `alias_meta.role` | `memref.load`, `memref.store` | `StringAttr` ("lo" or "hi") | Whether this op reads/writes the lo or hi region. |

Pass 2 reads these attrs, emits the corresponding LLVM alias scope metadata, then
removes the attrs so they don't appear in final output.

## What Each Pass Does (Current Implementation Status)

### Pass 1: `MarkAliasGroups` - **COMPLETE**

Walks all `func.func` ops in the module. For each function:
1. Collects `memref.subview` ops grouped by base memref SSA value
2. For each pair, checks partition-by-endpoint in 3 forms:
   - Form A: hi.offset IS lo.size (same SSA value), lo.offset == 0
   - Form B: hi.offset = arith.addi(lo.offset, lo.size)
   - Form C: all compile-time constants satisfying hi_off == lo_off + lo_size
3. Assigns group IDs (2N = lo, 2N+1 = hi) and walks def-use of each subview result
4. Tags `memref.load`/`memref.store` with `alias_meta.group_id` + `alias_meta.role`
5. For noinline callees: clones the callee (once per call site), redirects the call, then recursively calls `tagUsesOfValue` on the clone's matching `BlockArgument` - applying all the same chain-following rules inside the clone body

### Pass 2: `LowerWithAliasMeta` - **COMPLETE**

Partial DialectConversion using `LLVMTypeConverter`. For each tagged `memref.load`/`memref.store`:
1. Creates one `AliasScopeDomainAttr` and one `AliasScopeAttr` (lo scope) per disjoint pair
2. Uses `ConvertOpToLLVMPattern` + `getStridedElementPtr` to compute the element address
3. Emits `llvm.load`/`llvm.store` with:
   - lo ops: `alias_scopes = [lo_scope]`
   - hi ops: `noalias_scopes = [lo_scope]`
4. Leaves untagged ops for the standard `finalize-memref-to-llvm` pass

**Important:** Pass 2 must run BEFORE `finalize-memref-to-llvm`. Discardable attrs do not
survive the standard conversion. See `docs/implementation-log.md` for full rationale.

## How to Run the Full Pipeline

Use the pipeline script (mirrors `run_pipeline_cpu.sh`):

```bash
# Step 1: Our passes + standard lowering -> .ll
bash scripts/run_pipeline_cpu_with_meta.sh kernels/mlir/<name>.mlir outputs/<name>/<name>.meta

# Step 2: O2 optimization + remarks
bash scripts/run_opt_emit_ll.sh \
  outputs/<name>/<name>.meta.ll \
  outputs/<name>/<name>.meta.O2.ll \
  outputs/<name>/remarks.meta.O2.yml
```

## Validation Results

All 6 kernels validated. Alias-related misses (`LoadWithLoopInvariantAddressInvalidated`,
`LoadClobbered`) drop from **32 total across all 6 kernels to 0** with our metadata.

| Kernel | Baseline hoisted | Pass hoisted | Baseline misses | Pass misses |
|---|---|---|---|---|
| `dynamic_split` | 1 | 1 | 7 | **0** |
| `adjacent_tiles` | 2 | **3** | 4 | **0** |
| `matrix_row_split` | 5 | 5 | 5 | **0** |
| `subview_noalias` | 2 | **3** | 5 | **0** |
| `tiling_noinline` | 2 | **3** | 4 | **0** |
| `vectorize_split` | 1 | 1† | 7 | **0** |
| **Total** | **13** | **16** | **32** | **0** |

†The lo[0] data load hoist is immediately folded by SCCP; hoist count stays flat.
`vectorize_split` additionally resolves the `UnsafeDep` vectorization block - 3.76× on
Apple M-series when compiled with `-force-vector-width=4`.

See `docs/implementation-log.md` for full details on decisions, problems, and API notes.
