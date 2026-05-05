//===- LowerWithAliasMetaPass.cpp - Targeted lowering with alias metadata --===//
//
// Pass 2 of the alias metadata propagation pipeline.
//
// Converts memref.load/store ops that carry alias_meta.group_id / alias_meta.role
// discardable attributes (produced by Pass 1, MarkAliasGroups) into
// llvm.load/llvm.store ops with LLVM alias-scope / noalias-scope metadata.
//
// Design:
//   - Runs BEFORE finalize-memref-to-llvm (while memref.subview semantics exist).
//   - Uses applyPartialConversion with LLVMTypeConverter so that only the
//     tagged ops are lowered; the rest are left for standard passes.
//   - For each disjoint pair N (group IDs 2N / 2N+1):
//       * One AliasScopeDomainAttr is created.
//       * One AliasScopeAttr (lo scope) is created in that domain.
//       * lo-region loads/stores  -> alias_scopes    = [lo_scope]
//       * hi-region loads/stores  -> noalias_scopes  = [lo_scope]
//   This mirrors the manual oracle structure validated in the case studies.
//
//===----------------------------------------------------------------------===//

#include "AliasMetaPropagation/Passes.h"

#include "mlir/Conversion/LLVMCommon/LoweringOptions.h"
#include "mlir/Conversion/LLVMCommon/MemRefBuilder.h"
#include "mlir/Conversion/LLVMCommon/Pattern.h"
#include "mlir/Conversion/LLVMCommon/TypeConverter.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/LLVMIR/LLVMAttrs.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Transforms/DialectConversion.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "lower-with-alias-meta"

namespace mlir {
namespace alias_meta {

#define GEN_PASS_DEF_LOWERWITHALIASMETA
#include "AliasMetaPropagation/Passes.h.inc"

namespace {

// Alias scope info per disjoint pair

struct PairScopeInfo {
  LLVM::AliasScopeDomainAttr domain;
  LLVM::AliasScopeAttr loScope; // lo region scope; hi region noaliases it
};

// Helper: build alias scope attributes for all pairs seen in the module

/// Builds alias scope attributes for every disjoint pair seen in the module.
/// One AliasScopeDomainAttr and one AliasScopeAttr (lo scope) per pair.
static DenseMap<uint32_t, PairScopeInfo>
buildPairScopes(ModuleOp moduleOp, MLIRContext *ctx) {
  DenseMap<uint32_t, PairScopeInfo> pairScopes;

  moduleOp.walk([&](Operation *op) {
    if (!op->hasAttr(kAliasGroupAttr))
      return;
    auto groupId =
        cast<IntegerAttr>(op->getAttr(kAliasGroupAttr)).getValue().getZExtValue();
    uint32_t pairId = static_cast<uint32_t>(groupId) / 2;
    if (pairScopes.count(pairId))
      return;

    // Create a fresh domain and lo scope for this pair.
    auto domainDesc = StringAttr::get(
        ctx, llvm::Twine("pair_") + llvm::Twine(pairId) + "_domain");
    auto scopeDesc = StringAttr::get(
        ctx, llvm::Twine("pair_") + llvm::Twine(pairId) + "_lo");

    auto domain = LLVM::AliasScopeDomainAttr::get(ctx, domainDesc);
    auto loScope = LLVM::AliasScopeAttr::get(domain, scopeDesc);

    pairScopes.insert({pairId, {domain, loScope}});
    LLVM_DEBUG(llvm::dbgs() << "  Created scope for pair " << pairId
                             << ": domain=" << domain << "\n");
  });
  return pairScopes;
}

// Conversion patterns

static constexpr LLVM::GEPNoWrapFlags kNoWrapFlags =
    LLVM::GEPNoWrapFlags::inbounds | LLVM::GEPNoWrapFlags::nuw;

/// Shared helper: get (pairId, isLo) from an op's alias_meta attrs.
static std::pair<uint32_t, bool> getPairInfo(Operation *op) {
  auto groupId =
      cast<IntegerAttr>(op->getAttr(kAliasGroupAttr)).getValue().getZExtValue();
  uint32_t pairId = static_cast<uint32_t>(groupId) / 2;
  bool isLo = (groupId % 2 == 0);
  return {pairId, isLo};
}

/// Lower a tagged memref.load -> llvm.load with alias scope metadata.
struct TaggedLoadLowering : public ConvertOpToLLVMPattern<memref::LoadOp> {
  TaggedLoadLowering(const LLVMTypeConverter &tc,
                     const DenseMap<uint32_t, PairScopeInfo> &scopes)
      : ConvertOpToLLVMPattern(tc), pairScopes(scopes) {}

