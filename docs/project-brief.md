# MS Thesis Project Brief
## MLIR-to-LLVM Alias Metadata Propagation for Middle-End Optimization

> **Purpose of this document**: A complete technical briefing for a collaborating agent.
> It covers the thesis motivation, the technical problem, all cases found so far,
> the concrete pass design, and plans for evaluation.
> After reading this, you should be able to pick up implementation work without needing
> additional context.

---

## 1. Thesis Overview

### Motivation

MLIR (Multi-Level Intermediate Representation) is a compiler infrastructure that sits
above LLVM IR and carries *significantly richer* memory and alias information than LLVM
can infer on its own. When MLIR programs are lowered to LLVM IR via the standard lowering
pipeline, much of this rich alias information is silently discarded - it simply has no
representation in the generated LLVM IR.

As a result, LLVM's middle-end optimization passes (LICM, GVN, DSE, vectorization) make
*conservative alias assumptions* and miss optimizations that would be provably safe if
the MLIR-level knowledge were preserved.

### Core Hypothesis

> **MLIR's structural alias knowledge, when propagated as LLVM IR metadata, enables
> middle-end optimizations that LLVM 22 cannot otherwise perform - specifically LICM,
> GVN, DSE, and vectorization in loop-heavy, memory-bound kernels.**

### Thesis Contribution

1. **Case Study**: Identify and document a representative set of MLIR kernels where
   alias information is lost during lowering, causing provable optimization misses.
2. **Pass Implementation**: Build an MLIR compiler pass that detects these structural
   patterns before lowering and emits the appropriate LLVM IR alias metadata.
3. **Evaluation**: Measure the optimization impact (instructions eliminated, loop
   speedup, vectorization enabled) on real benchmarks.

---

## 2. Technical Background

### The MLIR -> LLVM Lowering Pipeline

The standard CPU lowering pipeline used in this project:

```
mlir-opt \
  -convert-scf-to-cf \
  -memref-expand \
  -fold-memref-alias-ops \
  -expand-strided-metadata \
  -lower-affine \
  -convert-arith-to-llvm \
  -convert-index-to-llvm \
  -convert-math-to-llvm \
  -convert-cf-to-llvm \
  -convert-func-to-llvm \
  -finalize-memref-to-llvm \
  -reconcile-unrealized-casts
```

This pipeline handles `memref`, `arith`, `scf`, `cf`, `func`, `index`, `math` dialects.
It does **not** handle `linalg`, `tensor`, or `gpu` ops (those require additional passes
before this pipeline).

### The memref ABI

A `memref<NxT>` in MLIR becomes a flat struct in LLVM IR:

```llvm
{ ptr alloc_ptr, ptr aligned_ptr, i64 offset, i64 size, i64 stride }
```

For 2D `memref<?x512xf32>`:
```llvm
{ ptr, ptr, i64, [2 x i64], [2 x i64] }   ; sizes and strides are arrays
```

**Critical detail**: A `memref<512xf32, strided<[1], offset: 512>>` (which carries a
*type-level* static offset of 512) gets lowered so that the `512` goes into the
`i64 offset` struct field - **not** baked into the pointer value. This means LLVM sees
a plain pointer and a separate integer, with no alias metadata connecting them.

### What Is Lost During Lowering

| MLIR structural information | LLVM IR representation | What LLVM sees |
|---|---|---|
| Two subviews with disjoint dynamic offsets (`n` vs `n+k`) | Two GEPs from the same base with `i64` offset args | Unknown aliasing - `k` might be 0 |
| `memref.subview` partition-by-endpoint (`hi.offset = lo.offset + lo.size`) | `add i64 offset, size` arithmetic in the offset fields | Arithmetic relationship - but LLVM doesn't connect this to GEP aliasing |
| Two subviews passed to a noinline callee | Two raw `ptr` args to a function | Completely opaque - no alias info |
| Static type-level offset (`strided<[1], offset: 512>`) | `i64` struct field `512` | Visible, but only as a separate integer |

### Key LLVM Concepts

**LICM (Loop-Invariant Code Motion)**: Hoists a loop-invariant load above the loop
preheader. Blocked if LLVM cannot prove the load's address is not modified by any store
in the loop. Uses `MemorySSA` + alias analysis (`BasicAA`, `TypeBasedAA`, `ScopedAA`).

**GVN (Global Value Numbering)**: Eliminates redundant loads by replacing them with
a previously computed value. Blocked by the same aliasing uncertainty.

**DSE (Dead Store Elimination)**: Removes a store whose written value is never
subsequently read. Blocked if a later load might read the same address.

**`!alias.scope` / `!noalias` metadata**: LLVM instruction-level metadata that explicitly
scopes loads and stores into named alias domains. A load tagged `!alias.scope !{S}` and
a store tagged `!noalias !{S}` are guaranteed by the compiler to not alias - LLVM uses
this to enable LICM/GVN/DSE.

**`llvm.assume ["separate_storage"(ptr A, ptr B)]`**: An operand bundle on an
`@llvm.assume` call asserting that pointers A and B come from entirely separate heap
allocations (different malloc/alloca calls). Produced by `memref.distinct_objects`.

**Important**: `separate_storage` is for *separate allocations*. For two disjoint
*regions within the same allocation* (subviews), the correct mechanism is
`!alias.scope`/`!noalias` metadata on the individual loads and stores.

