module {
  func.func @column_split(%arg0: memref<?x1024xf32>, %arg1: index, %arg2: index) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1024 = arith.constant 1024 : index
    %cst = arith.constant 1.000000e+00 : f32
    %0 = arith.subi %c1024, %arg2 : index
    %subview = memref.subview %arg0[0, 0] [%arg1, %arg2] [1, 1] : memref<?x1024xf32> to memref<?x?xf32, strided<[1024, 1]>>
    %subview_0 = memref.subview %arg0[0, %arg2] [%arg1, %0] [1, 1] : memref<?x1024xf32> to memref<?x?xf32, strided<[1024, 1], offset: ?>>
    memref.store %cst, %subview[%c0, %c0] : memref<?x?xf32, strided<[1024, 1]>>
    scf.for %arg3 = %c0 to %arg1 step %c1 {
      scf.for %arg4 = %c0 to %0 step %c1 {
        %1 = memref.load %subview[%c0, %c0] : memref<?x?xf32, strided<[1024, 1]>>
        %2 = memref.load %subview_0[%arg3, %arg4] : memref<?x?xf32, strided<[1024, 1], offset: ?>>
        %3 = arith.addf %2, %1 : f32
        memref.store %3, %subview_0[%arg3, %arg4] : memref<?x?xf32, strided<[1024, 1], offset: ?>>
      }
    }
    return
  }
}
