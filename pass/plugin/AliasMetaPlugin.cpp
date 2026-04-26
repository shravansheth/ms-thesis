//===- AliasMetaPlugin.cpp - Plugin entry point -----------------*- C++ -*-===//
//
// Registers the MarkAliasGroups and LowerWithAliasMeta passes so that
// mlir-opt can load them via --load-pass-plugin.
//
//===----------------------------------------------------------------------===//

#include "AliasMetaPropagation/Passes.h"
#include "mlir/Tools/Plugins/PassPlugin.h"
#include "llvm/Config/llvm-config.h"
#include "llvm/Support/Compiler.h"

/// Pass plugin registration — the only entry point needed.
extern "C" LLVM_ATTRIBUTE_WEAK ::mlir::PassPluginLibraryInfo
mlirGetPassPluginInfo() {
  return {MLIR_PLUGIN_API_VERSION, "AliasMetaPropagation", LLVM_VERSION_STRING,
          []() { mlir::alias_meta::registerPasses(); }};
}