### LLVM 22 Alias Analysis Capabilities

LLVM 22.0.0git (the version used in this project) has improved alias analysis compared
to older releases. Understanding what it can and cannot prove is critical for identifying
valid cases.

**What LLVM 22 CAN prove** (these cases are *not* useful for our thesis):
- Two GEPs from the same base with **constant, non-overlapping** offset ranges
  (e.g., `base+0..511` vs `base+512..1023` - proven by GEP arithmetic)
- Stride-2 even/odd element separation when GEP offsets are constant
  (SCEV modular arithmetic handles this)
- SSA-derived constants (e.g., `arith.addi %c128, %c128 -> 256`)

**What LLVM 22 CANNOT prove** (these are our thesis targets):
- Two GEPs `base+0` and `base+n` where `n` is a **runtime-unknown** value
  -> LLVM cannot rule out `n == 0`
- Two GEPs `base+j` and `base+(n+j)` even when the SSA relationship `hi.offset = lo.offset + lo.size` is structurally visible - LLVM's alias analysis does not connect the `add` arithmetic to the GEP aliasing check
- Two `ptr` function parameters with no `noalias` attribute or `separate_storage` assumption
- Alias relationships across `noinline` function call boundaries - the callee sees only raw `ptr` args

---

## 3. Workflow (How Cases Are Found and Validated)

```
1. Write MLIR kernel   ->   kernels/mlir/<name>.mlir
2. Lower to LLVM IR    ->   scripts/run_pipeline_cpu.sh kernels/mlir/<name>.mlir outputs/<name>/<name>
                            Produces: outputs/<name>/<name>.ll
                                      outputs/<name>/<name>.llvm_dialect.mlir
3. Run O2 + remarks    ->   scripts/run_opt_emit_ll.sh outputs/<name>/<name>.ll
                                                       outputs/<name>/<name>.O2.ll
                                                       outputs/<name>/remarks.O2.yml
4. Check remarks       ->   grep for licm/gvn/dse LoadWithLoopInvariantAddressInvalidated,
                            LoadClobbered, VectorizationUnsafeDep
5. Build oracle        ->   Copy <name>.ll -> <name>.oracle.ll
                            Manually add !alias.scope / !noalias metadata to loads/stores
6. Validate oracle     ->   Re-run run_opt_emit_ll.sh on oracle.ll
                            Confirm: misses become Hoisted / eliminated
7. Document            ->   cases/case_<name>.md
```

The **oracle** is the key validation step - it proves that the structural alias
information, if correctly represented in LLVM IR, *would* enable the optimization. The
pass is the mechanism that generates this metadata automatically from MLIR.

---

## 4. Valid Cases Found (6 Total)

All 6 valid cases use `!alias.scope`/`!noalias` as the oracle mechanism. All cases
target LICM as the primary missed optimization (some also show GVN/vectorization misses).

### The Structural Pattern: Partition-by-Endpoint

All valid cases share one core structural property, applied in different contexts:

> **Partition-by-endpoint**: Two subviews of the same base memref are provably disjoint
> when `subview_hi.offset == subview_lo.offset + subview_lo.size`.

In MLIR, this relationship is visible through SSA values. After lowering to LLVM IR, it
becomes arithmetic on `i64` offset fields that LLVM does not connect to GEP aliasing.

---

### Case 1: `subview_noalias` (Static Partition + Noinline Callee)
**File**: `kernels/mlir/subview_noalias.mlir` | `cases/case1_noalias_func.md`

**Pattern**: A 1024-element buffer is split into two static halves (`[0..511]` and
`[512..1023]`), cast to `memref<?xf32, strided<[1], offset: ?>>` (erasing the static
offset), and passed to a `noinline` callee. Inside the callee, LLVM sees two opaque `ptr`
arguments - the static type-level offset information (which proved disjointness) was
erased by the `memref.cast`.

**LLVM IR structure (callee)**:
```llvm
; ptr %1 = src aligned_ptr,  i64 %2 = src_offset (0 or 512)
; ptr %6 = dst aligned_ptr,  i64 %7 = dst_offset
; These are two arbitrary ptrs - LLVM has no basis to prove non-aliasing
%30 = load float, ptr (base + offset + 0)    ; src[0] - NOT hoisted
store float %36, ptr (base + dst_offset + j) ; dst[j]
```

**Missed optimization**: LICM cannot hoist `src[0]` load - the `dst[j]` store might alias.

**Oracle**: `!alias.scope` on `src` loads, `!noalias` on `dst` store -> LICM hoists.

**Why the pass can fix this**: At the MLIR `func.call` site, before the cast, the pass can
see that the two subviews have non-overlapping static offsets (0 and 512) with size 512
each -> structurally disjoint. It can emit alias-scope metadata for the callee's body.

---

### Case 2: `dynamic_split` (Dynamic Partition-by-Endpoint, Same Function)
**File**: `kernels/mlir/dynamic_split.mlir` | `cases/case_dynamic_split.md`

**Pattern**: A 2048-element buffer is partitioned at a runtime split point `%n` into
`lo = A[0..n-1]` and `hi = A[n..2047]`. The MLIR SSA relationship is direct:
`hi.offset = %n = lo.size`. Inside a loop over `hi`, `lo[0]` is invariant but LLVM
cannot prove it doesn't alias `hi[i]` stores.

