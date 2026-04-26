module {
  func.func @linalg_norm_split(%arg0: memref<2048xf32>, %arg1: index) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 1.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %c2048 = arith.constant 2048 : index
    %0 = arith.subi %c2048, %arg1 : index
    %subview = memref.subview %arg0[0] [%arg1] [1] : memref<2048xf32> to memref<?xf32, strided<[1]>>
    %subview_1 = memref.subview %arg0[%arg1] [%0] [1] : memref<2048xf32> to memref<?xf32, strided<[1], offset: ?>>
    memref.store %cst, %subview[%c0] : memref<?xf32, strided<[1]>>
    memref.store %cst_0, %subview[%c1] : memref<?xf32, strided<[1]>>
    scf.for %arg2 = %c0 to %0 step %c1 {
      %1 = memref.load %subview[%c0] : memref<?xf32, strided<[1]>>
      %2 = memref.load %subview_1[%arg2] : memref<?xf32, strided<[1], offset: ?>>
      %3 = arith.addf %2, %1 : f32
      memref.store %3, %subview_1[%arg2] : memref<?xf32, strided<[1], offset: ?>>
    }
    scf.for %arg2 = %c0 to %0 step %c1 {
      %1 = memref.load %subview[%c1] : memref<?xf32, strided<[1]>>
      %2 = memref.load %subview_1[%arg2] : memref<?xf32, strided<[1], offset: ?>>
      %3 = arith.mulf %2, %1 : f32
      memref.store %3, %subview_1[%arg2] : memref<?xf32, strided<[1], offset: ?>>
    }
    return
  }
}

