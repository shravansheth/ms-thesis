# Case Studies Reference

All six valid case-study kernels. For each: the structural pattern, MLIR source, what the baseline IR looks like, what optimization misses, and what the pass produces.

## What Is the Baseline

The baseline is the standard MLIR lowering pipeline run without our passes: `mlir-opt` with the standard dialect conversion sequence (`finalize-memref-to-llvm` and related passes), followed by `mlir-translate`, then `opt -O2` with remarks. No alias metadata is injected. LLVM sees only flat GEP pointer arithmetic with no knowledge of the structural disjointness present in the original `memref.subview` ops.

---

## Case 1: dynamic_split — Runtime Partition Point

**Kernel:** `kernels/mlir/dynamic_split.mlir`
**Detection:** Form A (hi.offset IS lo.size, same SSA Value; lo.offset == 0)

### MLIR Pattern

A 2048-element flat array `A` is split at a runtime offset `n`:
```mlir
%lo = memref.subview %A[0][%n][1]        // A[0 .. n-1]
%hi = memref.subview %A[%n][%hi_size][1] // A[n .. 2047]
```
Here `%hi.offset = %n` and `%lo.size = %n` — same SSA value. Pass 1 detects this as Form A.

The kernel stores 1.0 to `lo[0]` before the loop, then loops `hi[i] += lo[0]`.

### Why LLVM Cannot Prove Disjoint

After lowering: `lo[0]` → `load float, ptr (base + 0)`, `hi[i]` → `store float, ptr (base + n + i)`.
LLVM needs `n >= 1` to prove `n + i ≠ 0`. The value `n` is a runtime argument. LLVM has no lower bound on it.

### Baseline Behavior

- Remarks: 4 × `LoadWithLoopInvariantAddressInvalidated` + 2 × `LoadClobbered` + 1 × `UnsafeDep`
- Baseline loop body has **2 data loads/iter**: `lo[0]` (stuck in loop) + `hi[i]`
- The "1 Hoisted" count in remarks is a `getelementptr` instruction, not a data load

```llvm
; baseline loop body
%12 = load float, ptr %1, align 4      ; lo[0] — NOT hoisted
%14 = load float, ptr %13, align 4     ; hi[i]
%15 = fadd float %12, %14
store float %15, ptr %13, align 4
```

### Pass Result

- All 7 misses drop to 0
- LICM hoists `lo[0]`; SCCP then folds it to `1.000000e+00` (unconditionally stored before loop)
- The hoist-then-fold means the loop body now has **1 load/iter**, but the hoist count stays at 1 (the GEP) because the data load hoist becomes invisible after constant folding
- Vectorizer now reports `VectorizationNotBeneficial` instead of `UnsafeDep` — alias concern resolved

```llvm
; pass loop body
%13 = load float, ptr %12, align 4, !noalias !1  ; hi[i]
%14 = fadd float %13, 1.000000e+00               ; fused with hoisted constant
store float %14, ptr %12, align 4, !noalias !1
```

---

## Case 2: adjacent_tiles — Tile Boundary via Arithmetic Chain

**Kernel:** `kernels/mlir/adjacent_tiles.mlir`
**Detection:** Form B (hi.offset = arith.addi(lo.offset, lo.size))

### MLIR Pattern

A 4096-element array `A` split into two adjacent tiles of runtime size `N`:
```mlir
%src_off = arith.muli %tile, %N : index
%src = memref.subview %A[%src_off][%N][1]    // A[tile*N .. (tile+1)*N - 1]

%dst_off = arith.addi %src_off, %N : index   // dst.offset = src.offset + N
%dst = memref.subview %A[%dst_off][%N][1]    // A[(tile+1)*N .. (tile+2)*N - 1]
```
`dst.offset` is the result of `addi(src_off, N)`, and `src.size = N`. Pass 1 traces the addi to detect Form B.

The kernel computes `dst[j] = src[0] + src[j]` in a loop.

### Why LLVM Cannot Prove Disjoint

LLVM sees loads from `(base + tile*N)` and a store to `(base + tile*N + N + j)`. To prove non-aliasing, LLVM needs `N > 0`. LLVM does NOT use the inner-loop condition `j < N` to derive `N > 0` — LICM reasons at the preheader level before the loop is known to execute.

### Baseline Behavior

- Remarks: 3 × `LoadWithLoopInvariantAddressInvalidated` + 1 × `LoadClobbered`
- `src[0]` not hoisted; loop body has 2 loads/iter (`src[0]` + `src[j]`)
- Baseline successful hoist count: 2 (GEP arithmetic, not data loads)

