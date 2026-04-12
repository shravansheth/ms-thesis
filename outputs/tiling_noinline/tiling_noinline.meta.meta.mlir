#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @tile_stencil(%arg0: memref<?xf32, strided<[1], offset: ?>>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: index) attributes {no_inline} {
    %0 = builtin.unrealized_conversion_cast %arg1 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = builtin.unrealized_conversion_cast %arg0 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %c0 = arith.constant 0 : index
    %2 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg2 step %c1 {
      %3 = builtin.unrealized_conversion_cast %arg3 : index to i64
      %4 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %5 = llvm.extractvalue %1[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %6 = llvm.getelementptr %4[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %7 = llvm.getelementptr inbounds|nuw %6[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %8 = llvm.load %7 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %9 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %10 = llvm.extractvalue %1[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %11 = llvm.getelementptr %9[%10] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %12 = llvm.getelementptr inbounds|nuw %11[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %13 = llvm.load %12 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %14 = arith.addf %13, %8 : f32
      %15 = llvm.extractvalue %0[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %16 = llvm.extractvalue %0[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %17 = llvm.getelementptr %15[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %18 = llvm.getelementptr inbounds|nuw %17[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %14, %18 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    return
  }
  func.func @tiling_caller(%arg0: memref<4096xf32>, %arg1: index, %arg2: index) {
    %c1 = arith.constant 1 : index
    %0 = arith.muli %arg1, %arg2 : index
    %subview = memref.subview %arg0[%0] [%arg2] [1] : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>
    %1 = arith.addi %0, %arg2 : index
    %subview_0 = memref.subview %arg0[%1] [%arg2] [1] : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>
    call @tile_stencil(%subview, %subview_0, %arg2) {no_inline} : (memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, index) -> ()
    return
  }
}
