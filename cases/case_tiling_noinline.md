# Case: `tiling_noinline` - Partition-by-Endpoint Tiling + Noinline Callee

**Kernel**: `kernels/mlir/tiling_noinline.mlir`
**Optimization missed**: LICM (invariant `src[0]` load not hoisted) + GVN in noinline callee

---

## Pattern

A flat buffer `A[4096xf32]` is split into two adjacent tiles using the partition-by-endpoint
pattern. The computation on those tiles is factored into a noinline callee `@tile_stencil`.

```mlir
// Noinline callee: sees two opaque ptr args with no provable relationship.
func.func @tile_stencil(%src: memref<?xf32, strided<[1], offset: ?>>,
                        %dst: memref<?xf32, strided<[1], offset: ?>>,
                        %N: index) attributes {no_inline} {
  scf.for %j = %c0 to %N step %c1 {
    %inv = memref.load %src[%c0]   // invariant - LLVM cannot hoist
    %x   = memref.load %src[%j]
    memref.store (x + inv), %dst[%j]
  }
}

// Caller: creates src and dst as adjacent tiles, calls @tile_stencil.
func.func @tiling_caller(%A: memref<4096xf32>, %tile: index, %N: index) {
  %src_off = arith.muli %tile, %N : index
  %src = memref.subview %A[%src_off][%N][1] ...

  %dst_off = arith.addi %src_off, %N : index   // dst.offset = src.offset + N
  %dst = memref.subview %A[%dst_off][%N][1] ...

  func.call @tile_stencil(%src, %dst, %N) { no_inline }
}
```

This case combines two structural patterns:
1. **Partition-by-endpoint** (`dynamic_split` / `adjacent_tiles`): `dst.offset = src.offset + src.size` - provable disjointness at the MLIR call site in `tiling_caller`.
2. **Noinline callee boundary** (`subview_noalias`): The disjointness proof is lost when the callee receives raw `ptr` arguments - LLVM sees nothing about the relationship between them.

This is representative of real tiling workloads where a stencil kernel is abstracted as a
library function called with adjacent tile arguments.

---

## LLVM IR After Lowering

The generated `@tile_stencil` receives 11 parameters: two full 5-tuple memref descriptors
(alloc_ptr, aligned_ptr, offset, size, stride) and the tile size `N`:

```llvm
define void @tile_stencil(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4,
                          ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10) {
  ; ...loop over j = 0..N-1:
  ; src[0]: base + src_offset + 0 - invariant, NOT hoisted
  %28 = getelementptr float, ptr %26, i64 %27   ; src_aligned + src_offset
  %30 = load float, ptr %29                      ; src[0]
  ; src[j]: base + src_offset + j
  %35 = load float, ptr %34                      ; src[j]
  ; dst[j]: base + dst_offset + j  (dst_offset = src_offset + N in caller)
  store float %36, ptr %40                       ; dst[j]
}
```

**Key**: Inside `@tile_stencil`, LLVM sees `ptr %1` (src aligned) and `ptr %6` (dst aligned)
as two arbitrary pointer arguments. There is no evidence that the regions they point into
are disjoint - the caller's structural knowledge that `dst_off = src_off + N` is carried
in `i64` struct fields, not in any alias constraint on the pointers themselves.

**Structural distinction from `subview_noalias`**: In `subview_noalias`, the disjointness is
encoded in the MLIR types (static offsets `offset: 0` vs `offset: 512`). Here, the disjointness
is established by a runtime arithmetic chain (`dst_off = muli(tile, N) + N = addi(src_off, N)`)
that the pass must track through SSA to recover the partition-by-endpoint property.

---

## Optimization Misses (Remarks)

From `remarks.O2.yml` (before oracle):

| Pass | Name | Function | Description |
|------|------|----------|-------------|
| licm | `LoadWithLoopInvariantAddressInvalidated` | `tile_stencil` | `src[0]` not hoisted |
| licm | `LoadWithLoopInvariantAddressInvalidated` | `tile_stencil` | Repeated |
| licm | `LoadWithLoopInvariantAddressInvalidated` | `tile_stencil` | Repeated |
| gvn  | `LoadClobbered` | `tile_stencil` | Redundant `src[0]` reload not eliminated |
| inline | `NeverInline` | `tiling_caller` | `tile_stencil` not inlined (correct) |