### Pass Result

- All 4 misses drop to 0
- `src[0]` hoisted to loop preheader
- Pass successful hoist count: 3 (one additional data load hoist)
- Loop body: 1 load/iter (`src[j]` only)

---

## Case 3: matrix_row_split — 2D Row Partition

**Kernel:** `kernels/mlir/matrix_row_split.mlir`
**Detection:** Form A on dimension 0 of a 2D subview

### MLIR Pattern

A 2D matrix `A` of shape `<?x512xf32>` split at a runtime row boundary `%m`:
```mlir
%top = memref.subview %A[0, 0][%m, 512][1, 1]     // rows [0, m)
%bot = memref.subview %A[%m, 0][%m, 512][1, 1]    // rows [m, 2m)
```
`bot.row_offset = %m = top.row_size` — Form A in dimension 0. The disjointness proof holds for the full row range (all 512 columns).

The kernel computes `bot[i][j] = top[i][j] + top[0][0]` in a nested loop, with `top[0][0]` seeded as 1.0.

### Why LLVM Cannot Prove Disjoint

After lowering: `top[0][0]` → `load float, ptr (base + 0)`, `bot[i][j]` → `store float, ptr (base + (m+i)*512 + j)`. LLVM needs `m >= 1` to prove `m*512 + i*512 + j ≠ 0`. The 2D row-stride multiplication (`m*512`) makes this harder than the 1D cases — SCEV must reason about a product with a runtime value, not a simple offset.

### Baseline Behavior

- Remarks: 4 × `LoadWithLoopInvariantAddressInvalidated` + 1 × `LoadClobbered`
- `top[0][0]` not hoisted; inner loop has 2 loads/iter (`top[0][0]` + `top[i][j]`)
- Baseline hoist count: 5 (GEP arithmetic for both loops, not the invariant data load)

### Pass Result

- All 5 misses drop to 0
- `top[0][0]` hoisted; SCCP folds it to `1.000000e+00`
- Inner loop: 1 load/iter (`top[i][j]` only)
- Pass hoist count: 5 (same GEP hoists; the data load hoist is folded away and invisible)
- For `n_lo = 128`, this saves `128 * 512 - 1 = 65535` loads of `top[0][0]`

---

## Case 4: subview_noalias — Noinline Callee (Static Offsets)

**Kernel:** `kernels/mlir/subview_noalias.mlir`
**Detection:** Form C (all constants: lo offset=0, size=512; hi offset=512, size=512)

### MLIR Pattern

```mlir
// Caller
%A = memref.alloc() : memref<1024xf32>
%slice0 = memref.subview %A[0]  [512][1] : ... offset: 0
%slice1 = memref.subview %A[512][512][1] : ... offset: 512

%p = memref.cast %slice0 : memref<512xf32, strided<[1], offset: 0>>
                         to memref<?xf32, strided<[1], offset: ?>>
%q = memref.cast %slice1 : memref<512xf32, strided<[1], offset: 512>>
                         to memref<?xf32, strided<[1], offset: ?>>

func.call @kernel(%p, %q) { no_inline } : (...)
```

```mlir
// Callee (noinline)
func.func @kernel(%p: memref<?xf32, strided<[1], offset: ?>>,
                  %q: memref<?xf32, strided<[1], offset: ?>>)
    attributes { no_inline } {
  scf.for %i = %c0 to %c512 step %c1 {
    %inv = memref.load %p[%c0]   // invariant
    %x   = memref.load %p[%i]
    memref.store (%x + %inv), %q[%i]
  }
}
```

The callee has no structural knowledge of the call-site split. After lowering, `%p` and `%q` are two pointer-like arguments with no provable relationship.

### Why Interesting

Even though the static offsets (0 and 512) might allow LLVM to prove disjointness in some cases, LLVM 22 does NOT prove it here because after the `memref.cast`, the static offsets are folded into the `i64 offset` field of the descriptor struct, not baked into the pointer value. The callee's two pointer args have the same `aligned` pointer value (both point to `%A`). LLVM must conservatively assume they may alias.

### Baseline Behavior

- Remarks: 4 × `LoadWithLoopInvariantAddressInvalidated` + 1 × `LoadClobbered` (all in `@kernel`)
- `p[0]` not hoisted; callee loop has 2 loads/iter

### Pass Result

Pass 1 clones `@kernel` into `@kernel.__alias_meta_0` via function specialization. The call site in `@caller` is redirected to the clone. The clone's loads/stores are tagged.

