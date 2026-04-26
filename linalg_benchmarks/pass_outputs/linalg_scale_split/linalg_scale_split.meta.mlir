#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @linalg_scale_split(%arg0: memref<2048xf32>, %arg1: index) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %cst = arith.constant 1.000000e+00 : f32
    %c2048 = arith.constant 2048 : index
    %1 = arith.subi %c2048, %arg1 : index
    %subview = memref.subview %arg0[0] [%arg1] [1] : memref<2048xf32> to memref<?xf32, strided<[1]>>
    %2 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_0 = memref.subview %arg0[%arg1] [%1] [1] : memref<2048xf32> to memref<?xf32, strided<[1], offset: ?>>
    %3 = builtin.unrealized_conversion_cast %subview_0 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.getelementptr inbounds|nuw %4[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst, %5 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    scf.for %arg2 = %c0 to %1 step %c1 {
      %6 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %7 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %8 = llvm.getelementptr inbounds|nuw %7[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %9 = llvm.load %8 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %10 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %11 = llvm.extractvalue %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %12 = llvm.getelementptr %10[%11] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %13 = llvm.getelementptr inbounds|nuw %12[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %14 = llvm.load %13 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %15 = arith.addf %14, %9 : f32
      %16 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %17 = llvm.extractvalue %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %18 = llvm.getelementptr %16[%17] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %19 = llvm.getelementptr inbounds|nuw %18[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %15, %19 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    return
  }
}
