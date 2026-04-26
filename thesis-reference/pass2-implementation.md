# Pass 2: LowerWithAliasMeta — Implementation Reference

**File:** `pass/lib/LowerWithAliasMetaPass.cpp`

## What It Does

A partial dialect conversion pass. Converts only the `memref.load`/`memref.store` ops tagged by Pass 1 into `llvm.load`/`llvm.store` ops with LLVM alias scope metadata attached. All untagged ops are left untouched for the standard `finalize-memref-to-llvm` pass.

## Key Design Decisions

**Partial conversion, not full conversion.** `applyPartialConversion` is used with a `ConversionTarget` that:
- Marks all ops as dynamically legal by default (`markUnknownOpDynamicallyLegal`)
- Marks `memref::LoadOp` as illegal if and only if it has `alias_meta.group_id` (dynamically legal otherwise)
- Marks `memref::StoreOp` as illegal if and only if it has `alias_meta.group_id` (dynamically legal otherwise)

This means the conversion framework only touches the tagged ops and leaves everything else alone.

**`LLVMTypeConverter` with default options.** Standard type converter from `mlir/Conversion/LLVMCommon/TypeConverter.h`. Provides `memref → llvm.struct<...>` type conversion and the adaptor mechanism.

**`ConvertOpToLLVMPattern`.** Both conversion patterns inherit from `ConvertOpToLLVMPattern<memref::LoadOp>` and `ConvertOpToLLVMPattern<memref::StoreOp>`. This provides:
- The `adaptor` with already-converted operands (memref as LLVM struct via `unrealized_conversion_cast`)
- The `getStridedElementPtr` method for address computation

**`unrealized_conversion_cast` intermediary.** Because the IR still has `memref.*` ops at this stage, the adaptor cannot immediately provide an LLVM pointer — it provides the memref as an LLVM struct, bridged by an `unrealized_conversion_cast`. These casts are resolved later by the `reconcile-unrealized-casts` pass at the end of the pipeline.

## PairScopeInfo and buildPairScopes

```cpp
struct PairScopeInfo {
  LLVM::AliasScopeDomainAttr domain;
  LLVM::AliasScopeAttr loScope;
};

static DenseMap<uint32_t, PairScopeInfo>
buildPairScopes(ModuleOp moduleOp, MLIRContext *ctx)
```

`buildPairScopes` walks the entire module, finds every op with `alias_meta.group_id`, computes `pairId = groupId / 2`, and creates one `PairScopeInfo` per unique pair. Called once before the conversion runs.

Domain and scope creation:
```cpp
auto domain  = LLVM::AliasScopeDomainAttr::get(ctx, StringAttr("pair_N_domain"));
auto loScope = LLVM::AliasScopeAttr::get(domain, StringAttr("pair_N_lo"));
```

`DistinctAttr` is used internally by `AliasScopeDomainAttr::get` to give each domain a unique identity. This is what makes scopes from different pairs produce distinct `!N` LLVM metadata nodes in the final IR — two domains with the same string label are still distinct.

## TaggedLoadLowering

```cpp
struct TaggedLoadLowering : public ConvertOpToLLVMPattern<memref::LoadOp> {
  matchAndRewrite(memref::LoadOp loadOp, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter)
```

1. Early-exit if `!loadOp->hasAttr(kAliasGroupAttr)` (should never happen given the ConversionTarget, but belt-and-suspenders).
2. Decode `pairId = groupId / 2`, `isLo = (groupId % 2 == 0)`.
3. Compute element pointer: `getStridedElementPtr(rewriter, loc, memRefType, adaptor.getMemref(), adaptor.getIndices(), kNoWrapFlags)`.
4. Create load: `LLVM::LoadOp::create(rewriter, loc, elemType, dataPtr, /*alignment=*/0)`.
5. Attach scope: if `isLo`, `setAliasScopesAttr(scopeArray)`; else `setNoaliasScopesAttr(scopeArray)`.
6. `rewriter.replaceOp(loadOp, llvmLoad.getResult())`.

## TaggedStoreLowering

Same structure as TaggedLoadLowering. After creating the `llvm.store`, calls `rewriter.eraseOp(storeOp)` (no result to replace).

## Address Computation: getStridedElementPtr

From `mlir/Conversion/LLVMCommon/Pattern.h`:
```cpp
Value getStridedElementPtr(OpBuilder &builder, Location loc,
                           MemRefType memRefType, Value memRefDesc,
                           ValueRange indices,
                           LLVM::GEPNoWrapFlags noWrapFlags)
```

Computes the linearized address:
```
base_ptr + offset + sum_i(idx_i * stride_i)
```

This correctly handles:
- Static and dynamic offsets
- Static and dynamic strides
- Multi-dimensional indexing (flattened to 1D via the stride computation)

`kNoWrapFlags = LLVM::GEPNoWrapFlags::inbounds | LLVM::GEPNoWrapFlags::nuw` — matching what `finalize-memref-to-llvm` uses internally.

## API Details for LLVM Alias Attrs (LLVM 22)

```cpp
// Create domain
LLVM::AliasScopeDomainAttr::get(ctx, StringAttr description)

// Create scope in a domain
LLVM::AliasScopeAttr::get(domain, StringAttr description)

// Attach to llvm.load (lo ops)
ArrayAttr scopeArr = ArrayAttr::get(ctx, {cast<Attribute>(loScope)});
llvmLoad.setAliasScopesAttr(scopeArr);

// Attach to llvm.load (hi ops)
llvmLoad.setNoaliasScopesAttr(scopeArr);

// Same for llvm.store
llvmStore.setAliasScopesAttr(scopeArr);
llvmStore.setNoaliasScopesAttr(scopeArr);
```

Note the exact setter names: `setAliasScopesAttr` and `setNoaliasScopesAttr` (lowercase 'a' in noalias, matching the `$noalias_scopes` TableGen field name). Using the wrong capitalization will not compile.

## Deprecated API in LLVM 22

`OpBuilder::create<OpTy>(...)` is deprecated. Use `OpTy::create(rewriter, ...)`:
```cpp
// Correct (LLVM 22):
auto llvmLoad  = LLVM::LoadOp::create(rewriter, loc, elemType, dataPtr, 0);
auto llvmStore = LLVM::StoreOp::create(rewriter, loc, value, dataPtr, 0);

// Deprecated (will warn):
auto llvmLoad  = rewriter.create<LLVM::LoadOp>(loc, elemType, dataPtr);
```

## LLVM IR Output Example

From `dynamic_split.meta.ll` after `mlir-translate`:

```llvm
; lo store (before loop)
store float 1.000000e+00, ptr %44, align 4, !alias.scope !1

; lo load (inside loop — invariant address, hoistable)
%51 = load float, ptr %50, align 4, !alias.scope !1

; hi load (inside loop)
%56 = load float, ptr %55, align 4, !noalias !1

; hi store (inside loop)
store float %57, ptr %61, align 4, !noalias !1

!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
```

This structure exactly matches the hand-written oracle files that were used to validate the thesis hypothesis.
