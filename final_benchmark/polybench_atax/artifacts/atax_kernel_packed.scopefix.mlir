module @"/Volumes/ShravsSSD/ms-thesis-copy/benchmark_exploration/source_diffs/polybench_atax_clangir/atax_kernel_packed.c" attributes {llvm.target_triple = "arm64-apple-macosx26.0.0"} {
  func.func @kernel_atax(%arg0: i32, %arg1: i32, %arg2: memref<124xf32>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: memref<?xf32, strided<[1], offset: ?>>, %arg5: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast = memref.cast %alloca : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_0 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_1 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %cast_3 = memref.cast %alloca_2 : memref<1xmemref<124xf32>> to memref<?xmemref<124xf32>, strided<[1], offset: ?>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_5 = memref.cast %alloca_4 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_6 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_7 = memref.cast %alloca_6 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_8 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_9 = memref.cast %alloca_8 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_10 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_11 = memref.cast %alloca_10 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_12 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_13 = memref.cast %alloca_12 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %c0 = arith.constant 0 : index
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    %c0_14 = arith.constant 0 : index
    memref.store %arg1, %alloca_0[%c0_14] : memref<1xi32>
    %c0_15 = arith.constant 0 : index
    memref.store %arg2, %alloca_2[%c0_15] : memref<1xmemref<124xf32>>
    %c0_16 = arith.constant 0 : index
    memref.store %arg3, %alloca_4[%c0_16] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_17 = arith.constant 0 : index
    memref.store %arg4, %alloca_6[%c0_17] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_18 = arith.constant 0 : index
    memref.store %arg5, %alloca_8[%c0_18] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_i32 = arith.constant 0 : i32
    %c0_19 = arith.constant 0 : index
    memref.store %c0_i32, %alloca_10[%c0_19] : memref<1xi32>
    %c0_20 = arith.constant 0 : index
    %0 = memref.load %cast_1[%c0_20] : memref<?xi32, strided<[1], offset: ?>>
    %c1_i32 = arith.constant 1 : i32
    scf.for %arg6 = %c0_i32 to %0 step %c1_i32  : i32 {
      %c0_i32_23 = arith.constant 0 : i32
      %1 = arith.sitofp %c0_i32_23 : i32 to f32
      %c0_24 = arith.constant 0 : index
      %2 = memref.load %alloca_6[%c0_24] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
      %3 = arith.index_cast %arg6 : i32 to index
      %c0_25 = arith.constant 0 : index
      %dim = memref.dim %2, %c0_25 : memref<?xf32, strided<[1], offset: ?>>
      %4 = arith.subi %dim, %3 : index
      %subview = memref.subview %2[%3] [%4] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
      %c0_26 = arith.constant 0 : index
      memref.store %1, %subview[%c0_26] : memref<?xf32, strided<[1], offset: ?>>
    }
    %c0_i32_21 = arith.constant 0 : i32
    %c0_22 = arith.constant 0 : index
    memref.store %c0_i32_21, %alloca_10[%c0_22] : memref<1xi32>
    scf.while : () -> () {
      %c0_23 = arith.constant 0 : index
      %1 = memref.load %alloca_10[%c0_23] : memref<1xi32>
      %c0_24 = arith.constant 0 : index
      %2 = memref.load %alloca[%c0_24] : memref<1xi32>
      %3 = arith.cmpi slt, %1, %2 : i32
      scf.condition(%3)
    } do {
      %cst = arith.constant 0.000000e+00 : f32
      %c0_23 = arith.constant 0 : index
      %1 = memref.load %alloca_8[%c0_23] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
      %c0_24 = arith.constant 0 : index
      %2 = memref.load %alloca_10[%c0_24] : memref<1xi32>
      %3 = arith.index_cast %2 : i32 to index
      %c0_25 = arith.constant 0 : index
      %dim = memref.dim %1, %c0_25 : memref<?xf32, strided<[1], offset: ?>>
      %4 = arith.subi %dim, %3 : index
      %subview = memref.subview %1[%3] [%4] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
      %c0_26 = arith.constant 0 : index
      memref.store %cst, %subview[%c0_26] : memref<?xf32, strided<[1], offset: ?>>
      %c0_i32_27 = arith.constant 0 : i32
      %c0_28 = arith.constant 0 : index
      memref.store %c0_i32_27, %alloca_12[%c0_28] : memref<1xi32>
      scf.while : () -> () {
        %c0_34 = arith.constant 0 : index
        %7 = memref.load %alloca_12[%c0_34] : memref<1xi32>
        %c0_35 = arith.constant 0 : index
        %8 = memref.load %alloca_0[%c0_35] : memref<1xi32>
        %9 = arith.cmpi slt, %7, %8 : i32
        scf.condition(%9)
      } do {
        %c0_34 = arith.constant 0 : index
        %7 = memref.load %alloca_8[%c0_34] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_35 = arith.constant 0 : index
        %8 = memref.load %alloca_10[%c0_35] : memref<1xi32>
        %9 = arith.index_cast %8 : i32 to index
        %c0_36 = arith.constant 0 : index
        %dim_37 = memref.dim %7, %c0_36 : memref<?xf32, strided<[1], offset: ?>>
        %10 = arith.subi %dim_37, %9 : index
        %subview_38 = memref.subview %7[%9] [%10] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_39 = arith.constant 0 : index
        %11 = memref.load %subview_38[%c0_39] : memref<?xf32, strided<[1], offset: ?>>
        %c0_40 = arith.constant 0 : index
        %12 = memref.load %alloca_2[%c0_40] : memref<1xmemref<124xf32>>
        %c0_41 = arith.constant 0 : index
        %13 = memref.load %alloca_10[%c0_41] : memref<1xi32>
        %14 = arith.index_cast %13 : i32 to index
        %c0_42 = arith.constant 0 : index
        %c124 = arith.constant 124 : index
        %15 = arith.subi %c124, %14 : index
        %subview_43 = memref.subview %12[%14] [%15] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
        %c0_44 = arith.constant 0 : index
        %16 = memref.load %alloca_12[%c0_44] : memref<1xi32>
        %17 = arith.index_cast %16 : i32 to index
        %c1 = arith.constant 1 : index
        %subview_45 = memref.subview %subview_43[%17] [%c1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_46 = arith.constant 0 : index
        %18 = memref.load %subview_45[%c0_46] : memref<?xf32, strided<[1], offset: ?>>
        %c0_47 = arith.constant 0 : index
        %19 = memref.load %alloca_4[%c0_47] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_48 = arith.constant 0 : index
        %20 = memref.load %alloca_12[%c0_48] : memref<1xi32>
        %21 = arith.index_cast %20 : i32 to index
        %c0_49 = arith.constant 0 : index
        %dim_50 = memref.dim %19, %c0_49 : memref<?xf32, strided<[1], offset: ?>>
        %22 = arith.subi %dim_50, %21 : index
        %subview_51 = memref.subview %19[%21] [%22] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_52 = arith.constant 0 : index
        %23 = memref.load %subview_51[%c0_52] : memref<?xf32, strided<[1], offset: ?>>
        %24 = arith.mulf %18, %23 : f32
        %25 = arith.addf %11, %24 : f32
        %c0_53 = arith.constant 0 : index
        %26 = memref.load %alloca_8[%c0_53] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_54 = arith.constant 0 : index
        %27 = memref.load %alloca_10[%c0_54] : memref<1xi32>
        %28 = arith.index_cast %27 : i32 to index
        %c0_55 = arith.constant 0 : index
        %dim_56 = memref.dim %26, %c0_55 : memref<?xf32, strided<[1], offset: ?>>
        %29 = arith.subi %dim_56, %28 : index
        %subview_57 = memref.subview %26[%28] [%29] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_58 = arith.constant 0 : index
        memref.store %25, %subview_57[%c0_58] : memref<?xf32, strided<[1], offset: ?>>
        %c0_59 = arith.constant 0 : index
        %30 = memref.load %alloca_12[%c0_59] : memref<1xi32>
        %c1_i32_60 = arith.constant 1 : i32
        %31 = arith.addi %30, %c1_i32_60 : i32
        %c0_61 = arith.constant 0 : index
        memref.store %31, %alloca_12[%c0_61] : memref<1xi32>
        scf.yield
      }
      %c0_i32_29 = arith.constant 0 : i32
      %c0_30 = arith.constant 0 : index
      memref.store %c0_i32_29, %alloca_12[%c0_30] : memref<1xi32>
      scf.while : () -> () {
        %c0_34 = arith.constant 0 : index
        %7 = memref.load %alloca_12[%c0_34] : memref<1xi32>
        %c0_35 = arith.constant 0 : index
        %8 = memref.load %alloca_0[%c0_35] : memref<1xi32>
        %9 = arith.cmpi slt, %7, %8 : i32
        scf.condition(%9)
      } do {
        %c0_34 = arith.constant 0 : index
        %7 = memref.load %alloca_6[%c0_34] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_35 = arith.constant 0 : index
        %8 = memref.load %alloca_12[%c0_35] : memref<1xi32>
        %9 = arith.index_cast %8 : i32 to index
        %c0_36 = arith.constant 0 : index
        %dim_37 = memref.dim %7, %c0_36 : memref<?xf32, strided<[1], offset: ?>>
        %10 = arith.subi %dim_37, %9 : index
        %subview_38 = memref.subview %7[%9] [%10] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_39 = arith.constant 0 : index
        %11 = memref.load %subview_38[%c0_39] : memref<?xf32, strided<[1], offset: ?>>
        %c0_40 = arith.constant 0 : index
        %12 = memref.load %alloca_2[%c0_40] : memref<1xmemref<124xf32>>
        %c0_41 = arith.constant 0 : index
        %13 = memref.load %alloca_10[%c0_41] : memref<1xi32>
        %14 = arith.index_cast %13 : i32 to index
        %c0_42 = arith.constant 0 : index
        %c124 = arith.constant 124 : index
        %15 = arith.subi %c124, %14 : index
        %subview_43 = memref.subview %12[%14] [%15] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
        %c0_44 = arith.constant 0 : index
        %16 = memref.load %alloca_12[%c0_44] : memref<1xi32>
        %17 = arith.index_cast %16 : i32 to index
        %c1 = arith.constant 1 : index
        %subview_45 = memref.subview %subview_43[%17] [%c1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_46 = arith.constant 0 : index
        %18 = memref.load %subview_45[%c0_46] : memref<?xf32, strided<[1], offset: ?>>
        %c0_47 = arith.constant 0 : index
        %19 = memref.load %alloca_8[%c0_47] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_48 = arith.constant 0 : index
        %20 = memref.load %alloca_10[%c0_48] : memref<1xi32>
        %21 = arith.index_cast %20 : i32 to index
        %c0_49 = arith.constant 0 : index
        %dim_50 = memref.dim %19, %c0_49 : memref<?xf32, strided<[1], offset: ?>>
        %22 = arith.subi %dim_50, %21 : index
        %subview_51 = memref.subview %19[%21] [%22] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_52 = arith.constant 0 : index
        %23 = memref.load %subview_51[%c0_52] : memref<?xf32, strided<[1], offset: ?>>
        %24 = arith.mulf %18, %23 : f32
        %25 = arith.addf %11, %24 : f32
        %c0_53 = arith.constant 0 : index
        %26 = memref.load %alloca_6[%c0_53] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_54 = arith.constant 0 : index
        %27 = memref.load %alloca_12[%c0_54] : memref<1xi32>
        %28 = arith.index_cast %27 : i32 to index
        %c0_55 = arith.constant 0 : index
        %dim_56 = memref.dim %26, %c0_55 : memref<?xf32, strided<[1], offset: ?>>
        %29 = arith.subi %dim_56, %28 : index
        %subview_57 = memref.subview %26[%28] [%29] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_58 = arith.constant 0 : index
        memref.store %25, %subview_57[%c0_58] : memref<?xf32, strided<[1], offset: ?>>
        %c0_59 = arith.constant 0 : index
        %30 = memref.load %alloca_12[%c0_59] : memref<1xi32>
        %c1_i32_60 = arith.constant 1 : i32
        %31 = arith.addi %30, %c1_i32_60 : i32
        %c0_61 = arith.constant 0 : index
        memref.store %31, %alloca_12[%c0_61] : memref<1xi32>
        scf.yield
      }
      %c0_31 = arith.constant 0 : index
      %5 = memref.load %alloca_10[%c0_31] : memref<1xi32>
      %c1_i32_32 = arith.constant 1 : i32
      %6 = arith.addi %5, %c1_i32_32 : i32
      %c0_33 = arith.constant 0 : index
      memref.store %6, %alloca_10[%c0_33] : memref<1xi32>
      scf.yield
    }
    return
  }
  func.func @run_atax_packed(%arg0: memref<124xf32>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: memref<?xf32, strided<[1], offset: ?>>, %arg3: i32, %arg4: i32) attributes {no_inline} {
    %alloca = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %cast = memref.cast %alloca : memref<1xmemref<124xf32>> to memref<?xmemref<124xf32>, strided<[1], offset: ?>>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_1 = memref.cast %alloca_0 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_3 = memref.cast %alloca_2 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_4 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_5 = memref.cast %alloca_4 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_6 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_7 = memref.cast %alloca_6 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %c0 = arith.constant 0 : index
    memref.store %arg0, %alloca[%c0] : memref<1xmemref<124xf32>>
    %c0_8 = arith.constant 0 : index
    memref.store %arg1, %alloca_0[%c0_8] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_9 = arith.constant 0 : index
    memref.store %arg2, %alloca_2[%c0_9] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_10 = arith.constant 0 : index
    memref.store %arg3, %alloca_4[%c0_10] : memref<1xi32>
    %c0_11 = arith.constant 0 : index
    memref.store %arg4, %alloca_6[%c0_11] : memref<1xi32>
    %c0_12 = arith.constant 0 : index
    %0 = memref.load %alloca_4[%c0_12] : memref<1xi32>
    %c0_13 = arith.constant 0 : index
    %1 = memref.load %alloca_6[%c0_13] : memref<1xi32>
    %c0_14 = arith.constant 0 : index
    %2 = memref.load %alloca[%c0_14] : memref<1xmemref<124xf32>>
    %c0_15 = arith.constant 0 : index
    %3 = memref.load %alloca_0[%c0_15] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_16 = arith.constant 0 : index
    %4 = memref.load %alloca_2[%c0_16] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_17 = arith.constant 0 : index
    %5 = memref.load %alloca_4[%c0_17] : memref<1xi32>
    %6 = arith.index_cast %5 : i32 to index
    %c0_18 = arith.constant 0 : index
    %dim = memref.dim %4, %c0_18 : memref<?xf32, strided<[1], offset: ?>>
    %7 = arith.subi %dim, %6 : index
    %subview = memref.subview %4[%6] [%7] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    %c0_19 = arith.constant 0 : index
    %8 = memref.load %alloca_2[%c0_19] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    call @kernel_atax(%0, %1, %2, %3, %subview, %8) : (i32, i32, memref<124xf32>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    return
  }
}

