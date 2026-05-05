module {
  // IMEX softmax-derived candidate.
  //
  // IMEX softmax uses linalg maps like:
  //   data:  (d0, d1) -> (d0, d1)
  //   stats: (d0, d1) -> (d0, 0)
  //
  // This candidate isolates the row-wise scaling stage:
  //   data[row, col] = data[row, col] / stats[row, 0]
  //
  // Semantic-preserving benchmark manipulation:
  // pack the per-row stats and row data into adjacent column partitions of one
  // workspace:
  //   stats = work[:, 0 .. k)
  //   data  = work[:, k .. k + 1024)
  //
  // k is a runtime value (normally 1), so LLVM cannot prove data stores never
  // alias stats[row, 0] after lowering. The pass can prove the dim-1 endpoint.
  func.func @imex_softmax_scale_packed(
      %work: memref<?x2048xf32>,
      %rows: index,
      %k: index) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1024 = arith.constant 1024 : index

    %stats = memref.subview %work[0, 0][%rows, %k][1, 1]
      : memref<?x2048xf32> to memref<?x?xf32, strided<[2048, 1], offset: 0>>
    %data = memref.subview %work[0, %k][%rows, 1024][1, 1]
      : memref<?x2048xf32> to memref<?x1024xf32, strided<[2048, 1], offset: ?>>

    scf.for %r = %c0 to %rows step %c1 {
      scf.for %c = %c0 to %c1024 step %c1 {
        %scale = memref.load %stats[%r, %c0]
          : memref<?x?xf32, strided<[2048, 1], offset: 0>>
        %x = memref.load %data[%r, %c]
          : memref<?x1024xf32, strided<[2048, 1], offset: ?>>
        %y = arith.divf %x, %scale : f32
        memref.store %y, %data[%r, %c]
          : memref<?x1024xf32, strided<[2048, 1], offset: ?>>
      }
    }

    return
  }
}
