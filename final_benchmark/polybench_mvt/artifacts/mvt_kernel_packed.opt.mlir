module @"/Volumes/ShravsSSD/ms-thesis-copy/benchmark_exploration/source_diffs/polybench_mvt_clangir/mvt_kernel_packed.c" attributes {llvm.target_triple = "arm64-apple-macosx26.0.0"} {
  func.func @kernel_mvt(%arg0: i32, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: memref<?xf32, strided<[1], offset: ?>>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: memref<?xf32, strided<[1], offset: ?>>, %arg5: memref<124xf32>) attributes {no_inline} {
    %c1_i32 = arith.constant 1 : i32
    %c124 = arith.constant 124 : index
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_1 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_3 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %alloca_5 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_6 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg2, %alloca_1[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg3, %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg4, %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg5, %alloca_4[%c0] : memref<1xmemref<124xf32>>
    memref.store %c0_i32, %alloca_5[%c0] : memref<1xi32>
    scf.while : () -> () {
      %0 = memref.load %alloca_5[%c0] : memref<1xi32>
      %1 = memref.load %alloca[%c0] : memref<1xi32>
      %2 = arith.cmpi slt, %0, %1 : i32
      scf.condition(%2)
    } do {
      memref.store %c0_i32, %alloca_6[%c0] : memref<1xi32>
      scf.while : () -> () {
        %2 = memref.load %alloca_6[%c0] : memref<1xi32>
        %3 = memref.load %alloca[%c0] : memref<1xi32>
        %4 = arith.cmpi slt, %2, %3 : i32
        scf.condition(%4)
      } do {
        %2 = memref.load %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %3 = memref.load %alloca_5[%c0] : memref<1xi32>
        %4 = arith.index_cast %3 : i32 to index
        %dim = memref.dim %2, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %5 = arith.subi %dim, %4 : index
        %subview = memref.subview %2[%4] [%5] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %6 = memref.load %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %7 = memref.load %alloca_4[%c0] : memref<1xmemref<124xf32>>
        %8 = arith.subi %c124, %4 : index
        %subview_7 = memref.subview %7[%4] [%8] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
        %9 = memref.load %alloca_6[%c0] : memref<1xi32>
        %10 = arith.index_cast %9 : i32 to index
        %subview_8 = memref.subview %subview_7[%10] [1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<1xf32, strided<[1], offset: ?>>
        %11 = memref.load %subview_8[%c0] : memref<1xf32, strided<[1], offset: ?>>
        %12 = memref.load %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %dim_9 = memref.dim %12, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %13 = arith.subi %dim_9, %10 : index
        %subview_10 = memref.subview %12[%10] [%13] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %14 = memref.load %subview_10[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %15 = arith.mulf %11, %14 : f32
        %16 = arith.addf %6, %15 : f32
        memref.store %16, %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %17 = memref.load %alloca_6[%c0] : memref<1xi32>
        %18 = arith.addi %17, %c1_i32 : i32
        memref.store %18, %alloca_6[%c0] : memref<1xi32>
        scf.yield
      }
      %0 = memref.load %alloca_5[%c0] : memref<1xi32>
      %1 = arith.addi %0, %c1_i32 : i32
      memref.store %1, %alloca_5[%c0] : memref<1xi32>
      scf.yield
    }
    memref.store %c0_i32, %alloca_5[%c0] : memref<1xi32>
    scf.while : () -> () {
      %0 = memref.load %alloca_5[%c0] : memref<1xi32>
      %1 = memref.load %alloca[%c0] : memref<1xi32>
      %2 = arith.cmpi slt, %0, %1 : i32
      scf.condition(%2)
    } do {
      memref.store %c0_i32, %alloca_6[%c0] : memref<1xi32>
      scf.while : () -> () {
        %2 = memref.load %alloca_6[%c0] : memref<1xi32>
        %3 = memref.load %alloca[%c0] : memref<1xi32>
        %4 = arith.cmpi slt, %2, %3 : i32
        scf.condition(%4)
      } do {
        %2 = memref.load %alloca_1[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %3 = memref.load %alloca_5[%c0] : memref<1xi32>
        %4 = arith.index_cast %3 : i32 to index
        %dim = memref.dim %2, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %5 = arith.subi %dim, %4 : index
        %subview = memref.subview %2[%4] [%5] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %6 = memref.load %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %7 = memref.load %alloca_4[%c0] : memref<1xmemref<124xf32>>
        %8 = memref.load %alloca_6[%c0] : memref<1xi32>
        %9 = arith.index_cast %8 : i32 to index
        %10 = arith.subi %c124, %9 : index
        %subview_7 = memref.subview %7[%9] [%10] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
        %subview_8 = memref.subview %subview_7[%4] [1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<1xf32, strided<[1], offset: ?>>
        %11 = memref.load %subview_8[%c0] : memref<1xf32, strided<[1], offset: ?>>
        %12 = memref.load %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %dim_9 = memref.dim %12, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %13 = arith.subi %dim_9, %9 : index
        %subview_10 = memref.subview %12[%9] [%13] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %14 = memref.load %subview_10[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %15 = arith.mulf %11, %14 : f32
        %16 = arith.addf %6, %15 : f32
        memref.store %16, %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %17 = memref.load %alloca_6[%c0] : memref<1xi32>
        %18 = arith.addi %17, %c1_i32 : i32
        memref.store %18, %alloca_6[%c0] : memref<1xi32>
        scf.yield
      }
      %0 = memref.load %alloca_5[%c0] : memref<1xi32>
      %1 = arith.addi %0, %c1_i32 : i32
      memref.store %1, %alloca_5[%c0] : memref<1xi32>
      scf.yield
    }
    return
  }
  func.func @run_mvt_packed(%arg0: memref<124xf32>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: memref<?xf32, strided<[1], offset: ?>>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: i32) attributes {no_inline} {
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_1 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_3 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    memref.store %arg0, %alloca[%c0] : memref<1xmemref<124xf32>>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg2, %alloca_1[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg3, %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg4, %alloca_3[%c0] : memref<1xi32>
    %0 = memref.load %alloca_3[%c0] : memref<1xi32>
    %1 = memref.load %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %2 = memref.load %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %3 = arith.index_cast %0 : i32 to index
    %dim = memref.dim %1, %c0 : memref<?xf32, strided<[1], offset: ?>>
    %4 = arith.subi %dim, %3 : index
    %subview = memref.subview %1[%3] [%4] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    %5 = memref.load %alloca_1[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %6 = memref.load %alloca[%c0] : memref<1xmemref<124xf32>>
    call @kernel_mvt(%0, %1, %2, %subview, %5, %6) : (i32, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<124xf32>) -> ()
    return
  }
}

