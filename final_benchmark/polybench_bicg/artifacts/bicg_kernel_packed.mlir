module @"/Volumes/ShravsSSD/ms-thesis-copy/benchmark_exploration/source_diffs/polybench_bicg_clangir/bicg_kernel_packed.c" attributes {llvm.target_triple = "arm64-apple-macosx26.0.0"} {
  func.func @kernel_bicg(%arg0: i32, %arg1: i32, %arg2: memref<116xf32>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: memref<?xf32, strided<[1], offset: ?>>, %arg5: memref<?xf32, strided<[1], offset: ?>>, %arg6: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast = memref.cast %alloca : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_0 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_1 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<116xf32>>
    %cast_3 = memref.cast %alloca_2 : memref<1xmemref<116xf32>> to memref<?xmemref<116xf32>, strided<[1], offset: ?>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_5 = memref.cast %alloca_4 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_6 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_7 = memref.cast %alloca_6 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_8 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_9 = memref.cast %alloca_8 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_10 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_11 = memref.cast %alloca_10 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_12 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_13 = memref.cast %alloca_12 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_14 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_15 = memref.cast %alloca_14 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %c0 = arith.constant 0 : index
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    %c0_16 = arith.constant 0 : index
    memref.store %arg1, %alloca_0[%c0_16] : memref<1xi32>
    %c0_17 = arith.constant 0 : index
    memref.store %arg2, %alloca_2[%c0_17] : memref<1xmemref<116xf32>>
    %c0_18 = arith.constant 0 : index
    memref.store %arg3, %alloca_4[%c0_18] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_19 = arith.constant 0 : index
    memref.store %arg4, %alloca_6[%c0_19] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_20 = arith.constant 0 : index
    memref.store %arg5, %alloca_8[%c0_20] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_21 = arith.constant 0 : index
    memref.store %arg6, %alloca_10[%c0_21] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.alloca_scope  {
      %c0_i32 = arith.constant 0 : i32
      %c0_22 = arith.constant 0 : index
      memref.store %c0_i32, %alloca_12[%c0_22] : memref<1xi32>
      scf.while : () -> () {
        %c0_23 = arith.constant 0 : index
        %0 = memref.load %alloca_12[%c0_23] : memref<1xi32>
        %c0_24 = arith.constant 0 : index
        %1 = memref.load %alloca[%c0_24] : memref<1xi32>
        %2 = arith.cmpi slt, %0, %1 : i32
        scf.condition(%2)
      } do {
        %cst = arith.constant 0.000000e+00 : f32
        %c0_23 = arith.constant 0 : index
        %0 = memref.load %alloca_4[%c0_23] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %c0_24 = arith.constant 0 : index
        %1 = memref.load %alloca_12[%c0_24] : memref<1xi32>
        %2 = arith.index_cast %1 : i32 to index
        %c0_25 = arith.constant 0 : index
        %dim = memref.dim %0, %c0_25 : memref<?xf32, strided<[1], offset: ?>>
        %3 = arith.subi %dim, %2 : index
        %subview = memref.subview %0[%2] [%3] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %c0_26 = arith.constant 0 : index
        memref.store %cst, %subview[%c0_26] : memref<?xf32, strided<[1], offset: ?>>
        %c0_27 = arith.constant 0 : index
        %4 = memref.load %alloca_12[%c0_27] : memref<1xi32>
        %c1_i32 = arith.constant 1 : i32
        %5 = arith.addi %4, %c1_i32 : i32
        %c0_28 = arith.constant 0 : index
        memref.store %5, %alloca_12[%c0_28] : memref<1xi32>
        scf.yield
      }
    }
    memref.alloca_scope  {
      %c0_i32 = arith.constant 0 : i32
      %c0_22 = arith.constant 0 : index
      memref.store %c0_i32, %alloca_12[%c0_22] : memref<1xi32>
      scf.while : () -> () {
        %c0_23 = arith.constant 0 : index
        %0 = memref.load %alloca_12[%c0_23] : memref<1xi32>
        %c0_24 = arith.constant 0 : index
        %1 = memref.load %alloca_0[%c0_24] : memref<1xi32>
        %2 = arith.cmpi slt, %0, %1 : i32
        scf.condition(%2)
      } do {
        memref.alloca_scope  {
          %cst = arith.constant 0.000000e+00 : f32
          %c0_25 = arith.constant 0 : index
          %2 = memref.load %alloca_6[%c0_25] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
          %c0_26 = arith.constant 0 : index
          %3 = memref.load %alloca_12[%c0_26] : memref<1xi32>
          %4 = arith.index_cast %3 : i32 to index
          %c0_27 = arith.constant 0 : index
          %dim = memref.dim %2, %c0_27 : memref<?xf32, strided<[1], offset: ?>>
          %5 = arith.subi %dim, %4 : index
          %subview = memref.subview %2[%4] [%5] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
          %c0_28 = arith.constant 0 : index
          memref.store %cst, %subview[%c0_28] : memref<?xf32, strided<[1], offset: ?>>
          memref.alloca_scope  {
            %c0_i32_29 = arith.constant 0 : i32
            %c0_30 = arith.constant 0 : index
            memref.store %c0_i32_29, %alloca_14[%c0_30] : memref<1xi32>
            scf.while : () -> () {
              %c0_31 = arith.constant 0 : index
              %6 = memref.load %alloca_14[%c0_31] : memref<1xi32>
              %c0_32 = arith.constant 0 : index
              %7 = memref.load %alloca[%c0_32] : memref<1xi32>
              %8 = arith.cmpi slt, %6, %7 : i32
              scf.condition(%8)
            } do {
              memref.alloca_scope  {
                %c0_34 = arith.constant 0 : index
                %8 = memref.load %alloca_4[%c0_34] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
                %c0_35 = arith.constant 0 : index
                %9 = memref.load %alloca_14[%c0_35] : memref<1xi32>
                %10 = arith.index_cast %9 : i32 to index
                %c0_36 = arith.constant 0 : index
                %dim_37 = memref.dim %8, %c0_36 : memref<?xf32, strided<[1], offset: ?>>
                %11 = arith.subi %dim_37, %10 : index
                %subview_38 = memref.subview %8[%10] [%11] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
                %c0_39 = arith.constant 0 : index
                %12 = memref.load %subview_38[%c0_39] : memref<?xf32, strided<[1], offset: ?>>
                %c0_40 = arith.constant 0 : index
                %13 = memref.load %alloca_10[%c0_40] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
                %c0_41 = arith.constant 0 : index
                %14 = memref.load %alloca_12[%c0_41] : memref<1xi32>
                %15 = arith.index_cast %14 : i32 to index
                %c0_42 = arith.constant 0 : index
                %dim_43 = memref.dim %13, %c0_42 : memref<?xf32, strided<[1], offset: ?>>
                %16 = arith.subi %dim_43, %15 : index
                %subview_44 = memref.subview %13[%15] [%16] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
                %c0_45 = arith.constant 0 : index
                %17 = memref.load %subview_44[%c0_45] : memref<?xf32, strided<[1], offset: ?>>
                %c0_46 = arith.constant 0 : index
                %18 = memref.load %alloca_2[%c0_46] : memref<1xmemref<116xf32>>
                %c0_47 = arith.constant 0 : index
                %19 = memref.load %alloca_12[%c0_47] : memref<1xi32>
                %20 = arith.index_cast %19 : i32 to index
                %c0_48 = arith.constant 0 : index
                %c116 = arith.constant 116 : index
                %21 = arith.subi %c116, %20 : index
                %subview_49 = memref.subview %18[%20] [%21] [1] : memref<116xf32> to memref<?xf32, strided<[1], offset: ?>>
                %c0_50 = arith.constant 0 : index
                %22 = memref.load %alloca_14[%c0_50] : memref<1xi32>
                %23 = arith.index_cast %22 : i32 to index
                %c1 = arith.constant 1 : index
                %subview_51 = memref.subview %subview_49[%23] [%c1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
                %c0_52 = arith.constant 0 : index
                %24 = memref.load %subview_51[%c0_52] : memref<?xf32, strided<[1], offset: ?>>
                %25 = arith.mulf %17, %24 : f32
                %26 = arith.addf %12, %25 : f32
                %c0_53 = arith.constant 0 : index
                %27 = memref.load %alloca_4[%c0_53] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
                %c0_54 = arith.constant 0 : index
                %28 = memref.load %alloca_14[%c0_54] : memref<1xi32>
                %29 = arith.index_cast %28 : i32 to index
                %c0_55 = arith.constant 0 : index
                %dim_56 = memref.dim %27, %c0_55 : memref<?xf32, strided<[1], offset: ?>>
                %30 = arith.subi %dim_56, %29 : index
                %subview_57 = memref.subview %27[%29] [%30] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
                %c0_58 = arith.constant 0 : index
                memref.store %26, %subview_57[%c0_58] : memref<?xf32, strided<[1], offset: ?>>
                %c0_59 = arith.constant 0 : index
                %31 = memref.load %alloca_6[%c0_59] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
                %c0_60 = arith.constant 0 : index
                %32 = memref.load %alloca_12[%c0_60] : memref<1xi32>
                %33 = arith.index_cast %32 : i32 to index
                %c0_61 = arith.constant 0 : index
                %dim_62 = memref.dim %31, %c0_61 : memref<?xf32, strided<[1], offset: ?>>
                %34 = arith.subi %dim_62, %33 : index
                %subview_63 = memref.subview %31[%33] [%34] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
                %c0_64 = arith.constant 0 : index
                %35 = memref.load %subview_63[%c0_64] : memref<?xf32, strided<[1], offset: ?>>
                %c0_65 = arith.constant 0 : index
                %36 = memref.load %alloca_2[%c0_65] : memref<1xmemref<116xf32>>
                %c0_66 = arith.constant 0 : index
                %37 = memref.load %alloca_12[%c0_66] : memref<1xi32>
                %38 = arith.index_cast %37 : i32 to index
                %c0_67 = arith.constant 0 : index
                %c116_68 = arith.constant 116 : index
                %39 = arith.subi %c116_68, %38 : index
                %subview_69 = memref.subview %36[%38] [%39] [1] : memref<116xf32> to memref<?xf32, strided<[1], offset: ?>>
                %c0_70 = arith.constant 0 : index
                %40 = memref.load %alloca_14[%c0_70] : memref<1xi32>
                %41 = arith.index_cast %40 : i32 to index
                %c1_71 = arith.constant 1 : index
                %subview_72 = memref.subview %subview_69[%41] [%c1_71] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
                %c0_73 = arith.constant 0 : index
                %42 = memref.load %subview_72[%c0_73] : memref<?xf32, strided<[1], offset: ?>>
                %c0_74 = arith.constant 0 : index
                %43 = memref.load %alloca_8[%c0_74] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
                %c0_75 = arith.constant 0 : index
                %44 = memref.load %alloca_14[%c0_75] : memref<1xi32>
                %45 = arith.index_cast %44 : i32 to index
                %c0_76 = arith.constant 0 : index
                %dim_77 = memref.dim %43, %c0_76 : memref<?xf32, strided<[1], offset: ?>>
                %46 = arith.subi %dim_77, %45 : index
                %subview_78 = memref.subview %43[%45] [%46] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
                %c0_79 = arith.constant 0 : index
                %47 = memref.load %subview_78[%c0_79] : memref<?xf32, strided<[1], offset: ?>>
                %48 = arith.mulf %42, %47 : f32
                %49 = arith.addf %35, %48 : f32
                %c0_80 = arith.constant 0 : index
                %50 = memref.load %alloca_6[%c0_80] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
                %c0_81 = arith.constant 0 : index
                %51 = memref.load %alloca_12[%c0_81] : memref<1xi32>
                %52 = arith.index_cast %51 : i32 to index
                %c0_82 = arith.constant 0 : index
                %dim_83 = memref.dim %50, %c0_82 : memref<?xf32, strided<[1], offset: ?>>
                %53 = arith.subi %dim_83, %52 : index
                %subview_84 = memref.subview %50[%52] [%53] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
                %c0_85 = arith.constant 0 : index
                memref.store %49, %subview_84[%c0_85] : memref<?xf32, strided<[1], offset: ?>>
              }
              %c0_31 = arith.constant 0 : index
              %6 = memref.load %alloca_14[%c0_31] : memref<1xi32>
              %c1_i32_32 = arith.constant 1 : i32
              %7 = arith.addi %6, %c1_i32_32 : i32
              %c0_33 = arith.constant 0 : index
              memref.store %7, %alloca_14[%c0_33] : memref<1xi32>
              scf.yield
            }
          }
        }
        %c0_23 = arith.constant 0 : index
        %0 = memref.load %alloca_12[%c0_23] : memref<1xi32>
        %c1_i32 = arith.constant 1 : i32
        %1 = arith.addi %0, %c1_i32 : i32
        %c0_24 = arith.constant 0 : index
        memref.store %1, %alloca_12[%c0_24] : memref<1xi32>
        scf.yield
      }
    }
    return
  }
  func.func @run_bicg_packed(%arg0: memref<116xf32>, %arg1: memref<?xf32, strided<[1], offset: ?>>, %arg2: memref<?xf32, strided<[1], offset: ?>>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: i32, %arg5: i32) attributes {no_inline} {
    %alloca = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<116xf32>>
    %cast = memref.cast %alloca : memref<1xmemref<116xf32>> to memref<?xmemref<116xf32>, strided<[1], offset: ?>>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_1 = memref.cast %alloca_0 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_3 = memref.cast %alloca_2 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %cast_5 = memref.cast %alloca_4 : memref<1xmemref<?xf32, strided<[1], offset: ?>>> to memref<?xmemref<?xf32, strided<[1], offset: ?>>, strided<[1], offset: ?>>
    %alloca_6 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_7 = memref.cast %alloca_6 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %alloca_8 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %cast_9 = memref.cast %alloca_8 : memref<1xi32> to memref<?xi32, strided<[1], offset: ?>>
    %c0 = arith.constant 0 : index
    memref.store %arg0, %alloca[%c0] : memref<1xmemref<116xf32>>
    %c0_10 = arith.constant 0 : index
    memref.store %arg1, %alloca_0[%c0_10] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_11 = arith.constant 0 : index
    memref.store %arg2, %alloca_2[%c0_11] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_12 = arith.constant 0 : index
    memref.store %arg3, %alloca_4[%c0_12] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_13 = arith.constant 0 : index
    memref.store %arg4, %alloca_6[%c0_13] : memref<1xi32>
    %c0_14 = arith.constant 0 : index
    memref.store %arg5, %alloca_8[%c0_14] : memref<1xi32>
    %c0_15 = arith.constant 0 : index
    %0 = memref.load %alloca_6[%c0_15] : memref<1xi32>
    %c0_16 = arith.constant 0 : index
    %1 = memref.load %alloca_8[%c0_16] : memref<1xi32>
    %c0_17 = arith.constant 0 : index
    %2 = memref.load %alloca[%c0_17] : memref<1xmemref<116xf32>>
    %c0_18 = arith.constant 0 : index
    %3 = memref.load %alloca_4[%c0_18] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_19 = arith.constant 0 : index
    %4 = memref.load %alloca_4[%c0_19] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_20 = arith.constant 0 : index
    %5 = memref.load %alloca_6[%c0_20] : memref<1xi32>
    %6 = arith.index_cast %5 : i32 to index
    %c0_21 = arith.constant 0 : index
    %dim = memref.dim %4, %c0_21 : memref<?xf32, strided<[1], offset: ?>>
    %7 = arith.subi %dim, %6 : index
    %subview = memref.subview %4[%6] [%7] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    %c0_22 = arith.constant 0 : index
    %8 = memref.load %alloca_0[%c0_22] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %c0_23 = arith.constant 0 : index
    %9 = memref.load %alloca_2[%c0_23] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    call @kernel_bicg(%0, %1, %2, %3, %subview, %8, %9) : (i32, i32, memref<116xf32>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    return
  }
}

