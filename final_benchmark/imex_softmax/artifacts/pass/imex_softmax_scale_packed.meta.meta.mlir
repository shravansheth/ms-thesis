#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @imex_softmax_scale_packed(%arg0: memref<?x2048xf32>, %arg1: index, %arg2: index) {
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %c1024 = arith.constant 1024 : index
    %subview = memref.subview %arg0[0, 0] [%arg1, %arg2] [1, 1] : memref<?x2048xf32> to memref<?x?xf32, strided<[2048, 1]>>
    %1 = builtin.unrealized_conversion_cast %subview : memref<?x?xf32, strided<[2048, 1]>> to !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %subview_0 = memref.subview %arg0[0, %arg2] [%arg1, 1024] [1, 1] : memref<?x2048xf32> to memref<?x1024xf32, strided<[2048, 1], offset: ?>>
    %2 = builtin.unrealized_conversion_cast %subview_0 : memref<?x1024xf32, strided<[2048, 1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    scf.for %arg3 = %c0 to %arg1 step %c1 {
      %3 = builtin.unrealized_conversion_cast %arg3 : index to i64
      scf.for %arg4 = %c0 to %c1024 step %c1 {
        %4 = builtin.unrealized_conversion_cast %arg4 : index to i64
        %5 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
        %6 = llvm.mlir.constant(2048 : index) : i64
        %7 = llvm.mul %3, %6 overflow<nsw, nuw> : i64
        %8 = llvm.add %7, %0 overflow<nsw, nuw> : i64
        %9 = llvm.getelementptr inbounds|nuw %5[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %10 = llvm.load %9 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
        %11 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
        %12 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
        %13 = llvm.getelementptr %11[%12] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %14 = llvm.mlir.constant(2048 : index) : i64
        %15 = llvm.mul %3, %14 overflow<nsw, nuw> : i64
        %16 = llvm.add %15, %4 overflow<nsw, nuw> : i64
        %17 = llvm.getelementptr inbounds|nuw %13[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %18 = llvm.load %17 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
        %19 = arith.divf %18, %10 : f32
        %20 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
        %21 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
        %22 = llvm.getelementptr %20[%21] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %23 = llvm.mlir.constant(2048 : index) : i64
        %24 = llvm.mul %3, %23 overflow<nsw, nuw> : i64
        %25 = llvm.add %24, %4 overflow<nsw, nuw> : i64
        %26 = llvm.getelementptr inbounds|nuw %22[%25] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        llvm.store %19, %26 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
      }
    }
    return
  }
}
