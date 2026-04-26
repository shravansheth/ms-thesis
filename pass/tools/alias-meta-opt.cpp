//===- alias-meta-opt.cpp - Custom mlir-opt with alias meta passes ---*- C++ -*-===//
//
// A minimal mlir-opt driver that includes all standard MLIR dialects and passes
// plus our MarkAliasGroups and LowerWithAliasMeta passes.
//
// Usage:
//   alias-meta-opt <input.mlir> -mark-alias-groups -lower-with-alias-meta ...
//
//===-------------------------------------------------------------------------===//

#include "AliasMetaPropagation/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/Index/IR/IndexDialect.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlow.h"

#include "mlir/Conversion/SCFToControlFlow/SCFToControlFlow.h"
#include "mlir/Conversion/FuncToLLVM/ConvertFuncToLLVMPass.h"
#include "mlir/Conversion/ArithToLLVM/ArithToLLVM.h"
#include "mlir/Conversion/IndexToLLVM/IndexToLLVM.h"
#include "mlir/Conversion/MathToLLVM/MathToLLVM.h"
#include "mlir/Conversion/ControlFlowToLLVM/ControlFlowToLLVM.h"
#include "mlir/Conversion/MemRefToLLVM/MemRefToLLVM.h"
#include "mlir/Conversion/ReconcileUnrealizedCasts/ReconcileUnrealizedCasts.h"

#include "mlir/Dialect/Affine/Passes.h"
#include "mlir/Dialect/MemRef/Transforms/Passes.h"

#include "mlir/IR/MLIRContext.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Parser/Parser.h"
#include "mlir/IR/AsmState.h"
#include "mlir/Support/FileUtilities.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/Support/raw_ostream.h"

using namespace mlir;

static llvm::cl::opt<std::string> inputFilename(llvm::cl::Positional,
                                                  llvm::cl::desc("<input file>"),
                                                  llvm::cl::init("-"));

static llvm::cl::opt<std::string> outputFilename("o",
                                                   llvm::cl::desc("Output filename"),
                                                   llvm::cl::value_desc("filename"),
                                                   llvm::cl::init("-"));

static llvm::cl::opt<bool> markAliasGroups("mark-alias-groups",
                                            llvm::cl::desc("Run MarkAliasGroups pass"),
                                            llvm::cl::init(false));

static llvm::cl::opt<bool> lowerWithAliasMeta("lower-with-alias-meta",
                                               llvm::cl::desc("Run LowerWithAliasMeta pass"),
                                               llvm::cl::init(false));

int main(int argc, char **argv) {
  llvm::InitLLVM y(argc, argv);

  // Register pass command line options.
  registerAsmPrinterCLOptions();
  registerMLIRContextCLOptions();

  llvm::cl::ParseCommandLineOptions(argc, argv, "Alias meta propagation tool\n");

  MLIRContext context;
  context.loadDialect<arith::ArithDialect, func::FuncDialect,
                       memref::MemRefDialect, scf::SCFDialect,
                       math::MathDialect, index::IndexDialect,
                       cf::ControlFlowDialect, LLVM::LLVMDialect>();

  // Parse the input file.
  std::string errorMessage;
  auto inputFile = openInputFile(inputFilename, &errorMessage);
  if (!inputFile) {
    llvm::errs() << errorMessage << "\n";
    return 1;
  }

  llvm::SourceMgr sourceMgr;
  sourceMgr.AddNewSourceBuffer(std::move(inputFile), llvm::SMLoc());

  OwningOpRef<ModuleOp> module = parseSourceFile<ModuleOp>(sourceMgr, &context);
  if (!module) {
    llvm::errs() << "Failed to parse input\n";
    return 1;
  }

  // Build the pass pipeline.
  PassManager pm(&context);

  if (markAliasGroups)
    pm.addPass(alias_meta::createMarkAliasGroups());
  if (lowerWithAliasMeta)
    pm.addPass(alias_meta::createLowerWithAliasMeta());

  if (failed(pm.run(*module))) {
    llvm::errs() << "Pass pipeline failed\n";
    return 1;
  }

  // Write the output.
  auto outputFile = openOutputFile(outputFilename, &errorMessage);
  if (!outputFile) {
    llvm::errs() << errorMessage << "\n";
    return 1;
  }

  module->print(outputFile->os());
  outputFile->keep();

  return 0;
}
