//===- MarkAliasGroupsPass.cpp - Detect disjoint subview pairs-===//
//
// Pass 1 of the alias metadata propagation pipeline.
//
// Walks memref.subview ops, detects partition-by-endpoint disjoint pairs,
// and tags memref.load/store ops with discardable alias-group attributes.
//
// Partition-by-endpoint: two subviews (lo, hi) of the same buffer are disjoint
// when  hi.offset[d] == lo.offset[d] + lo.size[d]  for the split dimension d.
//
// Three structural forms detected:
//   A. Direct SSA identity:  hi.offset is lo.size (same Value), lo.offset == 0
//   B. arith.addi chain:     hi.offset = addi(lo.offset, lo.size)
//   C. Constant arithmetic:  all three are compile-time constants that satisfy
//                            hi_off == lo_off + lo_size
//
// For noinline callees: when a disjoint subview pair is passed as call args,
// the corresponding loads/stores inside the callee are tagged directly.
//
// Output attributes (discardable, no custom dialect needed):
//   alias_meta.group_id  - IntegerAttr(i32): even=lo, odd=hi of pair N (2N/2N+1)
//   alias_meta.role      - StringAttr: "lo" or "hi"
//
//===----------------------------------------------------------------------===//

#include "AliasMetaPropagation/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/IR/OperationSupport.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "mark-alias-groups"

