//===- Passes.td - AliasMetaPropagation passes ------*- tablegen -*-===//
//
// Defines the passes for MLIR->LLVM alias metadata propagation.
//
//===--------------------------------------------------------------===//

#ifndef ALIASMETAPROPAGATION_PASSES
#define ALIASMETAPROPAGATION_PASSES

include "mlir/Pass/PassBase.td"

def MarkAliasGroups : Pass<"mark-alias-groups", "::mlir::ModuleOp"> {
  let summary = "Detect disjoint memref.subview pairs and tag loads/stores.";
  let description = [{
    Walks memref.subview ops, detects partition-by-endpoint disjoint pairs
    (hi.offset == lo.offset + lo.size in any dimension), and tags the
    associated memref.load / memref.store ops with an integer alias-group
    attribute. For noinline callees, clones the callee for the proven call site
    and tags the clone's memory operations.

    This pass records the analysis result as discardable attributes. It also
    specializes noinline callees by cloning so metadata is not unsoundly applied
    to unrelated call sites.
  }];
}

def MaterializePrefixSubviews
    : Pass<"materialize-prefix-subviews", "::mlir::ModuleOp"> {
  let summary = "Materialize prefix subviews for ClangIR-style split calls.";
  let description = [{
    ClangIR can lower pointer arithmetic such as `work + n` into a suffix
    memref.subview, while the unoffset pointer argument remains the original
    base memref. This pass rewrites narrow call sites from:

      call @kernel(%base, %suffix, ...)

    into:

      %prefix = memref.subview %base[0] [%split] [1]
      call @kernel(%prefix, %suffix, ...)

    when `%suffix` is a subview of `%base` starting at `%split`. The resulting
    prefix/suffix subview pair exposes the existing partition-by-endpoint
    pattern to MarkAliasGroups.
  }];
}

def LowerWithAliasMeta : Pass<"lower-with-alias-meta", "::mlir::ModuleOp"> {
  let summary = "Lower marked memref ops to LLVM dialect with alias metadata.";
  let description = [{
    A targeted DialectConversion pass that matches only memref.load / memref.store
    ops carrying the alias-group marker from MarkAliasGroups. Lowers them to
    llvm.load / llvm.store with alias_scopes / noalias_scopes attributes.

    Unmarked memref.load / memref.store ops are left untouched for the standard
    finalize-memref-to-llvm pass.
  }];
}

#endif // ALIASMETAPROPAGATION_PASSES
