#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope_domain1 = #llvm.alias_scope_domain<id = distinct[1]<>, description = "pair_1_domain">
#alias_scope = #llvm.alias_scope<id = distinct[2]<>, domain = #alias_scope_domain, description = "pair_0_lo">
#alias_scope1 = #llvm.alias_scope<id = distinct[3]<>, domain = #alias_scope_domain1, description = "pair_1_lo">
module {
  func.func @stencil_a(%arg0: memref<?xf32, strided<[1], offset: ?>>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: index) attributes {no_inline} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg2 step %c1 {
      %0 = memref.load %arg0[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %1 = memref.load %arg0[%arg3] : memref<?xf32, strided<[1], offset: ?>>
      %2 = arith.addf %1, %0 : f32
      memref.store %2, %arg1[%arg3] : memref<?xf32, strided<[1], offset: ?>>
    }
    return
  }
  func.func @stencil_b(%arg0: memref<?xf32, strided<[1], offset: ?>>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: index) attributes {no_inline} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg2 step %c1 {
      %0 = memref.load %arg0[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %1 = memref.load %arg0[%arg3] : memref<?xf32, strided<[1], offset: ?>>
      %2 = arith.addf %1, %0 : f32
      memref.store %2, %arg1[%arg3] : memref<?xf32, strided<[1], offset: ?>>
    }
    return
  }
  func.func @caller(%arg0: memref<1024xf32>, %arg1: memref<1024xf32>, %arg2: index) {
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    %cst = arith.constant 1.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %subview = memref.subview %arg0[0] [512] [1] : memref<1024xf32> to memref<512xf32, strided<[1]>>
    %1 = builtin.unrealized_conversion_cast %subview : memref<512xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_1 = memref.subview %arg0[512] [512] [1] : memref<1024xf32> to memref<512xf32, strided<[1], offset: 512>>
    %2 = arith.subi %c512, %arg2 : index
    %subview_2 = memref.subview %arg1[0] [%arg2] [1] : memref<1024xf32> to memref<?xf32, strided<[1]>>
    %3 = builtin.unrealized_conversion_cast %subview_2 : memref<?xf32, strided<[1]>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %subview_3 = memref.subview %arg1[%arg2] [%2] [1] : memref<1024xf32> to memref<?xf32, strided<[1], offset: ?>>
    %4 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.getelementptr inbounds|nuw %4[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst, %5 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %6 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %7 = llvm.getelementptr inbounds|nuw %6[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %cst_0, %7 {alias_scopes = [#alias_scope1]} : f32, !llvm.ptr
    %cast = memref.cast %subview : memref<512xf32, strided<[1]>> to memref<?xf32, strided<[1], offset: ?>>
    %cast_4 = memref.cast %subview_1 : memref<512xf32, strided<[1], offset: 512>> to memref<?xf32, strided<[1], offset: ?>>
    call @stencil_a.__alias_meta_0(%cast, %cast_4, %c512) {no_inline} : (memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, index) -> ()
    %cast_5 = memref.cast %subview_2 : memref<?xf32, strided<[1]>> to memref<?xf32, strided<[1], offset: ?>>
    call @stencil_b.__alias_meta_1(%cast_5, %subview_3, %2) {no_inline} : (memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, index) -> ()
    return
  }
  func.func @stencil_a.__alias_meta_0(%arg0: memref<?xf32, strided<[1], offset: ?>>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: index) attributes {no_inline} {
    %0 = builtin.unrealized_conversion_cast %arg1 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = builtin.unrealized_conversion_cast %arg0 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %c0 = arith.constant 0 : index
    %2 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg2 step %c1 {
      %3 = builtin.unrealized_conversion_cast %arg3 : index to i64
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
  func.func @stencil_b.__alias_meta_1(%arg0: memref<?xf32, strided<[1], offset: ?>>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: index) attributes {no_inline} {
    %0 = builtin.unrealized_conversion_cast %arg1 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = builtin.unrealized_conversion_cast %arg0 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %c0 = arith.constant 0 : index
    %2 = builtin.unrealized_conversion_cast %c0 : index to i64
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg2 step %c1 {
      %3 = builtin.unrealized_conversion_cast %arg3 : index to i64
      %4 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %5 = llvm.extractvalue %1[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %6 = llvm.getelementptr %4[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %7 = llvm.getelementptr inbounds|nuw %6[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %8 = llvm.load %7 {alias_scopes = [#alias_scope1]} : !llvm.ptr -> f32
      %9 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %10 = llvm.extractvalue %1[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %11 = llvm.getelementptr %9[%10] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %12 = llvm.getelementptr inbounds|nuw %11[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %13 = llvm.load %12 {alias_scopes = [#alias_scope1]} : !llvm.ptr -> f32
      %14 = arith.addf %13, %8 : f32
      %15 = llvm.extractvalue %0[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %16 = llvm.extractvalue %0[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %17 = llvm.getelementptr %15[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %18 = llvm.getelementptr inbounds|nuw %17[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %14, %18 {noalias_scopes = [#alias_scope1]} : f32, !llvm.ptr
    }
    return
  }
}
