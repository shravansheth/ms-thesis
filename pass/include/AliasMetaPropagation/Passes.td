//===- Passes.td - AliasMetaPropagation passes ------*- tablegen -*-===//
//
// Defines the two passes for MLIR->LLVM alias metadata propagation.
//
//===--------------------------------------------------------------===//

#ifndef ALIASMETAPROPAGATION_PASSES
#define ALIASMETAPROPAGATION_PASSES

include "mlir/Pass/PassBase.td"

def MarkAliasGroups : Pass<"mark-alias-groups", "::mlir::ModuleOp"> {
  let summary = "Detect disjoint memref.subview pairs and tag loads/stores.";
  let description = [{
    Walks memref.subview ops, detects partition-by-endpoint disjoint pairs
    (hi.offset == lo.offset + lo.size), and tags the associated memref.load /
    memref.store ops with an integer alias-group attribute. Also tags func.call
    ops that pass disjoint subview pairs to noinline callees.

    This is a pure analysis pass — it does not lower or modify IR structure.
  }];
}

def LowerWithAliasMeta : Pass<"lower-with-alias-meta", "::mlir::ModuleOp"> {
  let summary = "Lower marked memref ops to LLVM dialect with alias metadata.";
  let description = [{
    A targeted DialectConversion pass that matches only memref.load / memref.store
    ops carrying the alias-group marker from MarkAliasGroups. Lowers them to
    llvm.load / llvm.store with alias_scopes / noalias_scopes attributes.

    For noinline callee cases, adds llvm.noalias parameter attributes to the
    callee function signature at the tagged argument positions.

    Unmarked memref.load / memref.store ops are left untouched for the standard
    finalize-memref-to-llvm pass.
  }];
}

#endif // ALIASMETAPROPAGATION_PASSES