---

## Oracle

**File**: `outputs/tiling_noinline/tiling_noinline.oracle.ll`

Add `!alias.scope !2` to the `src[0]` and `src[j]` loads and `!noalias !2` to the
`dst[j]` store inside `@tile_stencil`. This encodes what the pass would emit when it:
1. Recognises the partition-by-endpoint pattern at the call site in `tiling_caller`
   (`dst_off = src_off + N = src_off + src.size`).
2. Propagates the disjointness as alias-scope metadata into the callee body.

```llvm
  %30 = load float, ptr %29, align 4, !alias.scope !2   ; src[0] - invariant
  %35 = load float, ptr %34, align 4, !alias.scope !2   ; src[j] - variant
  store float %36, ptr %40, align 4, !noalias !2         ; dst[j]

!1 = distinct !{!1, !"tiling_noinline:src_domain"}
!3 = distinct !{!3, !1, !"tiling_noinline:src_scope"}
!2 = !{!3}
```

**Result** (from `oracle.O2.yml`):
- 3× LICM `Hoisted` in `tile_stencil` (GEP, load - the invariant `src[0]` load is hoisted)
- Zero `LoadWithLoopInvariantAddressInvalidated` misses
- `NeverInline` - function remains noinline throughout
- Only misses: `VectorizationNotBeneficial` + `InterleavingNotBeneficial` (cost-model)

Optimized `@tile_stencil`:
```llvm
.lr.ph:                              ; loop preheader
  %13 = gep float, ptr %1, i64 %2   ; src base ptr
  %14 = load float, ptr %13, !alias.scope !1  ; <- src[0] hoisted here
  %15 = gep float, ptr %6, i64 %7   ; dst base ptr

16:                                  ; inner loop
  %18 = gep ... ptr %13, i64 %17   ; src[j]
  %19 = load float, ptr %18, !alias.scope !1
  %20 = fadd float %14, %19         ; src[0] (hoisted) + src[j]
  %21 = gep ... ptr %15, i64 %17   ; dst[j]
  store float %20, ptr %21, !noalias !1
```

---

## What the Pass Must Do

This case requires the pass to work across two layers simultaneously:

**Layer 1 (Caller - `tiling_caller`)**: Recognise the partition-by-endpoint pattern.
- Track `%src_off = muli(%tile, %N)` and `%dst_off = addi(%src_off, %N)`.
- Establish: `dst_off = src_off + N` and `src.size = N` -> `dst_off == src_off + src.size`.

**Layer 2 (Call site)**: Propagate the structural proof across the function boundary.
- At the `func.call @tile_stencil(%src, %dst, %N)` site, the pass knows `%src` and `%dst`
  are disjoint partitions.
- Emit `!alias.scope`/`!noalias` metadata on the callee's loads/stores for that specific call
  (similar to how `memref.distinct_objects` emits `separate_storage` at call sites).

---

## Structural Difference from `subview_noalias`

| Aspect | `subview_noalias` | `tiling_noinline` |
|--------|-------------------|-------------------|
| Disjointness proof | Static MLIR types (`offset: 0`, `offset: 512`) | Runtime arithmetic chain (`dst_off = src_off + N`) |
| Pattern | Explicit separate subregions | Partition-by-endpoint (same N) |
| Arithmetic required | None - types encode the offsets | Track `muli`/`addi` SSA chain |
| Fix mechanism | Same: `!alias.scope`/`!noalias` or `noalias` param |
| Representative of | Static kernel specialization | Dynamic tiling / streaming access patterns |

---

## Why Valid

1. The pass has concrete structural evidence at the MLIR call site: `dst_off` is expressible
   as `src_off + N` via traceable SSA (`muli`, `addi`), and `src.size = N`.
2. The partition-by-endpoint proof is sound: in any execution where the callee's loop runs
   (j < N), `N >= 1` is implied - but the pass doesn't need this; structural SSA identity suffices.
3. The noinline callee is a common real-world pattern (library kernels, stencil abstractions).
4. The `!alias.scope`/`!noalias` mechanism is semantically correct for subregions of the
   same allocation and produces the correct optimization.
