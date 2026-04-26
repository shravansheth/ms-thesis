set(LIBS
  MLIRIR
  MLIRPass
  MLIRParser
  MLIRSupport
  MLIRFuncDialect
  MLIRArithDialect
  MLIRMemRefDialect
  MLIRSCFDialect
  MLIRMathDialect
  MLIRIndexDialect
  MLIRControlFlowDialect
  MLIRLLVMDialect
  MLIRSCFToControlFlow
  MLIRFuncToLLVM
  MLIRArithToLLVM
  MLIRIndexToLLVM
  MLIRMathToLLVM
  MLIRControlFlowToLLVM
  MLIRMemRefToLLVM
  MLIRReconcileUnrealizedCasts
  MLIRAffineTransforms
  MLIRMemRefTransforms
  AliasMetaPropagation
)

add_llvm_executable(alias-meta-opt alias-meta-opt.cpp)
llvm_update_compile_flags(alias-meta-opt)
target_link_libraries(alias-meta-opt PRIVATE ${LIBS})
mlir_check_all_link_libraries(alias-meta-opt)
