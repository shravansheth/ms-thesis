#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @vectorize_split(%arg0: memref<2097152xf32>, %arg1: index) {
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %c1048576 = arith.constant 1048576 : index
    %cst = arith.constant 1.000000e+00 : f32
    %subview = memref.subview %arg0[0] [%arg1] [1] : memref<2097152xf32> to memref<?xf32, strided<[1]>>
    %1 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_0 = memref.subview %arg0[%arg1] [1048576] [1] : memref<2097152xf32> to memref<1048576xf32, strided<[1], offset: ?>>
    %2 = builtin.unrealized_conversion_cast %subview_0 : memref<1048576xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.getelementptr inbounds|nuw %3[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst, %4 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    scf.for %arg2 = %c0 to %c1048576 step %c1 {
      %5 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %6 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %7 = llvm.getelementptr inbounds|nuw %6[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %8 = llvm.load %7 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %9 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %10 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %11 = llvm.getelementptr %9[%10] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %12 = llvm.getelementptr inbounds|nuw %11[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %13 = llvm.load %12 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %14 = arith.addf %13, %8 : f32
      %15 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %16 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %17 = llvm.getelementptr %15[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %18 = llvm.getelementptr inbounds|nuw %17[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %14, %18 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    return
  }
}
