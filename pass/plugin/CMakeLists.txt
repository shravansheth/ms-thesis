# Build a single shared MODULE that contains all pass code + plugin entry point.
# On macOS, we use -flat_namespace -undefined suppress to resolve all MLIR/LLVM
# symbols from the host mlir-opt binary at load time.

add_llvm_library(AliasMetaPropagationPlugin
  MODULE
  AliasMetaPlugin.cpp
  ../lib/MarkAliasGroupsPass.cpp
  ../lib/LowerWithAliasMetaPass.cpp

  DEPENDS
  AliasMetaPropagationPassesIncGen

  PLUGIN_TOOL
  mlir-opt
)

target_include_directories(AliasMetaPropagationPlugin
  PRIVATE
  "${PROJECT_SOURCE_DIR}/include"
  "${PROJECT_BINARY_DIR}/include"
)

# On macOS, use flat namespace so the plugin resolves ALL symbols (including
# inline/template instantiations) from the host binary rather than using its
# own copies. This avoids ODR violations and the passState assertion failure.
if(APPLE)
  target_link_options(AliasMetaPropagationPlugin PRIVATE
    "LINKER:-flat_namespace,-undefined,suppress"
  )
endif()