**LLVM IR structure**:
```llvm
; lo[0] = base + 0,  hi[i] = base + n + i
; LLVM cannot prove n > 0, so base+0 might equal base+n+0 if n=0
%inv = load float, ptr (base + 0)          ; lo[0] - NOT hoisted
store float %y, ptr (base + %n + %i)       ; hi[i]
```

**Missed optimizations**: LICM ×3 (`LoadWithLoopInvariantAddressInvalidated`),
GVN (`LoadClobbered`), vectorization (`UnsafeDep`).

**Failed oracle attempt**: `@llvm.assume(icmp sge n, 1)` - LLVM's LICM does NOT consume
icmp-based assume range constraints for GEP aliasing. This is a known limitation of
LLVM's `LazyValueInfo` not feeding into `BasicAA`/`MemorySSA`.

**Working oracle**: `!alias.scope`/`!noalias` -> all 3 LICM misses resolved, load constant-
propagated to `1.0`, loop vectorized after hoisting.

**Why the pass can fix this**: The MLIR partition-by-endpoint is structurally explicit:
`hi = memref.subview %A[%n][%hi_size][1]` and `%n` is the SSA value of `lo`'s size.

---

### Case 3: `adjacent_tiles` (Partition-by-Endpoint via Arithmetic Chain)
**File**: `kernels/mlir/adjacent_tiles.mlir` | `cases/case_adjacent_tiles.md`

**Pattern**: A 4096-element buffer is split into two adjacent tiles using dynamic tile
index `%tile` and tile size `%N`. The source tile is `A[tile*N..(tile+1)*N-1]` and the
destination tile is `A[(tile+1)*N..(tile+2)*N-1]`. The partition-by-endpoint relationship
is established via arithmetic: `dst_off = muli(tile, N) + N = src_off + N = src_off + src.size`.

**LLVM IR structure**:
```llvm
%src_off = tile * N
%dst_off = src_off + N
; src[0] = base + src_off,  dst[j] = base + dst_off + j
; LLVM cannot prove N > 0, so src[0] might equal dst[0]
load float, ptr (base + src_off)           ; src[0] - NOT hoisted
store float %y, ptr (base + dst_off + %j) ; dst[j]
```

**Surprising finding**: LLVM does NOT use the inner-loop condition `j < N` to derive
`N > 0` and rule out aliasing. LICM reasons at the preheader level - before the loop is
known to execute - and cannot use the loop-entry condition as an aliasing constraint.

**Missed optimizations**: LICM + GVN on `src[0]`.

**Oracle**: `!alias.scope`/`!noalias` -> LICM hoists.

**What distinguishes this from `dynamic_split`**: The partition endpoint is derived via a
compound arithmetic chain (`muli` + `addi`) rather than direct SSA identity. The pass
must trace through these arithmetic ops to recover the partition structure.

---

### Case 4: `matrix_row_split` (2D Matrix Horizontal Split)
**File**: `kernels/mlir/matrix_row_split.mlir` | `cases/case_matrix_row_split.md`

**Pattern**: A 2D matrix `memref<?x512xf32>` (dynamic row count, static 512 columns) is
split at dynamic row boundary `%m`. Top half covers rows `[0, m)`, bottom half rows
`[m, 2m)`. A doubly-nested loop reads `top[0][0]` (invariant) and `top[i][j]`, writing
`bot[i][j]`.

**LLVM IR structure (flat GEP arithmetic)**:
```llvm
; top[0][0] = base + 0
; top[i][j] = base + i*512 + j
; bot[i][j] = base + (m+i)*512 + j
; LLVM cannot prove m*512 != 0 without m >= 1
load float, ptr (base + 0)                         ; top[0][0] - NOT hoisted
store float %y, ptr (base + (m+i)*512 + j)        ; bot[i][j]
```

**What makes this harder than 1D**: The row-stride multiplication (`i64 * 512`) creates
a compound GEP expression - LLVM must reason about a *product* `m*512` rather than a
simple offset. This is representative of real matrix-tiling workloads (BLAS, tensor ops).

**Missed optimizations**: LICM ×3 from nested loop.

**Oracle**: `!alias.scope`/`!noalias` -> `top[0][0]` hoisted and constant-propagated to
`1.0` (known from seed store). Optimized inner loop is just `bot[i][j] = top[i][j] + 1.0`.

**Why the pass can fix this**: At MLIR level, `bot.row_offset (%m) = top.row_size (%m)`
is directly readable from `memref.subview` arguments. This is the 2D analogue of
partition-by-endpoint.

---

### Case 5: `tiling_noinline` (Partition-by-Endpoint + Noinline Callee)
**File**: `kernels/mlir/tiling_noinline.mlir` | `cases/case_tiling_noinline.md`

**Pattern**: The `adjacent_tiles` arithmetic chain pattern combined with a noinline callee
boundary. The caller creates two adjacent tiles (partition-by-endpoint via `muli + addi`)
and passes them to `@tile_stencil` marked `no_inline`. Inside the callee, LLVM sees two
raw `ptr` arguments - both the partition structure AND the function boundary work together
to completely obscure the aliasing relationship.