- All 5 misses drop to 0
- `p[0]` hoisted in the clone's loop preheader
- Pass hoist count: 3 (one additional data load hoist)
- Original `@kernel` is untouched

---

## Case 5: tiling_noinline — Noinline + Runtime Arithmetic Chain

**Kernel:** `kernels/mlir/tiling_noinline.mlir`
**Detection:** Form B at call site in caller, then noinline specialization into callee

### MLIR Pattern

Combines Cases 2 and 4: partition-by-endpoint via arithmetic chain, plus noinline callee.

```mlir
// Caller
func.func @tiling_caller(%A: memref<4096xf32>, %tile: index, %N: index) {
  %src_off = arith.muli %tile, %N : index
  %src = memref.subview %A[%src_off][%N][1] ...

  %dst_off = arith.addi %src_off, %N : index   // dst.offset = src.offset + N
  %dst = memref.subview %A[%dst_off][%N][1] ...

  func.call @tile_stencil(%src, %dst, %N) { no_inline }
}

// Callee (noinline)
func.func @tile_stencil(%src: memref<?xf32, ...>, %dst: memref<?xf32, ...>,
                        %N: index) attributes {no_inline} {
  scf.for %j = %c0 to %N step %c1 {
    %inv = memref.load %src[%c0]   // invariant
    %x   = memref.load %src[%j]
    memref.store (%x + %inv), %dst[%j]
  }
}
```

### Key Structural Distinction from subview_noalias

In `subview_noalias`, the disjointness is visible in static MLIR types (`offset: 0` vs `offset: 512`). Here, the disjointness is established by a runtime arithmetic chain (`dst_off = addi(muli(tile, N), N)`) that the pass must trace through SSA. This is representative of real tiling workloads where tile offsets are computed at runtime.

### Baseline Behavior

- Remarks: 3 × `LoadWithLoopInvariantAddressInvalidated` + 1 × `LoadClobbered` (all in `@tile_stencil`)
- `src[0]` not hoisted; callee loop has 2 loads/iter

### Pass Result

Pass 1 detects Form B in `@tiling_caller`, then clones `@tile_stencil` into `@tile_stencil.__alias_meta_0`. Tags the clone's loads/stores.

- All 4 misses drop to 0
- `src[0]` hoisted in the clone's loop preheader
- Pass hoist count: 3 (one additional data load hoist)
- Original `@tile_stencil` is untouched

---

---

## Case 6: vectorize_split — Dynamic Split Blocks LICM and Vectorization

**Kernel:** `kernels/mlir/vectorize_split.mlir`
**Detection:** Form A (hi.offset IS lo.size, same SSA Value; lo.offset == 0)

### MLIR Pattern

A 2M-element buffer `A` split at a runtime offset `n`:
```mlir
%lo = memref.subview %A[0][%n][1]          // A[0 .. n-1]  (dynamic size)
%hi = memref.subview %A[%n][1048576][1]    // A[n .. n+1M-1]  (STATIC size 1M)
```
`hi.offset = %n = lo.size` — Form A partition-by-endpoint. The static `1048576` hi size gives the vectorizer a known trip count once alias uncertainty is resolved.

The kernel seeds `lo[0] = 1.0`, then loops 1M iterations: `hi[i] += lo[0]`.

### Why LLVM Cannot Prove Disjoint

After lowering, both accesses use the same base pointer `ptr %1`:
- `lo[0]` → `load float, ptr %1`
- `hi[i]` → `store float, ptr (base + n + i)`

Without `n >= 1`, LLVM cannot rule out that `n + i = 0`. The `UnsafeDep` report is a **safety failure**, not a cost-model decision. Even `-force-vector-width=4` cannot override it.

**Evidence**: `outputs/vectorize_split/vectorize_split.baseline.fvw4.O2.ll` contains zero `<4 x float>` instructions despite `-force-vector-width=4`. `UnsafeDep` still appears in `remarks.baseline.fvw4.O2.yml`.

### Baseline Behavior

- Remarks: 4 × `LoadWithLoopInvariantAddressInvalidated` + 2 × `LoadClobbered` + 1 × `UnsafeDep`
- `lo[0]` not hoisted; loop body: 2 loads/iter
- `-force-vector-width=4` on baseline: still scalar (UnsafeDep blocks regardless of forced VF)

### Three-Pass Cascade (Pass Result)

Alias metadata → LICM → SCCP → vectorization:

