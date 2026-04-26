# Infrastructure Reference

## Project Structure

The pass lives in `pass/` at the repo root. It is an out-of-tree MLIR pass project — it does not touch the LLVM/MLIR source tree and does not require rebuilding `mlir-opt`.

```
pass/
├── CMakeLists.txt                          # Root cmake; finds MLIR from existing build
├── include/
│   └── AliasMetaPropagation/
│       ├── Passes.h                        # Public header: attr name constants + pass decls
│       └── Passes.td                       # TableGen: defines MarkAliasGroups + LowerWithAliasMeta
├── lib/
│   ├── CMakeLists.txt
│   ├── MarkAliasGroupsPass.cpp             # Pass 1 implementation
│   └── LowerWithAliasMetaPass.cpp          # Pass 2 implementation
├── plugin/
│   ├── CMakeLists.txt
│   └── AliasMetaPlugin.cpp                 # Plugin entry point (mlirGetPassPluginInfo)
├── tools/
│   ├── CMakeLists.txt
│   └── alias-meta-opt.cpp                  # Standalone driver binary
└── build/                                  # CMake build directory (gitignored)
    ├── bin/alias-meta-opt
    └── lib/AliasMetaPropagationPlugin.dylib
```

## Tool Paths

| Tool | Path |
|---|---|
| LLVM build root | `/Users/shravansheth/ShravsSSD/llvm-project/build` |
| `mlir-opt` | `.../build/bin/mlir-opt` |
| `mlir-translate` | `.../build/bin/mlir-translate` |
| `opt` | `.../build/bin/opt` |
| `alias-meta-opt` | `pass/build/bin/alias-meta-opt` |
| LLVM version | 22.0.0git |

## Building the Pass

CMake is already configured. From the repo root:

```bash
cd pass/build
make -j4
```

To reconfigure from scratch:

```bash
cd pass/build
cmake .. \
  -DMLIR_DIR=/Users/shravansheth/ShravsSSD/llvm-project/build/lib/cmake/mlir \
  -DLLVM_DIR=/Users/shravansheth/ShravsSSD/llvm-project/build/lib/cmake/llvm
make -j4
```

**Do NOT run `ninja` in the LLVM build directory.** That rebuilds all of mlir-opt from source (thousands of files). Our project builds in seconds.

## Scripts

All scripts live in `scripts/`. Each takes positional args.

### `run_pipeline_cpu.sh <input.mlir> <output_prefix>`

The **baseline** pipeline. Runs `mlir-opt` with the standard dialect conversion sequence, then `mlir-translate`, then generates CFG PNGs. No alias metadata. Produces:
- `<prefix>.llvm_dialect.mlir` — MLIR in LLVM dialect after conversion
- `<prefix>.ll` — LLVM IR from `mlir-translate`
- `<funcname>.png` — CFG diagrams per function

`mlir-opt` pass sequence (order matters):
```
-convert-scf-to-cf
-memref-expand
-fold-memref-alias-ops
-expand-strided-metadata
-lower-affine
-convert-arith-to-llvm
-convert-index-to-llvm
-convert-math-to-llvm
-convert-cf-to-llvm
-convert-func-to-llvm
-finalize-memref-to-llvm
-reconcile-unrealized-casts
```

**Dialect support**: handles `memref`, `arith`, `scf`, `cf`, `func`, `index`, `math`. Will fail on `linalg`, `tensor`, `gpu` ops.

### `run_opt_emit_ll.sh <input.ll> <output.ll> <remarks.yml>`

Runs `opt -passes="default<O2>"` with optimization remarks enabled for:
`licm, gvn, dse, cse, sccp, loops`

Produces:
- `<output.ll>` — O2-optimized LLVM IR
- `<remarks.yml>` — machine-readable remarks (YAML)
- `<funcname>.O2.png` — CFG diagrams after O2

### `run_pipeline_cpu_with_meta.sh <input.mlir> <output_prefix>`