```mlir
// Caller: has structural proof
%src_off = arith.muli %tile, %N
%dst_off = arith.addi %src_off, %N   // = src_off + N = src_off + src.size
func.call @tile_stencil(%src, %dst, %N) { no_inline }

// Callee: sees nothing
func.func @tile_stencil(%src: memref<?xf32, strided<[1], offset: ?>>,
                        %dst: memref<?xf32, strided<[1], offset: ?>>, ...) {
  // src[0] load cannot be hoisted - dst[j] store might alias
}
```

**Two-layer information loss**:
1. The arithmetic partition proof lives in the caller's SSA - not visible in callee
2. The function call boundary erases all alias relationships

**Missed optimizations**: LICM ×3 + GVN in `@tile_stencil`.

**Oracle**: `!alias.scope`/`!noalias` inside callee body (same metadata as intra-function
cases) -> `src[0]` hoisted to loop preheader, callee stays noinline.

**What distinguishes this from `subview_noalias`**:

| | `subview_noalias` | `tiling_noinline` |
|---|---|---|
| Proof source | Static MLIR types (offset: 0, offset: 512) | Runtime arithmetic chain (`muli + addi`) |
| Pass effort | Read static type attributes | Trace SSA arithmetic chain |
| Representative of | Static kernel specialization | Dynamic tiling / streaming access |

---

### Case 6: `vectorize_split` (Dynamic Split Blocks LICM and Vectorization)
**File**: `kernels/mlir/vectorize_split.mlir` | `cases/case_vectorize_split.md`

**Pattern**: A 2M-element buffer is split at a runtime offset `%n` into `lo = A[0..n-1]` (dynamic
size) and `hi = A[n..n+1M-1]` (static size 1M). The static hi size gives the vectorizer a known
trip count once alias uncertainty is removed. The kernel seeds `lo[0] = 1.0`, then loops 1M
iterations: `hi[i] += lo[0]`.

**Missed optimizations**: LICM × 4 (`LoadWithLoopInvariantAddressInvalidated`),
GVN × 2 (`LoadClobbered`), vectorization (`UnsafeDep`). The `UnsafeDep` is a **safety failure** -
not a cost-model decision. Even `-force-vector-width=4` cannot override it.

**Three-pass cascade on pass output**:
1. `!noalias` on hi stores -> LICM hoists `lo[0]`
2. Hoisted `lo[0]` sees only the pre-loop `store float 1.0` -> SCCP folds to `1.000000e+00`, load
   disappears from IR
3. Loop reduces to `hi[i] += 1.0` - static trip count, no aliasing concern -> SIMD vectorized

**Oracle**: `!alias.scope`/`!noalias` -> all 7 misses resolved, loop vectorized with fvw4.

**What distinguishes this from `dynamic_split`**: The hi size is static (1M), giving the
vectorizer a known trip count. In `dynamic_split`, the dynamic `%hi_size` causes the cost model
to decline vectorization even after the safety block is removed.

---

## 5. Invalidated Cases (Brief)

These patterns were explored but are NOT valid cases for the thesis because LLVM 22
already handles them without metadata, or because they have no sound structural basis.

| Pattern | Why Invalid |
|---|---|
| **Static subview halves** (`A[0..511]` and `A[512..1023]` with constant offsets lowered to constant GEPs) | LLVM 22 proves disjoint by GEP constant-offset arithmetic. No metadata needed. |
| **Simple function arguments** (two `ptr` params, no structural source of disjointness) | No structural basis for the pass to know they're disjoint - there's no MLIR-level evidence to extract. |
| **SSA-derived but constant offsets** (`arith.addi %c128, %c128`) | LLVM's constant folding / SCEV evaluates these to constants, then proves via GEP arithmetic. |
| **Subview inside inlined callee** (same function, static offsets) | After inlining, reverts to the constant-offset case that LLVM handles. |
| **DSE case with opaque function args** | Same root problem as "simple function arguments" - no structural disjointness evidence. |

The key distinguishing question for validity: **Does the MLIR program have structural,
inspectable SSA evidence that two regions are disjoint, in a way that is lost during
lowering?** If yes -> valid. If no, or if LLVM can recover it -> invalid.

---

## 6. Key Technical Notes for Implementation

### The Structural Proof: Partition-by-Endpoint

The single most important pattern to detect is partition-by-endpoint:

```
subview_hi.offset == subview_lo.offset + subview_lo.size
```

At the MLIR `memref.subview` op level, this is directly readable from the op's offset
and size operands. The operands are SSA values, so the proof is: look at whether
`hi_offset_value` is produced by `arith.addi` of `lo_offset_value` and `lo_size_value`.

For the 2D case: `bot.row_offset == top.row_size` (checking the first dimension operand).

### MLIR Attributes for noinline

`no_inline` in MLIR becomes `noinline` in LLVM IR. The function attribute is:
```mlir
func.func @foo(...) attributes {no_inline} { ... }
```
The call-site attribute (to prevent inlining of a specific call) is:
```mlir
func.call @foo(...) { no_inline } : (...) -> ()
```

### Oracle Metadata Structure (What the Pass Must Emit)

Every valid oracle uses the same metadata hierarchy:

```llvm
; On loads from subview A (the "protected" region):
%val = load float, ptr %addr, align 4, !alias.scope !2

; On stores to subview B (the region that doesn't alias A):
store float %val, ptr %addr, align 4, !noalias !2

; Metadata (at end of module):
!1 = distinct !{!1, !"kernel:domain"}           ; alias domain
!3 = distinct !{!3, !1, !"kernel:scope"}         ; scope in that domain
!2 = !{!3}                                       ; scope list (what metadata refs)
```

