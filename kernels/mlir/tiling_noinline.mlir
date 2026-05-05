module {
  // Tiling stencil: compute dst[j] = src[j] + src[0] for adjacent tiles of a flat buffer.
  //
  // The computation is factored into a noinline callee that receives src and dst as
  // separate memref arguments. The caller creates the two adjacent tiles via subview
  // with the partition-by-endpoint pattern (dst.offset = src.offset + N).
  //
  // Information loss: at the MLIR call site, src and dst are provably disjoint (structural
  // partition-by-endpoint). After lowering, the callee receives two raw ptr arguments with
  // no alias information — LLVM cannot prove disjointness inside @tile_stencil.
  //
  // This case combines:
  //   1. The partition-by-endpoint pattern (adjacent_tiles / dynamic_split)
  //   2. The noinline callee boundary (subview_noalias)
  //
  // It represents real tiling workloads where a stencil kernel is abstracted as a
  // separate (possibly library) function.

  // Noinline callee: reads src[0] (invariant) and src[j], writes to dst[j].
  // LLVM sees two ptr args — no structural proof of disjointness available inside.
  func.func @tile_stencil(%src: memref<?xf32, strided<[1], offset: ?>>,
                          %dst: memref<?xf32, strided<[1], offset: ?>>,
                          %N: index) attributes {no_inline} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %j = %c0 to %N step %c1 {
      %inv = memref.load %src[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %x   = memref.load %src[%j]  : memref<?xf32, strided<[1], offset: ?>>
      %y   = arith.addf %x, %inv : f32
      memref.store %y, %dst[%j] : memref<?xf32, strided<[1], offset: ?>>
    }
    return
  }

  // Caller: partitions A into src and dst tiles using partition-by-endpoint.
  // src = A[tile*N .. (tile+1)*N - 1]
  // dst = A[(tile+1)*N .. (tile+2)*N - 1]
  // dst.offset = src.offset + N = src.offset + src.size  -> partition-by-endpoint
  func.func @tiling_caller(%A: memref<4096xf32>, %tile: index, %N: index) {
    %c1 = arith.constant 1 : index

    %src_off = arith.muli %tile, %N : index
    %src = memref.subview %A[%src_off][%N][1]
      : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>

    // dst.offset = src.offset + N  ->  partition-by-endpoint
    %dst_off = arith.addi %src_off, %N : index
    %dst = memref.subview %A[%dst_off][%N][1]
      : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>

    func.call @tile_stencil(%src, %dst, %N) { no_inline }
      : (memref<?xf32, strided<[1], offset: ?>>,
         memref<?xf32, strided<[1], offset: ?>>,
         index) -> ()
    return
  }
}
