# Case - Typed subview offset lost at call boundary; callee cannot prove disjointness

## Kernel
`kernels/mlir/subview_call_boundary.mlir`

Intent: A caller allocates a 1024-float buffer, creates two disjoint typed subviews:
- `slice0 = A[0 .. 511]`   typed as `memref<512xf32, strided<[1]>>`        (offset 0 baked in type)
- `slice1 = A[512 .. 1023]` typed as `memref<512xf32, strided<[1], offset: 512>>` (offset 512 baked in type)

These are passed to a callee `@kernel(src, dst)` that:
- Reads `src[0]` (loop-invariant) and `src[i]` (loop-variant) each iteration.
- Stores to `dst[i]` each iteration.

The MLIR type system explicitly encodes the disjointness: `offset: 0` vs `offset: 512`.

## Baseline lowering (no explicit alias metadata)
Artifacts:
- `outputs/subview_call_boundary/subview_call_boundary.ll`
- `outputs/subview_call_boundary/subview_call_boundary.O2.ll`
- `outputs/subview_call_boundary/remarks.O2.yml`

What the lowering does with the typed offset:
The MLIR memref ABI flattens the typed `offset: 512` into an `i64` field in the struct descriptor,
NOT into the pointer itself. Both `src.aligned_ptr` and `dst.aligned_ptr` are the same malloc pointer.
Inside `@kernel`:
```llvm
define void @kernel(ptr %src_alloc, ptr %src_ptr, i64 %src_off,  ...
                    ptr %dst_alloc, ptr %dst_ptr, i64 %dst_off,  ...) {
  ; src[0] load: getelementptr float, ptr %src_ptr, i64 0
  ; dst[i] store: getelementptr float, ptr %dst_ptr, i64 (512 + i)
  ; %src_ptr and %dst_ptr are BOTH the same underlying malloc result.
}
```
LLVM receives `%src_ptr` and `%dst_ptr` as separate function parameters with NO provable relationship.
It cannot know `%dst_ptr == %src_ptr` (same allocation) OR infer the static offset from the type.
Hence it cannot rule out aliasing.

Observed behavior:
- Remarks: `licm: LoadWithLoopInvariantAddressInvalidated` (×3) - LLVM cannot hoist `src[0]`.
- Remarks: `gvn: LoadClobbered` (×1) - GVN also blocked.

## Key difference from the `subview_noalias` case
In `subview_noalias`, the two views come from **different** named subviews of the same allocation,
and the callee is explicitly `noinline`. The aliasing uncertainty is about two distinct pointers.

Here, the offset that proves disjointness (`512`) is **encoded in the MLIR type** (`offset: 512`),
but the type information is **discarded by the ABI lowering**: the aligned pointer and the offset
are stored in separate fields of the struct. The callee receives them as separate arguments and
LLVM sees no relationship between `%src_ptr` and `%dst_ptr`.

## The mechanism of information loss
| Layer              | What is known                                          |
|:-------------------|:-------------------------------------------------------|
| MLIR type system   | `memref<512xf32, strided<[1], offset: 512>>` - 512-float offset from base |
| MLIR lowering      | Struct: `{ ptr alloc, ptr aligned, i64 512, i64 512, i64 1 }` |
| LLVM function ABI  | Five separate `i64`/`ptr` arguments; offset = `i64 512` field |
| LLVM AA inside @kernel | Two `ptr` arguments with no provable relationship    |

The typed offset `512` IS passed (as `i64 %7 = 512` in the struct), but LLVM's alias analysis
does not connect this `i64` offset field with the actual pointer arithmetic inside the callee.

## Manual oracle approach
The correct oracle for this case is NOT `separate_storage` (both pointers derive from the same
allocation). Instead, the oracle should rewrite the callee to express the pointer relationship
explicitly:
```llvm
; Instead of using %dst_ptr as an independent argument,
; recompute dst_ptr from src_ptr using the known offset:
%dst_recomputed = getelementptr float, ptr %src_ptr, i64 512
; Then all dst stores: gep %dst_recomputed, i = src_ptr + 512 + i
; Now LLVM can prove: load (src_ptr + 0) vs store (src_ptr + 512 + i) - offset 512+i ≠ 0
```
Or alternatively, add `!alias.scope` / `!noalias` metadata on the src loads and dst stores,
following the same pattern as the `dynamic_split` oracle.

## Conclusion
This case demonstrates a **typed-offset loss at call boundaries**: MLIR's memref type encodes
a statically known offset (`offset: 512`) that proves two views of the same allocation are
disjoint. This information is translated by the lowering into an `i64` ABI field, but LLVM's
alias analysis has no mechanism to connect `i64` descriptor fields to pointer aliasing inside
the callee. The result is conservative aliasing and missed LICM/GVN in the callee, even though
the disjointness is structurally obvious in the MLIR type.

This is a different failure mode from the `subview_noalias` case (which is about cross-function
interprocedural alias loss) and the `dynamic_split` case (which is about dynamic offset bounds).
Here the issue is that a **static, type-level offset** is lost when the struct ABI decouples the
pointer from its typed offset.
