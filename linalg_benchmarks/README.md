# Linalg Benchmark Suite

## Motivation

The primary thesis validation uses six hand-written SCF kernels (`kernels/mlir/*.mlir`).
These kernels write the `memref.subview` partition structure and the `scf.for` loops directly.

This directory shows that the same partition-by-endpoint structural pattern - and the same
alias-blocking problem - arises naturally from `linalg.generic` lowering. `linalg.generic`
is the central abstraction in ML compilers (IREE, TensorFlow MLIR, etc.): a compiler backend
that produces `linalg.generic` for bias-add, normalization, and element-wise kernels will
encounter the same alias-conservatism problem when lowering to LLVM IR, and the same pass
resolves it.

The two-step pipeline is:
1. `mlir-opt --convert-linalg-to-loops` - lowers linalg.generic -> scf.for + memref.load/store
2. Then the existing alias-meta-opt pass and standard lowering (unchanged)

The pass does not need to know anything about linalg. It only cares about the resulting
`memref.subview` + `memref.load`/`memref.store` structure, which is identical whether the
kernel was hand-written or linalg-derived.

---

## Repository Structure

```
linalg_benchmarks/
├── kernels/
│   ├── linalg_scale_split.mlir     # Bias-add via linalg.generic (Form A)
│   ├── linalg_norm_split.mlir      # Two-stage normalize via 2× linalg.generic (Form A)
│   └── linalg_stencil_split.mlir   # Element-wise stencil via linalg.generic (Form A)
├── scripts/
│   ├── run_linalg_baseline.sh      # Baseline pipeline (linalg-to-loops + standard lowering)
│   └── run_linalg_with_meta.sh     # Pass pipeline (linalg-to-loops + alias-meta-opt + standard)
├── outputs/<name>/                  # Baseline artifacts per kernel
│   ├── <name>.loops.mlir           # After linalg-to-loops
│   ├── <name>.llvm_dialect.mlir    # After full MLIR lowering
│   ├── <name>.ll                   # LLVM IR (baseline)
│   ├── <name>.O2.ll                # O2-optimized LLVM IR
│   └── remarks.baseline.O2.yml    # LLVM optimization remarks
└── pass_outputs/<name>/             # Pass artifacts per kernel
    ├── <name>.loops.mlir           # After linalg-to-loops
    ├── <name>.meta.mlir            # After alias-meta-opt (has alias.scope attrs)
    ├── <name>.ll                   # LLVM IR with alias metadata
    ├── <name>.O2.ll                # O2-optimized LLVM IR
    └── remarks.pass.O2.yml        # LLVM optimization remarks (misses drop to 0)
```

---

## Kernels

### `linalg_scale_split.mlir` - Bias-Add (Form A)

**Algorithm**: scale all elements of a partition by the first element of the adjacent partition.
Represents bias-add in a normalization layer: one scalar offset applied to an array.

**Structure**:
```mlir
%lo = memref.subview %buf[0][%n][1]      // lo = buf[0..n)  - scale factor at lo[0]
%hi = memref.subview %buf[%n][%hi_size][1] // hi = buf[n..2048)
linalg.generic { maps = [affine_map<(d0)->(0)>, affine_map<(d0)->(d0)>] }
  ins(%lo) outs(%hi) { hi[d0] += lo[0] }  // lo[0] is loop-invariant
```

**Form A**: hi.offset (`%n`) == lo.size (`%n`) - same SSA value.

After `--convert-linalg-to-loops`:
```
for d0 in [0, dim(hi,0)):
  alpha = load lo[0]    <- loop-invariant; LICM-blocked by alias conservatism
  x     = load hi[d0]
  store hi[d0], x + alpha
```

LLVM cannot hoist `load lo[0]` because both lo and hi derive from the same base pointer.
The vectorizer also emits `UnsafeDep`: the invariant load at offset 0 could overlap with
vectorized stores at offsets `[n, n+1, n+2, n+3]` if n < 3.

### `linalg_norm_split.mlir` - Two-Stage Normalize (Form A)

