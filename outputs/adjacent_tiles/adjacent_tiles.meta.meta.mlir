#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @adjacent_tiles(%arg0: memref<4096xf32>, %arg1: index, %arg2: index) {
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %1 = arith.muli %arg1, %arg2 : index
    %subview = memref.subview %arg0[%1] [%arg2] [1] : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>
    %2 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %3 = arith.addi %1, %arg2 : index
    %subview_0 = memref.subview %arg0[%3] [%arg2] [1] : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>
    %4 = builtin.unrealized_conversion_cast %subview_0 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    scf.for %arg3 = %c0 to %arg2 step %c1 {
      %5 = builtin.unrealized_conversion_cast %arg3 : index to i64
      %6 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %7 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %8 = llvm.getelementptr %6[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %9 = llvm.getelementptr inbounds|nuw %8[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %10 = llvm.load %9 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %11 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %12 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %13 = llvm.getelementptr %11[%12] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %14 = llvm.getelementptr inbounds|nuw %13[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %15 = llvm.load %14 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %16 = arith.addf %15, %10 : f32
      %17 = llvm.extractvalue %4[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %18 = llvm.extractvalue %4[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %19 = llvm.getelementptr %17[%18] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %20 = llvm.getelementptr inbounds|nuw %19[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %16, %20 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    return
  }
}
