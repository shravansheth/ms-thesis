//===- MaterializePrefixSubviewsPass.cpp - Expose split call pairs --------===//
//
// ClangIR's memref-subview prototype can lower pointer arithmetic such as
// `work + n` into a suffix memref.subview while leaving the unoffset pointer
// argument as the original base memref:
//
//   %hi = memref.subview %work[%n] [%dim_minus_n] [1]
//   %hi_arg = memref.reinterpret_cast %hi ...
//   call @kernel(%work, %hi_arg, %n)
//
// The existing MarkAliasGroups pass needs two subviews with the same source:
//
//   %lo = memref.subview %work[0] [%n] [1]
//   %hi = memref.subview %work[%n] [%dim_minus_n] [1]
//
// This pass materializes the missing prefix subview at narrow call sites and
// rewrites the base call operand to use it, preserving the original call ABI
// type with a reinterpret_cast when needed.
//
//===----------------------------------------------------------------------===//

#include "AliasMetaPropagation/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "materialize-prefix-subviews"

namespace mlir {
namespace alias_meta {

#define GEN_PASS_DEF_MATERIALIZEPREFIXSUBVIEWS
#include "AliasMetaPropagation/Passes.h.inc"

namespace {

/// Traces through memref.cast and memref.reinterpret_cast chains to find the
/// underlying memref.subview definition for a value. Returns null if none found.
static memref::SubViewOp findSubviewDef(Value value) {
  SmallPtrSet<Value, 8> visited;
  while (value && visited.insert(value).second) {
    if (auto subview = value.getDefiningOp<memref::SubViewOp>())
      return subview;

    if (auto castOp = value.getDefiningOp<memref::CastOp>()) {
      value = castOp.getSource();
      continue;
    }

    if (auto reinterpretOp = value.getDefiningOp<memref::ReinterpretCastOp>()) {
      value = reinterpretOp.getSource();
      continue;
    }

    return nullptr;
  }

  return nullptr;
}

/// Returns true if lhs and rhs share the same element type and memory space,
/// regardless of shape or layout.
static bool sameMemRefElementAndSpace(MemRefType lhs, MemRefType rhs) {
  return lhs.getElementType() == rhs.getElementType() &&
         lhs.getMemorySpace() == rhs.getMemorySpace();
}

/// Returns true if a prefix subview of type `prefixType` (with size `prefixSize`)
/// can serve as a call argument where `callType` is expected. Handles dynamic-dim
/// and static-dim cases produced by ClangIR.
static bool isSupportedCallType(MemRefType prefixType, MemRefType callType,
                                OpFoldResult prefixSize) {
  if (prefixType == callType)
    return true;

  // Keep the prototype narrow: ClangIR currently gives us 1-D pointer-like
  // memrefs for the benchmark shapes we are targeting.
  if (prefixType.getRank() != 1 || callType.getRank() != 1)
    return false;
  if (!sameMemRefElementAndSpace(prefixType, callType))
    return false;

  int64_t callDim = callType.getDimSize(0);
  if (ShapedType::isDynamic(callDim))
    return true;

  auto staticPrefixSize = getConstantIntValue(prefixSize);
  return staticPrefixSize && *staticPrefixSize == callDim;
}

/// Materializes a prefix subview of `source` covering [0, splitPoint) and
/// returns a value typed as `originalCallOperandType`, inserting a
/// reinterpret_cast when needed to match the call ABI. Returns {} on failure.
static Value buildCallCompatiblePrefix(OpBuilder &builder, Location loc,
                                       Value source,
                                       OpFoldResult splitPoint,
                                       Type originalCallOperandType) {
  auto sourceType = dyn_cast<MemRefType>(source.getType());
  auto callType = dyn_cast<MemRefType>(originalCallOperandType);
  if (!sourceType || !callType)
    return {};

  if (sourceType.getRank() != 1 || callType.getRank() != 1)
    return {};
  if (!sameMemRefElementAndSpace(sourceType, callType))
    return {};
  if (isConstantIntValue(splitPoint, 0))
    return {};

  SmallVector<OpFoldResult> offsets{builder.getIndexAttr(0)};
  SmallVector<OpFoldResult> sizes{splitPoint};
  SmallVector<OpFoldResult> strides{builder.getIndexAttr(1)};

  auto prefixType =
      memref::SubViewOp::inferResultType(sourceType, offsets, sizes, strides);
  auto prefix = memref::SubViewOp::create(builder, loc, prefixType, source,
                                          offsets, sizes, strides);

  if (prefix.getType() == callType)
    return prefix.getResult();

  if (!isSupportedCallType(prefix.getType(), callType, splitPoint))
    return {};

  return memref::ReinterpretCastOp::create(
             builder, loc, callType, prefix.getResult(),
             builder.getIndexAttr(0), sizes, strides)
      .getResult();
}

/// Checks if `callOp` has a suffix-subview argument paired with the base memref
/// it was sliced from. If found, materializes the corresponding prefix subview
/// and rewrites the base operand to use it. Returns true if a rewrite was made.
static bool tryRewriteCall(func::CallOp callOp) {
  OperandRange operands = callOp.getArgOperands();

  for (auto [suffixIdx, suffixArg] : llvm::enumerate(operands)) {
    memref::SubViewOp suffixSubview = findSubviewDef(suffixArg);
    if (!suffixSubview)
      continue;

    auto suffixSourceType =
        dyn_cast<MemRefType>(suffixSubview.getSource().getType());
    if (!suffixSourceType || suffixSourceType.getRank() != 1)
      continue;

    SmallVector<OpFoldResult> suffixOffsets =
        suffixSubview.getMixedOffsets();
    if (suffixOffsets.size() != 1)
      continue;

    OpFoldResult splitPoint = suffixOffsets[0];
    if (isConstantIntValue(splitPoint, 0))
      continue;

    for (auto [baseIdx, baseArg] : llvm::enumerate(operands)) {
      if (baseIdx == suffixIdx || baseArg != suffixSubview.getSource())
        continue;

      OpBuilder builder(callOp);
      Value prefixArg =
          buildCallCompatiblePrefix(builder, callOp.getLoc(),
                                    suffixSubview.getSource(), splitPoint,
                                    baseArg.getType());
      if (!prefixArg)
        continue;

      callOp->setOperand(baseIdx, prefixArg);
      LLVM_DEBUG(llvm::dbgs()
                 << "Materialized prefix subview for call operand " << baseIdx
                 << " paired with suffix operand " << suffixIdx << "\n");
      return true;
    }
  }

  return false;
}

class MaterializePrefixSubviewsPass
    : public impl::MaterializePrefixSubviewsBase<
          MaterializePrefixSubviewsPass> {
public:
  void runOnOperation() override {
    ModuleOp moduleOp = getOperation();

    SmallVector<func::CallOp> calls;
    moduleOp.walk([&](func::CallOp callOp) { calls.push_back(callOp); });

    unsigned numRewritten = 0;
    for (func::CallOp callOp : calls)
      if (tryRewriteCall(callOp))
        ++numRewritten;

    LLVM_DEBUG(llvm::dbgs() << "MaterializePrefixSubviews rewrote "
                            << numRewritten << " call(s)\n");
  }
};

} // namespace
} // namespace alias_meta
} // namespace mlir
