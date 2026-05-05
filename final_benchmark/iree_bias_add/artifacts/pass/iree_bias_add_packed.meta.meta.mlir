#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @iree_bias_add_packed(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: index, %arg3: index) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = arith.muli %arg2, %arg3 : index
    %subview = memref.subview %arg1[0] [%arg3] [1] : memref<?xf32> to memref<?xf32, strided<[1]>>
    %1 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_0 = memref.subview %arg1[%arg3] [%0] [1] : memref<?xf32> to memref<?xf32, strided<[1], offset: ?>>
    %2 = builtin.unrealized_conversion_cast %subview_0 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    scf.for %arg4 = %c0 to %arg3 step %c1 {
      %3 = builtin.unrealized_conversion_cast %arg4 : index to i64
      scf.for %arg5 = %c0 to %arg2 step %c1 {
        %4 = arith.muli %arg5, %arg3 : index
        %5 = arith.addi %4, %arg4 : index
        %6 = builtin.unrealized_conversion_cast %5 : index to i64
        %7 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %8 = llvm.getelementptr inbounds|nuw %7[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %9 = llvm.load %8 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
        %10 = memref.load %arg0[%5] : memref<?xf32>
        %11 = arith.addf %10, %9 : f32
        %12 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %13 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %14 = llvm.getelementptr %12[%13] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %15 = llvm.getelementptr inbounds|nuw %14[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        llvm.store %11, %15 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
      }
    }
    return
  }
}