This corresponds to MLIR's `LLVM::AliasScopeAttr` / `LLVM::AliasScopeDomainAttr`
attached to LLVM dialect `llvm.load` / `llvm.store` ops.

---

## 7. Pass Design

### Why the Pass Must Run Before Lowering

A post-lowering pass (at the LLVM dialect level or on plain LLVM IR) would only have
GEP arithmetic to work with - the same information LLVM already has. Running there would
make the thesis contribution "a GEP pattern-matching LLVM pass," which does not require
or leverage MLIR at all. The thesis contribution is precisely that **`memref.subview`
semantics - which are explicit and inspectable only at the MLIR level - are used to drive
alias metadata emission**. Once `finalize-memref-to-llvm` runs, subview structure is gone.

The pass therefore runs pre-lowering, in a window where `memref.subview` ops are fully
normalized but still present.

### Pass Location in the Pipeline

The implementation is **three MLIR passes** run via `alias-meta-opt` before the standard
`mlir-opt` lowering. The pre-pass is only needed for ClangIR-lowered benchmarks; the
six hand-written case-study kernels use only Passes 1 and 2.

```
[ClangIR path only]
 ┌──────────────────────────────────────────────────────────────┐
 │  Pre-pass: MaterializePrefixSubviews  <- materializes prefix  │
 │            subview at call sites where base memref is passed │
 │            alongside a suffix subview (ClangIR artifact)     │
 └──────────────────────────────────────────────────────────────┘

-convert-scf-to-cf
-memref-expand
-fold-memref-alias-ops          <- normalises/folds subview chains
 ┌──────────────────────────────────────────────────────────────┐
 │  Pass 1: MarkAliasGroups     <- analysis, runs here           │
 │  Pass 2: LowerWithAliasMeta  <- targeted lowering, runs here  │
 └──────────────────────────────────────────────────────────────┘
-expand-strided-metadata        <- expands remaining memref ops
-lower-affine
-convert-arith-to-llvm
...
-finalize-memref-to-llvm        <- lowers remaining memref.load/store (unaffected)
-reconcile-unrealized-casts
     │
     ▼
[LLVM IR with !alias.scope / !noalias metadata]
     │
     ▼
[LLVM O2/O3: LICM / GVN / DSE / vectorization now fire]
```

Running after `fold-memref-alias-ops` is important: that pass collapses chains like
`subview(subview(A))` into a single normalized `subview`, giving the analysis the
cleanest possible view of the offset/size relationships.

Running before `expand-strided-metadata` is important: that pass decomposes `memref.subview`
into explicit scalar arithmetic, destroying the named offset/size operands the analysis depends on.

### Pass 1 - `MarkAliasGroups` (Analysis)

**Infrastructure**: `mlir::OperationPass<mlir::ModuleOp>` (module-level, needed to see
both caller and callee for the cross-function case).

**What it does**:

For each `func.func` in the module, walk all `memref.subview` ops and collect pairs
`(lo, hi)` that share the same base memref. For each pair, check the
**partition-by-endpoint** condition using the subview's explicit operands:

```
hi.offset_operand  ──defined by──>  arith.addi(lo.offset_operand, lo.size_operand)
```

This is a depth-1 SSA check: `dyn_cast<arith::AddIOp>(hi.getOffsets()[0].getDefiningOp())`
and verify its two operands match `lo.getOffsets()[0]` and `lo.getSizes()[0]`.

For the 2D case (`matrix_row_split`): check only the row-dimension operand (dimension 0).

Once a disjoint pair `(lo, hi)` is confirmed, walk the def-use chain of both subview
results to find all `memref.load` and `memref.store` ops that use them. Mark each with a
custom integer attribute `#alias_group<id = N>` (a simple `IntegerAttr` on the op in a
custom namespace). Assign a fresh group ID per disjoint pair.

For the **noinline callee** case (`subview_noalias`, `tiling_noinline`): the pass clones
the callee into a specialized variant `@name.__alias_meta_N`. It then descends into the
clone's body and tags the corresponding `memref.load`/`memref.store` ops directly (the
clone's argument SSA values map to the caller's proven-disjoint subview operands). The
`func.call` at the proven-disjoint call site is rewritten to call the clone. The original
callee is untouched (other call sites are unaffected).

**Output**: `memref.load` / `memref.store` ops tagged with `alias_meta.group_id` (i32)
and `alias_meta.role` ("lo"/"hi") discardable attributes - both in the caller body and
inside any cloned callee variants.

### Pass 2 - `LowerWithAliasMeta` (Targeted Lowering)

**Infrastructure**: A `DialectConversion` pass (using MLIR's `ConversionTarget` +
`ConversionPattern` framework) targeting only the marked ops from Pass 1. Unmarked
`memref.load`/`memref.store` ops are left untouched for `finalize-memref-to-llvm`.

**What it does**:

*For intra-function cases (Cases 2, 3, 4)*:

Defines custom `LoadOpLowering` and `StoreOpLowering` conversion patterns that:
1. Match only `memref.load`/`memref.store` ops carrying an `#alias_group<id>` attr
2. Create `LLVM::AliasScopeDomainAttr` and `LLVM::AliasScopeAttr` (one domain + scope
   per unique group ID; these are MLIR LLVM dialect attribute types, no metadata nodes
   needed at this stage)
