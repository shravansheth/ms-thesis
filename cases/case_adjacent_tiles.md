# Case: `adjacent_tiles` — Adjacent Tiling (Partition-by-Endpoint via Arithmetic)

**Kernel**: `kernels/mlir/adjacent_tiles.mlir`
**Optimization missed**: LICM (invariant `src[0]` load not hoisted) + GVN

---

## Pattern

A flat 1D buffer `A[4096xf32]` is partitioned into two adjacent tiles of size `N` using
a dynamic tile index. The source tile is `A[tile*N .. (tile+1)*N - 1]` and the destination
tile is `A[(tile+1)*N .. (tile+2)*N - 1]`. The tile-to-tile copy reads `src[0]` (invariant)
and `src[j]` inside the loop and stores `src[j] + src[0]` into `dst[j]`.

```mlir
%src_off = arith.muli %tile, %N : index
%src = memref.subview %A[%src_off][%N][1]
  : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>

%dst_off = arith.addi %src_off, %N : index    // ← dst.offset = src.offset + N
%dst = memref.subview %A[%dst_off][%N][1]
  : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>

scf.for %j = %c0 to %N step %c1 {
  %inv = memref.load %src[%c0]   // invariant: src[0] = A[tile*N]
  %x   = memref.load %src[%j]
  %y   = arith.addf %x, %inv : f32
  memref.store %y, %dst[%j]
}
```

**Key structural fact**: `dst.offset = src.offset + N = src.offset + src.size`.
This is the same *partition-by-endpoint* pattern as `dynamic_split`, but the endpoint
is derived via `arith.muli` + `arith.addi` rather than being a raw SSA identity. At MLIR
level, disjointness is structurally provable from these offset relationships.

---

## LLVM IR After Lowering

After lowering through the standard pipeline:

```llvm
define void @adjacent_tiles(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6) {
  ; %5 = tile*N (src_off),  %6 = N,  %14 = (tile+1)*N (dst_off)
  %13 = mul i64 %5, %6        ; src_off = tile * N
  %14 = add i64 %13, %6       ; dst_off = src_off + N

  ; loop over j = 0..N-1:
  %20 = gep ptr %19, i64 %13        ; src[0] pointer = base + tile*N
  %21 = load float, ptr %20         ; ← invariant load, NOT hoisted
  %22 = add i64 %13, %16            ; src[j] = tile*N + j
  %24 = gep ptr %23, i64 %22
  %25 = load float, ptr %24         ; src[j] load
  %27 = add i64 %14, %16            ; dst[j] = (tile+1)*N + j
  %29 = gep ptr %28, i64 %27
  store float %26, ptr %29          ; ← store to dst[j]
}
```

LLVM sees loads from `(base + tile*N + 0)` and a store to `(base + tile*N + N + j)`.
To prove non-aliasing, LLVM needs `N > 0`. It has no basis to assume this — `N` is a
runtime argument and could be 0.

**Surprising finding**: LLVM does NOT use the inner-loop exit condition `j < N` to derive
`N > 0`. LICM reasons at the preheader level — before the loop is known to execute — so it
cannot use the loop-entry condition to constrain `N`.

---

## Optimization Misses (Remarks)

From `remarks.O2.yml`:

| Pass | Miss Name | Description |
|------|-----------|-------------|
| licm | `LoadWithLoopInvariantAddressInvalidated` | `src[0]` load not hoisted — may alias `dst[j]` store |
| licm | `LoadWithLoopInvariantAddressInvalidated` | Repeated — conservative alias for each invalidation check |
| gvn  | `LoadClobbered` | `src[0]` reload not eliminated — same aliasing uncertainty |

---

## Oracle

**File**: `outputs/adjacent_tiles/adjacent_tiles.oracle.ll`

Add `!alias.scope !2` to the `src[0]` and `src[j]` loads and `!noalias !2` to the
`dst[j]` store. The scope encodes the MLIR structural fact that `src` and `dst` are
non-overlapping partitions of the same buffer.

```llvm
  %21 = load float, ptr %20, align 4, !alias.scope !2   ; src[0] — invariant
  %25 = load float, ptr %24, align 4, !alias.scope !2   ; src[j] — variant
  store float %26, ptr %29, align 4, !noalias !2         ; dst[j]

; Metadata:
!1 = distinct !{!1, !"adjacent_tiles:src_domain"}
!3 = distinct !{!3, !1, !"adjacent_tiles:src_scope"}
!2 = !{!3}
```

**Result**: LICM hoists the `src[0]` load to the loop preheader; GVN eliminates the
redundant reload. The optimized loop body reduces to `dst[j] = src[j] + src[0]` with
`src[0]` a pre-hoisted constant.

---

## What the Pass Must Recognise

The pass recognises the partition-by-endpoint pattern even when the endpoint is derived
via arithmetic:
- `%src_off = arith.muli %tile, %N` → LLVM `mul i64 %tile, %N`
- `%dst_off = arith.addi %src_off, %N` → LLVM `add i64 %src_off, %N`

The SSA chain `dst_off = src_off + N` and `src.size = N` establishes:
`dst_off == src_off + src_size` → partition-by-endpoint → disjoint.

No runtime bounds on `N` are needed. In any well-defined MLIR program where the loop body
executes (`j < N` is true), `N >= 1` is implied — but the pass doesn't rely on this. The
structural proof is sufficient: any overlap between `src` and `dst` accesses implies UB
in the original MLIR program.

---

## Why Valid

The pass has concrete, inspectable structural evidence at the MLIR level:
1. Both subviews are derived from the same base memref `%A`.
2. `dst.offset` is the SSA result of `addi(src_offset, src_size)` — partition-by-endpoint.
3. The arithmetic chain (`muli` + `addi`) is expressible in LLVM IR terms and can be
   tracked by the pass during lowering.

The fix (`!alias.scope`/`!noalias`) is the correct mechanism: `src` and `dst` are
disjoint regions within the same allocation, not separate allocations, so `noalias` on
function parameters or `separate_storage` would be incorrect.
