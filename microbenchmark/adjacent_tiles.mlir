module {
  // Read from tile k: A[tile*N .. (tile+1)*N - 1]
  // Write to tile k+1: A[(tile+1)*N .. (tile+2)*N - 1]
  //
  // These are structurally disjoint: dst.offset = src.offset + src.size (same partition-by-endpoint
  // pattern as dynamic_split, but the endpoint is derived via arith.muli + arith.addi).
  //
  // NOTE: if the inner loop executes at all (j < N is true for j=0), then N >= 1.
  // LLVM may derive N > 0 from the inner-loop condition, potentially enabling LICM without
  // any alias metadata. This case is exploratory — testing whether LLVM handles it.
  func.func @adjacent_tiles(%A: memref<4096xf32>, %tile: index, %N: index) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index

    // src = A[tile*N .. (tile+1)*N - 1]
    %src_off = arith.muli %tile, %N : index
    %src = memref.subview %A[%src_off][%N][1]
      : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>

    // dst = A[(tile+1)*N .. (tile+2)*N - 1]
    // dst.offset = src.offset + N = src.offset + src.size → partition-by-endpoint
    %dst_off = arith.addi %src_off, %N : index
    %dst = memref.subview %A[%dst_off][%N][1]
      : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>

    scf.for %j = %c0 to %N step %c1 {
      // Loop-invariant load from src[0] = A[tile*N]
      %inv = memref.load %src[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %x   = memref.load %src[%j]  : memref<?xf32, strided<[1], offset: ?>>
      %y   = arith.addf %x, %inv : f32
      memref.store %y, %dst[%j] : memref<?xf32, strided<[1], offset: ?>>
    }

    return
  }
}
