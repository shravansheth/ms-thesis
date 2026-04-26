#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @linalg_norm_split(%arg0: memref<2048xf32>, %arg1: index) {
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %1 = builtin.unrealized_conversion_cast %c1 : index to i64
    %cst = arith.constant 1.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %c2048 = arith.constant 2048 : index
    %2 = arith.subi %c2048, %arg1 : index
    %subview = memref.subview %arg0[0] [%arg1] [1] : memref<2048xf32> to memref<?xf32, strided<[1]>>
    %3 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_1 = memref.subview %arg0[%arg1] [%2] [1] : memref<2048xf32> to memref<?xf32, strided<[1], offset: ?>>
    %4 = builtin.unrealized_conversion_cast %subview_1 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.getelementptr inbounds|nuw %5[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst, %6 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %7 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %8 = llvm.getelementptr inbounds|nuw %7[%1] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst_0, %8 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    scf.for %arg2 = %c0 to %2 step %c1 {
      %9 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %10 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %11 = llvm.getelementptr inbounds|nuw %10[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %12 = llvm.load %11 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %13 = llvm.extractvalue %4[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %14 = llvm.extractvalue %4[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %15 = llvm.getelementptr %13[%14] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %16 = llvm.getelementptr inbounds|nuw %15[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %17 = llvm.load %16 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %18 = arith.addf %17, %12 : f32
      %19 = llvm.extractvalue %4[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %20 = llvm.extractvalue %4[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %21 = llvm.getelementptr %19[%20] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %22 = llvm.getelementptr inbounds|nuw %21[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %18, %22 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    scf.for %arg2 = %c0 to %2 step %c1 {
      %9 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %10 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %11 = llvm.getelementptr inbounds|nuw %10[%1] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %12 = llvm.load %11 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %13 = llvm.extractvalue %4[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %14 = llvm.extractvalue %4[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %15 = llvm.getelementptr %13[%14] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %16 = llvm.getelementptr inbounds|nuw %15[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %17 = llvm.load %16 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %18 = arith.mulf %17, %12 : f32
      %19 = llvm.extractvalue %4[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %20 = llvm.extractvalue %4[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %21 = llvm.getelementptr %19[%20] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %22 = llvm.getelementptr inbounds|nuw %21[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %18, %22 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    return
  }
}
