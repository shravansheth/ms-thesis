module {
  // linalg.generic-derived normalize: two sequential generics on the same (lo, hi) pair.
  //
  // The flat buffer %buf (2048 floats) is partitioned at runtime point %n:
  //   lo = buf[0 .. n-1]   — lo[0] = bias addend, lo[1] = scale multiplier
  //   hi = buf[n .. 2047]  — data elements to normalize
  //
  // Partition-by-endpoint (Form A): hi.offset == lo.size (both are %n).
  //
  // Two linalg.generic ops represent a two-stage normalize pipeline:
  //   Stage 1 (bias):  hi[d0] += lo[0]   (affine_map<(d0) -> (0)>)
  //   Stage 2 (scale): hi[d0] *= lo[1]   (affine_map<(d0) -> (1)>)
  //
  // After --convert-linalg-to-loops, each stage becomes a separate loop:
  //   Loop 1: bias = load lo[0]; hi[d0] += bias   <- lo[0] load is invariant
  //   Loop 2: sc   = load lo[1]; hi[d0] *= sc     <- lo[1] load is invariant
  //
  // Both lo[0] and lo[1] are loop-invariant, but LLVM cannot hoist them because
  // lo and hi share the same base pointer. The pass tags all uses of %lo (including
  // both loops' loads), emitting metadata that unblocks LICM for both loads.
  //
  // Demonstrates: 2-load LICM block (analogous to the double_invariant micro-bench),
  // derived from a linalg.generic normalize pattern.
  func.func @linalg_norm_split(%buf: memref<2048xf32>, %n: index) {
    %c0    = arith.constant 0 : index
    %c1    = arith.constant 1 : index
    %f1    = arith.constant 1.0 : f32
    %f2    = arith.constant 2.0 : f32
    %c2048 = arith.constant 2048 : index

    %hi_size = arith.subi %c2048, %n : index

    // lo = buf[0 .. n-1], hi = buf[n .. 2047].
    // Form A: hi.offset (%n) == lo.size (%n).
    %lo = memref.subview %buf[0][%n][1]
      : memref<2048xf32> to memref<?xf32, strided<[1]>>
    %hi = memref.subview %buf[%n][%hi_size][1]
      : memref<2048xf32> to memref<?xf32, strided<[1], offset: ?>>

    // Set lo[0] = bias (1.0), lo[1] = scale (2.0).
    memref.store %f1, %lo[%c0] : memref<?xf32, strided<[1]>>
    memref.store %f2, %lo[%c1] : memref<?xf32, strided<[1]>>

    // Stage 1 (bias-add): hi[d0] += lo[0]
    linalg.generic {
      indexing_maps = [
        affine_map<(d0) -> (0)>,    // lo: always element 0 (bias)
        affine_map<(d0) -> (d0)>    // hi: element d0
      ],
      iterator_types = ["parallel"]
    } ins(%lo : memref<?xf32, strided<[1]>>)
      outs(%hi : memref<?xf32, strided<[1], offset: ?>>) {
    ^bb0(%bias: f32, %val: f32):
      %biased = arith.addf %val, %bias : f32
      linalg.yield %biased : f32
    }

    // Stage 2 (scale): hi[d0] *= lo[1]
    linalg.generic {
      indexing_maps = [
        affine_map<(d0) -> (1)>,    // lo: always element 1 (scale)
        affine_map<(d0) -> (d0)>    // hi: element d0
      ],
      iterator_types = ["parallel"]
    } ins(%lo : memref<?xf32, strided<[1]>>)
      outs(%hi : memref<?xf32, strided<[1], offset: ?>>) {
    ^bb0(%sc: f32, %val: f32):
      %scaled = arith.mulf %val, %sc : f32
      linalg.yield %scaled : f32
    }

    return
  }
}