**Algorithm**: normalize an array in two passes: (1) bias-add using lo[0]; (2) scale using lo[1].
Represents a mean-subtract + scale-by-std normalization layer.

**Structure**:
```mlir
%lo = memref.subview %buf[0][%n][1]      // lo[0] = bias, lo[1] = scale
%hi = memref.subview %buf[%n][%hi_size][1]

// Stage 1: hi[d0] += lo[0]
linalg.generic { maps = [affine_map<(d0)->(0)>, affine_map<(d0)->(d0)>] }
  ins(%lo) outs(%hi) { hi[d0] += lo[0] }

// Stage 2: hi[d0] *= lo[1]
linalg.generic { maps = [affine_map<(d0)->(1)>, affine_map<(d0)->(d0)>] }
  ins(%lo) outs(%hi) { hi[d0] *= lo[1] }
```

After lowering: two separate loops. In each loop, a different element of lo is loop-invariant
and LICM/GVN-blocked. Both `lo[0]` and `lo[1]` loads are alias-clobbered by `store hi[i]`
from LLVM's perspective. The pass tags all uses of `%lo` in both loops, resolving both blocks.

### `linalg_stencil_split.mlir` - Element-Wise Stencil (Form A)

**Algorithm**: copy each element of the lo partition into the hi partition with arithmetic.
Represents an element-wise kernel between input/output partitions of a single buffer.

**Structure**:
```mlir
%lo = memref.subview %buf[0][%n][1]
%hi = memref.subview %buf[%n][%hi_size][1]
linalg.generic { maps = [affine_map<(d0)->(d0)>, affine_map<(d0)->(d0)>] }
  ins(%lo) outs(%hi) { hi[d0] = lo[d0] + hi[d0] + 1.0 }
```

After lowering: reads lo[i] and writes hi[i] at the same iteration index.
This is structurally different from the invariant-load case: lo[i] and hi[i] have GEP
offsets `i` vs `n+i`, a constant distance of n. LLVM 22's loop vectorizer handles this
pattern via a different path (cost-model decision with runtime checks rather than static
`UnsafeDep`). The pass still resolves one GVN miss.

---

## Pipeline

### Baseline
```bash
bash linalg_benchmarks/scripts/run_linalg_baseline.sh \
    linalg_benchmarks/kernels/<name>.mlir \
    linalg_benchmarks/outputs/<name>/<name>

bash scripts/run_opt_emit_ll.sh \
    linalg_benchmarks/outputs/<name>/<name>.ll \
    linalg_benchmarks/outputs/<name>/<name>.O2.ll \
    linalg_benchmarks/outputs/<name>/remarks.baseline.O2.yml
```

### With alias metadata pass
```bash
bash linalg_benchmarks/scripts/run_linalg_with_meta.sh \
    linalg_benchmarks/kernels/<name>.mlir \
    linalg_benchmarks/pass_outputs/<name>/<name>

bash scripts/run_opt_emit_ll.sh \
    linalg_benchmarks/pass_outputs/<name>/<name>.ll \
    linalg_benchmarks/pass_outputs/<name>/<name>.O2.ll \
    linalg_benchmarks/pass_outputs/<name>/remarks.pass.O2.yml
```

The two-step linalg pipeline differs from the existing `run_pipeline_cpu_with_meta.sh` only
in the added `--convert-linalg-to-loops` step at the front:

```
mlir-opt --convert-linalg-to-loops         # linalg -> scf + memref.load/store
alias-meta-opt --mark-alias-groups \       # detect partition-by-endpoint pairs
               --lower-with-alias-meta     # emit alias.scope / noalias on llvm.load/store
mlir-opt [standard CPU lowering passes]    # convert-scf-to-cf ... finalize-memref-to-llvm
mlir-translate --mlir-to-llvmir
opt -O2 ...
```

---

## Results

All three kernels were validated. Pass correctly attaches `!alias.scope`/`!noalias` metadata
to the lowered `llvm.load`/`llvm.store` ops (verified in `*.meta.mlir` intermediates).

### Alias-Related Optimization Miss Counts

