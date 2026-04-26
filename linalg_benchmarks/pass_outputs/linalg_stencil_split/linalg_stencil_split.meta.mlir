#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @linalg_stencil_split(%arg0: memref<4096xf32>, %arg1: index) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 1.000000e+00 : f32
    %c4096 = arith.constant 4096 : index
    %0 = arith.subi %c4096, %arg1 : index
    %subview = memref.subview %arg0[0] [%arg1] [1] : memref<4096xf32> to memref<?xf32, strided<[1]>>
    %1 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_0 = memref.subview %arg0[%arg1] [%0] [1] : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>
    %2 = builtin.unrealized_conversion_cast %subview_0 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    scf.for %arg2 = %c0 to %0 step %c1 {
      %3 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %4 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %5 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %6 = llvm.getelementptr %4[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %7 = llvm.getelementptr inbounds|nuw %6[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %cst, %7 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    scf.for %arg2 = %c0 to %arg1 step %c1 {
      %3 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %4 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %5 = llvm.getelementptr inbounds|nuw %4[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %6 = llvm.load %5 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %7 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %8 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %9 = llvm.getelementptr %7[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %10 = llvm.getelementptr inbounds|nuw %9[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %11 = llvm.load %10 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %12 = arith.addf %11, %6 : f32
      %13 = arith.addf %12, %cst : f32
      %14 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %15 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %16 = llvm.getelementptr %14[%15] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %17 = llvm.getelementptr inbounds|nuw %16[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %13, %17 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    return
  }
}
