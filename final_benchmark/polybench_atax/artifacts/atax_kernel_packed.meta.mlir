#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module @"/Volumes/ShravsSSD/ms-thesis-copy/benchmark_exploration/source_diffs/polybench_atax_clangir/atax_kernel_packed.c" attributes {llvm.target_triple = "arm64-apple-macosx26.0.0"} {
  func.func @kernel_atax(%arg0: i32, %arg1: i32, %arg2: memref<124xf32>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: memref<?xf32, strided<[1], offset: ?>>, %arg5: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %c124 = arith.constant 124 : index
    %cst = arith.constant 0.000000e+00 : f32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_0 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_1 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_3 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_5 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_6 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xi32>
    memref.store %arg2, %alloca_1[%c0] : memref<1xmemref<124xf32>>
    memref.store %arg3, %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg4, %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg5, %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %c0_i32, %alloca_5[%c0] : memref<1xi32>
    scf.while : () -> () {
      %0 = memref.load %alloca_5[%c0] : memref<1xi32>
      %1 = memref.load %alloca_0[%c0] : memref<1xi32>
      %2 = arith.cmpi slt, %0, %1 : i32
      scf.condition(%2)
    } do {
      %0 = memref.load %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
      %1 = memref.load %alloca_5[%c0] : memref<1xi32>
      %2 = arith.index_cast %1 : i32 to index
      %dim = memref.dim %0, %c0 : memref<?xf32, strided<[1], offset: ?>>
      %3 = arith.subi %dim, %2 : index
      %subview = memref.subview %0[%2] [%3] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
      memref.store %cst, %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %4 = memref.load %alloca_5[%c0] : memref<1xi32>
      %5 = arith.addi %4, %c1_i32 : i32
      memref.store %5, %alloca_5[%c0] : memref<1xi32>
      scf.yield
    }
    memref.store %c0_i32, %alloca_5[%c0] : memref<1xi32>
    scf.while : () -> () {
      %0 = memref.load %alloca_5[%c0] : memref<1xi32>
      %1 = memref.load %alloca[%c0] : memref<1xi32>
      %2 = arith.cmpi slt, %0, %1 : i32
      scf.condition(%2)
    } do {
      %0 = memref.load %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
      %1 = memref.load %alloca_5[%c0] : memref<1xi32>
      %2 = arith.index_cast %1 : i32 to index
      %dim = memref.dim %0, %c0 : memref<?xf32, strided<[1], offset: ?>>
      %3 = arith.subi %dim, %2 : index
      %subview = memref.subview %0[%2] [%3] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
      memref.store %cst, %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
      memref.store %c0_i32, %alloca_6[%c0] : memref<1xi32>
      scf.while : () -> () {
        %6 = memref.load %alloca_6[%c0] : memref<1xi32>
        %7 = memref.load %alloca_0[%c0] : memref<1xi32>
        %8 = arith.cmpi slt, %6, %7 : i32
        scf.condition(%8)
      } do {
        %6 = memref.load %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %7 = memref.load %alloca_5[%c0] : memref<1xi32>
        %8 = arith.index_cast %7 : i32 to index
        %dim_7 = memref.dim %6, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %9 = arith.subi %dim_7, %8 : index
        %subview_8 = memref.subview %6[%8] [%9] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %10 = memref.load %subview_8[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %11 = memref.load %alloca_1[%c0] : memref<1xmemref<124xf32>>
        %12 = arith.subi %c124, %8 : index
        %subview_9 = memref.subview %11[%8] [%12] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
        %13 = memref.load %alloca_6[%c0] : memref<1xi32>
        %14 = arith.index_cast %13 : i32 to index
        %subview_10 = memref.subview %subview_9[%14] [1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<1xf32, strided<[1], offset: ?>>
        %15 = memref.load %subview_10[%c0] : memref<1xf32, strided<[1], offset: ?>>
        %16 = memref.load %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %dim_11 = memref.dim %16, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %17 = arith.subi %dim_11, %14 : index
        %subview_12 = memref.subview %16[%14] [%17] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %18 = memref.load %subview_12[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %19 = arith.mulf %15, %18 : f32
        %20 = arith.addf %10, %19 : f32
        memref.store %20, %subview_8[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %21 = memref.load %alloca_6[%c0] : memref<1xi32>
        %22 = arith.addi %21, %c1_i32 : i32
        memref.store %22, %alloca_6[%c0] : memref<1xi32>
        scf.yield
      }
      memref.store %c0_i32, %alloca_6[%c0] : memref<1xi32>
      scf.while : () -> () {
        %6 = memref.load %alloca_6[%c0] : memref<1xi32>
        %7 = memref.load %alloca_0[%c0] : memref<1xi32>
        %8 = arith.cmpi slt, %6, %7 : i32
        scf.condition(%8)
      } do {
        %6 = memref.load %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %7 = memref.load %alloca_6[%c0] : memref<1xi32>
        %8 = arith.index_cast %7 : i32 to index
        %dim_7 = memref.dim %6, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %9 = arith.subi %dim_7, %8 : index
        %subview_8 = memref.subview %6[%8] [%9] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %10 = memref.load %subview_8[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %11 = memref.load %alloca_1[%c0] : memref<1xmemref<124xf32>>
        %12 = memref.load %alloca_5[%c0] : memref<1xi32>
        %13 = arith.index_cast %12 : i32 to index
        %14 = arith.subi %c124, %13 : index
        %subview_9 = memref.subview %11[%13] [%14] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
        %subview_10 = memref.subview %subview_9[%8] [1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<1xf32, strided<[1], offset: ?>>
        %15 = memref.load %subview_10[%c0] : memref<1xf32, strided<[1], offset: ?>>
        %16 = memref.load %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %dim_11 = memref.dim %16, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %17 = arith.subi %dim_11, %13 : index
        %subview_12 = memref.subview %16[%13] [%17] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %18 = memref.load %subview_12[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %19 = arith.mulf %15, %18 : f32
        %20 = arith.addf %10, %19 : f32
        memref.store %20, %subview_8[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %21 = memref.load %alloca_6[%c0] : memref<1xi32>
        %22 = arith.addi %21, %c1_i32 : i32
        memref.store %22, %alloca_6[%c0] : memref<1xi32>
        scf.yield
      }
      %4 = memref.load %alloca_5[%c0] : memref<1xi32>
      %5 = arith.addi %4, %c1_i32 : i32
      memref.store %5, %alloca_5[%c0] : memref<1xi32>
      scf.yield
    }
    return
  }
  func.func @run_atax_packed(%arg0: memref<124xf32>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: memref<?xf32, strided<[1], offset: ?>>, %arg3: i32, %arg4: i32) attributes {no_inline} {
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_1 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_2 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_3 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    memref.store %arg0, %alloca[%c0] : memref<1xmemref<124xf32>>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg2, %alloca_1[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg3, %alloca_2[%c0] : memref<1xi32>
    memref.store %arg4, %alloca_3[%c0] : memref<1xi32>
    %0 = memref.load %alloca_2[%c0] : memref<1xi32>
    %1 = memref.load %alloca_3[%c0] : memref<1xi32>
    %2 = memref.load %alloca[%c0] : memref<1xmemref<124xf32>>
    %3 = memref.load %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %4 = memref.load %alloca_1[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %5 = arith.index_cast %0 : i32 to index
    %dim = memref.dim %4, %c0 : memref<?xf32, strided<[1], offset: ?>>
    %6 = arith.subi %dim, %5 : index
    %subview = memref.subview %4[%5] [%6] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    %subview_4 = memref.subview %4[0] [%5] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    call @kernel_atax.__alias_meta_0(%0, %1, %2, %3, %subview, %subview_4) : (i32, i32, memref<124xf32>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    return
  }
  func.func @kernel_atax.__alias_meta_0(%arg0: i32, %arg1: i32, %arg2: memref<124xf32>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: memref<?xf32, strided<[1], offset: ?>>, %arg5: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %c124 = arith.constant 124 : index
    %cst = arith.constant 0.000000e+00 : f32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %0 = builtin.unrealized_conversion_cast %c0 : index to i64
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_0 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_1 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_3 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_5 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_6 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xi32>
    memref.store %arg2, %alloca_1[%c0] : memref<1xmemref<124xf32>>
    memref.store %arg3, %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg4, %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg5, %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %c0_i32, %alloca_5[%c0] : memref<1xi32>
    scf.while : () -> () {
      %1 = memref.load %alloca_5[%c0] : memref<1xi32>
      %2 = memref.load %alloca_0[%c0] : memref<1xi32>
      %3 = arith.cmpi slt, %1, %2 : i32
      scf.condition(%3)
    } do {
      %1 = memref.load %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
      %2 = memref.load %alloca_5[%c0] : memref<1xi32>
      %3 = arith.index_cast %2 : i32 to index
      %dim = memref.dim %1, %c0 : memref<?xf32, strided<[1], offset: ?>>
      %4 = arith.subi %dim, %3 : index
      %subview = memref.subview %1[%3] [%4] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
      %5 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
      %6 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %7 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %8 = llvm.getelementptr %6[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %9 = llvm.getelementptr inbounds|nuw %8[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %cst, %9 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
      %10 = memref.load %alloca_5[%c0] : memref<1xi32>
      %11 = arith.addi %10, %c1_i32 : i32
      memref.store %11, %alloca_5[%c0] : memref<1xi32>
      scf.yield
    }
    memref.store %c0_i32, %alloca_5[%c0] : memref<1xi32>
    scf.while : () -> () {
      %1 = memref.load %alloca_5[%c0] : memref<1xi32>
      %2 = memref.load %alloca[%c0] : memref<1xi32>
      %3 = arith.cmpi slt, %1, %2 : i32
      scf.condition(%3)
    } do {
      %1 = memref.load %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
      %2 = memref.load %alloca_5[%c0] : memref<1xi32>
      %3 = arith.index_cast %2 : i32 to index
      %dim = memref.dim %1, %c0 : memref<?xf32, strided<[1], offset: ?>>
      %4 = arith.subi %dim, %3 : index
      %subview = memref.subview %1[%3] [%4] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
      %5 = builtin.unrealized_conversion_cast %subview : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
      %6 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %7 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
      %8 = llvm.getelementptr %6[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %9 = llvm.getelementptr inbounds|nuw %8[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %cst, %9 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
      memref.store %c0_i32, %alloca_6[%c0] : memref<1xi32>
      scf.while : () -> () {
        %12 = memref.load %alloca_6[%c0] : memref<1xi32>
        %13 = memref.load %alloca_0[%c0] : memref<1xi32>
        %14 = arith.cmpi slt, %12, %13 : i32
        scf.condition(%14)
      } do {
        %12 = memref.load %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %13 = memref.load %alloca_5[%c0] : memref<1xi32>
        %14 = arith.index_cast %13 : i32 to index
        %dim_7 = memref.dim %12, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %15 = arith.subi %dim_7, %14 : index
        %subview_8 = memref.subview %12[%14] [%15] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %16 = builtin.unrealized_conversion_cast %subview_8 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
        %17 = llvm.extractvalue %16[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %18 = llvm.extractvalue %16[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %19 = llvm.getelementptr %17[%18] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %20 = llvm.getelementptr inbounds|nuw %19[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %21 = llvm.load %20 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
        %22 = memref.load %alloca_1[%c0] : memref<1xmemref<124xf32>>
        %23 = arith.subi %c124, %14 : index
        %subview_9 = memref.subview %22[%14] [%23] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
        %24 = memref.load %alloca_6[%c0] : memref<1xi32>
        %25 = arith.index_cast %24 : i32 to index
        %subview_10 = memref.subview %subview_9[%25] [1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<1xf32, strided<[1], offset: ?>>
        %26 = memref.load %subview_10[%c0] : memref<1xf32, strided<[1], offset: ?>>
        %27 = memref.load %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %dim_11 = memref.dim %27, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %28 = arith.subi %dim_11, %25 : index
        %subview_12 = memref.subview %27[%25] [%28] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %29 = memref.load %subview_12[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %30 = arith.mulf %26, %29 : f32
        %31 = arith.addf %21, %30 : f32
        %32 = llvm.extractvalue %16[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %33 = llvm.extractvalue %16[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %34 = llvm.getelementptr %32[%33] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %35 = llvm.getelementptr inbounds|nuw %34[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        llvm.store %31, %35 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
        %36 = memref.load %alloca_6[%c0] : memref<1xi32>
        %37 = arith.addi %36, %c1_i32 : i32
        memref.store %37, %alloca_6[%c0] : memref<1xi32>
        scf.yield
      }
      memref.store %c0_i32, %alloca_6[%c0] : memref<1xi32>
      scf.while : () -> () {
        %12 = memref.load %alloca_6[%c0] : memref<1xi32>
        %13 = memref.load %alloca_0[%c0] : memref<1xi32>
        %14 = arith.cmpi slt, %12, %13 : i32
        scf.condition(%14)
      } do {
        %12 = memref.load %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %13 = memref.load %alloca_6[%c0] : memref<1xi32>
        %14 = arith.index_cast %13 : i32 to index
        %dim_7 = memref.dim %12, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %15 = arith.subi %dim_7, %14 : index
        %subview_8 = memref.subview %12[%14] [%15] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %16 = builtin.unrealized_conversion_cast %subview_8 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
        %17 = llvm.extractvalue %16[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %18 = llvm.extractvalue %16[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %19 = llvm.getelementptr %17[%18] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %20 = llvm.getelementptr inbounds|nuw %19[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %21 = llvm.load %20 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
        %22 = memref.load %alloca_1[%c0] : memref<1xmemref<124xf32>>
        %23 = memref.load %alloca_5[%c0] : memref<1xi32>
        %24 = arith.index_cast %23 : i32 to index
        %25 = arith.subi %c124, %24 : index
        %subview_9 = memref.subview %22[%24] [%25] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
        %subview_10 = memref.subview %subview_9[%14] [1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<1xf32, strided<[1], offset: ?>>
        %26 = memref.load %subview_10[%c0] : memref<1xf32, strided<[1], offset: ?>>
        %27 = memref.load %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %dim_11 = memref.dim %27, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %28 = arith.subi %dim_11, %24 : index
        %subview_12 = memref.subview %27[%24] [%28] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %29 = builtin.unrealized_conversion_cast %subview_12 : memref<?xf32, strided<[1], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
        %30 = llvm.extractvalue %29[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %31 = llvm.extractvalue %29[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %32 = llvm.getelementptr %30[%31] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %33 = llvm.getelementptr inbounds|nuw %32[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %34 = llvm.load %33 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
        %35 = arith.mulf %26, %34 : f32
        %36 = arith.addf %21, %35 : f32
        %37 = llvm.extractvalue %16[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %38 = llvm.extractvalue %16[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
        %39 = llvm.getelementptr %37[%38] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %40 = llvm.getelementptr inbounds|nuw %39[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        llvm.store %36, %40 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
        %41 = memref.load %alloca_6[%c0] : memref<1xi32>
        %42 = arith.addi %41, %c1_i32 : i32
        memref.store %42, %alloca_6[%c0] : memref<1xi32>
        scf.yield
      }
      %10 = memref.load %alloca_5[%c0] : memref<1xi32>
      %11 = arith.addi %10, %c1_i32 : i32
      memref.store %11, %alloca_5[%c0] : memref<1xi32>
      scf.yield
    }
    return
  }
}
