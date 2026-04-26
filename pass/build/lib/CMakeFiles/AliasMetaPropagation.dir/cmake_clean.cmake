file(REMOVE_RECURSE
  "libAliasMetaPropagation.a"
  "libAliasMetaPropagation.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/AliasMetaPropagation.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