3. Lower the op to `llvm.load`/`llvm.store` using the same address computation as
   `finalize-memref-to-llvm`'s standard `LoadOpLowering` (the `MemRefDescriptor` helper
   class and `LLVMTypeConverter` from `mlir/Conversion/LLVMCommon/` provide this)
4. Set `alias_scopes = [scope]` on `llvm.load`/`llvm.store` for the `lo` group
5. Set `noalias_scopes = [scope]` for the `hi` group

The standard `finalize-memref-to-llvm` pass handles all remaining (unmarked) ops.

*For the noinline callee cases (Cases 1, 5)*:

Pass 1 has already cloned the callee and tagged the clone's `memref.load`/`memref.store`
ops. Pass 2 handles those tagged ops inside the clone identically to the intra-function
case - the same `LoadOpLowering`/`StoreOpLowering` patterns fire on the clone's body and
emit `alias_scopes`/`noalias_scopes` on the resulting `llvm.load`/`llvm.store` ops. No
special handling of function signatures or `noalias` parameter attributes is needed.

### Arithmetic Chain Tracing

For Cases 3 and 5 (`adjacent_tiles`, `tiling_noinline`), the partition-by-endpoint
relationship is not a direct SSA identity but is established via a two-op chain:

```mlir
%src_off = arith.muli %tile, %N    ; tile * N
%dst_off = arith.addi %src_off, %N ; tile*N + N  <-  src_off + src.size
```

The check in Pass 1 already handles this: when we check
`hi.offset_operand is arith.addi(lo.offset_operand, lo.size_operand)`, and
`lo.size_operand = %N` and `lo.offset_operand = %src_off = muli(%tile, %N)`,
the `addi` check succeeds trivially - we don't need to look through the `muli`.
The SSA values are opaque to the check; we only verify the `addi` producer has
the right two operands. This handles all depth-1 arithmetic chains automatically.

### Pass Infrastructure Summary

| | Pre-pass `MaterializePrefixSubviews` | Pass 1 `MarkAliasGroups` | Pass 2 `LowerWithAliasMeta` |
|---|---|---|---|
| Base class | `OperationPass<ModuleOp>` | `OperationPass<ModuleOp>` | `OperationPass<ModuleOp>` using `DialectConversion` |
| When needed | ClangIR benchmarks only | Always | Always |
| Pattern matching | Find call sites where one arg is a subview of another; materialize prefix subview | Walk `memref.subview`, check `addi` def chain | `ConversionPattern` on marked `memref.load`/`store` |
| Key MLIR APIs | `memref.subview`, `memref.reinterpret_cast` | `op.getDefiningOp()`, `op.getUses()`, discardable attrs | `MemRefDescriptor`, `LLVMTypeConverter`, `LLVM::AliasScopeAttr` |
| Noinline case | N/A | Clone callee -> `@name.__alias_meta_N`; tag clone's memory ops | Same lowering patterns fire on clone body |
| Does NOT modify | Anything outside call sites | `finalize-memref-to-llvm` or any upstream pass | Any unmarked ops |

### What the Pass Does NOT Need to Do

- Prove disjointness from numeric bounds - all proofs are structural SSA identity checks
- Handle all MLIR memory ops - only `memref.load`, `memref.store`, `memref.subview`
- Handle `linalg`, `tensor`, or `gpu` ops (out of scope)

---

## 8. Benchmarking and Evaluation

### Evaluation Strategy

The evaluation demonstrates three things:
1. The pass correctly identifies the structural patterns (32 baseline misses -> 0 across all 6 kernels)
2. The emitted metadata enables the optimizations that were missed (remarks confirm, IR confirms)
3. The impact on real benchmark performance is measurable across hardware platforms

The comparison is three-way:
- **Baseline**: Standard MLIR -> LLVM lowering, no alias metadata
- **Oracle**: Manually annotated LLVM IR (proves the metadata approach is sound, independent of the pass)
- **Pass**: Automatic metadata emission - matches oracle miss counts on all 6 kernels

### Completed Evaluation: Six Case-Study Kernels

The primary evaluation is six hand-written MLIR kernels, each exercising a distinct structural
variant of the partition-by-endpoint pattern. Hand-written kernels are the right scope: the thesis
claims to detect and propagate a specific structural pattern, and the six cases cover all distinct
variants of that pattern (Form A, Form B, Form C, intra-function, cross-function noinline,
vectorization-enabling).

Standard benchmark suites (PolyBench, NPB, etc.) do not naturally produce `memref.subview` ops
and do not exercise the pass without additional pipeline steps that introduce their own variables.
The six kernels provide clean, controlled validation of the thesis claims.

**Remarks results** (across all 6 kernels):

| Metric | Baseline | Pass |
|---|---|---|
| Alias-related misses (`LoadWithLoopInvariantAddressInvalidated` + `LoadClobbered`) | 32 | **0** |
| Successful LICM hoists | 13 | **16** |
| Hot-loop memory reads/iter | 2 | **1** (all 5 LICM kernels) |
| `UnsafeDep` vectorization blocks | 1 | **0** |

**Correctness**: `scripts/run_correctness_tests.sh` - 6/6 kernels pass numeric checksum
comparison between baseline and pass binaries.

