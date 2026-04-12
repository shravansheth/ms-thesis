# Case: `matrix_row_split` — 2D Matrix Split on Dynamic Row Boundary

**Kernel**: `kernels/mlir/matrix_row_split.mlir`
**Optimization missed**: LICM (invariant `top[0][0]` load not hoisted from nested loop)

---

## Pattern

A 2D matrix `A` of shape `memref<?x512xf32>` (dynamic row count, static 512 columns) is
split horizontally at a runtime row boundary `%m`. The top half covers rows `[0, m)` and
the bottom half covers rows `[m, 2m)`. The computation reads `top[0][0]` (invariant) and
`top[i][j]` (loop-variant) inside a doubly-nested loop and stores `top[i][j] + top[0][0]`
into `bot[i][j]`.

```mlir
%top = memref.subview %A[0, 0][%m, 512][1, 1]
  : memref<?x512xf32> to memref<?x512xf32, strided<[512, 1], offset: 0>>

%bot = memref.subview %A[%m, 0][%m, 512][1, 1]
  : memref<?x512xf32> to memref<?x512xf32, strided<[512, 1], offset: ?>>

memref.store %f1, %top[%c0, %c0]   // seed top[0][0] = 1.0

scf.for %i = %c0 to %m step %c1 {
  scf.for %j = %c0 to %c512 step %c1 {
    %inv = memref.load %top[%c0, %c0]   // invariant: top[0][0] = A[0][0]
    %x   = memref.load %top[%i, %j]
    %y   = arith.addf %x, %inv : f32
    memref.store %y, %bot[%i, %j]
  }
}
```

**Key structural fact**: `bot.row_offset = %m = top.row_size`. In 2D, this means
`bot[0][0]` is at flat offset `m * 512` from the base. LLVM cannot prove `m*512 != 0`
without knowing `m >= 1`.

**Distinction from 1D cases**: The 2D row-stride multiplication (`i64 * 512`) creates a
compound GEP expression. LLVM's arithmetic reasoning must deal with a product `m*512`
rather than a simple offset `n` — making this harder to reason about than the 1D cases
and more representative of real matrix-tiling workloads.

---

## LLVM IR After Lowering

The memref descriptor carries sizes and strides as separate `i64` fields. After
`expand-strided-metadata` and `finalize-memref-to-llvm`, the 2D layout becomes flat
pointer arithmetic:

```llvm
; top[0][0] = base + 0 (flat offset 0)
; top[i][j] = base + i*512 + j
; bot[i][j] = base + (m+i)*512 + j

; inner loop block 25 (before oracle):
%28 = load float, ptr %27, align 4          ; top[0][0] — NOT hoisted
%33 = load float, ptr %32, align 4          ; top[i][j]
store float %34, ptr %39, align 4           ; bot[i][j]

; GEP for bot[i][j]:
%35 = add i64 %7, %19                       ; m + i  (%7=m, %19=i)
%37 = mul nuw nsw i64 %35, 512              ; (m+i) * 512
%38 = add nuw nsw i64 %37, %23             ; (m+i)*512 + j
%39 = getelementptr inbounds nuw float, ptr %36, i64 %38
```

LLVM sees: load from `(base + 0)` vs store to `(base + (m+i)*512 + j)`. To prove they
can't be the same address, LLVM needs `m*512 + i*512 + j != 0`, which requires `m >= 1`.
No such constraint is available at LLVM level.

---

## Optimization Misses (Remarks)

From `remarks.O2.yml`:

| Pass | Miss Name | Description |
|------|-----------|-------------|
| licm | `LoadWithLoopInvariantAddressInvalidated` | `top[0][0]` load not hoisted — inner loop |
| licm | `LoadWithLoopInvariantAddressInvalidated` | Same check repeated for outer loop preheader |
| licm | `LoadWithLoopInvariantAddressInvalidated` | Third repetition (multiple LICM passes) |

---

## Oracle

**File**: `outputs/matrix_row_split/matrix_row_split.oracle.ll`

Add `!alias.scope !2` to both `top` loads (invariant `top[0][0]` and variant `top[i][j]`)
and `!noalias !2` to the `bot[i][j]` store:

```llvm
  %28 = load float, ptr %27, align 4, !alias.scope !2   ; top[0][0] — invariant
  %33 = load float, ptr %32, align 4, !alias.scope !2   ; top[i][j] — variant
  store float %34, ptr %39, align 4, !noalias !2         ; bot[i][j]

; Metadata:
!1 = distinct !{!1, !"matrix_row_split:top_domain"}
!3 = distinct !{!3, !1, !"matrix_row_split:top_scope"}
!2 = !{!3}
```

**Result** (from `oracle.O2.yml`):
- 5× LICM `Hoisted` — invariant `top[0][0]` load hoisted to outer-loop preheader
- `top[0][0]` constant-propagated to `1.0` (known from the seed store)
- No `LoadWithLoopInvariantAddressInvalidated` misses
- Only misses: `VectorizationNotBeneficial` + `InterleavingNotBeneficial` (cost-model only)

The optimized inner loop reduces to:
```llvm
  %17 = load float, ptr %16, align 4, !alias.scope !1   ; top[i][j] (row ptr precomputed)
  %18 = fadd float %17, 1.000000e+00                    ; + hoisted 1.0 constant
  store float %18, ptr %19, align 4, !noalias !1         ; bot[i][j]
```

---

## What the Pass Must Recognise

For a 2D memref subview, the pass must understand the flat offset computation:
- `top` maps row `r`, col `c` to flat offset `r * stride[0] + c * stride[1] + base_offset`
- `bot` maps row `r`, col `c` to flat offset `(m + r) * stride[0] + c * stride[1] + ?`

The key structural relationship: `bot.row_offset (%m)` equals `top.row_size (%m)` — the
rows of `top` and `bot` tile the original matrix without overlap. This is the 2D
analogue of the 1D partition-by-endpoint pattern.

`expand-strided-metadata` decomposes these relationships into scalar arithmetic, so the
pass may need to track through the MLIR-level strided-layout expansion to recover the
partition structure. Alternatively, the analysis can be done pre-lowering at the MLIR
`memref.subview` level, where the relationship is direct and explicit.

---

## Why Valid

1. The two subviews tile the matrix without overlap — provable from MLIR types and
   operation arguments before any lowering.
2. The 2D row-stride multiplication is the canonical representation of matrix tiling —
   a common pattern in BLAS, ML kernels, and tensor computations.
3. LLVM cannot recover the structural proof after lowering to flat GEPs with dynamic
   multiplications — the barrier is the same as in the 1D case but with an extra level
   of arithmetic complexity.
4. The `!alias.scope`/`!noalias` oracle mechanism works identically for 2D as for 1D.
