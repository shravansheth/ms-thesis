#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @split_accumulate(%arg0: memref<2048xf32>, %arg1: index) {
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %c2048 = arith.constant 2048 : index
    %cst = arith.constant 1.000000e+00 : f32
    %1 = arith.subi %c2048, %arg1 : index
    %subview = memref.subview %arg0[0] [%arg1] [1] : memref<2048xf32> to memref<?xf32, strided<[1]>>
    %2 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_0 = memref.subview %arg0[%arg1] [%1] [1] : memref<2048xf32> to memref<?xf32, strided<[1], offset: ?>>
    %3 = builtin.unrealized_conversion_cast %subview_0 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.extractvalue %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.getelementptr %4[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %7 = llvm.getelementptr inbounds|nuw %6[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst, %7 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    scf.for %arg2 = %c0 to %arg1 step %c1 {
      %8 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %9 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %10 = llvm.extractvalue %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %11 = llvm.getelementptr %9[%10] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %12 = llvm.getelementptr inbounds|nuw %11[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %13 = llvm.load %12 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %14 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %15 = llvm.getelementptr inbounds|nuw %14[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %16 = llvm.load %15 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %17 = arith.addf %16, %13 : f32
      %18 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %19 = llvm.getelementptr inbounds|nuw %18[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %17, %19 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    return
  }
}
