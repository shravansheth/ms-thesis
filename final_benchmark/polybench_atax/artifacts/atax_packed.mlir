module @"/Volumes/ShravsSSD/ms-thesis-copy/benchmark_exploration/source_diffs/polybench_atax_clangir/atax_packed.c" attributes {llvm.target_triple = "arm64-apple-macosx26.0.0"} {
  func.func private @polybench_alloc_data(i64, i32) -> !llvm.ptr
  func.func private @init_array(%arg0: i32, %arg1: i32, %arg2: memref<124xf32>, %arg3: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast = memref.cast %alloca : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_0 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_1 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %cast_3 = memref.cast %alloca_2 : memref<1xmemref<124xf32>> to memref<?xmemref<124xf32>, strided<[1], offset: ?>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_5 = memref.cast %alloca_4 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_6 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_7 = memref.cast %alloca_6 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_8 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_9 = memref.cast %alloca_8 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_10 = memref.alloca() {alignment = 4 : i64} : memref<1xf32>
    %cast_11 = memref.cast %alloca_10 : memref<1xf32> to memref<?xf32, strided<[1], offset: ?>>
    %c0 = arith.constant 0 : index
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    %c0_12 = arith.constant 0 : index
    memref.store %arg1, %alloca_0[%c0_12] : memref<1xi32>
    %c0_13 = arith.constant 0 : index
    memref.store %arg2, %alloca_2[%c0_13] : memref<1xmemref<124xf32>>
    %c0_14 = arith.constant 0 : index
    memref.store %arg3, %alloca_4[%c0_14] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_15 = arith.constant 0 : index
    %0 = memref.load %alloca_0[%c0_15] : memref<1xi32>
    %1 = arith.sitofp %0 : i32 to f32
    %c0_16 = arith.constant 0 : index
    memref.store %1, %alloca_10[%c0_16] : memref<1xf32>
    memref.alloca_scope  {
      %c0_i32 = arith.constant 0 : i32
      %c0_17 = arith.constant 0 : index
      memref.store %c0_i32, %alloca_6[%c0_17] : memref<1xi32>
      scf.while : () -> () {
        %c0_18 = arith.constant 0 : index
        %2 = memref.load %alloca_6[%c0_18] : memref<1xi32>
        %c0_19 = arith.constant 0 : index
        %3 = memref.load %alloca_0[%c0_19] : memref<1xi32>
        %4 = arith.cmpi slt, %2, %3 : i32
        scf.condition(%4)
      } do {
        %c1_i32 = arith.constant 1 : i32
        %2 = arith.sitofp %c1_i32 : i32 to f32
        %c0_18 = arith.constant 0 : index
        %3 = memref.load %alloca_6[%c0_18] : memref<1xi32>
        %4 = arith.sitofp %3 : i32 to f32
        %c0_19 = arith.constant 0 : index
        %5 = memref.load %alloca_10[%c0_19] : memref<1xf32>
        %6 = arith.divf %4, %5 : f32
        %7 = arith.addf %2, %6 : f32
        %c0_20 = arith.constant 0 : index
        %8 = memref.load %alloca_4[%c0_20] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_21 = arith.constant 0 : index
        %9 = memref.load %alloca_6[%c0_21] : memref<1xi32>
        %10 = arith.index_cast %9 : i32 to index
        %c0_22 = arith.constant 0 : index
        %dim = memref.dim %8, %c0_22 : memref<?xf32, strided<[1], offset: ?>>
        %11 = arith.subi %dim, %10 : index
        %subview = memref.subview %8[%10] [%11] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_23 = arith.constant 0 : index
        memref.store %7, %subview[%c0_23] : memref<?xf32, strided<[1], offset: ?>>
        %c0_24 = arith.constant 0 : index
        %12 = memref.load %alloca_6[%c0_24] : memref<1xi32>
        %c1_i32_25 = arith.constant 1 : i32
        %13 = arith.addi %12, %c1_i32_25 : i32
        %c0_26 = arith.constant 0 : index
        memref.store %13, %alloca_6[%c0_26] : memref<1xi32>
        scf.yield
      }
    }
    memref.alloca_scope  {
      %c0_i32 = arith.constant 0 : i32
      %c0_17 = arith.constant 0 : index
      memref.store %c0_i32, %alloca_6[%c0_17] : memref<1xi32>
      scf.while : () -> () {
        %c0_18 = arith.constant 0 : index
        %2 = memref.load %alloca_6[%c0_18] : memref<1xi32>
        %c0_19 = arith.constant 0 : index
        %3 = memref.load %alloca[%c0_19] : memref<1xi32>
        %4 = arith.cmpi slt, %2, %3 : i32
        scf.condition(%4)
      } do {
        memref.alloca_scope  {
          %c0_i32_20 = arith.constant 0 : i32
          %c0_21 = arith.constant 0 : index
          memref.store %c0_i32_20, %alloca_8[%c0_21] : memref<1xi32>
          scf.while : () -> () {
            %c0_22 = arith.constant 0 : index
            %4 = memref.load %alloca_8[%c0_22] : memref<1xi32>
            %c0_23 = arith.constant 0 : index
            %5 = memref.load %alloca_0[%c0_23] : memref<1xi32>
            %6 = arith.cmpi slt, %4, %5 : i32
            scf.condition(%6)
          } do {
            %c0_22 = arith.constant 0 : index
            %4 = memref.load %alloca_6[%c0_22] : memref<1xi32>
            %c0_23 = arith.constant 0 : index
            %5 = memref.load %alloca_8[%c0_23] : memref<1xi32>
            %6 = arith.addi %4, %5 : i32
            %c0_24 = arith.constant 0 : index
            %7 = memref.load %alloca_0[%c0_24] : memref<1xi32>
            %8 = arith.remsi %6, %7 : i32
            %9 = arith.sitofp %8 : i32 to f32
            %c5_i32 = arith.constant 5 : i32
            %c0_25 = arith.constant 0 : index
            %10 = memref.load %alloca[%c0_25] : memref<1xi32>
            %11 = arith.muli %c5_i32, %10 : i32
            %12 = arith.sitofp %11 : i32 to f32
            %13 = arith.divf %9, %12 : f32
            %c0_26 = arith.constant 0 : index
            %14 = memref.load %alloca_2[%c0_26] : memref<1xmemref<124xf32>>
            %c0_27 = arith.constant 0 : index
            %15 = memref.load %alloca_6[%c0_27] : memref<1xi32>
            %16 = arith.index_cast %15 : i32 to index
            %c0_28 = arith.constant 0 : index
            %c124 = arith.constant 124 : index
            %17 = arith.subi %c124, %16 : index
            %subview = memref.subview %14[%16] [%17] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
            %c0_29 = arith.constant 0 : index
            %18 = memref.load %alloca_8[%c0_29] : memref<1xi32>
            %19 = arith.index_cast %18 : i32 to index
            %c1 = arith.constant 1 : index
            %subview_30 = memref.subview %subview[%19] [%c1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
            %c0_31 = arith.constant 0 : index
            memref.store %13, %subview_30[%c0_31] : memref<?xf32, strided<[1], offset: ?>>
            %c0_32 = arith.constant 0 : index
            %20 = memref.load %alloca_8[%c0_32] : memref<1xi32>
            %c1_i32_33 = arith.constant 1 : i32
            %21 = arith.addi %20, %c1_i32_33 : i32
            %c0_34 = arith.constant 0 : index
            memref.store %21, %alloca_8[%c0_34] : memref<1xi32>
            scf.yield
          }
        }
        %c0_18 = arith.constant 0 : index
        %2 = memref.load %alloca_6[%c0_18] : memref<1xi32>
        %c1_i32 = arith.constant 1 : i32
        %3 = arith.addi %2, %c1_i32 : i32
        %c0_19 = arith.constant 0 : index
        memref.store %3, %alloca_6[%c0_19] : memref<1xi32>
        scf.yield
      }
    }
    return
  }
  func.func private @kernel_atax(%arg0: i32, %arg1: i32, %arg2: memref<124xf32>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: memref<?xf32, strided<[1], offset: ?>>, %arg5: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
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
    memref.alloca_scope  {
      %c0_i32 = arith.constant 0 : i32
      %c0_19 = arith.constant 0 : index
      memref.store %c0_i32, %alloca_10[%c0_19] : memref<1xi32>
      scf.while : () -> () {
        %c0_20 = arith.constant 0 : index
        %0 = memref.load %alloca_10[%c0_20] : memref<1xi32>
        %c0_21 = arith.constant 0 : index
        %1 = memref.load %alloca_0[%c0_21] : memref<1xi32>
        %2 = arith.cmpi slt, %0, %1 : i32
        scf.condition(%2)
      } do {
        %c0_i32_20 = arith.constant 0 : i32
        %0 = arith.sitofp %c0_i32_20 : i32 to f32
        %c0_21 = arith.constant 0 : index
        %1 = memref.load %alloca_6[%c0_21] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_22 = arith.constant 0 : index
        %2 = memref.load %alloca_10[%c0_22] : memref<1xi32>
        %3 = arith.index_cast %2 : i32 to index
        %c0_23 = arith.constant 0 : index
        %dim = memref.dim %1, %c0_23 : memref<?xf32, strided<[1], offset: ?>>
        %4 = arith.subi %dim, %3 : index
        %subview = memref.subview %1[%3] [%4] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_24 = arith.constant 0 : index
        memref.store %0, %subview[%c0_24] : memref<?xf32, strided<[1], offset: ?>>
        %c0_25 = arith.constant 0 : index
        %5 = memref.load %alloca_10[%c0_25] : memref<1xi32>
        %c1_i32 = arith.constant 1 : i32
        %6 = arith.addi %5, %c1_i32 : i32
        %c0_26 = arith.constant 0 : index
        memref.store %6, %alloca_10[%c0_26] : memref<1xi32>
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
          %cst = arith.constant 0.000000e+00 : f32
          %c0_22 = arith.constant 0 : index
          %2 = memref.load %alloca_8[%c0_22] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
          %c0_23 = arith.constant 0 : index
          %3 = memref.load %alloca_10[%c0_23] : memref<1xi32>
          %4 = arith.index_cast %3 : i32 to index
          %c0_24 = arith.constant 0 : index
          %dim = memref.dim %2, %c0_24 : memref<?xf32, strided<[1], offset: ?>>
          %5 = arith.subi %dim, %4 : index
          %subview = memref.subview %2[%4] [%5] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
          %c0_25 = arith.constant 0 : index
          memref.store %cst, %subview[%c0_25] : memref<?xf32, strided<[1], offset: ?>>
          memref.alloca_scope  {
            %c0_i32_26 = arith.constant 0 : i32
            %c0_27 = arith.constant 0 : index
            memref.store %c0_i32_26, %alloca_12[%c0_27] : memref<1xi32>
            scf.while : () -> () {
              %c0_28 = arith.constant 0 : index
              %6 = memref.load %alloca_12[%c0_28] : memref<1xi32>
              %c0_29 = arith.constant 0 : index
              %7 = memref.load %alloca_0[%c0_29] : memref<1xi32>
              %8 = arith.cmpi slt, %6, %7 : i32
              scf.condition(%8)
            } do {
              %c0_28 = arith.constant 0 : index
              %6 = memref.load %alloca_8[%c0_28] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
              %c0_29 = arith.constant 0 : index
              %7 = memref.load %alloca_10[%c0_29] : memref<1xi32>
              %8 = arith.index_cast %7 : i32 to index
              %c0_30 = arith.constant 0 : index
              %dim_31 = memref.dim %6, %c0_30 : memref<?xf32, strided<[1], offset: ?>>
              %9 = arith.subi %dim_31, %8 : index
              %subview_32 = memref.subview %6[%8] [%9] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
              %c0_33 = arith.constant 0 : index
              %10 = memref.load %subview_32[%c0_33] : memref<?xf32, strided<[1], offset: ?>>
              %c0_34 = arith.constant 0 : index
              %11 = memref.load %alloca_2[%c0_34] : memref<1xmemref<124xf32>>
              %c0_35 = arith.constant 0 : index
              %12 = memref.load %alloca_10[%c0_35] : memref<1xi32>
              %13 = arith.index_cast %12 : i32 to index
              %c0_36 = arith.constant 0 : index
              %c124 = arith.constant 124 : index
              %14 = arith.subi %c124, %13 : index
              %subview_37 = memref.subview %11[%13] [%14] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
              %c0_38 = arith.constant 0 : index
              %15 = memref.load %alloca_12[%c0_38] : memref<1xi32>
              %16 = arith.index_cast %15 : i32 to index
              %c1 = arith.constant 1 : index
              %subview_39 = memref.subview %subview_37[%16] [%c1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
              %c0_40 = arith.constant 0 : index
              %17 = memref.load %subview_39[%c0_40] : memref<?xf32, strided<[1], offset: ?>>
              %c0_41 = arith.constant 0 : index
              %18 = memref.load %alloca_4[%c0_41] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
              %c0_42 = arith.constant 0 : index
              %19 = memref.load %alloca_12[%c0_42] : memref<1xi32>
              %20 = arith.index_cast %19 : i32 to index
              %c0_43 = arith.constant 0 : index
              %dim_44 = memref.dim %18, %c0_43 : memref<?xf32, strided<[1], offset: ?>>
              %21 = arith.subi %dim_44, %20 : index
              %subview_45 = memref.subview %18[%20] [%21] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
              %c0_46 = arith.constant 0 : index
              %22 = memref.load %subview_45[%c0_46] : memref<?xf32, strided<[1], offset: ?>>
              %23 = arith.mulf %17, %22 : f32
              %24 = arith.addf %10, %23 : f32
              %c0_47 = arith.constant 0 : index
              %25 = memref.load %alloca_8[%c0_47] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
              %c0_48 = arith.constant 0 : index
              %26 = memref.load %alloca_10[%c0_48] : memref<1xi32>
              %27 = arith.index_cast %26 : i32 to index
              %c0_49 = arith.constant 0 : index
              %dim_50 = memref.dim %25, %c0_49 : memref<?xf32, strided<[1], offset: ?>>
              %28 = arith.subi %dim_50, %27 : index
              %subview_51 = memref.subview %25[%27] [%28] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
              %c0_52 = arith.constant 0 : index
              memref.store %24, %subview_51[%c0_52] : memref<?xf32, strided<[1], offset: ?>>
              %c0_53 = arith.constant 0 : index
              %29 = memref.load %alloca_12[%c0_53] : memref<1xi32>
              %c1_i32_54 = arith.constant 1 : i32
              %30 = arith.addi %29, %c1_i32_54 : i32
              %c0_55 = arith.constant 0 : index
              memref.store %30, %alloca_12[%c0_55] : memref<1xi32>
              scf.yield
            }
          }
          memref.alloca_scope  {
            %c0_i32_26 = arith.constant 0 : i32
            %c0_27 = arith.constant 0 : index
            memref.store %c0_i32_26, %alloca_12[%c0_27] : memref<1xi32>
            scf.while : () -> () {
              %c0_28 = arith.constant 0 : index
              %6 = memref.load %alloca_12[%c0_28] : memref<1xi32>
              %c0_29 = arith.constant 0 : index
              %7 = memref.load %alloca_0[%c0_29] : memref<1xi32>
              %8 = arith.cmpi slt, %6, %7 : i32
              scf.condition(%8)
            } do {
              %c0_28 = arith.constant 0 : index
              %6 = memref.load %alloca_6[%c0_28] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
              %c0_29 = arith.constant 0 : index
              %7 = memref.load %alloca_12[%c0_29] : memref<1xi32>
              %8 = arith.index_cast %7 : i32 to index
              %c0_30 = arith.constant 0 : index
              %dim_31 = memref.dim %6, %c0_30 : memref<?xf32, strided<[1], offset: ?>>
              %9 = arith.subi %dim_31, %8 : index
              %subview_32 = memref.subview %6[%8] [%9] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
              %c0_33 = arith.constant 0 : index
              %10 = memref.load %subview_32[%c0_33] : memref<?xf32, strided<[1], offset: ?>>
              %c0_34 = arith.constant 0 : index
              %11 = memref.load %alloca_2[%c0_34] : memref<1xmemref<124xf32>>
              %c0_35 = arith.constant 0 : index
              %12 = memref.load %alloca_10[%c0_35] : memref<1xi32>
              %13 = arith.index_cast %12 : i32 to index
              %c0_36 = arith.constant 0 : index
              %c124 = arith.constant 124 : index
              %14 = arith.subi %c124, %13 : index
              %subview_37 = memref.subview %11[%13] [%14] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
              %c0_38 = arith.constant 0 : index
              %15 = memref.load %alloca_12[%c0_38] : memref<1xi32>
              %16 = arith.index_cast %15 : i32 to index
              %c1 = arith.constant 1 : index
              %subview_39 = memref.subview %subview_37[%16] [%c1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
              %c0_40 = arith.constant 0 : index
              %17 = memref.load %subview_39[%c0_40] : memref<?xf32, strided<[1], offset: ?>>
              %c0_41 = arith.constant 0 : index
              %18 = memref.load %alloca_8[%c0_41] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
              %c0_42 = arith.constant 0 : index
              %19 = memref.load %alloca_10[%c0_42] : memref<1xi32>
              %20 = arith.index_cast %19 : i32 to index
              %c0_43 = arith.constant 0 : index
              %dim_44 = memref.dim %18, %c0_43 : memref<?xf32, strided<[1], offset: ?>>
              %21 = arith.subi %dim_44, %20 : index
              %subview_45 = memref.subview %18[%20] [%21] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
              %c0_46 = arith.constant 0 : index
              %22 = memref.load %subview_45[%c0_46] : memref<?xf32, strided<[1], offset: ?>>
              %23 = arith.mulf %17, %22 : f32
              %24 = arith.addf %10, %23 : f32
              %c0_47 = arith.constant 0 : index
              %25 = memref.load %alloca_6[%c0_47] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
              %c0_48 = arith.constant 0 : index
              %26 = memref.load %alloca_12[%c0_48] : memref<1xi32>
              %27 = arith.index_cast %26 : i32 to index
              %c0_49 = arith.constant 0 : index
              %dim_50 = memref.dim %25, %c0_49 : memref<?xf32, strided<[1], offset: ?>>
              %28 = arith.subi %dim_50, %27 : index
              %subview_51 = memref.subview %25[%27] [%28] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
              %c0_52 = arith.constant 0 : index
              memref.store %24, %subview_51[%c0_52] : memref<?xf32, strided<[1], offset: ?>>
              %c0_53 = arith.constant 0 : index
              %29 = memref.load %alloca_12[%c0_53] : memref<1xi32>
              %c1_i32_54 = arith.constant 1 : i32
              %30 = arith.addi %29, %c1_i32_54 : i32
              %c0_55 = arith.constant 0 : index
              memref.store %30, %alloca_12[%c0_55] : memref<1xi32>
              scf.yield
            }
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
  func.func private @strcmp(memref<?xi8, strided<[1], offset: ?>>, memref<?xi8, strided<[1], offset: ?>>) -> i32
  memref.global "private" constant @".str" : memref<1xi8> = dense<0> {alignment = 1 : i64}
  llvm.func @fprintf(!llvm.ptr, !llvm.ptr, ...) -> i32
  llvm.mlir.global external @__stderrp() {addr_space = 0 : i32, alignment = 8 : i64} : !llvm.ptr
  memref.global "private" constant @".str.1" : memref<23xi8> = dense<[61, 61, 66, 69, 71, 73, 78, 32, 68, 85, 77, 80, 95, 65, 82, 82, 65, 89, 83, 61, 61, 10, 0]> {alignment = 1 : i64}
  memref.global "private" constant @".str.2" : memref<15xi8> = dense<[98, 101, 103, 105, 110, 32, 100, 117, 109, 112, 58, 32, 37, 115, 0]> {alignment = 1 : i64}
  memref.global "private" constant @".str.3" : memref<2xi8> = dense<[121, 0]> {alignment = 1 : i64}
  memref.global "private" constant @".str.4" : memref<2xi8> = dense<[10, 0]> {alignment = 1 : i64}
  memref.global "private" constant @".str.5" : memref<7xi8> = dense<[37, 48, 46, 50, 102, 32, 0]> {alignment = 1 : i64}
  memref.global "private" constant @".str.6" : memref<17xi8> = dense<[10, 101, 110, 100, 32, 32, 32, 100, 117, 109, 112, 58, 32, 37, 115, 10, 0]> {alignment = 1 : i64}
  memref.global "private" constant @".str.7" : memref<23xi8> = dense<[61, 61, 69, 78, 68, 32, 32, 32, 68, 85, 77, 80, 95, 65, 82, 82, 65, 89, 83, 61, 61, 10, 0]> {alignment = 1 : i64}
  func.func private @print_array(%arg0: i32, %arg1: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast = memref.cast %alloca : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_1 = memref.cast %alloca_0 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_2 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_3 = memref.cast %alloca_2 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %c0 = arith.constant 0 : index
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    %c0_4 = arith.constant 0 : index
    memref.store %arg1, %alloca_0[%c0_4] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %0 = llvm.mlir.addressof @__stderrp : !llvm.ptr
    %1 = llvm.load %0 : !llvm.ptr -> !llvm.ptr
    %2 = memref.get_global @".str.1" : memref<23xi8>
    %c0_5 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c23 = arith.constant 23 : index
    %subview = memref.subview %2[%c0_5] [%c23] [%c1] : memref<23xi8> to memref<?xi8, strided<[?], offset: ?>>
    %reinterpret_cast = memref.reinterpret_cast %subview to offset: [0], sizes: [%c23], strides: [1] : memref<?xi8, strided<[?], offset: ?>> to memref<?xi8, strided<[1], offset: ?>>
    %intptr = memref.extract_aligned_pointer_as_index %reinterpret_cast : memref<?xi8, strided<[1], offset: ?>> -> index
    %3 = arith.index_castui %intptr : index to i64
    %4 = llvm.inttoptr %3 : i64 to !llvm.ptr
    %5 = llvm.call @fprintf(%1, %4) vararg(!llvm.func<i32 (ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr) -> i32
    %6 = llvm.mlir.addressof @__stderrp : !llvm.ptr
    %7 = llvm.load %6 : !llvm.ptr -> !llvm.ptr
    %8 = memref.get_global @".str.2" : memref<15xi8>
    %c0_6 = arith.constant 0 : index
    %c1_7 = arith.constant 1 : index
    %c15 = arith.constant 15 : index
    %subview_8 = memref.subview %8[%c0_6] [%c15] [%c1_7] : memref<15xi8> to memref<?xi8, strided<[?], offset: ?>>
    %reinterpret_cast_9 = memref.reinterpret_cast %subview_8 to offset: [0], sizes: [%c15], strides: [1] : memref<?xi8, strided<[?], offset: ?>> to memref<?xi8, strided<[1], offset: ?>>
    %9 = memref.get_global @".str.3" : memref<2xi8>
    %c0_10 = arith.constant 0 : index
    %c1_11 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %subview_12 = memref.subview %9[%c0_10] [%c2] [%c1_11] : memref<2xi8> to memref<?xi8, strided<[?], offset: ?>>
    %reinterpret_cast_13 = memref.reinterpret_cast %subview_12 to offset: [0], sizes: [%c2], strides: [1] : memref<?xi8, strided<[?], offset: ?>> to memref<?xi8, strided<[1], offset: ?>>
    %intptr_14 = memref.extract_aligned_pointer_as_index %reinterpret_cast_9 : memref<?xi8, strided<[1], offset: ?>> -> index
    %10 = arith.index_castui %intptr_14 : index to i64
    %11 = llvm.inttoptr %10 : i64 to !llvm.ptr
    %intptr_15 = memref.extract_aligned_pointer_as_index %reinterpret_cast_13 : memref<?xi8, strided<[1], offset: ?>> -> index
    %12 = arith.index_castui %intptr_15 : index to i64
    %13 = llvm.inttoptr %12 : i64 to !llvm.ptr
    %14 = llvm.call @fprintf(%7, %11, %13) vararg(!llvm.func<i32 (ptr, ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
    memref.alloca_scope  {
      %c0_i32 = arith.constant 0 : i32
      %c0_33 = arith.constant 0 : index
      memref.store %c0_i32, %alloca_2[%c0_33] : memref<1xi32>
      scf.while : () -> () {
        %c0_34 = arith.constant 0 : index
        %30 = memref.load %alloca_2[%c0_34] : memref<1xi32>
        %c0_35 = arith.constant 0 : index
        %31 = memref.load %alloca[%c0_35] : memref<1xi32>
        %32 = arith.cmpi slt, %30, %31 : i32
        scf.condition(%32)
      } do {
        memref.alloca_scope  {
          memref.alloca_scope  {
            %c0_46 = arith.constant 0 : index
            %44 = memref.load %alloca_2[%c0_46] : memref<1xi32>
            %c20_i32 = arith.constant 20 : i32
            %45 = arith.remsi %44, %c20_i32 : i32
            %c0_i32_47 = arith.constant 0 : i32
            %46 = arith.cmpi eq, %45, %c0_i32_47 : i32
            scf.if %46 {
              %47 = llvm.mlir.addressof @__stderrp : !llvm.ptr
              %48 = llvm.load %47 : !llvm.ptr -> !llvm.ptr
              %49 = memref.get_global @".str.4" : memref<2xi8>
              %c0_48 = arith.constant 0 : index
              %c1_49 = arith.constant 1 : index
              %c2_50 = arith.constant 2 : index
              %subview_51 = memref.subview %49[%c0_48] [%c2_50] [%c1_49] : memref<2xi8> to memref<?xi8, strided<[?], offset: ?>>
              %reinterpret_cast_52 = memref.reinterpret_cast %subview_51 to offset: [0], sizes: [%c2_50], strides: [1] : memref<?xi8, strided<[?], offset: ?>> to memref<?xi8, strided<[1], offset: ?>>
              %intptr_53 = memref.extract_aligned_pointer_as_index %reinterpret_cast_52 : memref<?xi8, strided<[1], offset: ?>> -> index
              %50 = arith.index_castui %intptr_53 : index to i64
              %51 = llvm.inttoptr %50 : i64 to !llvm.ptr
              %52 = llvm.call @fprintf(%48, %51) vararg(!llvm.func<i32 (ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr) -> i32
            }
          }
          %32 = llvm.mlir.addressof @__stderrp : !llvm.ptr
          %33 = llvm.load %32 : !llvm.ptr -> !llvm.ptr
          %34 = memref.get_global @".str.5" : memref<7xi8>
          %c0_36 = arith.constant 0 : index
          %c1_37 = arith.constant 1 : index
          %c7 = arith.constant 7 : index
          %subview_38 = memref.subview %34[%c0_36] [%c7] [%c1_37] : memref<7xi8> to memref<?xi8, strided<[?], offset: ?>>
          %reinterpret_cast_39 = memref.reinterpret_cast %subview_38 to offset: [0], sizes: [%c7], strides: [1] : memref<?xi8, strided<[?], offset: ?>> to memref<?xi8, strided<[1], offset: ?>>
          %c0_40 = arith.constant 0 : index
          %35 = memref.load %alloca_0[%c0_40] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
          %c0_41 = arith.constant 0 : index
          %36 = memref.load %alloca_2[%c0_41] : memref<1xi32>
          %37 = arith.index_cast %36 : i32 to index
          %c0_42 = arith.constant 0 : index
          %dim = memref.dim %35, %c0_42 : memref<?xf32, strided<[1], offset: ?>>
          %38 = arith.subi %dim, %37 : index
          %subview_43 = memref.subview %35[%37] [%38] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
          %c0_44 = arith.constant 0 : index
          %39 = memref.load %subview_43[%c0_44] : memref<?xf32, strided<[1], offset: ?>>
          %40 = arith.extf %39 : f32 to f64
          %intptr_45 = memref.extract_aligned_pointer_as_index %reinterpret_cast_39 : memref<?xi8, strided<[1], offset: ?>> -> index
          %41 = arith.index_castui %intptr_45 : index to i64
          %42 = llvm.inttoptr %41 : i64 to !llvm.ptr
          %43 = llvm.call @fprintf(%33, %42, %40) vararg(!llvm.func<i32 (ptr, ptr, f64, ...)>) : (!llvm.ptr, !llvm.ptr, f64) -> i32
        }
        %c0_34 = arith.constant 0 : index
        %30 = memref.load %alloca_2[%c0_34] : memref<1xi32>
        %c1_i32 = arith.constant 1 : i32
        %31 = arith.addi %30, %c1_i32 : i32
        %c0_35 = arith.constant 0 : index
        memref.store %31, %alloca_2[%c0_35] : memref<1xi32>
        scf.yield
      }
    }
    %15 = llvm.mlir.addressof @__stderrp : !llvm.ptr
    %16 = llvm.load %15 : !llvm.ptr -> !llvm.ptr
    %17 = memref.get_global @".str.6" : memref<17xi8>
    %c0_16 = arith.constant 0 : index
    %c1_17 = arith.constant 1 : index
    %c17 = arith.constant 17 : index
    %subview_18 = memref.subview %17[%c0_16] [%c17] [%c1_17] : memref<17xi8> to memref<?xi8, strided<[?], offset: ?>>
    %reinterpret_cast_19 = memref.reinterpret_cast %subview_18 to offset: [0], sizes: [%c17], strides: [1] : memref<?xi8, strided<[?], offset: ?>> to memref<?xi8, strided<[1], offset: ?>>
    %18 = memref.get_global @".str.3" : memref<2xi8>
    %c0_20 = arith.constant 0 : index
    %c1_21 = arith.constant 1 : index
    %c2_22 = arith.constant 2 : index
    %subview_23 = memref.subview %18[%c0_20] [%c2_22] [%c1_21] : memref<2xi8> to memref<?xi8, strided<[?], offset: ?>>
    %reinterpret_cast_24 = memref.reinterpret_cast %subview_23 to offset: [0], sizes: [%c2_22], strides: [1] : memref<?xi8, strided<[?], offset: ?>> to memref<?xi8, strided<[1], offset: ?>>
    %intptr_25 = memref.extract_aligned_pointer_as_index %reinterpret_cast_19 : memref<?xi8, strided<[1], offset: ?>> -> index
    %19 = arith.index_castui %intptr_25 : index to i64
    %20 = llvm.inttoptr %19 : i64 to !llvm.ptr
    %intptr_26 = memref.extract_aligned_pointer_as_index %reinterpret_cast_24 : memref<?xi8, strided<[1], offset: ?>> -> index
    %21 = arith.index_castui %intptr_26 : index to i64
    %22 = llvm.inttoptr %21 : i64 to !llvm.ptr
    %23 = llvm.call @fprintf(%16, %20, %22) vararg(!llvm.func<i32 (ptr, ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
    %24 = llvm.mlir.addressof @__stderrp : !llvm.ptr
    %25 = llvm.load %24 : !llvm.ptr -> !llvm.ptr
    %26 = memref.get_global @".str.7" : memref<23xi8>
    %c0_27 = arith.constant 0 : index
    %c1_28 = arith.constant 1 : index
    %c23_29 = arith.constant 23 : index
    %subview_30 = memref.subview %26[%c0_27] [%c23_29] [%c1_28] : memref<23xi8> to memref<?xi8, strided<[?], offset: ?>>
    %reinterpret_cast_31 = memref.reinterpret_cast %subview_30 to offset: [0], sizes: [%c23_29], strides: [1] : memref<?xi8, strided<[?], offset: ?>> to memref<?xi8, strided<[1], offset: ?>>
    %intptr_32 = memref.extract_aligned_pointer_as_index %reinterpret_cast_31 : memref<?xi8, strided<[1], offset: ?>> -> index
    %27 = arith.index_castui %intptr_32 : index to i64
    %28 = llvm.inttoptr %27 : i64 to !llvm.ptr
    %29 = llvm.call @fprintf(%25, %28) vararg(!llvm.func<i32 (ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr) -> i32
    return
  }
  func.func private @free(!llvm.ptr)
  func.func private @polybench_free_data(!llvm.ptr)
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>) -> i32 attributes {no_inline} {
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast = memref.cast %alloca : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>>
    %cast_1 = memref.cast %alloca_0 : memref<1xmemref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>> to memref<?xmemref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_2 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_3 = memref.cast %alloca_2 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_4 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_5 = memref.cast %alloca_4 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_6 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_7 = memref.cast %alloca_6 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_8 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<116x124xf32>>
    %cast_9 = memref.cast %alloca_8 : memref<1xmemref<116x124xf32>> to memref<?xmemref<116x124xf32>, strided<[1], offset: ?>>
    %alloca_10 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %cast_11 = memref.cast %alloca_10 : memref<1xmemref<124xf32>> to memref<?xmemref<124xf32>, strided<[1], offset: ?>>
    %alloca_12 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_13 = memref.cast %alloca_12 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %c0 = arith.constant 0 : index
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    %c0_14 = arith.constant 0 : index
    memref.store %arg1, %alloca_0[%c0_14] : memref<1xmemref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>>
    %c116_i32 = arith.constant 116 : i32
    %c0_15 = arith.constant 0 : index
    memref.store %c116_i32, %alloca_4[%c0_15] : memref<1xi32>
    %c124_i32 = arith.constant 124 : i32
    %c0_16 = arith.constant 0 : index
    memref.store %c124_i32, %alloca_6[%c0_16] : memref<1xi32>
    %c116_i32_17 = arith.constant 116 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.addi %c116_i32_17, %c0_i32 : i32
    %c124_i32_18 = arith.constant 124 : i32
    %c0_i32_19 = arith.constant 0 : i32
    %1 = arith.addi %c124_i32_18, %c0_i32_19 : i32
    %2 = arith.muli %0, %1 : i32
    %3 = arith.extsi %2 : i32 to i64
    %c4_i64 = arith.constant 4 : i64
    %4 = arith.trunci %c4_i64 : i64 to i32
    %5 = call @polybench_alloc_data(%3, %4) : (i64, i32) -> !llvm.ptr
    %6 = llvm.mlir.constant(0 : i64) : i64
    %7 = llvm.mlir.constant(1 : i64) : i64
    %8 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %9 = llvm.insertvalue %5, %8[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.insertvalue %5, %9[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %6, %10[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %3, %11[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %7, %12[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = builtin.unrealized_conversion_cast %13 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> to memref<116x124xf32>
    %c0_20 = arith.constant 0 : index
    memref.store %14, %alloca_8[%c0_20] : memref<1xmemref<116x124xf32>>
    %c124_i32_21 = arith.constant 124 : i32
    %c0_i32_22 = arith.constant 0 : i32
    %15 = arith.addi %c124_i32_21, %c0_i32_22 : i32
    %16 = arith.extsi %15 : i32 to i64
    %c4_i64_23 = arith.constant 4 : i64
    %17 = arith.trunci %c4_i64_23 : i64 to i32
    %18 = call @polybench_alloc_data(%16, %17) : (i64, i32) -> !llvm.ptr
    %19 = llvm.mlir.constant(0 : i64) : i64
    %20 = llvm.mlir.constant(1 : i64) : i64
    %21 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %22 = llvm.insertvalue %18, %21[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.insertvalue %18, %22[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.insertvalue %19, %23[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %25 = llvm.insertvalue %16, %24[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %26 = llvm.insertvalue %20, %25[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = builtin.unrealized_conversion_cast %26 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> to memref<124xf32>
    %c0_24 = arith.constant 0 : index
    memref.store %27, %alloca_10[%c0_24] : memref<1xmemref<124xf32>>
    %c0_25 = arith.constant 0 : index
    %28 = memref.load %alloca_4[%c0_25] : memref<1xi32>
    %c0_26 = arith.constant 0 : index
    %29 = memref.load %alloca_6[%c0_26] : memref<1xi32>
    %30 = arith.addi %28, %29 : i32
    %31 = arith.extsi %30 : i32 to i64
    %c4_i64_27 = arith.constant 4 : i64
    %32 = arith.trunci %c4_i64_27 : i64 to i32
    %33 = call @polybench_alloc_data(%31, %32) : (i64, i32) -> !llvm.ptr
    %34 = llvm.mlir.constant(0 : i64) : i64
    %35 = llvm.mlir.constant(1 : i64) : i64
    %36 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %37 = llvm.insertvalue %33, %36[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.insertvalue %33, %37[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %39 = llvm.insertvalue %34, %38[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %40 = llvm.insertvalue %31, %39[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %41 = llvm.insertvalue %35, %40[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %42 = builtin.unrealized_conversion_cast %41 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> to memref<?xf32, strided<[1], offset: ?>>
    %c0_28 = arith.constant 0 : index
    memref.store %42, %alloca_12[%c0_28] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_29 = arith.constant 0 : index
    %43 = memref.load %alloca_4[%c0_29] : memref<1xi32>
    %c0_30 = arith.constant 0 : index
    %44 = memref.load %alloca_6[%c0_30] : memref<1xi32>
    %c0_31 = arith.constant 0 : index
    %45 = memref.load %alloca_8[%c0_31] : memref<1xmemref<116x124xf32>>
    %reinterpret_cast = memref.reinterpret_cast %45 to offset: [0], sizes: [124], strides: [1] : memref<116x124xf32> to memref<124xf32>
    %c0_32 = arith.constant 0 : index
    %46 = memref.load %alloca_10[%c0_32] : memref<1xmemref<124xf32>>
    %c0_33 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c124 = arith.constant 124 : index
    %subview = memref.subview %46[%c0_33] [%c124] [%c1] : memref<124xf32> to memref<?xf32, strided<[?], offset: ?>>
    %reinterpret_cast_34 = memref.reinterpret_cast %subview to offset: [0], sizes: [%c124], strides: [1] : memref<?xf32, strided<[?], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    call @init_array(%43, %44, %reinterpret_cast, %reinterpret_cast_34) : (i32, i32, memref<124xf32>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    %c0_35 = arith.constant 0 : index
    %47 = memref.load %alloca_4[%c0_35] : memref<1xi32>
    %c0_36 = arith.constant 0 : index
    %48 = memref.load %alloca_6[%c0_36] : memref<1xi32>
    %c0_37 = arith.constant 0 : index
    %49 = memref.load %alloca_8[%c0_37] : memref<1xmemref<116x124xf32>>
    %reinterpret_cast_38 = memref.reinterpret_cast %49 to offset: [0], sizes: [124], strides: [1] : memref<116x124xf32> to memref<124xf32>
    %c0_39 = arith.constant 0 : index
    %50 = memref.load %alloca_10[%c0_39] : memref<1xmemref<124xf32>>
    %c0_40 = arith.constant 0 : index
    %c1_41 = arith.constant 1 : index
    %c124_42 = arith.constant 124 : index
    %subview_43 = memref.subview %50[%c0_40] [%c124_42] [%c1_41] : memref<124xf32> to memref<?xf32, strided<[?], offset: ?>>
    %reinterpret_cast_44 = memref.reinterpret_cast %subview_43 to offset: [0], sizes: [%c124_42], strides: [1] : memref<?xf32, strided<[?], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    %c0_45 = arith.constant 0 : index
    %51 = memref.load %alloca_12[%c0_45] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_46 = arith.constant 0 : index
    %52 = memref.load %alloca_4[%c0_46] : memref<1xi32>
    %53 = arith.index_cast %52 : i32 to index
    %c0_47 = arith.constant 0 : index
    %dim = memref.dim %51, %c0_47 : memref<?xf32, strided<[1], offset: ?>>
    %54 = arith.subi %dim, %53 : index
    %subview_48 = memref.subview %51[%53] [%54] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    %c0_49 = arith.constant 0 : index
    %55 = memref.load %alloca_12[%c0_49] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    call @kernel_atax(%47, %48, %reinterpret_cast_38, %reinterpret_cast_44, %subview_48, %55) : (i32, i32, memref<124xf32>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    memref.alloca_scope  {
      %c0_58 = arith.constant 0 : index
      %66 = memref.load %alloca[%c0_58] : memref<1xi32>
      %c42_i32 = arith.constant 42 : i32
      %67 = arith.cmpi sgt, %66, %c42_i32 : i32
      %68 = scf.if %67 -> (i1) {
        %c0_59 = arith.constant 0 : index
        %69 = memref.load %alloca_0[%c0_59] : memref<1xmemref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>>
        %c0_i32_60 = arith.constant 0 : i32
        %70 = arith.index_cast %c0_i32_60 : i32 to index
        %c0_61 = arith.constant 0 : index
        %dim_62 = memref.dim %69, %c0_61 : memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>
        %71 = arith.subi %dim_62, %70 : index
        %subview_63 = memref.subview %69[%70] [%71] [1] : memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>> to memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>
        %c0_64 = arith.constant 0 : index
        %72 = memref.load %subview_63[%c0_64] : memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>
        %73 = memref.get_global @".str" : memref<1xi8>
        %c0_65 = arith.constant 0 : index
        %c1_66 = arith.constant 1 : index
        %c1_67 = arith.constant 1 : index
        %subview_68 = memref.subview %73[%c0_65] [%c1_67] [%c1_66] : memref<1xi8> to memref<?xi8, strided<[?], offset: ?>>
        %reinterpret_cast_69 = memref.reinterpret_cast %subview_68 to offset: [0], sizes: [%c1_67], strides: [1] : memref<?xi8, strided<[?], offset: ?>> to memref<?xi8, strided<[1], offset: ?>>
        %74 = func.call @strcmp(%72, %reinterpret_cast_69) : (memref<?xi8, strided<[1], offset: ?>>, memref<?xi8, strided<[1], offset: ?>>) -> i32
        %c0_i32_70 = arith.constant 0 : i32
        %75 = arith.cmpi ne, %74, %c0_i32_70 : i32
        %true = arith.constant true
        %76 = arith.xori %true, %75 : i1
        %77 = scf.if %76 -> (i1) {
          %true_71 = arith.constant true
          scf.yield %true_71 : i1
        } else {
          %false = arith.constant false
          scf.yield %false : i1
        }
        scf.yield %77 : i1
      } else {
        %false = arith.constant false
        scf.yield %false : i1
      }
      scf.if %68 {
        %c0_59 = arith.constant 0 : index
        %69 = memref.load %alloca_6[%c0_59] : memref<1xi32>
        %c0_60 = arith.constant 0 : index
        %70 = memref.load %alloca_12[%c0_60] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_61 = arith.constant 0 : index
        %71 = memref.load %alloca_4[%c0_61] : memref<1xi32>
        %72 = arith.index_cast %71 : i32 to index
        %c0_62 = arith.constant 0 : index
        %dim_63 = memref.dim %70, %c0_62 : memref<?xf32, strided<[1], offset: ?>>
        %73 = arith.subi %dim_63, %72 : index
        %subview_64 = memref.subview %70[%72] [%73] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        func.call @print_array(%69, %subview_64) : (i32, memref<?xf32, strided<[1], offset: ?>>) -> ()
      }
    }
    %c0_50 = arith.constant 0 : index
    %56 = memref.load %alloca_8[%c0_50] : memref<1xmemref<116x124xf32>>
    %intptr = memref.extract_aligned_pointer_as_index %56 : memref<116x124xf32> -> index
    %57 = arith.index_castui %intptr : index to i64
    %58 = llvm.inttoptr %57 : i64 to !llvm.ptr
    call @free(%58) : (!llvm.ptr) -> ()
    %c0_51 = arith.constant 0 : index
    %59 = memref.load %alloca_10[%c0_51] : memref<1xmemref<124xf32>>
    %intptr_52 = memref.extract_aligned_pointer_as_index %59 : memref<124xf32> -> index
    %60 = arith.index_castui %intptr_52 : index to i64
    %61 = llvm.inttoptr %60 : i64 to !llvm.ptr
    call @free(%61) : (!llvm.ptr) -> ()
    %c0_53 = arith.constant 0 : index
    %62 = memref.load %alloca_12[%c0_53] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %intptr_54 = memref.extract_aligned_pointer_as_index %62 : memref<?xf32, strided<[1], offset: ?>> -> index
    %63 = arith.index_castui %intptr_54 : index to i64
    %64 = llvm.inttoptr %63 : i64 to !llvm.ptr
    call @polybench_free_data(%64) : (!llvm.ptr) -> ()
    %c0_i32_55 = arith.constant 0 : i32
    %c0_56 = arith.constant 0 : index
    memref.store %c0_i32_55, %alloca_2[%c0_56] : memref<1xi32>
    %c0_57 = arith.constant 0 : index
    %65 = memref.load %alloca_2[%c0_57] : memref<1xi32>
    return %65 : i32
  }
}

