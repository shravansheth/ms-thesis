module {
  // linalg.generic-derived scale-add on a dynamically-split buffer.
  //
  // The flat buffer %buf (2048 floats) is partitioned at runtime point %n:
  //   lo = buf[0 .. n-1]    — scale factor lives at lo[0]
  //   hi = buf[n .. 2047]   — data elements to be updated
  //
  // Partition-by-endpoint (Form A): hi.offset == lo.size (both are %n).
  // Both subviews derive from the same base pointer %buf.
  //
  // The linalg.generic maps:
  //   ins(%lo) with affine_map<(d0) -> (0)>:  always reads lo[0]
  //   outs(%hi) with affine_map<(d0) -> (d0)>: reads/writes hi[d0]
  //
  // After --convert-linalg-to-loops, this becomes:
  //   for d0 in [0, dim(hi,0)):
  //     alpha = memref.load %lo[0]    <- loop-invariant; alias conservatism blocks hoist
  //     x     = memref.load %hi[d0]
  //     memref.store %hi[d0], x + alpha
  //
  // Without alias metadata LLVM cannot prove lo[0] and hi[d0] are disjoint
  // (they share the same base pointer). The pass emits !alias.scope / !noalias
  // on the lowered load/store ops, enabling LICM to hoist the lo[0] load.
  //
  // Corresponds to: bias-add in a normalization layer (add a scalar offset
  // to each element of a partition) — a common linalg.generic in ML compilers.
  func.func @linalg_scale_split(%buf: memref<2048xf32>, %n: index) {
    %c0    = arith.constant 0 : index
    %f1    = arith.constant 1.0 : f32
    %c2048 = arith.constant 2048 : index

    %hi_size = arith.subi %c2048, %n : index

    // lo = buf[0 .. n-1]: n elements at offset 0.
    // hi = buf[n .. 2047]: (2048-n) elements at dynamic offset n.
    // MLIR structural guarantee: hi.offset (%n) == lo.size (%n) → non-overlapping.
    %lo = memref.subview %buf[0][%n][1]
      : memref<2048xf32> to memref<?xf32, strided<[1]>>
    %hi = memref.subview %buf[%n][%hi_size][1]
      : memref<2048xf32> to memref<?xf32, strided<[1], offset: ?>>

    // Seed: set lo[0] (the scale factor) to 1.0.
    memref.store %f1, %lo[%c0] : memref<?xf32, strided<[1]>>

    // linalg.generic: hi[d0] += lo[0]  for all d0 in [0, hi_size)
    linalg.generic {
      indexing_maps = [
        affine_map<(d0) -> (0)>,    // lo: constant index 0 — scale factor
        affine_map<(d0) -> (d0)>    // hi: element d0
      ],
      iterator_types = ["parallel"]
    } ins(%lo : memref<?xf32, strided<[1]>>)
      outs(%hi : memref<?xf32, strided<[1], offset: ?>>) {
    ^bb0(%alpha: f32, %val: f32):
      %result = arith.addf %val, %alpha : f32
      linalg.yield %result : f32
    }

    return
  }
}