### Cross-Platform Wall-Clock Benchmarks

Wall-clock benchmarks on four platforms expose qualitatively different mechanisms by which alias
uncertainty affects runtime performance. RPi binaries cross-compiled on Apple Silicon via
`zig cc --target=aarch64-linux-musl -static` with `llc -mcpu=<cortex-a53|a72|a76>`. Timing uses
`CLOCK_MONOTONIC_RAW`, minimum of 5 rounds, after warmup.

**Three performance patterns:**

| Platform type | Hardware | Mechanism | Representative speedup |
|---|---|---|---|
| In-order | RPi 3B (A53, ~1.2 GHz) | One `ldr` removed from critical path per iteration | ~1.12× (all simple hoist cases) |
| Shallow OOO | RPi 4B (A72, 1.5 GHz) | LSU disambiguation overhead eliminated across all loop iterations | 1.16-1.28× (scales with relationship count) |
| Deep OOO | RPi 5 (A76, ~1.5 GHz) | Simple hoists persist; complex relationships absorbed; one regression | 0.88-1.28× |
| Vectorization | macOS (Apple M-series) | UnsafeDep safety block removed -> NEON SIMD enabled | **3.76×** (`vectorize_split`) |

Key non-obvious results:
- OOO benefit equals or exceeds in-order benefit for simple hoist cases (A72 1.16× > A53 1.12×)
  because LSU disambiguation overhead is an OOO-specific cost that vanishes when the load is hoisted
- `double_invariant` (two invariant loads): A72 1.28× vs A53 1.08× - non-linear OOO overhead
- `matrix_row_split` (32,768 inner stores checking one outer-loop load): A72 1.20×, A53/A76 noise
- `tiling_noinline` on A76: genuine 0.88× regression, reproducible, cause not established
- `vectorize_split` on A72: 0.91× regression (DRAM-bound at 8 MB working set, ~6 GB/s LPDDR4)

Full case-study benchmark analysis: `thesis-reference/case-study-evaluation.md`.
Final evaluation suite: `final_benchmark/benchmark.md`.

### Final Benchmark Suite (COMPLETE)

Five benchmark-derived kernels run on four platforms. The PolyBench/C candidates use the
ClangIR C-source path; the IMEX and IREE candidates are MLIR-stage extracts. The
`MaterializePrefixSubviewsPass` pre-pass is required for the ClangIR source path.

| Benchmark | Mac Mini M4 | RPi 3B | RPi 4B | RPi 5 |
|---|---:|---:|---:|---:|
| PolyBench ATAX | 1.463× | 1.252× | 1.470× | 1.509× |
| PolyBench BICG | 1.081× | 1.000× | 2.095× | 2.131× |
| IMEX Softmax | 1.022× | 1.000× | 1.106× | 1.123× |
| PolyBench MVT | 1.006× | 1.000× | 1.000× | 1.000× |
| IREE Bias Add | 1.011× | 1.026× | 1.054× | 0.948× |

Full results, source diffs, MLIR snippets: `final_benchmark/benchmark.md`.
Correctness: all checksums match baseline on all 4 platforms.

**Linalg benchmarks** (`linalg_benchmarks/`): 3 linalg.generic-derived kernels, validated at
remark level only (25 alias misses resolved). Not included in wall-clock evaluation.

### Metrics

| Metric | How | What It Shows |
|---|---|---|
| Alias-related misses | Count `LoadWithLoopInvariantAddressInvalidated` + `LoadClobbered` in remarks | Alias uncertainty eliminated |
| LICM hoists enabled | Count `Hoisted` delta (pass − baseline) | Optimizations unblocked |
| Vectorization unblocked | `UnsafeDep` -> `Vectorized` or `VectorizationNotBeneficial` | Safety block resolved |
| Hot-loop load count | Loads/iter in O2 IR body | Code quality impact |
| Runtime speedup | ns/call (min of 5 rounds, after warmup) | Actual performance impact |

---

## 9. Repository Structure

