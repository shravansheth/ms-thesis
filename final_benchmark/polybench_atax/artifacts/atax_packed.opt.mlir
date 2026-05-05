module @"/Volumes/ShravsSSD/ms-thesis-copy/benchmark_exploration/source_diffs/polybench_atax_clangir/atax_packed.c" attributes {llvm.target_triple = "arm64-apple-macosx26.0.0"} {
  func.func private @polybench_alloc_data(i64, i32) -> !llvm.ptr
  func.func private @init_array(%arg0: i32, %arg1: i32, %arg2: memref<124xf32>, %arg3: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
    %cst = arith.constant 1.000000e+00 : f32
    %c124 = arith.constant 124 : index
    %c5_i32 = arith.constant 5 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_0 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_1 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %alloca_2 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_3 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_4 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_5 = memref.alloca() {alignment = 4 : i64} : memref<1xf32>
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xi32>
    memref.store %arg2, %alloca_1[%c0] : memref<1xmemref<124xf32>>
    memref.store %arg3, %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %0 = memref.load %alloca_0[%c0] : memref<1xi32>
    %1 = arith.sitofp %0 : i32 to f32
    memref.store %1, %alloca_5[%c0] : memref<1xf32>
    memref.store %c0_i32, %alloca_3[%c0] : memref<1xi32>
    scf.while : () -> () {
      %2 = memref.load %alloca_3[%c0] : memref<1xi32>
      %3 = memref.load %alloca_0[%c0] : memref<1xi32>
      %4 = arith.cmpi slt, %2, %3 : i32
      scf.condition(%4)
    } do {
      %2 = memref.load %alloca_3[%c0] : memref<1xi32>
      %3 = arith.sitofp %2 : i32 to f32
      %4 = memref.load %alloca_5[%c0] : memref<1xf32>
      %5 = arith.divf %3, %4 : f32
      %6 = arith.addf %5, %cst : f32
      %7 = memref.load %alloca_2[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
      %8 = arith.index_cast %2 : i32 to index
      %dim = memref.dim %7, %c0 : memref<?xf32, strided<[1], offset: ?>>
      %9 = arith.subi %dim, %8 : index
      %subview = memref.subview %7[%8] [%9] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
      memref.store %6, %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %10 = memref.load %alloca_3[%c0] : memref<1xi32>
      %11 = arith.addi %10, %c1_i32 : i32
      memref.store %11, %alloca_3[%c0] : memref<1xi32>
      scf.yield
    }
    memref.store %c0_i32, %alloca_3[%c0] : memref<1xi32>
    scf.while : () -> () {
      %2 = memref.load %alloca_3[%c0] : memref<1xi32>
      %3 = memref.load %alloca[%c0] : memref<1xi32>
      %4 = arith.cmpi slt, %2, %3 : i32
      scf.condition(%4)
    } do {
      memref.store %c0_i32, %alloca_4[%c0] : memref<1xi32>
      scf.while : () -> () {
        %4 = memref.load %alloca_4[%c0] : memref<1xi32>
        %5 = memref.load %alloca_0[%c0] : memref<1xi32>
        %6 = arith.cmpi slt, %4, %5 : i32
        scf.condition(%6)
      } do {
        %4 = memref.load %alloca_3[%c0] : memref<1xi32>
        %5 = memref.load %alloca_4[%c0] : memref<1xi32>
        %6 = arith.addi %4, %5 : i32
        %7 = memref.load %alloca_0[%c0] : memref<1xi32>
        %8 = arith.remsi %6, %7 : i32
        %9 = arith.sitofp %8 : i32 to f32
        %10 = memref.load %alloca[%c0] : memref<1xi32>
        %11 = arith.muli %10, %c5_i32 : i32
        %12 = arith.sitofp %11 : i32 to f32
        %13 = arith.divf %9, %12 : f32
        %14 = memref.load %alloca_1[%c0] : memref<1xmemref<124xf32>>
        %15 = arith.index_cast %4 : i32 to index
        %16 = arith.subi %c124, %15 : index
        %subview = memref.subview %14[%15] [%16] [1] : memref<124xf32> to memref<?xf32, strided<[1], offset: ?>>
        %17 = arith.index_cast %5 : i32 to index
        %subview_6 = memref.subview %subview[%17] [1] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<1xf32, strided<[1], offset: ?>>
        memref.store %13, %subview_6[%c0] : memref<1xf32, strided<[1], offset: ?>>
        %18 = memref.load %alloca_4[%c0] : memref<1xi32>
        %19 = arith.addi %18, %c1_i32 : i32
        memref.store %19, %alloca_4[%c0] : memref<1xi32>
        scf.yield
      }
      %2 = memref.load %alloca_3[%c0] : memref<1xi32>
      %3 = arith.addi %2, %c1_i32 : i32
      memref.store %3, %alloca_3[%c0] : memref<1xi32>
      scf.yield
    }
    return
  }
  func.func private @kernel_atax(%arg0: i32, %arg1: i32, %arg2: memref<124xf32>, %arg3: memref<?xf32, strided<[1], offset: ?>>, %arg4: memref<?xf32, strided<[1], offset: ?>>, %arg5: memref<?xf32, strided<[1], offset: ?>>) attributes {no_inline} {
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
    %c1_i32 = arith.constant 1 : i32
    %c20_i32 = arith.constant 20 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = llvm.mlir.addressof @__stderrp : !llvm.ptr
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %alloca_1 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %1 = llvm.load %0 : !llvm.ptr -> !llvm.ptr
    %2 = memref.get_global @".str.1" : memref<23xi8>
    %reinterpret_cast = memref.reinterpret_cast %2 to offset: [0], sizes: [23], strides: [1] : memref<23xi8> to memref<23xi8, strided<[1]>>
    %cast = memref.cast %reinterpret_cast : memref<23xi8, strided<[1]>> to memref<?xi8, strided<[1], offset: ?>>
    %intptr = memref.extract_aligned_pointer_as_index %cast : memref<?xi8, strided<[1], offset: ?>> -> index
    %3 = arith.index_castui %intptr : index to i64
    %4 = llvm.inttoptr %3 : i64 to !llvm.ptr
    %5 = llvm.call @fprintf(%1, %4) vararg(!llvm.func<i32 (ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr) -> i32
    %6 = llvm.load %0 : !llvm.ptr -> !llvm.ptr
    %7 = memref.get_global @".str.2" : memref<15xi8>
    %reinterpret_cast_2 = memref.reinterpret_cast %7 to offset: [0], sizes: [15], strides: [1] : memref<15xi8> to memref<15xi8, strided<[1]>>
    %cast_3 = memref.cast %reinterpret_cast_2 : memref<15xi8, strided<[1]>> to memref<?xi8, strided<[1], offset: ?>>
    %8 = memref.get_global @".str.3" : memref<2xi8>
    %reinterpret_cast_4 = memref.reinterpret_cast %8 to offset: [0], sizes: [2], strides: [1] : memref<2xi8> to memref<2xi8, strided<[1]>>
    %cast_5 = memref.cast %reinterpret_cast_4 : memref<2xi8, strided<[1]>> to memref<?xi8, strided<[1], offset: ?>>
    %intptr_6 = memref.extract_aligned_pointer_as_index %cast_3 : memref<?xi8, strided<[1], offset: ?>> -> index
    %9 = arith.index_castui %intptr_6 : index to i64
    %10 = llvm.inttoptr %9 : i64 to !llvm.ptr
    %intptr_7 = memref.extract_aligned_pointer_as_index %cast_5 : memref<?xi8, strided<[1], offset: ?>> -> index
    %11 = arith.index_castui %intptr_7 : index to i64
    %12 = llvm.inttoptr %11 : i64 to !llvm.ptr
    %13 = llvm.call @fprintf(%6, %10, %12) vararg(!llvm.func<i32 (ptr, ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
    memref.store %c0_i32, %alloca_1[%c0] : memref<1xi32>
    scf.while : () -> () {
      %24 = memref.load %alloca_1[%c0] : memref<1xi32>
      %25 = memref.load %alloca[%c0] : memref<1xi32>
      %26 = arith.cmpi slt, %24, %25 : i32
      scf.condition(%26)
    } do {
      memref.alloca_scope  {
        memref.alloca_scope  {
          %37 = memref.load %alloca_1[%c0] : memref<1xi32>
          %38 = arith.remsi %37, %c20_i32 : i32
          %39 = arith.cmpi eq, %38, %c0_i32 : i32
          scf.if %39 {
            %40 = llvm.load %0 : !llvm.ptr -> !llvm.ptr
            %41 = memref.get_global @".str.4" : memref<2xi8>
            %reinterpret_cast_17 = memref.reinterpret_cast %41 to offset: [0], sizes: [2], strides: [1] : memref<2xi8> to memref<2xi8, strided<[1]>>
            %cast_18 = memref.cast %reinterpret_cast_17 : memref<2xi8, strided<[1]>> to memref<?xi8, strided<[1], offset: ?>>
            %intptr_19 = memref.extract_aligned_pointer_as_index %cast_18 : memref<?xi8, strided<[1], offset: ?>> -> index
            %42 = arith.index_castui %intptr_19 : index to i64
            %43 = llvm.inttoptr %42 : i64 to !llvm.ptr
            %44 = llvm.call @fprintf(%40, %43) vararg(!llvm.func<i32 (ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr) -> i32
          }
        }
        %26 = llvm.load %0 : !llvm.ptr -> !llvm.ptr
        %27 = memref.get_global @".str.5" : memref<7xi8>
        %reinterpret_cast_14 = memref.reinterpret_cast %27 to offset: [0], sizes: [7], strides: [1] : memref<7xi8> to memref<7xi8, strided<[1]>>
        %cast_15 = memref.cast %reinterpret_cast_14 : memref<7xi8, strided<[1]>> to memref<?xi8, strided<[1], offset: ?>>
        %28 = memref.load %alloca_0[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %29 = memref.load %alloca_1[%c0] : memref<1xi32>
        %30 = arith.index_cast %29 : i32 to index
        %dim = memref.dim %28, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %31 = arith.subi %dim, %30 : index
        %subview = memref.subview %28[%30] [%31] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        %32 = memref.load %subview[%c0] : memref<?xf32, strided<[1], offset: ?>>
        %33 = arith.extf %32 : f32 to f64
        %intptr_16 = memref.extract_aligned_pointer_as_index %cast_15 : memref<?xi8, strided<[1], offset: ?>> -> index
        %34 = arith.index_castui %intptr_16 : index to i64
        %35 = llvm.inttoptr %34 : i64 to !llvm.ptr
        %36 = llvm.call @fprintf(%26, %35, %33) vararg(!llvm.func<i32 (ptr, ptr, f64, ...)>) : (!llvm.ptr, !llvm.ptr, f64) -> i32
      }
      %24 = memref.load %alloca_1[%c0] : memref<1xi32>
      %25 = arith.addi %24, %c1_i32 : i32
      memref.store %25, %alloca_1[%c0] : memref<1xi32>
      scf.yield
    }
    %14 = llvm.load %0 : !llvm.ptr -> !llvm.ptr
    %15 = memref.get_global @".str.6" : memref<17xi8>
    %reinterpret_cast_8 = memref.reinterpret_cast %15 to offset: [0], sizes: [17], strides: [1] : memref<17xi8> to memref<17xi8, strided<[1]>>
    %cast_9 = memref.cast %reinterpret_cast_8 : memref<17xi8, strided<[1]>> to memref<?xi8, strided<[1], offset: ?>>
    %intptr_10 = memref.extract_aligned_pointer_as_index %cast_9 : memref<?xi8, strided<[1], offset: ?>> -> index
    %16 = arith.index_castui %intptr_10 : index to i64
    %17 = llvm.inttoptr %16 : i64 to !llvm.ptr
    %18 = llvm.call @fprintf(%14, %17, %12) vararg(!llvm.func<i32 (ptr, ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
    %19 = llvm.load %0 : !llvm.ptr -> !llvm.ptr
    %20 = memref.get_global @".str.7" : memref<23xi8>
    %reinterpret_cast_11 = memref.reinterpret_cast %20 to offset: [0], sizes: [23], strides: [1] : memref<23xi8> to memref<23xi8, strided<[1]>>
    %cast_12 = memref.cast %reinterpret_cast_11 : memref<23xi8, strided<[1]>> to memref<?xi8, strided<[1], offset: ?>>
    %intptr_13 = memref.extract_aligned_pointer_as_index %cast_12 : memref<?xi8, strided<[1], offset: ?>> -> index
    %21 = arith.index_castui %intptr_13 : index to i64
    %22 = llvm.inttoptr %21 : i64 to !llvm.ptr
    %23 = llvm.call @fprintf(%19, %22) vararg(!llvm.func<i32 (ptr, ptr, ...)>) : (!llvm.ptr, !llvm.ptr) -> i32
    return
  }
  func.func private @free(!llvm.ptr)
  func.func private @polybench_free_data(!llvm.ptr)
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>) -> i32 attributes {no_inline} {
    %c124_i64 = arith.constant 124 : i64
    %c4_i32 = arith.constant 4 : i32
    %c14384_i64 = arith.constant 14384 : i64
    %false = arith.constant false
    %c42_i32 = arith.constant 42 : i32
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %2 = llvm.mlir.constant(1 : i64) : i64
    %3 = llvm.mlir.constant(0 : i64) : i64
    %c0_i32 = arith.constant 0 : i32
    %c124_i32 = arith.constant 124 : i32
    %c116_i32 = arith.constant 116 : i32
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_0 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>>
    %alloca_1 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_2 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_3 = memref.alloca() {alignment = 4 : i64} : memref<1xi32>
    %alloca_4 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<116x124xf32>>
    %alloca_5 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<124xf32>>
    %alloca_6 = memref.alloca() {alignment = 8 : i64} : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    memref.store %arg0, %alloca[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>>
    memref.store %c116_i32, %alloca_2[%c0] : memref<1xi32>
    memref.store %c124_i32, %alloca_3[%c0] : memref<1xi32>
    %4 = call @polybench_alloc_data(%c14384_i64, %c4_i32) : (i64, i32) -> !llvm.ptr
    %5 = llvm.insertvalue %4, %1[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %4, %5[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %3, %6[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.insertvalue %c14384_i64, %7[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %9 = llvm.insertvalue %2, %8[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = builtin.unrealized_conversion_cast %9 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> to memref<116x124xf32>
    memref.store %10, %alloca_4[%c0] : memref<1xmemref<116x124xf32>>
    %11 = call @polybench_alloc_data(%c124_i64, %c4_i32) : (i64, i32) -> !llvm.ptr
    %12 = llvm.insertvalue %11, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %13 = llvm.insertvalue %11, %12[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %14 = llvm.insertvalue %3, %13[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.insertvalue %c124_i64, %14[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %16 = llvm.insertvalue %2, %15[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %17 = builtin.unrealized_conversion_cast %16 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> to memref<124xf32>
    memref.store %17, %alloca_5[%c0] : memref<1xmemref<124xf32>>
    %18 = memref.load %alloca_2[%c0] : memref<1xi32>
    %19 = memref.load %alloca_3[%c0] : memref<1xi32>
    %20 = arith.addi %18, %19 : i32
    %21 = arith.extsi %20 : i32 to i64
    %22 = call @polybench_alloc_data(%21, %c4_i32) : (i64, i32) -> !llvm.ptr
    %23 = llvm.insertvalue %22, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.insertvalue %22, %23[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %25 = llvm.insertvalue %3, %24[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %26 = llvm.insertvalue %21, %25[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = llvm.insertvalue %2, %26[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %28 = builtin.unrealized_conversion_cast %27 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> to memref<?xf32, strided<[1], offset: ?>>
    memref.store %28, %alloca_6[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %29 = memref.load %alloca_2[%c0] : memref<1xi32>
    %30 = memref.load %alloca_3[%c0] : memref<1xi32>
    %31 = memref.load %alloca_4[%c0] : memref<1xmemref<116x124xf32>>
    %reinterpret_cast = memref.reinterpret_cast %31 to offset: [0], sizes: [124], strides: [1] : memref<116x124xf32> to memref<124xf32>
    %32 = memref.load %alloca_5[%c0] : memref<1xmemref<124xf32>>
    %reinterpret_cast_7 = memref.reinterpret_cast %32 to offset: [0], sizes: [124], strides: [1] : memref<124xf32> to memref<124xf32, strided<[1]>>
    %cast = memref.cast %reinterpret_cast_7 : memref<124xf32, strided<[1]>> to memref<?xf32, strided<[1], offset: ?>>
    call @init_array(%29, %30, %reinterpret_cast, %cast) : (i32, i32, memref<124xf32>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    %33 = memref.load %alloca_2[%c0] : memref<1xi32>
    %34 = memref.load %alloca_3[%c0] : memref<1xi32>
    %35 = memref.load %alloca_4[%c0] : memref<1xmemref<116x124xf32>>
    %reinterpret_cast_8 = memref.reinterpret_cast %35 to offset: [0], sizes: [124], strides: [1] : memref<116x124xf32> to memref<124xf32>
    %36 = memref.load %alloca_5[%c0] : memref<1xmemref<124xf32>>
    %reinterpret_cast_9 = memref.reinterpret_cast %36 to offset: [0], sizes: [124], strides: [1] : memref<124xf32> to memref<124xf32, strided<[1]>>
    %cast_10 = memref.cast %reinterpret_cast_9 : memref<124xf32, strided<[1]>> to memref<?xf32, strided<[1], offset: ?>>
    %37 = memref.load %alloca_6[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %38 = arith.index_cast %33 : i32 to index
    %dim = memref.dim %37, %c0 : memref<?xf32, strided<[1], offset: ?>>
    %39 = arith.subi %dim, %38 : index
    %subview = memref.subview %37[%38] [%39] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
    call @kernel_atax(%33, %34, %reinterpret_cast_8, %cast_10, %subview, %37) : (i32, i32, memref<124xf32>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>, memref<?xf32, strided<[1], offset: ?>>) -> ()
    memref.alloca_scope  {
      %50 = memref.load %alloca[%c0] : memref<1xi32>
      %51 = arith.cmpi sgt, %50, %c42_i32 : i32
      %52 = scf.if %51 -> (i1) {
        %53 = memref.load %alloca_0[%c0] : memref<1xmemref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>>
        %dim_13 = memref.dim %53, %c0 : memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>
        %subview_14 = memref.subview %53[0] [%dim_13] [1] : memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>> to memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>
        %54 = memref.load %subview_14[%c0] : memref<?xmemref<?xi8, strided<[1], offset: ?>>, strided<[1], offset: ?>>
        %55 = memref.get_global @".str" : memref<1xi8>
        %reinterpret_cast_15 = memref.reinterpret_cast %55 to offset: [0], sizes: [1], strides: [1] : memref<1xi8> to memref<1xi8, strided<[1]>>
        %cast_16 = memref.cast %reinterpret_cast_15 : memref<1xi8, strided<[1]>> to memref<?xi8, strided<[1], offset: ?>>
        %56 = func.call @strcmp(%54, %cast_16) : (memref<?xi8, strided<[1], offset: ?>>, memref<?xi8, strided<[1], offset: ?>>) -> i32
        %57 = arith.cmpi eq, %56, %c0_i32 : i32
        scf.yield %57 : i1
      } else {
        scf.yield %false : i1
      }
      scf.if %52 {
        %53 = memref.load %alloca_3[%c0] : memref<1xi32>
        %54 = memref.load %alloca_6[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
        %55 = memref.load %alloca_2[%c0] : memref<1xi32>
        %56 = arith.index_cast %55 : i32 to index
        %dim_13 = memref.dim %54, %c0 : memref<?xf32, strided<[1], offset: ?>>
        %57 = arith.subi %dim_13, %56 : index
        %subview_14 = memref.subview %54[%56] [%57] [1] : memref<?xf32, strided<[1], offset: ?>> to memref<?xf32, strided<[1], offset: ?>>
        func.call @print_array(%53, %subview_14) : (i32, memref<?xf32, strided<[1], offset: ?>>) -> ()
      }
    }
    %40 = memref.load %alloca_4[%c0] : memref<1xmemref<116x124xf32>>
    %intptr = memref.extract_aligned_pointer_as_index %40 : memref<116x124xf32> -> index
    %41 = arith.index_castui %intptr : index to i64
    %42 = llvm.inttoptr %41 : i64 to !llvm.ptr
    call @free(%42) : (!llvm.ptr) -> ()
    %43 = memref.load %alloca_5[%c0] : memref<1xmemref<124xf32>>
    %intptr_11 = memref.extract_aligned_pointer_as_index %43 : memref<124xf32> -> index
    %44 = arith.index_castui %intptr_11 : index to i64
    %45 = llvm.inttoptr %44 : i64 to !llvm.ptr
    call @free(%45) : (!llvm.ptr) -> ()
    %46 = memref.load %alloca_6[%c0] : memref<1xmemref<?xf32, strided<[1], offset: ?>>>
    %intptr_12 = memref.extract_aligned_pointer_as_index %46 : memref<?xf32, strided<[1], offset: ?>> -> index
    %47 = arith.index_castui %intptr_12 : index to i64
    %48 = llvm.inttoptr %47 : i64 to !llvm.ptr
    call @polybench_free_data(%48) : (!llvm.ptr) -> ()
    memref.store %c0_i32, %alloca_1[%c0] : memref<1xi32>
    %49 = memref.load %alloca_1[%c0] : memref<1xi32>
    return %49 : i32
  }
}