namespace mlir {
namespace alias_meta {

#define GEN_PASS_DEF_MARKALIASGROUPS
#include "AliasMetaPropagation/Passes.h.inc"

namespace {

// Helpers

/// Attach the alias-group marker attributes to an op.
static void tagOp(Operation *op, uint32_t groupId, StringRef role,
                  MLIRContext *ctx) {
  op->setDiscardableAttr(
      kAliasGroupAttr,
      IntegerAttr::get(IntegerType::get(ctx, 32), groupId));
  op->setDiscardableAttr(kAliasRoleAttr, StringAttr::get(ctx, role));
  LLVM_DEBUG(llvm::dbgs() << "  Tagged [group=" << groupId << " role=" << role
                           << "]: " << *op << "\n");
}

/// Returns true if the call is marked noinline (call-site or callee attr).
static bool isNoinlineCall(func::CallOp callOp, ModuleOp moduleOp) {
  if (callOp->hasAttr("no_inline"))
    return true;
  if (auto *callee = moduleOp.lookupSymbol(callOp.getCallee()))
    return callee->hasAttr("no_inline");
  return false;
}

/// Check partition-by-endpoint in one dimension:
///   hi.offset[d] == lo.offset[d] + lo.size[d]
///
/// Handles three forms:
///   A. hi_off is same SSA Value as lo_size, and lo_off is constant 0
///   B. hi_off = arith.addi(lo_off, lo_size)
///   C. all three are compile-time constants satisfying the equation
static bool isPartitionByEndpointDim(memref::SubViewOp lo,
                                     memref::SubViewOp hi, unsigned dim) {
  SmallVector<OpFoldResult> loOffsets = lo.getMixedOffsets();
  SmallVector<OpFoldResult> loSizes   = lo.getMixedSizes();
  SmallVector<OpFoldResult> hiOffsets = hi.getMixedOffsets();

  if (dim >= loOffsets.size() || dim >= hiOffsets.size() ||
      dim >= loSizes.size())
    return false;

  OpFoldResult loOff  = loOffsets[dim];
  OpFoldResult loSize = loSizes[dim];
  OpFoldResult hiOff  = hiOffsets[dim];

  // ---- Case A: hi.off IS lo.size (same Value), lo.off == 0 ---------------
  if (isConstantIntValue(loOff, 0)) {
    // Same SSA value
    if (hiOff == loSize)
      return true;
    // Same constant value (e.g., both are IntegerAttr(512))
    auto hc = getConstantIntValue(hiOff);
    auto sc = getConstantIntValue(loSize);
    if (hc && sc && *hc == *sc)
      return true;
  }

  // ---- Case B: hi.off = arith.addi(lo.off, lo.size) ----------------------
  if (auto hiVal = dyn_cast<Value>(hiOff)) {
    if (auto addOp = hiVal.getDefiningOp<arith::AddIOp>()) {
      if (auto loOffVal = dyn_cast<Value>(loOff)) {
        if (auto loSzVal = dyn_cast<Value>(loSize)) {
          Value lhs = addOp.getLhs(), rhs = addOp.getRhs();
          if ((lhs == loOffVal && rhs == loSzVal) ||
              (lhs == loSzVal  && rhs == loOffVal))
            return true;
        }
      }
    }
  }

  // ---- Case C: all compile-time constants ---------------------------------
  auto hc  = getConstantIntValue(hiOff);
  auto loc = getConstantIntValue(loOff);
  auto sc  = getConstantIntValue(loSize);
  if (hc && loc && sc && *hc == *loc + *sc)
    return true;

  return false;
}

/// Check whether (lo, hi) form a partition-by-endpoint pair.
/// A split in any dimension is sufficient: if one projected interval is
/// adjacent and non-overlapping, the full subview regions are disjoint.
static bool isPartitionByEndpoint(memref::SubViewOp lo,
                                  memref::SubViewOp hi) {
  if (lo.getSource() != hi.getSource())
    return false;
  if (lo.getMixedOffsets().size() != hi.getMixedOffsets().size())
    return false;

  for (unsigned dim = 0, e = lo.getMixedOffsets().size(); dim < e; ++dim)
    if (isPartitionByEndpointDim(lo, hi, dim))
      return true;

  return false;
}

static bool sameIndexValue(Value a, Value b) {
  if (a == b)
    return true;
  auto aConst = a.getDefiningOp<arith::ConstantIndexOp>();
  auto bConst = b.getDefiningOp<arith::ConstantIndexOp>();
  return aConst && bConst && aConst.value() == bConst.value();
}

static bool sameIndices(ValueRange lhs, ValueRange rhs) {
  if (lhs.size() != rhs.size())
    return false;
  for (auto [a, b] : llvm::zip_equal(lhs, rhs))
    if (!sameIndexValue(a, b))
      return false;
  return true;
}

/// Walk all uses of `startVal`, tagging memref.load/store ops with the given
/// group ID and role. Follows view-preserving memref cast chains. For noinline
/// func.call ops, clones the callee (once per call site) and tags the clone's
/// loads/stores.
///
/// `callSiteClones` maps a func.call Operation* to its already-created clone,
/// ensuring that when both lo and hi tagUsesOfValue calls hit the same call
/// site, they share the SAME clone instead of creating two separate ones.
/// `cloneCounter` provides monotonically-increasing integers for unique names.
static void tagUsesOfValue(Value startVal, uint32_t groupId, StringRef role,
                           MLIRContext *ctx, ModuleOp moduleOp,
                           DenseMap<Operation *, func::FuncOp> &callSiteClones,
                           uint32_t &cloneCounter) {
  SmallVector<Value> worklist = {startVal};
  SmallPtrSet<Value, 8> visited;

  while (!worklist.empty()) {
    Value v = worklist.pop_back_val();
    if (!visited.insert(v).second)
      continue;

    for (Operation *user : v.getUsers()) {
      // Direct load/store: tag it.
      if (auto loadOp = dyn_cast<memref::LoadOp>(user)) {
        if (loadOp.getMemref() == v)
          tagOp(user, groupId, role, ctx);
        continue;
      }
      if (auto storeOp = dyn_cast<memref::StoreOp>(user)) {
        if (storeOp.getMemref() == v) {
          tagOp(user, groupId, role, ctx);
          continue;
        }

        // ClangIR often stores pointer/memref arguments into one-slot allocas
        // and reloads them inside the loop. Follow that descriptor traffic so
        // the actual memory accesses through the reloaded memref are tagged.
        if (storeOp.getValue() == v && isa<MemRefType>(v.getType())) {
          Value slot = storeOp.getMemref();
          for (Operation *slotUser : slot.getUsers()) {
            auto reload = dyn_cast<memref::LoadOp>(slotUser);
            if (!reload || reload.getMemref() != slot)
              continue;
            if (!sameIndices(storeOp.getIndices(), reload.getIndices()))
              continue;
            worklist.push_back(reload.getResult());
          }
        }
        continue;
      }

      // Cast: follow through to the cast result.
      if (auto castOp = dyn_cast<memref::CastOp>(user)) {
        worklist.push_back(castOp.getResult());
        continue;
      }

      // Reinterpret cast: ClangIR uses this to pass strided subviews to
      // callees whose pointer-like ABI type is an identity-layout memref.
      if (auto reinterpretOp = dyn_cast<memref::ReinterpretCastOp>(user)) {
        worklist.push_back(reinterpretOp.getResult());
        continue;
      }

      // Subview: any access through a subview of an already-proven region is
      // still within that region.
      if (auto subviewOp = dyn_cast<memref::SubViewOp>(user)) {
        if (subviewOp.getSource() == v)
          worklist.push_back(subviewOp.getResult());
        continue;
      }

      // Noinline call: clone the callee (once per call site) and tag the
      // clone's argument uses. This avoids the soundness bug of tagging the
      // original callee, which would affect ALL call sites (even those where
      // the disjointness property does not hold).
      if (auto callOp = dyn_cast<func::CallOp>(user)) {
        if (!isNoinlineCall(callOp, moduleOp))
          continue;

        // Look up the callee (using the CURRENT callee name, which may
        // already point to a previously-created clone from the other role).
        auto *calleeSym = moduleOp.lookupSymbol(callOp.getCallee());
        auto calleeFn = dyn_cast_or_null<func::FuncOp>(calleeSym);
        if (!calleeFn)
          continue;

        // Get-or-create a clone for this specific call site.
        func::FuncOp clonedFn;
        Operation *callOpKey = callOp.getOperation();
        auto it = callSiteClones.find(callOpKey);
        if (it != callSiteClones.end()) {
          clonedFn = it->second;
        } else {
          // Clone the callee (copies the entire function body).
          clonedFn = calleeFn.clone();
          // Unique name: original_name.__alias_meta_N
          std::string cloneName =
              (calleeFn.getName() + ".__alias_meta_" +
               llvm::Twine(cloneCounter++))
                  .str();
          clonedFn.setName(cloneName);
          // Insert the clone into the module (after the original).
          calleeFn->getParentOp()
              ->getRegion(0)
              .getBlocks()
              .front()
              .push_back(clonedFn);
          // Redirect this call site to the clone.
          callOp.setCallee(cloneName);
          callSiteClones[callOpKey] = clonedFn;
          LLVM_DEBUG(llvm::dbgs()
                     << "  Cloned callee " << calleeFn.getName() << " -> "
                     << cloneName << "\n");
        }

        // Tag the clone's argument uses (not the original callee's).
        for (auto [idx, arg] : llvm::enumerate(callOp.getArgOperands())) {
          if (arg != v)
            continue;
          if (idx >= clonedFn.getNumArguments())
            continue;
          BlockArgument cloneArg = clonedFn.getArgument(idx);
          if (!isa<MemRefType>(cloneArg.getType()))
            continue;
          tagUsesOfValue(cloneArg, groupId, role, ctx, moduleOp,
                         callSiteClones, cloneCounter);
        }
      }
    }
  }
}

// Pass

class MarkAliasGroupsPass
    : public impl::MarkAliasGroupsBase<MarkAliasGroupsPass> {
public:
  void runOnOperation() override {
    ModuleOp moduleOp = getOperation();
    MLIRContext *ctx  = &getContext();
    uint32_t nextPairId = 0;

    // Track clones created for noinline call sites. Shared across all
    // tagUsesOfValue calls so that when both lo and hi of a disjoint pair
    // are passed through the same call site, they share the same clone.
    DenseMap<Operation *, func::FuncOp> callSiteClones;
    uint32_t cloneCounter = 0;

    LLVM_DEBUG(llvm::dbgs() << "=== MarkAliasGroups: begin ===\n");

    // Walk every function in the module.
    moduleOp.walk([&](func::FuncOp funcOp) {
      LLVM_DEBUG(llvm::dbgs() << "  Function: " << funcOp.getName() << "\n");

      // Collect all subview ops grouped by their source (base) memref.
      DenseMap<Value, SmallVector<memref::SubViewOp>> byBase;
      funcOp.walk([&](memref::SubViewOp sv) {
        byBase[sv.getSource()].push_back(sv);
      });

      // For each base memref, try all (lo, hi) pairs.
      for (auto &[base, svs] : byBase) {
        if (svs.size() < 2)
          continue;

        for (size_t i = 0; i < svs.size(); ++i) {
          for (size_t j = i + 1; j < svs.size(); ++j) {
            memref::SubViewOp a = svs[i], b = svs[j];
            memref::SubViewOp lo, hi;

            if (isPartitionByEndpoint(a, b)) {
              lo = a; hi = b;
            } else if (isPartitionByEndpoint(b, a)) {
              lo = b; hi = a;
            } else {
              continue;
            }

            uint32_t loId = 2 * nextPairId;
            uint32_t hiId = 2 * nextPairId + 1;
            nextPairId++;

            LLVM_DEBUG(llvm::dbgs()
                       << "  Disjoint pair " << nextPairId - 1
                       << ": lo=" << lo.getLoc()
                       << " hi=" << hi.getLoc() << "\n");

            // Tag all uses of lo (including into callees via cloning).
            tagUsesOfValue(lo.getResult(), loId, "lo", ctx, moduleOp,
                           callSiteClones, cloneCounter);
            // Tag all uses of hi (including into callees via cloning).
            tagUsesOfValue(hi.getResult(), hiId, "hi", ctx, moduleOp,
                           callSiteClones, cloneCounter);
          }
        }
      }
    });

    LLVM_DEBUG(llvm::dbgs() << "=== MarkAliasGroups: tagged " << nextPairId
                             << " pair(s) ===\n");
  }
};

} // namespace
} // namespace alias_meta
} // namespace mlir