```
ms-thesis-copy/
├── pass/                          # Out-of-tree MLIR pass (main contribution)
│   ├── lib/                       # MaterializePrefixSubviewsPass.cpp,
│   │                              #   MarkAliasGroupsPass.cpp, LowerWithAliasMetaPass.cpp
│   ├── include/AliasMetaPropagation/ # Passes.h, Passes.td
│   ├── tools/                     # alias-meta-opt.cpp (standalone driver)
│   ├── plugin/                    # AliasMetaPlugin.cpp (not used - ODR issues on macOS)
│   └── build/bin/alias-meta-opt   # Standalone pass binary (gitignored)
├── kernels/mlir/                  # MLIR kernel sources
│   ├── subview_noalias.mlir       # Case 1: noinline callee, static offsets
│   ├── dynamic_split.mlir         # Case 2: 1D runtime partition
│   ├── adjacent_tiles.mlir        # Case 3: tile boundary via addi chain
│   ├── matrix_row_split.mlir      # Case 4: 2D row split
│   ├── tiling_noinline.mlir       # Case 5: noinline + runtime addi chain
│   ├── vectorize_split.mlir       # Case 6: SIMD vectorization enabling (also in case-study-kernels/)
│   └── ...                        # Exploratory and invalidated kernels
├── outputs/<name>/                # Per-kernel artifacts
│   ├── <name>.ll                  # Baseline LLVM IR
│   ├── <name>.O2.ll               # Baseline after O2
│   ├── remarks.O2.yml             # Baseline optimization remarks
│   ├── <name>.oracle.ll           # Manually annotated oracle
│   ├── <name>.oracle.O2.ll        # Oracle after O2
│   ├── <name>.meta.ll             # Pass LLVM IR
│   └── <name>.meta.O2.ll          # Pass after O2
├── pass_outputs/<name>/           # Pass pipeline outputs (baseline/ and with_meta/)
├── case-study-kernels/            # MLIR sources for the 10 case-study benchmark kernels
├── case-study-kernel-outputs/     # Compiled LLVM IR (baseline/ and with_meta/ per kernel)
├── case-study-harnesses/          # C timing harnesses (bench_<name>.c, bench.h)
├── case-study-binaries/           # Cross-compiled RPi binaries (rpi3b/, rpi4b/, rpi5/)
├── final_benchmark/               # Final evaluation suite (ATAX, BICG, IMEX, MVT, IREE)
│   ├── benchmark.md               # Full results, source diffs, MLIR snippets
│   ├── bench.h                    # Shared timing utility
│   └── bench_outputs/             # Raw timing data and median summaries
├── linalg_benchmarks/             # Linalg-derived kernels (remark-level validation only)
├── benchmark_exploration/         # External-suite exploration and discarded candidates
├── tests/                         # Correctness test harnesses (test_<name>.c)
├── cases/                         # 6 valid case documents
│   ├── case1_noalias_func.md
│   ├── case_dynamic_split.md
│   ├── case_adjacent_tiles.md
│   ├── case_matrix_row_split.md
│   ├── case_tiling_noinline.md
│   └── case_vectorize_split.md
├── invalid_cases/                 # 5 invalidated case documents with rationale
├── docs/
│   ├── thesis-summary.md          # Concise project summary with results
│   ├── project-brief.md           # This document
│   ├── implementation-log.md      # Implementation decisions, problems, validation
│   ├── pass-build-notes.md        # Build instructions and API reference
│   └── final-benchmark-evaluation.md # Final benchmark evaluation record
├── thesis-reference/              # Per-topic reference docs for thesis writing
│   ├── thesis-argument.md
│   ├── pass-design.md
│   ├── pass1-implementation.md
│   ├── pass2-implementation.md
│   ├── case-studies.md
│   ├── optimization-results.md
│   ├── case-study-evaluation.md   # Case-study kernel benchmarks + cross-platform performance analysis
│   ├── final-benchmark-evaluation.md # Final benchmark results reference
│   ├── infrastructure.md          # Infrastructure and artifact locations
│   ├── llvm-alias-metadata.md
│   ├── mlir-to-llvm-lowering.md
│   └── invalidated-cases.md
├── scripts/
│   ├── run_pipeline_cpu.sh        # Baseline MLIR -> LLVM IR pipeline
│   ├── run_pipeline_cpu_with_meta.sh # Pass pipeline (alias-meta-opt -> mlir-opt)
│   ├── run_opt_emit_ll.sh         # O2 optimization + remarks
│   ├── run_correctness_tests.sh   # Correctness verification
│   ├── cross_compile_rpi.sh       # Cross-compile for RPi 3B/4B/5
│   ├── run_rpi_benchmarks.sh      # Run benchmarks on RPi via SSH
│   ├── rpi_config.sh              # RPi SSH host configuration
│   └── diff_ir.sh                 # Diff baseline vs pass LLVM IR
├── cgeist-tests/                  # Polygeist (cgeist) exploration
├── case_exploration_log.md        # Chronological exploration log
└── llvm-version.txt
```

---

## 10. Current Status

### Completed

- Identified 6 valid cases with confirmed LICM/GVN/vectorization misses
- Built and validated manual oracles for all 6 cases
- Documented all cases with detailed structural analysis
- Confirmed what LLVM 22 can and cannot prove (boundary between valid and invalidated cases)
- Implemented `MaterializePrefixSubviewsPass` (pre-pass) - ClangIR call-site prefix materialization
- Implemented `MarkAliasGroupsPass` (Pass 1) - all three disjointness forms, noinline callee cloning
- Implemented `LowerWithAliasMetaPass` (Pass 2) - partial conversion, alias scope metadata emission
- Standalone binary `alias-meta-opt` working; plugin approach abandoned (macOS ODR)
- Pipeline script `run_pipeline_cpu_with_meta.sh` - alias-meta-opt -> mlir-opt two-step
- Validated: 32 baseline alias misses -> 0 across all 6 kernels
- Correctness tests: 6/6 kernels pass numeric checksum comparison
- Case-study wall-clock benchmarks: macOS (Apple M-series), RPi 3B (A53), RPi 4B (A72), RPi 5 (A76)
- Final benchmark suite (ATAX, BICG, IMEX Softmax, MVT, IREE Bias Add): 4 platforms, all correctness verified
- Linalg benchmark suite (3 kernels): remark-level validation only

### In Progress

- Thesis writing

### Key Implementation Notes

See `docs/implementation-log.md` for a detailed record of every implementation decision, problem
encountered, and resolution. See `docs/pass-build-notes.md` for build instructions and API
reference. See `thesis-reference/` for per-topic reference docs organized for thesis writing.
