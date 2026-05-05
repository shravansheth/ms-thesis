module @"/Volumes/ShravsSSD/ms-thesis-copy/benchmark_exploration/source_diffs/polybench_mvt_clangir/mvt_kernel_packed.c" attributes {llvm.target_triple = "arm64-apple-macosx26.0.0"} {
  func.func @kernel_mvt(%arg0: i32, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: memref<?xf32, strided<[1], offset: ?>>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: memref<?xf32, strided<[1], offset: ?>>, %arg5: memref<124xf32>) attributes {no_inline} {
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast = memref.cast %alloca : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_1 = memref.cast %alloca_0 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_3 = memref.cast %alloca_2 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_5 = memref.cast %alloca_4 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_6 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_7 = memref.cast %alloca_6 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_8 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %cast_9 = memref.cast %alloca_8 : memref<1xmemref<124xf32>> to memref<?xmemref<124xf32>, strided<[1], offset: ?>>
    %alloca_10 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_11 = memref.cast %alloca_10 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_12 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_13 = memref.cast %alloca_12 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %c0 = arith.constant 0 : index
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    %c0_14 = arith.constant 0 : index
    memref.store %arg1, %alloca_0[%c0_14] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_15 = arith.constant 0 : index
    memref.store %arg2, %alloca_2[%c0_15] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_16 = arith.constant 0 : index
    memref.store %arg3, %alloca_4[%c0_16] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_17 = arith.constant 0 : index
    memref.store %arg4, %alloca_6[%c0_17] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_18 = arith.constant 0 : index
    memref.store %arg5, %alloca_8[%c0_18] : memref<1xmemref<124xf32>>
    memref.alloca_scope  {
      %c0_i32 = arith.constant 0 : i32
      %c0_19 = arith.constant 0 : index
      memref.store %c0_i32, %alloca_10[%c0_19] : memref<1xi32>
      scf.while : () -> () {
        %c0_20 = arith.constant 0 : index
        %0 = memref.load %alloca_10[%c0_20] : memref<1xi32>
        %c0_21 = arith.constant 0 : index
        %1 = memref.load %alloca[%c0_21] : memref<1xi32>
        %2 = arith.cmpi slt, %0, %1 : i32
        scf.condition(%2)
      } do {
        memref.alloca_scope  {
          %c0_i32_22 = arith.constant 0 : i32
          %c0_23 = arith.constant 0 : index
          memref.store %c0_i32_22, %alloca_12[%c0_23] : memref<1xi32>
          scf.while : () -> () {
            %c0_24 = arith.constant 0 : index
            %2 = memref.load %alloca_12[%c0_24] : memref<1xi32>
            %c0_25 = arith.constant 0 : index
            %3 = memref.load %alloca[%c0_25] : memref<1xi32>
            %4 = arith.cmpi slt, %2, %3 : i32
            scf.condition(%4)
          } do {
            %c0_24 = arith.constant 0 : index
            %2 = memref.load %alloca_0[%c0_24] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
            %c0_25 = arith.constant 0 : index
            %3 = memref.load %alloca_10[%c0_25] : memref<1xi32>
            %4 = arith.index_cast %3 : i32 to index
            %c0_26 = arith.constant 0 : index
            %dim = memref.dim %2, %c0_26 : memref<?xf32, strided<[1], offset: ?>>
            %5 = arith.subi %dim, %4 : index
            %subview = memref.subview %2[%4] [%5] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
            %c0_27 = arith.constant 0 : index
            %6 = memref.load %subview[%c0_27] : memref<?xf32, strided<[1], offset: ?>>
            %c0_28 = arith.constant 0 : index
            %7 = memref.load %alloca_8[%c0_28] : memref<1xmemref<124xf32>>
            %c0_29 = arith.constant 0 : index
            %8 = memref.load %alloca_10[%c0_29] : memref<1xi32>
            %9 = arith.index_cast %8 : i32 to index
            %c0_30 = arith.constant 0 : index
            %c124 = arith.constant 124 : index
            %10 = arith.subi %c124, %9 : index
            %subview_31 = memref.subview %7[%9] [%10] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
            %c0_32 = arith.constant 0 : index
            %11 = memref.load %alloca_12[%c0_32] : memref<1xi32>
            %12 = arith.index_cast %11 : i32 to index
            %c1 = arith.constant 1 : index
            %subview_33 = memref.subview %subview_31[%12] [%c1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
            %c0_34 = arith.constant 0 : index
            %13 = memref.load %subview_33[%c0_34] : memref<?xf32, strided<[1], offset: ?>>
            %c0_35 = arith.constant 0 : index
            %14 = memref.load %alloca_4[%c0_35] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
            %c0_36 = arith.constant 0 : index
            %15 = memref.load %alloca_12[%c0_36] : memref<1xi32>
            %16 = arith.index_cast %15 : i32 to index
            %c0_37 = arith.constant 0 : index
            %dim_38 = memref.dim %14, %c0_37 : memref<?xf32, strided<[1], offset: ?>>
            %17 = arith.subi %dim_38, %16 : index
            %subview_39 = memref.subview %14[%16] [%17] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
            %c0_40 = arith.constant 0 : index
            %18 = memref.load %subview_39[%c0_40] : memref<?xf32, strided<[1], offset: ?>>
            %19 = arith.mulf %13, %18 : f32
            %20 = arith.addf %6, %19 : f32
            %c0_41 = arith.constant 0 : index
            %21 = memref.load %alloca_0[%c0_41] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
            %c0_42 = arith.constant 0 : index
            %22 = memref.load %alloca_10[%c0_42] : memref<1xi32>
            %23 = arith.index_cast %22 : i32 to index
            %c0_43 = arith.constant 0 : index
            %dim_44 = memref.dim %21, %c0_43 : memref<?xf32, strided<[1], offset: ?>>
            %24 = arith.subi %dim_44, %23 : index
            %subview_45 = memref.subview %21[%23] [%24] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
            %c0_46 = arith.constant 0 : index
            memref.store %20, %subview_45[%c0_46] : memref<?xf32, strided<[1], offset: ?>>
            %c0_47 = arith.constant 0 : index
            %25 = memref.load %alloca_12[%c0_47] : memref<1xi32>
            %c1_i32_48 = arith.constant 1 : i32
            %26 = arith.addi %25, %c1_i32_48 : i32
            %c0_49 = arith.constant 0 : index
            memref.store %26, %alloca_12[%c0_49] : memref<1xi32>
            scf.yield
          }
        }
        %c0_20 = arith.constant 0 : index
        %0 = memref.load %alloca_10[%c0_20] : memref<1xi32>
        %c1_i32 = arith.constant 1 : i32
        %1 = arith.addi %0, %c1_i32 : i32
        %c0_21 = arith.constant 0 : index
        memref.store %1, %alloca_10[%c0_21] : memref<1xi32>
        scf.yield
      }
    }
    memref.alloca_scope  {
      %c0_i32 = arith.constant 0 : i32
      %c0_19 = arith.constant 0 : index
      memref.store %c0_i32, %alloca_10[%c0_19] : memref<1xi32>
      scf.while : () -> () {
        %c0_20 = arith.constant 0 : index
        %0 = memref.load %alloca_10[%c0_20] : memref<1xi32>
        %c0_21 = arith.constant 0 : index
        %1 = memref.load %alloca[%c0_21] : memref<1xi32>
        %2 = arith.cmpi slt, %0, %1 : i32
        scf.condition(%2)
      } do {
        memref.alloca_scope  {
          %c0_i32_22 = arith.constant 0 : i32
          %c0_23 = arith.constant 0 : index
          memref.store %c0_i32_22, %alloca_12[%c0_23] : memref<1xi32>
          scf.while : () -> () {
            %c0_24 = arith.constant 0 : index
            %2 = memref.load %alloca_12[%c0_24] : memref<1xi32>
            %c0_25 = arith.constant 0 : index
            %3 = memref.load %alloca[%c0_25] : memref<1xi32>
            %4 = arith.cmpi slt, %2, %3 : i32
            scf.condition(%4)
          } do {
            %c0_24 = arith.constant 0 : index
            %2 = memref.load %alloca_2[%c0_24] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
            %c0_25 = arith.constant 0 : index
            %3 = memref.load %alloca_10[%c0_25] : memref<1xi32>
            %4 = arith.index_cast %3 : i32 to index
            %c0_26 = arith.constant 0 : index
            %dim = memref.dim %2, %c0_26 : memref<?xf32, strided<[1], offset: ?>>
            %5 = arith.subi %dim, %4 : index
            %subview = memref.subview %2[%4] [%5] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
            %c0_27 = arith.constant 0 : index
            %6 = memref.load %subview[%c0_27] : memref<?xf32, strided<[1], offset: ?>>
            %c0_28 = arith.constant 0 : index
            %7 = memref.load %alloca_8[%c0_28] : memref<1xmemref<124xf32>>
            %c0_29 = arith.constant 0 : index
            %8 = memref.load %alloca_12[%c0_29] : memref<1xi32>
            %9 = arith.index_cast %8 : i32 to index
            %c0_30 = arith.constant 0 : index
            %c124 = arith.constant 124 : index
            %10 = arith.subi %c124, %9 : index
            %subview_31 = memref.subview %7[%9] [%10] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
            %c0_32 = arith.constant 0 : index
            %11 = memref.load %alloca_10[%c0_32] : memref<1xi32>
            %12 = arith.index_cast %11 : i32 to index
            %c1 = arith.constant 1 : index
            %subview_33 = memref.subview %subview_31[%12] [%c1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
            %c0_34 = arith.constant 0 : index
            %13 = memref.load %subview_33[%c0_34] : memref<?xf32, strided<[1], offset: ?>>
            %c0_35 = arith.constant 0 : index
            %14 = memref.load %alloca_6[%c0_35] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
            %c0_36 = arith.constant 0 : index
            %15 = memref.load %alloca_12[%c0_36] : memref<1xi32>
            %16 = arith.index_cast %15 : i32 to index
            %c0_37 = arith.constant 0 : index
            %dim_38 = memref.dim %14, %c0_37 : memref<?xf32, strided<[1], offset: ?>>
            %17 = arith.subi %dim_38, %16 : index
            %subview_39 = memref.subview %14[%16] [%17] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
            %c0_40 = arith.constant 0 : index
            %18 = memref.load %subview_39[%c0_40] : memref<?xf32, strided<[1], offset: ?>>
            %19 = arith.mulf %13, %18 : f32
            %20 = arith.addf %6, %19 : f32
            %c0_41 = arith.constant 0 : index
            %21 = memref.load %alloca_2[%c0_41] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
            %c0_42 = arith.constant 0 : index
            %22 = memref.load %alloca_10[%c0_42] : memref<1xi32>
            %23 = arith.index_cast %22 : i32 to index
            %c0_43 = arith.constant 0 : index
            %dim_44 = memref.dim %21, %c0_43 : memref<?xf32, strided<[1], offset: ?>>
            %24 = arith.subi %dim_44, %23 : index
            %subview_45 = memref.subview %21[%23] [%24] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
            %c0_46 = arith.constant 0 : index
            memref.store %20, %subview_45[%c0_46] : memref<?xf32, strided<[1], offset: ?>>
            %c0_47 = arith.constant 0 : index
            %25 = memref.load %alloca_12[%c0_47] : memref<1xi32>
            %c1_i32_48 = arith.constant 1 : i32
            %26 = arith.addi %25, %c1_i32_48 : i32
            %c0_49 = arith.constant 0 : index
            memref.store %26, %alloca_12[%c0_49] : memref<1xi32>
            scf.yield
          }
        }
        %c0_20 = arith.constant 0 : index
        %0 = memref.load %alloca_10[%c0_20] : memref<1xi32>
        %c1_i32 = arith.constant 1 : i32
        %1 = arith.addi %0, %c1_i32 : i32
        %c0_21 = arith.constant 0 : index
        memref.store %1, %alloca_10[%c0_21] : memref<1xi32>
        scf.yield
      }
    }
    return
  }
  func.func @run_mvt_packed(%arg0: memref<124xf32>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: memref<?xf32, strided<[1], offset: ?>>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: i32) attributes {no_inline} {
    %alloca = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %cast = memref.cast %alloca : memref<1xmemref<124xf32>> to memref<?xmemref<124xf32>, strided<[1], offset: ?>>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_1 = memref.cast %alloca_0 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_3 = memref.cast %alloca_2 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_5 = memref.cast %alloca_4 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_6 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_7 = memref.cast %alloca_6 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %c0 = arith.constant 0 : index
    memref.store %arg0, %alloca[%c0] : memref<1xmemref<124xf32>>
    %c0_8 = arith.constant 0 : index
    memref.store %arg1, %alloca_0[%c0_8] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_9 = arith.constant 0 : index
    memref.store %arg2, %alloca_2[%c0_9] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_10 = arith.constant 0 : index
    memref.store %arg3, %alloca_4[%c0_10] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_11 = arith.constant 0 : index
    memref.store %arg4, %alloca_6[%c0_11] : memref<1xi32>
    %c0_12 = arith.constant 0 : index
    %0 = memref.load %alloca_6[%c0_12] : memref<1xi32>
    %c0_13 = arith.constant 0 : index
    %1 = memref.load %alloca_4[%c0_13] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_14 = arith.constant 0 : index
    %2 = memref.load %alloca_0[%c0_14] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_15 = arith.constant 0 : index
    %3 = memref.load %alloca_4[%c0_15] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_16 = arith.constant 0 : index
    %4 = memref.load %alloca_6[%c0_16] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %c0_17 = arith.constant 0 : index
    %dim = memref.dim %3, %c0_17 : memref<?xf32, strided<[1], offset: ?>>
    %6 = arith.subi %dim, %5 : index
    %subview = memref.subview %3[%5] [%6] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    %c0_18 = arith.constant 0 : index
    %7 = memref.load %alloca_2[%c0_18] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_19 = arith.constant 0 : index
    %8 = memref.load %alloca[%c0_19] : memref<1xmemref<124xf32>>
    call @kernel_mvt(%0, %1, %2, %subview, %7, %8) : (i32, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<124xf32>) -> ()
    return
  }
}

