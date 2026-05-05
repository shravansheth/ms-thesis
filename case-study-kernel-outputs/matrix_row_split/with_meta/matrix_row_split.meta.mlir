#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @matrix_row_split(%arg0: memref<?x512xf32>, %arg1: index) {
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    %cst = arith.constant 1.000000e+00 : f32
    %subview = memref.subview %arg0[0, 0] [%arg1, 512] [1, 1] : memref<?x512xf32> to memref<?x512xf32, strided<[512, 1]>>
    %1 = builtin.unrealized_conversion_cast %subview : memref<?x512xf32, strided<[512, 1]>> to !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %subview_0 = memref.subview %arg0[%arg1, 0] [%arg1, 512] [1, 1] : memref<?x512xf32> to memref<?x512xf32, strided<[512, 1], offset: ?>>
    %2 = builtin.unrealized_conversion_cast %subview_0 : memref<?x512xf32, strided<[512, 1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %3 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.mlir.constant(512 : index) : i64
    %5 = llvm.mul %0, %4 overflow<nsw, nuw> : i64
    %6 = llvm.add %5, %0 overflow<nsw, nuw> : i64
    %7 = llvm.getelementptr inbounds|nuw %3[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst, %7 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    scf.for %arg2 = %c0 to %arg1 step %c1 {
      %8 = builtin.unrealized_conversion_cast %arg2 : index to i64
      scf.for %arg3 = %c0 to %c512 step %c1 {
        %9 = builtin.unrealized_conversion_cast %arg3 : index to i64
        %10 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
        %11 = llvm.mlir.constant(512 : index) : i64
        %12 = llvm.mul %0, %11 overflow<nsw, nuw> : i64
        %13 = llvm.add %12, %0 overflow<nsw, nuw> : i64
        %14 = llvm.getelementptr inbounds|nuw %10[%13] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %15 = llvm.load %14 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
        %16 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
        %17 = llvm.mlir.constant(512 : index) : i64
        %18 = llvm.mul %8, %17 overflow<nsw, nuw> : i64
        %19 = llvm.add %18, %9 overflow<nsw, nuw> : i64
        %20 = llvm.getelementptr inbounds|nuw %16[%19] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %21 = llvm.load %20 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
        %22 = arith.addf %21, %15 : f32
        %23 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
        %24 = llvm.extractvalue %2[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
        %25 = llvm.getelementptr %23[%24] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %26 = llvm.mlir.constant(512 : index) : i64
        %27 = llvm.mul %8, %26 overflow<nsw, nuw> : i64
        %28 = llvm.add %27, %9 overflow<nsw, nuw> : i64
        %29 = llvm.getelementptr inbounds|nuw %25[%28] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        llvm.store %22, %29 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
      }
    }
    return
  }
}
