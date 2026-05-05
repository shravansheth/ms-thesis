module {
  // 2D matrix with static column count (512) and dynamic row count.
  // Split into top half (rows 0..m-1) and bottom half (rows m..2m-1).
  //
  // At MLIR level: top and bot are structurally disjoint — bot's row-offset (%m)
  // equals top's row-size (%m), the same partition-by-endpoint pattern as dynamic_split
  // but in 2D with a compound flat offset: bot[i][j] = base + (m + i)*512 + j.
  //
  // After lowering: load from (base + 0), store to (base + m*512 + i*512 + j).
  // LLVM cannot prove m*512 + i*512 + j != 0 without knowing m >= 1.
  // The 2D compound GEP (multiply + accumulate of row stride) makes this harder
  // than the 1D case and is representative of real matrix-tiling workloads.
  func.func @matrix_row_split(%A: memref<?x512xf32>, %m: index) {
    %c0   = arith.constant 0 : index
    %c1   = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    %f1   = arith.constant 1.0 : f32

    // top: rows [0, m), all 512 columns.
    %top = memref.subview %A[0, 0][%m, 512][1, 1]
      : memref<?x512xf32> to memref<?x512xf32, strided<[512, 1], offset: 0>>

    // bot: rows [m, 2m), all 512 columns.
    // bot's row-offset (%m) == top's row-size (%m) -> structurally disjoint.
    // Flat offset of bot[0][0] = m * 512, which LLVM cannot prove non-zero.
    %bot = memref.subview %A[%m, 0][%m, 512][1, 1]
      : memref<?x512xf32> to memref<?x512xf32, strided<[512, 1], offset: ?>>

    // Seed top[0][0] with a non-trivial value.
    memref.store %f1, %top[%c0, %c0]
      : memref<?x512xf32, strided<[512, 1], offset: 0>>

    // Nested loop: invariant load from top[0][0], stores to bot[i][j].
    // LLVM sees: load (base + 0) vs store (base + m*512 + i*512 + j).
    scf.for %i = %c0 to %m step %c1 {
      scf.for %j = %c0 to %c512 step %c1 {
        %inv = memref.load %top[%c0, %c0]
          : memref<?x512xf32, strided<[512, 1], offset: 0>>
        %x   = memref.load %top[%i, %j]
          : memref<?x512xf32, strided<[512, 1], offset: 0>>
        %y   = arith.addf %x, %inv : f32
        memref.store %y, %bot[%i, %j]
          : memref<?x512xf32, strided<[512, 1], offset: ?>>
      }
    }

    return
  }
}