  LogicalResult
  matchAndRewrite(memref::LoadOp loadOp, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    if (!loadOp->hasAttr(kAliasGroupAttr))
      return failure();

    auto [pairId, isLo] = getPairInfo(loadOp.getOperation());
    Location loc = loadOp.getLoc();
    MemRefType memRefType = loadOp.getMemRefType();

    // Compute element pointer (handles strided/offset layouts).
    Value dataPtr = getStridedElementPtr(rewriter, loc, memRefType,
                                         adaptor.getMemref(),
                                         adaptor.getIndices(), kNoWrapFlags);

    Type elemType =
        typeConverter->convertType(memRefType.getElementType());
    auto llvmLoad = LLVM::LoadOp::create(rewriter, loc, elemType, dataPtr,
                                          /*alignment=*/0);

    // Attach alias scope metadata.
    const PairScopeInfo &info = pairScopes.at(pairId);
    ArrayAttr scopeArray =
        ArrayAttr::get(rewriter.getContext(), {cast<Attribute>(info.loScope)});
    if (isLo)
      llvmLoad.setAliasScopesAttr(scopeArray);
    else
      llvmLoad.setNoaliasScopesAttr(scopeArray);

    // Remove the alias_meta attrs from the new op (they're discardable on the
    // LLVM op but don't belong there — we've encoded them as proper metadata).
    rewriter.replaceOp(loadOp, llvmLoad.getResult());

    LLVM_DEBUG(llvm::dbgs()
               << "  Lowered tagged load: pair=" << pairId
               << (isLo ? " lo->alias_scopes" : " hi->noalias_scopes") << "\n");
    return success();
  }

private:
  const DenseMap<uint32_t, PairScopeInfo> &pairScopes;
};

/// Lower a tagged memref.store -> llvm.store with alias scope metadata.
struct TaggedStoreLowering : public ConvertOpToLLVMPattern<memref::StoreOp> {
  TaggedStoreLowering(const LLVMTypeConverter &tc,
                      const DenseMap<uint32_t, PairScopeInfo> &scopes)
      : ConvertOpToLLVMPattern(tc), pairScopes(scopes) {}

  LogicalResult
  matchAndRewrite(memref::StoreOp storeOp, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    if (!storeOp->hasAttr(kAliasGroupAttr))
      return failure();

    auto [pairId, isLo] = getPairInfo(storeOp.getOperation());
    Location loc = storeOp.getLoc();
    MemRefType memRefType = storeOp.getMemRefType();

    Value dataPtr = getStridedElementPtr(rewriter, loc, memRefType,
                                         adaptor.getMemref(),
                                         adaptor.getIndices(), kNoWrapFlags);

    auto llvmStore = LLVM::StoreOp::create(rewriter, loc, adaptor.getValue(),
                                           dataPtr, /*alignment=*/0);

    const PairScopeInfo &info = pairScopes.at(pairId);
    ArrayAttr scopeArray =
        ArrayAttr::get(rewriter.getContext(), {cast<Attribute>(info.loScope)});
    if (isLo)
      llvmStore.setAliasScopesAttr(scopeArray);
    else
      llvmStore.setNoaliasScopesAttr(scopeArray);

    rewriter.eraseOp(storeOp);

    LLVM_DEBUG(llvm::dbgs()
               << "  Lowered tagged store: pair=" << pairId
               << (isLo ? " lo->alias_scopes" : " hi->noalias_scopes") << "\n");
    return success();
  }

private:
  const DenseMap<uint32_t, PairScopeInfo> &pairScopes;
};

// Pass

class LowerWithAliasMetaPass
    : public impl::LowerWithAliasMetaBase<LowerWithAliasMetaPass> {
public:
  void runOnOperation() override {
    ModuleOp moduleOp = getOperation();
    MLIRContext *ctx   = &getContext();

    LLVM_DEBUG(llvm::dbgs() << "=== LowerWithAliasMeta: begin ===\n");

    // Build alias scope attrs for every disjoint pair seen in the module.
    DenseMap<uint32_t, PairScopeInfo> pairScopes = buildPairScopes(moduleOp, ctx);

    if (pairScopes.empty()) {
      LLVM_DEBUG(llvm::dbgs() << "  No tagged ops found, nothing to do.\n");
      return;
    }

    // Configure type converter with default options.
    LowerToLLVMOptions options(ctx);
    LLVMTypeConverter typeConverter(ctx, options);

    // Conversion target: tagged loads/stores must be lowered; everything else
    // is legal as-is (we are doing a partial conversion).
    ConversionTarget target(*ctx);
    target.markUnknownOpDynamicallyLegal([](Operation *) { return true; });
    target.addDynamicallyLegalOp<memref::LoadOp>([](memref::LoadOp op) {
      return !op->hasAttr(kAliasGroupAttr);
    });
    target.addDynamicallyLegalOp<memref::StoreOp>([](memref::StoreOp op) {
      return !op->hasAttr(kAliasGroupAttr);
    });

    // Add conversion patterns.
    RewritePatternSet patterns(ctx);
    patterns.add<TaggedLoadLowering>(typeConverter, pairScopes);
    patterns.add<TaggedStoreLowering>(typeConverter, pairScopes);

    if (failed(applyPartialConversion(moduleOp, target, std::move(patterns)))) {
      moduleOp.emitError("LowerWithAliasMeta: partial conversion failed");
      signalPassFailure();
      return;
    }

    LLVM_DEBUG(llvm::dbgs() << "=== LowerWithAliasMeta: done ("
                             << pairScopes.size() << " pair(s)) ===\n");
  }
};

} // namespace
} // namespace alias_meta
} // namespace mlir
