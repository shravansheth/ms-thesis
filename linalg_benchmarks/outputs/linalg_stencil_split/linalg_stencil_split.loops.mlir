module {
  func.func @linalg_stencil_split(%arg0: memref<4096xf32>, %arg1: index) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 1.000000e+00 : f32
    %c4096 = arith.constant 4096 : index
    %0 = arith.subi %c4096, %arg1 : index
    %subview = memref.subview %arg0[0] [%arg1] [1] : memref<4096xf32> to memref<?xf32, strided<[1]>>
    %subview_0 = memref.subview %arg0[%arg1] [%0] [1] : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>
    scf.for %arg2 = %c0 to %0 step %c1 {
      memref.store %cst, %subview_0[%arg2] : memref<?xf32, strided<[1], offset: ?>>
    }
    scf.for %arg2 = %c0 to %arg1 step %c1 {
      %1 = memref.load %subview[%arg2] : memref<?xf32, strided<[1]>>
      %2 = memref.load %subview_0[%arg2] : memref<?xf32, strided<[1], offset: ?>>
      %3 = arith.addf %2, %1 : f32
      %4 = arith.addf %3, %cst : f32
      memref.store %4, %subview_0[%arg2] : memref<?xf32, strided<[1], offset: ?>>
    }
    return
  }
}