The **pass** pipeline. Inserts our two passes before the standard lowering. Produces all the same files as the baseline pipeline, plus an intermediate `<prefix>.meta.mlir`.

Step 1: `alias-meta-opt --mark-alias-groups --lower-with-alias-meta input.mlir -o <prefix>.meta.mlir`
Step 2: `run_pipeline_cpu.sh <prefix>.meta.mlir <prefix>` (reused unchanged)

### `diff_ir.sh`

Helper for diffing baseline vs. pass LLVM IR output.

## Full Workflow

```bash
# 1. Baseline
bash scripts/run_pipeline_cpu.sh kernels/mlir/<name>.mlir outputs/<name>/<name>
bash scripts/run_opt_emit_ll.sh \
    outputs/<name>/<name>.ll \
    outputs/<name>/<name>.O2.ll \
    outputs/<name>/remarks.O2.yml

# 2. With pass
bash scripts/run_pipeline_cpu_with_meta.sh kernels/mlir/<name>.mlir outputs/<name>/<name>.meta
bash scripts/run_opt_emit_ll.sh \
    outputs/<name>/<name>.meta.ll \
    outputs/<name>/<name>.meta.O2.ll \
    outputs/<name>/remarks.meta.O2.yml
```

## Output Directories

`outputs/<kernel>/` — baseline, oracle, and pass artifacts for the five case-study kernels
`microbench_outputs/<kernel>/baseline/` — baseline artifacts for microbenchmark kernels
`microbench_outputs/<kernel>/with_meta/` — pass artifacts for microbenchmark kernels

## Plugin: Do Not Use

`AliasMetaPropagationPlugin.dylib` is an alternative entry point that would allow loading our passes directly into the standard `mlir-opt` via `--load-pass-plugin`, avoiding the need for a custom binary. It crashes on macOS with an ODR assertion:
```
Assertion failed: (passState && "pass state was never initialized")
```

**Root cause:** This is a macOS ODR (One Definition Rule) violation. MLIR headers define certain functions as `inline` — for example `Pass::getPassState()`. When the plugin `.dylib` is compiled, those inline functions get baked into the plugin. The host `mlir-opt` binary has its own copies too. When the plugin is loaded at runtime, two definitions of the same function exist in memory. The macOS dynamic linker uses a two-level namespace by default and does not deduplicate them, so the plugin's copy — which was never initialized by the host — is called and the assertion fires.

The `-flat_namespace -undefined suppress` linker flags in `plugin/CMakeLists.txt` attempt to force global (one-level) symbol resolution, but inline functions that were inlined at compile time are not exported as symbols at all — they are baked into the calling code — so the linker flag cannot reach them.

**The real fix:** Rebuild MLIR/LLVM with shared library output:
```bash
cmake ... -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_LINK_LLVM_DYLIB=ON
```
When `mlir-opt` links against a single `libMLIR.dylib` instead of static `.a` archives, both the host and any loaded plugin share the same dylib at runtime. Inline functions exist in exactly one place and the ODR violation disappears. This is how official MLIR plugin support is designed to work.

**Why we are not doing this:** It requires a full rebuild of the LLVM/MLIR project from scratch. The existing build at `/Users/shravansheth/ShravsSSD/llvm-project/build` used the default static linking and cannot be changed without rebuilding.

**Why it does not matter:** The plugin's only benefit would be running our passes and all standard MLIR passes in a single `mlir-opt` invocation. Our two-step pipeline (`alias-meta-opt` → `mlir-opt`) achieves the same result with no practical limitation. The plugin is a dead artifact from project scaffolding.

## alias-meta-opt Dialect Coverage

The standalone binary loads only the dialects needed for our kernels:
`arith`, `func`, `memref`, `scf`, `math`, `index`, `cf`, `llvm`

It registers our two passes as plain boolean CLI flags (`--mark-alias-groups`, `--lower-with-alias-meta`), NOT via the MLIR pass pipeline mechanism. Both single- and double-dash work; the scripts use `--`. Do not use `-pass-pipeline=`.
