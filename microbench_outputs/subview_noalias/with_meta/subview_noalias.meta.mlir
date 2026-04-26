#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  func.func @kernel(%arg0: memref<?xf32, strided<[1], offset: ?>>, %arg1: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    scf.for %arg2 = %c0 to %c512 step %c1 {
      %0 = memref.load %arg0[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %1 = memref.load %arg0[%arg2] : memref<?xf32, strided<[1], offset: ?>>
      %2 = arith.addf %1, %0 : f32
      memref.store %2, %arg1[%arg2] : memref<?xf32, strided<[1], offset: ?>>
    }
    return
  }
  func.func @caller() {
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    %cst = arith.constant 1.000000e+00 : f32
    %alloc = memref.alloc() : memref<1024xf32>
    %subview = memref.subview %alloc[0] [512] [1] : memref<1024xf32> to memref<512xf32, strided<[1]>>
    %1 = builtin.unrealized_conversion_cast %subview : memref<512xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_0 = memref.subview %alloc[512] [512] [1] : memref<1024xf32> to memref<512xf32, strided<[1], offset: 512>>
    %2 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.getelementptr inbounds|nuw %2[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst, %3 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %cast = memref.cast %subview : memref<512xf32, strided<[1]>> to memref<?xf32, strided<[1], offset: ?>>
    %cast_1 = memref.cast %subview_0 : memref<512xf32, strided<[1], offset: 512>> to memref<?xf32, strided<[1], offset: ?>>
    call @kernel.__alias_meta_0(%cast, %cast_1) {no_inline} : (memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    memref.dealloc %alloc : memref<1024xf32>
    return
  }
  func.func @kernel.__alias_meta_0(%arg0: memref<?xf32, strided<[1], offset: ?>>, %arg1: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %0 = builtin.unrealized_conversion_cast %arg1 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = builtin.unrealized_conversion_cast %arg0 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %c0 = arith.constant 0 : index
    %2 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    scf.for %arg2 = %c0 to %c512 step %c1 {
      %3 = builtin.unrealized_conversion_cast %arg2 : index to i64
      %4 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %5 = llvm.extractvalue %1[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %6 = llvm.getelementptr %4[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %7 = llvm.getelementptr inbounds|nuw %6[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %8 = llvm.load %7 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %9 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %10 = llvm.extractvalue %1[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %11 = llvm.getelementptr %9[%10] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %12 = llvm.getelementptr inbounds|nuw %11[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %13 = llvm.load %12 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
      %14 = arith.addf %13, %8 : f32
      %15 = llvm.extractvalue %0[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %16 = llvm.extractvalue %0[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %17 = llvm.getelementptr %15[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %18 = llvm.getelementptr inbounds|nuw %17[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %14, %18 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    }
    return
  }
}
