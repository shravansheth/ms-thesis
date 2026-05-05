# Case Exploration Log

A running record of every kernel / pattern explored, what optimization was expected to be missed,
whether it turned out to be a valid case, and why.

LLVM version: 22.0.0git (commit 9af00e62ecc33960ada5366bffc369a647699fe9)

---

##  Valid Cases

### Case: `subview_noalias` - INCLUDED
**Kernel**: `kernels/mlir/subview_noalias.mlir`
**Case file**: `cases/case1_noalias_func.md`
**Optimization missed**: LICM (invariant `p[0]` load not hoisted) + GVN
**Pattern**: Caller creates two disjoint subviews (`slice0 = A[0..511]`, `slice1 = A[512..1023]`)
and passes them to a `noinline` callee. Inside the callee, LLVM sees two arbitrary `ptr` arguments
with no proven relationship - it cannot see the caller's structural disjointness.
**Oracle**: Add `@llvm.assume(i1 true) ["separate_storage"(ptr p, ptr q)]` in the callee ->
LICM hoists the invariant load.
**Why valid**: The pass has concrete structural evidence at the call site (two `memref.subview`
ops on the same base with non-overlapping ranges). It can propagate `separate_storage` to the
callee's arguments for that specific call.

---

### Case: `dynamic_split` - INCLUDED
**Kernel**: `kernels/mlir/dynamic_split.mlir`
**Case file**: `cases/case_dynamic_split.md`
**Optimization missed**: LICM + GVN + **vectorization** (`UnsafeDep`)
**Pattern**: A buffer is split at a runtime index `%n` into `lo = A[0..n-1]` and
`hi = A[n..2047]`. These are structurally disjoint by MLIR construction (hi's offset SSA value
equals lo's size SSA value). LLVM sees two GEPs from the same base with a runtime offset and
cannot rule out aliasing without knowing `n >= 1`.
**Oracle**: Add `!alias.scope` / `!noalias` metadata on the `lo` loads and `hi` stores ->
LICM hoists the invariant load, vectorization is unblocked (only cost-model miss remains).
**Why valid**: The pass recognises the structural "partition by endpoint" pattern - `hi.offset`
is the same SSA value as `lo.size` - and can emit alias scope metadata without needing runtime
bound knowledge. Any access to `lo[0]` in well-defined code already implies `n >= 1`.

---

### Case: `tiling_noinline` - INCLUDED - Same class as subview noalias
**Kernel**: `kernels/mlir/tiling_noinline.mlir`
**Case file**: `cases/case_tiling_noinline.md`
**Optimization missed**: LICM + GVN in noinline callee `@tile_stencil`
**Pattern**: A flat buffer is partitioned into two adjacent tiles (partition-by-endpoint:
`dst.offset = src.offset + N`) via `arith.muli` + `arith.addi`. The computation is
factored into a `no_inline` callee `@tile_stencil`. Inside the callee, LLVM sees two
opaque `ptr` args - the caller's structural disjointness proof (SSA arithmetic chain) is
invisible after ABI lowering.
**Oracle**: `!alias.scope`/`!noalias` on src loads / dst store inside the callee. Pass must
(1) recognise partition-by-endpoint at the call site in the caller, (2) propagate the
structural proof as alias-scope metadata into the callee body.
**Structural distinction from `subview_noalias`**: `subview_noalias` has static MLIR
types encoding the offsets. Here, disjointness is established by a runtime arithmetic chain
(`dst_off = muli(tile, N) + N`) that the pass must track through SSA.
**Why valid**: Real-world tiling workloads routinely call kernel functions with adjacent
tile arguments. The pass has concrete inspectable evidence at the MLIR level; the only
barrier is propagating that evidence across the function boundary.

---

### Case: `adjacent_tiles`
**Kernel**: `kernels/mlir/adjacent_tiles.mlir`
**Case file**: `cases/case_adjacent_tiles.md`
**Optimization missed**: LICM (invariant `src[0]` load not hoisted) + GVN
**Pattern**: Tiling pattern - two adjacent tiles `src = A[tile*N..(tile+1)*N-1]` and
`dst = A[(tile+1)*N..(tile+2)*N-1]`. Partition-by-endpoint, but endpoint derived via
`arith.muli + arith.addi` (compound arithmetic chain) rather than direct SSA identity.
**Oracle**: `!alias.scope`/`!noalias` on src loads / dst store -> LICM hoists `src[0]`.
**Surprising finding**: LLVM does NOT use the inner-loop bound `j < N` to derive `N > 0`
at the preheader. LICM reasons before the loop is known to execute - it cannot use the
loop-entry condition to constrain the aliasing check.
**Why valid**: The pass can track the arithmetic chain `dst_off = src_off + N` and
`src.size = N` at the MLIR level, establishing partition-by-endpoint even through
`muli`/`addi`. The structural proof is available pre-lowering and must be encoded as
metadata for LLVM.

---

### Case: `matrix_row_split`
**Kernel**: `kernels/mlir/matrix_row_split.mlir`
**Case file**: `cases/case_matrix_row_split.md`
**Optimization missed**: LICM (invariant `top[0][0]` load not hoisted from nested loop)
**Pattern**: 2D matrix `memref<?x512xf32>` split at dynamic row `%m`. Top half covers
rows `[0, m)`, bottom half rows `[m, 2m)`. Nested loop reads `top[0][0]` (invariant) and
`top[i][j]` while writing `bot[i][j]`. Flat offsets: `top[i][j] = base + i*512 + j`,
`bot[i][j] = base + (m+i)*512 + j`. LLVM cannot prove `m*512 + i*512 + j != 0`.
**Oracle**: `!alias.scope`/`!noalias` on top loads / bot store -> LICM hoists, GVN
constant-propagates `top[0][0]` = `1.0` to the preheader. Optimized loop is clean.
**Why valid**: 2D analogue of the 1D partition-by-endpoint pattern. The `bot.row_offset
= top.row_size` relationship is structurally provable at MLIR subview level. After
lowering to flat GEPs with row-stride multiplication, LLVM cannot recover this structure.
Representative of real matrix-tiling workloads (BLAS, tensor ops). The `!alias.scope`
mechanism works identically for 2D as 1D.

---

##  Invalid / Invalidated Cases

### Case: `hoist_candidate`
**Kernel**: `kernels/mlir/hoist_candidate.mlir`
**Case file**: `invalid_cases/case_hoist_candidate.md`
**Optimization expected to miss**: LICM on `B[0]` load inside loop writing to `A[i]`
**Why invalidated**: LLVM 22.0.0 handles this - version mismatch with the original finding.
The optimization now passes without any alias metadata.

---

### Case: `subview_hoist_static` (memref_subview_static)
**Kernel**: `kernels/mlir/subview_hoist_static.mlir`
**Case file**: `invalid_cases/case_memref_subview_static.md`
**Optimization expected to miss**: LICM - invariant load from `slice0[0]` while storing to `slice1[i]`
**Why invalidated**: LLVM 22.0.0 can prove disjointness via constant GEP offset arithmetic.
`slice0` maps to `[0..511]` and `slice1` to `[512..1023]` - non-overlapping constant ranges.
No alias metadata needed; LLVM's BasicAA handles it. The original finding was from an older LLVM.

---

### Case: `distinct_args_hoist_base` / `distinct_args_hoist_distinct`
**Kernels**: `kernels/mlir/distinct_args_hoist_base.mlir`, `distinct_args_hoist_distinct.mlir`
**Case file**: `invalid_cases/case_distinct_args.md`
**Optimization missed**: LICM on `B[0]` load, blocked because `%A` and `%B` function args may alias
**Oracle**: `memref.distinct_objects` in MLIR -> `@llvm.assume ["separate_storage"(...)]` -> LICM passes
**Why invalidated as a standalone case**: There is no structural MLIR evidence that the two
function arguments are disjoint. The pass has no basis for emitting `separate_storage` unless
the caller provides subview-derived disjointness. Without caller evidence, these are just two
arbitrary `ptr` function parameters - the pass cannot safely annotate them.
**Note**: The `memref.distinct_objects` -> `separate_storage` lowering IS the right mechanism,
and works correctly. The issue is knowing WHEN to apply it - which requires caller-site evidence.

---

### Case: `subview_call_boundary`
**Kernel**: `kernels/mlir/subview_call_boundary.mlir`
**Case file**: `invalid_cases/case_subview_call_boundary.md`
**Optimization missed**: LICM in `@kernel` callee (typed offset `strided<[1], offset: 512>` lost at ABI boundary)
**Pattern**: The MLIR type system encodes `offset: 512` for `dst`, proving it starts 512 floats
after `src`. After lowering, this offset becomes an `i64` field in the struct ABI - the callee
receives two raw `ptr` args with no provable relationship.
**Why invalidated**: While the structural evidence IS present in the MLIR types at the call site,
this is essentially subsumed by the `subview_noalias` case - both involve passing disjoint
subview-derived pointers to a callee. The mechanism of information loss (ABI struct field vs
noinline boundary) is different, but the thesis argument and fix direction are the same.
Not a sufficiently distinct structural scenario to warrant a separate case.

---

### Case: `dse_blocked_alias`
**Kernel**: `kernels/mlir/dse_blocked_alias.mlir`
**Case file**: `invalid_cases/case_dse_blocked_alias.md`
**Optimization missed**: DSE (dead init store `A[i] = 0.0` not eliminated) + GVN
**Why invalidated**: The kernel takes two arbitrary function-argument memrefs with no structural
evidence of disjointness at any call site. The pass has no basis for knowing `%A` and `%B` don't
alias. The DSE miss is real but the root cause is identical to `distinct_args_hoist_base` - it
is not a new structural scenario. Would only become a valid case if restructured to have a caller
providing subview-derived disjointness (making it a DSE companion to `subview_noalias`).

---

## Patterns Explored but Not Productive

### `subview_hoist_derived`
**Kernel**: `kernels/mlir/subview_hoist_derived.mlir`
**Why not a case**: Remarks show `LoadWithLoopInvariantAddressInvalidated` but the O2 IR shows
the invariant load IS hoisted to the preheader via GVN-PRE. The `!Missed` remarks come from an
early LICM pass run; a later GVN-PRE run handles it. LLVM 22 effectively optimizes this.

### `memref_subview_stride` (even/odd stride)
**Kernel**: (kernel no longer in `kernels/mlir/`, output in `outputs/memref_subview_stride/`)
**Pattern**: Stride-2 subviews at offset 0 and offset 1 (even/odd elements)
**Why not a case**: LLVM 22 handles this via SCEV-based modular arithmetic - the GEP constant
offsets (e.g., 512 vs 513) differ by an odd number, which LLVM recognises as distinct.
Also, with static offsets, range analysis proves min-store-offset > load-offset.

### `redundant_load_gvn`
**Output**: `outputs/redundant_load_gvn/`
**Why not a case**: No GVN miss in remarks. LLVM 22 eliminates the redundant load.

### `static_subview` (dylan variant)
**Output**: `outputs/static_subview/`, `outputs/static_subview_dylan/`
**Why not a case**: Same as `subview_hoist_static` - LLVM 22 handles static disjoint offsets.

### `subview_static_2`
**Kernel**: `kernels/mlir/subview_static_2.mlir`
**Why not explored further**: Variant of static subview (invariant load from `slice0[1]` instead
of `slice0[0]`). Same LLVM 22 handling expected - static offsets are provable by GEP arithmetic.

### `axpy_memref`
**Kernel**: `kernels/mlir/axpy_memref.mlir`
**Why not a case**: Basic AXPY with A and B as separate function args. Not explored formally;
would show the same `distinct_args` pattern without subview evidence - same invalidation reason.