1. **LICM**: `!noalias` on hi stores proves lo[0] is unaffected. `lo[0]` hoisted to preheader. Remark: `Hoisted`.
2. **SCCP**: Hoisted `lo[0]` load sees only the pre-loop `store float 1.0` as its reaching definition. SCCP folds to `1.000000e+00`. The load disappears from the IR.
3. **Vectorization**: Loop is now `hi[i] += 1.0` — no aliasing concern, static trip count. With `-force-vector-width=4`, vectorizer emits `<4 x float>` SIMD. Remark: `Vectorized (width: 4)`.

Without fvw4, the pass O2 reports `VectorizationNotBeneficial` (cost model, not safety) — confirming alias block is gone.

### Artifacts

| File | Description |
|---|---|
| `outputs/vectorize_split/vectorize_split.O2.ll` | Baseline scalar loop (lo[0] in body) |
| `outputs/vectorize_split/remarks.O2.yml` | 4×LICM miss + 2×GVN miss + UnsafeDep |
| `outputs/vectorize_split/vectorize_split.baseline.fvw4.O2.ll` | Baseline+fvw4 still scalar (control) |
| `outputs/vectorize_split/remarks.baseline.fvw4.O2.yml` | UnsafeDep persists with fvw4 |
| `pass_outputs/vectorize_split/with_meta/vectorize_split.meta.O2.ll` | Pass scalar (VectorizationNotBeneficial) |
| `pass_outputs/vectorize_split/with_meta/remarks.meta.O2.yml` | Hoisted + VectorizationNotBeneficial |
| `outputs/vectorize_split/vectorize_split.meta.fvw4.O2.ll` | Pass+fvw4 SIMD `<4 x float>` |
| `outputs/vectorize_split/remarks.meta.fvw4.O2.yml` | Hoisted + Vectorized (width: 4) |

### Benchmark Results

| Platform | Baseline (ns) | Pass+fvw4 (ns) | Speedup |
|---|---:|---:|---|
| macOS (Apple M2) | 1,440,486 | 383,304 | **3.76×** |
| RPi 3B (A53, LPDDR2) | 7,356,595 | 4,448,108 | **1.65×** |
| RPi 4B (A72, LPDDR4) | 3,619,207 | 3,962,715 | 0.91× ❌ (DRAM-bound) |
| RPi 5 (A76, LPDDR4X) | 624,074 | 501,103 | **1.25×** |

The 8 MB working set is DRAM-bound on A72 (~6 GB/s). SIMD reduces instruction count but not bytes transferred — the bottleneck is unchanged and marginal overhead produces a regression. On M2 and A76, higher memory bandwidth allows SIMD's instruction reduction to improve wall-clock time.

---

## Quantitative Summary

| Kernel | Baseline Hoisted | Pass Hoisted | Baseline Misses | Pass Misses | Baseline loads/iter | Pass loads/iter |
|---|---|---|---|---|---|---|
| `dynamic_split` | 1 | 1 | 7 | **0** | 2 | **1** |
| `adjacent_tiles` | 2 | **3** | 4 | **0** | 2 | **1** |
| `matrix_row_split` | 5 | 5 | 5 | **0** | 2 | **1** |
| `subview_noalias` | 2 | **3** | 5 | **0** | 2 | **1** |
| `tiling_noinline` | 2 | **3** | 4 | **0** | 2 | **1** |
| `vectorize_split` | 1 | **1†** | 7 | **0** | 2 | **1 (SIMD)** |
| **Total** | **13** | **16** | **32** | **0** | | |

†Same hoist count as baseline (GEP hoist); the lo[0] data load hoist is immediately folded by SCCP. The vectorization enabling is the primary contribution of this case.

**Hoisted count notes:**
- Baseline and pass counts include GEP hoists (pointer arithmetic), not only data loads.
- In `dynamic_split` and `matrix_row_split`, the pass hoists the data load but SCCP immediately folds it to a constant, making the hoist invisible in the remark count. The improvement is real and visible in the loop body IR.
- In the three cases with equal counts (`dynamic_split`, `matrix_row_split`), "nothing changed" is wrong — the load count and alias uncertainty both improved; the remark count is just not sensitive to hoists that disappear via constant folding.

**Miss count notes:**
- A single blocked load generates multiple miss remarks because LICM runs more than once in the O2 pipeline (early LICM, post-simplification LICM) and GVN independently attempts the same loads.
- Zero misses confirms the alias uncertainty is fully removed; the actual benefit is measured in the loop-body load count and performance estimates.
