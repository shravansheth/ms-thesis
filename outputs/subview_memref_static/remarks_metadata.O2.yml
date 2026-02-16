--- !Missed
Pass:            inline
Name:            NoDefinition
Function:        subview_hoist_static
Args:
  - Callee:          malloc
  - String:          ' will not be inlined into '
  - Caller:          subview_hoist_static
  - String:          ' because its definition is unavailable'
...
--- !Missed
Pass:            inline
Name:            NoDefinition
Function:        subview_hoist_static
Args:
  - Callee:          free
  - String:          ' will not be inlined into '
  - Caller:          subview_hoist_static
  - String:          ' because its definition is unavailable'
...
--- !Missed
Pass:            loop-vectorize
Name:            VectorizationNotBeneficial
Function:        subview_hoist_static
Args:
  - String:          the cost-model indicates that vectorization is not beneficial
...
--- !Missed
Pass:            loop-vectorize
Name:            InterleavingNotBeneficial
Function:        subview_hoist_static
Args:
  - String:          the cost-model indicates that interleaving is not beneficial
...
