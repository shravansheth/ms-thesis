module @"/Volumes/ShravsSSD/ms-thesis-copy/benchmark_exploration/source_diffs/polybench_bicg_clangir/bicg_kernel_packed.c" attributes {llvm.target_triple = "arm64-apple-macosx26.0.0"} {
  func.func @kernel_bicg(%arg0: i32, %arg1: i32, %arg2: memref<116xf32>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: memref<?xf32, strided<[1], offset: ?>>, %arg5: memref<?xf32, strided<[1], offset: ?>>, %arg6: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %c116 = arith.constant 116 : index
    %c1_i32 = arith.constant 1 : i32
    %cst = arith.constant 0.000000e+00 : f32
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_0 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_1 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<116xf32>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_3 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_5 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_6 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_7 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xi32>
    memref.store %arg2, %alloca_1[%c0] : memref<1xmemref<116xf32>>
    memref.store %arg3, %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg4, %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg5, %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg6, %alloca_5[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %c0_i32, %alloca_6[%c0] : memref<1xi32>
    scf.while : () -> () {
      %0 = memref.load %alloca_6[%c0] : memref<1xi32>
      %1 = memref.load %alloca[%c0] : memref<1xi32>
      %2 = arith.cmpi slt, %0, %1 : i32
      scf.condition(%2)
    } do {
      %0 = memref.load %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
      %1 = memref.load %alloca_6[%c0] : memref<1xi32>
      %2 = arith.index_cast %1 : i32 to index
      %dim = memref.dim %0, %c0 : memref<?xf32, strided<[1], offset: ?>>
      %3 = arith.subi %dim, %2 : index
      %subview = memref.subview %0[%2] [%3] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
      memref.store %cst, %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %4 = memref.load %alloca_6[%c0] : memref<1xi32>
      %5 = arith.addi %4, %c1_i32 : i32
      memref.store %5, %alloca_6[%c0] : memref<1xi32>
      scf.yield
    }
    memref.store %c0_i32, %alloca_6[%c0] : memref<1xi32>
    scf.while : () -> () {
      %0 = memref.load %alloca_6[%c0] : memref<1xi32>
      %1 = memref.load %alloca_0[%c0] : memref<1xi32>
      %2 = arith.cmpi slt, %0, %1 : i32
      scf.condition(%2)
    } do {
      %0 = memref.load %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
      %1 = memref.load %alloca_6[%c0] : memref<1xi32>
      %2 = arith.index_cast %1 : i32 to index
      %dim = memref.dim %0, %c0 : memref<?xf32, strided<[1], offset: ?>>
      %3 = arith.subi %dim, %2 : index
      %subview = memref.subview %0[%2] [%3] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
      memref.store %cst, %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
      memref.store %c0_i32, %alloca_7[%c0] : memref<1xi32>
      scf.while : () -> () {
        %6 = memref.load %alloca_7[%c0] : memref<1xi32>
        %7 = memref.load %alloca[%c0] : memref<1xi32>
        %8 = arith.cmpi slt, %6, %7 : i32
        scf.condition(%8)
      } do {
        %6 = memref.load %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %7 = memref.load %alloca_7[%c0] : memref<1xi32>
        %8 = arith.index_cast %7 : i32 to index
        %dim_8 = memref.dim %6, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %9 = arith.subi %dim_8, %8 : index
        %subview_9 = memref.subview %6[%8] [%9] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %10 = memref.load %subview_9[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %11 = memref.load %alloca_5[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %12 = memref.load %alloca_6[%c0] : memref<1xi32>
        %13 = arith.index_cast %12 : i32 to index
        %dim_10 = memref.dim %11, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %14 = arith.subi %dim_10, %13 : index
        %subview_11 = memref.subview %11[%13] [%14] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %15 = memref.load %subview_11[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %16 = memref.load %alloca_1[%c0] : memref<1xmemref<116xf32>>
        %17 = arith.subi %c116, %13 : index
        %subview_12 = memref.subview %16[%13] [%17] [1] : memref<116xf32> to memref<?xf32, strided<[1], offset: ?>>
        %subview_13 = memref.subview %subview_12[%8] [1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<1xf32, strided<[1], offset: ?>>
        %18 = memref.load %subview_13[%c0] : memref<1xf32, strided<[1], offset: ?>>
        %19 = arith.mulf %15, %18 : f32
        %20 = arith.addf %10, %19 : f32
        memref.store %20, %subview_9[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %21 = memref.load %alloca_3[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %22 = memref.load %alloca_6[%c0] : memref<1xi32>
        %23 = arith.index_cast %22 : i32 to index
        %dim_14 = memref.dim %21, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %24 = arith.subi %dim_14, %23 : index
        %subview_15 = memref.subview %21[%23] [%24] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %25 = memref.load %subview_15[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %26 = memref.load %alloca_1[%c0] : memref<1xmemref<116xf32>>
        %27 = arith.subi %c116, %23 : index
        %subview_16 = memref.subview %26[%23] [%27] [1] : memref<116xf32> to memref<?xf32, strided<[1], offset: ?>>
        %28 = memref.load %alloca_7[%c0] : memref<1xi32>
        %29 = arith.index_cast %28 : i32 to index
        %subview_17 = memref.subview %subview_16[%29] [1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<1xf32, strided<[1], offset: ?>>
        %30 = memref.load %subview_17[%c0] : memref<1xf32, strided<[1], offset: ?>>
        %31 = memref.load %alloca_4[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %dim_18 = memref.dim %31, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %32 = arith.subi %dim_18, %29 : index
        %subview_19 = memref.subview %31[%29] [%32] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %33 = memref.load %subview_19[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %34 = arith.mulf %30, %33 : f32
        %35 = arith.addf %25, %34 : f32
        memref.store %35, %subview_15[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %36 = memref.load %alloca_7[%c0] : memref<1xi32>
        %37 = arith.addi %36, %c1_i32 : i32
        memref.store %37, %alloca_7[%c0] : memref<1xi32>
        scf.yield
      }
      %4 = memref.load %alloca_6[%c0] : memref<1xi32>
      %5 = arith.addi %4, %c1_i32 : i32
      memref.store %5, %alloca_6[%c0] : memref<1xi32>
      scf.yield
    }
    return
  }
  func.func @run_bicg_packed(%arg0: memref<116xf32>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: memref<?xf32, strided<[1], offset: ?>>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: i32, %arg5: i32) attributes {no_inline} {
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<116xf32>>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_1 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_3 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_4 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    memref.store %arg0, %alloca[%c0] : memref<1xmemref<116xf32>>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg2, %alloca_1[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg3, %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg4, %alloca_3[%c0] : memref<1xi32>
    memref.store %arg5, %alloca_4[%c0] : memref<1xi32>
    %0 = memref.load %alloca_3[%c0] : memref<1xi32>
    %1 = memref.load %alloca_4[%c0] : memref<1xi32>
    %2 = memref.load %alloca[%c0] : memref<1xmemref<116xf32>>
    %3 = memref.load %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %4 = arith.index_cast %0 : i32 to index
    %dim = memref.dim %3, %c0 : memref<?xf32, strided<[1], offset: ?>>
    %5 = arith.subi %dim, %4 : index
    %subview = memref.subview %3[%4] [%5] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    %6 = memref.load %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %7 = memref.load %alloca_1[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    call @kernel_bicg(%0, %1, %2, %3, %subview, %6, %7) : (i32, i32, memref<116xf32>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    return
  }
}

