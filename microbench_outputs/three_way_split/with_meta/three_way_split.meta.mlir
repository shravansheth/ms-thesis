#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope_domain1 = #llvm.alias_scope_domain<id = distinct[1]<>, description = "pair_1_domain">
#alias_scope = #llvm.alias_scope<id = distinct[2]<>, domain = #alias_scope_domain, description = "pair_0_lo">
#alias_scope1 = #llvm.alias_scope<id = distinct[3]<>, domain = #alias_scope_domain1, description = "pair_1_lo">
module {
  func.func @three_way_split(%arg0: memref<3072xf32>, %arg1: index) {
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %cst = arith.constant 1.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %1 = arith.addi %arg1, %arg1 : index
    %subview = memref.subview %arg0[0] [%arg1] [1] : memref<3072xf32> to memref<?xf32, strided<[1]>>
    %2 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_1 = memref.subview %arg0[%arg1] [%arg1] [1] : memref<3072xf32> to memref<?xf32, strided<[1], offset: ?>>
    %3 = builtin.unrealized_conversion_cast %subview_1 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_2 = memref.subview %arg0[%1] [%arg1] [1] : memref<3072xf32> to memref<?xf32, strided<[1], offset: ?>>
    %4 = builtin.unrealized_conversion_cast %subview_2 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.getelementptr inbounds|nuw %5[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst, %6 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %7 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %8 = llvm.extractvalue %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %9 = llvm.getelementptr %7[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %10 = llvm.getelementptr inbounds|nuw %9[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst_0, %10 {alias_scopes = [#alias_scope1]} : f32, !llvm.ptr
    scf.for %arg2 = %c0 to %arg1 step %c1 {
      %11 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %12 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %13 = llvm.getelementptr inbounds|nuw %12[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %14 = llvm.load %13 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %15 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %16 = llvm.extractvalue %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %17 = llvm.getelementptr %15[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %18 = llvm.getelementptr inbounds|nuw %17[%11] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %19 = llvm.load %18 {alias_scopes = [#alias_scope1]} : !llvm.ptr -> f32
      %20 = arith.addf %19, %14 : f32
      %21 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %22 = llvm.extractvalue %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %23 = llvm.getelementptr %21[%22] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %24 = llvm.getelementptr inbounds|nuw %23[%11] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %20, %24 {alias_scopes = [#alias_scope1]} : f32, !llvm.ptr
    }
    scf.for %arg2 = %c0 to %arg1 step %c1 {
      %11 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %12 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %13 = llvm.extractvalue %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %14 = llvm.getelementptr %12[%13] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %15 = llvm.getelementptr inbounds|nuw %14[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %16 = llvm.load %15 {alias_scopes = [#alias_scope1]} : !llvm.ptr -> f32
      %17 = llvm.extractvalue %4[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %18 = llvm.extractvalue %4[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %19 = llvm.getelementptr %17[%18] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %20 = llvm.getelementptr inbounds|nuw %19[%11] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %21 = llvm.load %20 {noalias_scopes = [#alias_scope1]} : !llvm.ptr -> f32
      %22 = arith.addf %21, %16 : f32
      %23 = llvm.extractvalue %4[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %24 = llvm.extractvalue %4[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %25 = llvm.getelementptr %23[%24] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %26 = llvm.getelementptr inbounds|nuw %25[%11] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %22, %26 {noalias_scopes = [#alias_scope1]} : f32, !llvm.ptr
    }
    return
  }
}