| Kernel | Form | Baseline LICM | Baseline GVN | Vec. Blocked | Pass LICM | Pass GVN | Hoisted |
|---|---|---:|---:|---:|---:|---:|---:|
| `linalg_scale_split` | A | 4 | 2 | **Yes** (1×) | **0** | **0** | 1 |
| `linalg_norm_split` | A | 8 | 12 | **Yes** (2×) | **0** | 2† | 2 |
| `linalg_stencil_split` | A | 0 | 2 | No‡ | 0 | 1 | 2* |

- **LICM**: `LoadWithLoopInvariantAddressInvalidated` remarks from LLVM LICM pass
- **GVN**: `LoadClobbered` remarks from LLVM GVN pass
- **Vec. Blocked**: `UnsafeDep` remark from loop vectorizer
- **Hoisted**: `Hoisted` remarks confirming successful hoist in pass run

†`linalg_norm_split` pass: 2 `LoadClobbered` remain; these are genuine loop-carried GVN misses
on `hi[i]` (clobbered by the previous iteration's `hi[i-1]` store), not alias-caused.
The 10 alias-caused GVN misses (lo[0]/lo[1] clobbered by hi[i] store) are all resolved.

‡`linalg_stencil_split`: LLVM 22's vectorizer handles the element-wise same-index stencil
differently. The access pattern (lo[i] at offset `i`, hi[i] at offset `n+i`) has a constant
distance of `n`. The vectorizer does not emit static `UnsafeDep`; instead it considers runtime
memchecks and decides based on cost model (`VectorizationNotBeneficial`). The pass still
resolves 1 of 2 GVN misses. This shows that alias-caused blocking in LLVM 22 is sensitive
to the access pattern: invariant-load patterns (lo[0] in a loop over hi) trigger `UnsafeDep`;
same-index element-wise patterns (lo[i] vs hi[i] with constant offset) do not.

*`linalg_stencil_split` pass: `Hoisted` remarks are for GEP address expressions (base pointer
computations), not for load instructions. No load was hoisted because no load is loop-invariant
in the stencil kernel.

### Alias Misses Resolved

| Kernel | Alias-caused misses (baseline) | Alias-caused misses (pass) | Resolved |
|---|---:|---:|---:|
| `linalg_scale_split` | 6 + 1 UnsafeDep | 0 | **6 + vec. unblocked** |
| `linalg_norm_split` | 18 + 2 UnsafeDep | 0 | **18 + 2× vec. unblocked** |
| `linalg_stencil_split` | 1 | 0 | **1** |
| **Total** | **25 + 3 UnsafeDep** | **0** | **25** |

---

## Key Finding

The `linalg.generic` -> SCF lowering (`--convert-linalg-to-loops`) preserves the
partition-by-endpoint structural invariant: the two `memref.subview` ops remain in the
function with their SSA relationship intact after lowering. The pass detects and tags them
identically to hand-written kernels.

The critical indexing map pattern is `affine_map<(d0) -> (0)>` applied to a subview ins
argument: this becomes `memref.load %subview[%c0]` in the loop body after lowering - a
direct use of the subview result that `tagUsesOfValue` finds and tags correctly.

The `affine_map<(d0) -> (d0)>` pattern (element-wise, same index) does NOT produce
loop-invariant loads and therefore does not trigger LICM misses. The vectorization blocking
for this pattern in LLVM 22 is more nuanced (runtime checks vs static `UnsafeDep`).

---

## Relation to Main Case Studies

| Linalg kernel | Analogous handwritten kernel | Common pattern |
|---|---|---|
| `linalg_scale_split` | `dynamic_split` | 1D dynamic split, 1 invariant load (Form A) |
| `linalg_norm_split` | `double_invariant` (microbench) | 2 invariant loads from same lo partition |
| `linalg_stencil_split` | `vectorize_split` (partial) | Element-wise, alias-blocking GVN; vectorizer cost-model limited |

The linalg suite confirms that the structural pattern the pass targets emerges directly from
standard `linalg.generic` lowering, not only from hand-written SCF kernels.
