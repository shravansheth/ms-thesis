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
    call @kernel_atax(%0, %1, %2, %3, %subview, %4) : (i32, i32, memref<124xf32>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    return
  }
}

