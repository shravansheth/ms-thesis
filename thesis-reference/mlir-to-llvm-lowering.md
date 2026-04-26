# MLIR-to-LLVM Lowering Reference

## The Information Loss Problem

MLIR's `memref` type system encodes rich structural information about memory regions: base pointer, element type, offset from base, per-dimension sizes, and per-dimension strides. A `memref.subview` makes the partition structure of a buffer explicit at the type level and in the IR semantics. During lowering to LLVM IR, this structure is decomposed into flat pointer arithmetic: individual `i64` values for the offset, sizes, and strides, and raw `ptr` values for the base. LLVM sees GEP arithmetic from a shared base pointer with runtime `i64` operands. The structural disjointness proof — which was self-evident at the MLIR level — must be re-derived by LLVM from pointer arithmetic alone, and in the dynamic-offset case, LLVM cannot.

## memref ABI in LLVM IR

A memref value in LLVM IR is passed and stored as a struct:
```
{ ptr alloc_ptr, ptr aligned_ptr, i64 offset, i64 size_0, ..., i64 stride_0, ... }
```

For `memref<?xf32>` (1D, dynamic size, unit stride):
```llvm
{ ptr, ptr, i64, i64, i64 }
 ↑     ↑    ↑    ↑    ↑
 alloc align off  sz   str
```

For `memref<?x512xf32>` (2D, dynamic rows, static 512 cols):
```llvm
{ ptr, ptr, i64, i64, i64, i64, i64 }
 alloc align off  sz0  sz1  str0 str1
```

**Key facts:**
- `aligned_ptr` is the base pointer used for GEP arithmetic. Both `lo` and `hi` subviews of the same allocation share the same `aligned_ptr` value.
- The subview offset is in the `i64 offset` field, not in the pointer.
- After `expand-strided-metadata` and `finalize-memref-to-llvm`, the struct fields are extracted as individual `i64` SSA values and used in GEP computations.

## What memref.subview Lowers To

MLIR `memref.subview %A[%off][%sz][%str]` produces a new memref value with:
- Same `alloc_ptr` and `aligned_ptr` as the parent
- `offset = parent.offset + %off * parent.stride` (accumulated)
- `size = %sz`
- `stride = parent.stride * %str`

After lowering: both the parent and the subview have the same `aligned_ptr` pointer value. The offset into the subview is an `i64` added to the GEP index at each load/store. LLVM sees two GEP expressions from the same base pointer; it cannot prove they are disjoint without knowing the relationship between their `i64` offsets.

## Static vs Dynamic Offsets: What Survives

**Static offset (e.g., `memref.subview %A[512][512][1]`):**

The offset 512 may be:
- Baked into the `i64 offset` field as a constant (LLVM can use this for GEP constant folding)
- Or folded directly into the pointer by `fold-memref-alias-ops` if the parent also has a static offset

In LLVM 22, when both offsets are fully static and non-overlapping constants, LLVM can prove disjointness via BasicAA/SCEV. This is why the `case_memref_subview_static` case was invalidated — LLVM 22 handles it without our pass.

**Dynamic offset (e.g., `memref.subview %A[%n][%sz][1]`):**

The offset `%n` becomes an `i64` argument to the GEP computation:
```llvm
%gep = getelementptr float, ptr %aligned, i64 %offset_plus_n
```
LLVM sees an arbitrary `i64` being added to the pointer. Without a lower bound on `%n`, LLVM cannot rule out overlap with accesses at offset 0.

## memref.cast and Its Effect

`memref.cast` changes the memref type (e.g., strips static offset/size information) without changing the runtime values. After lowering, it is a no-op — the same struct fields are passed through unchanged.

In the `subview_noalias` kernel, the caller casts static-offset subviews to dynamic-offset memrefs before the call:
```mlir
%p = memref.cast %slice0
  : memref<512xf32, strided<[1], offset: 0>>   →
    memref<?xf32, strided<[1], offset: ?>>
```
After lowering, this means the callee receives the `aligned_ptr` for `%A` with a runtime `i64 offset` (which happens to be 0 or 512), but LLVM treats these as opaque — it does not reconstruct the original constant offsets from the struct fields in a way that helps alias analysis.

## The Pipeline Passes and What They Do

From `run_pipeline_cpu.sh`:

| Pass | What it does |
|---|---|
| `-convert-scf-to-cf` | Lowers `scf.for`/`scf.if` to branch-based control flow |
| `-memref-expand` | Expands complex memref ops (e.g., `memref.atomic_rmw`) to simpler ones |
| `-fold-memref-alias-ops` | Folds chains of `subview`/`cast` into single ops where possible |
| `-expand-strided-metadata` | Extracts offset/size/stride fields from memref descriptors into scalar SSA values |
| `-lower-affine` | Lowers affine dialect maps and loops |
| `-convert-arith-to-llvm` | Converts `arith` ops to `llvm` dialect equivalents |
| `-convert-index-to-llvm` | Converts `index` type ops to `i64` equivalents |
| `-convert-math-to-llvm` | Converts `math` ops to LLVM intrinsics |
| `-convert-cf-to-llvm` | Converts branch/block ops to `llvm.br`/`llvm.cond_br` |
| `-convert-func-to-llvm` | Converts `func.func`/`func.call` to LLVM calling convention |
| `-finalize-memref-to-llvm` | Final lowering of `memref.alloc`/`memref.load`/`memref.store` to `llvm.*` |
| `-reconcile-unrealized-casts` | Removes `unrealized_conversion_cast` bridge ops |

`-expand-strided-metadata` is particularly important: it is what decomposes memref descriptor fields into individual `i64` values before the final lowering. Our Pass 2 inserts its lowering before `-finalize-memref-to-llvm` processes the untagged ops, but after our tagged ops are already converted.

## Why Our Pass Must Run Before finalize-memref-to-llvm

`finalize-memref-to-llvm` converts `memref.load`/`memref.store` to `llvm.load`/`llvm.store`. The conversion framework creates fresh `llvm.*` ops without copying discardable attributes from the source ops. Verified empirically: attaching `{alias_meta.group_id = 0 : i32}` to a `memref.load` and running `finalize-memref-to-llvm` produces a plain `llvm.load` with no attributes.

Our Pass 2 must therefore handle the tagged `memref.load`/`memref.store` ops *before* `finalize-memref-to-llvm` runs. It uses `applyPartialConversion` to convert only the tagged ops, leaving the rest for the standard pass.

## no_inline Attribute

MLIR's `no_inline` attribute on a `func.func` lowers to LLVM's `noinline` function attribute. The call-site `no_inline` attribute (on `func.call`) is MLIR-specific and does not directly lower — it is consumed by analyses (including our pass) before lowering.

After lowering:
```llvm
define void @tile_stencil(...) #0 { ... }
attributes #0 = { noinline ... }
```

LLVM's inliner respects `noinline` and does not inline the callee, so the alias metadata on individual loads/stores inside the clone is the only mechanism available.
