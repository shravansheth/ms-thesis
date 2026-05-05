add_mlir_library(AliasMetaPropagation
  MarkAliasGroupsPass.cpp
  MaterializePrefixSubviewsPass.cpp
  LowerWithAliasMetaPass.cpp

  ADDITIONAL_HEADER_DIRS
  ${PROJECT_SOURCE_DIR}/include/AliasMetaPropagation

  DEPENDS
  AliasMetaPropagationPassesIncGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRPass
  MLIRFuncDialect
  MLIRMemRefDialect
  MLIRArithDialect
  MLIRSCFDialect
  MLIRLLVMDialect
  MLIRLLVMCommonConversion
  MLIRMemRefToLLVM
  MLIRTransforms
)
