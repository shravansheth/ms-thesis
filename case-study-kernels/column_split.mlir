module {
  // 2D matrix split on COLUMNS (dimension 1) rather than rows (dimension 0).
  //
  // A: memref<?x1024xf32>.  Split at column boundary %k:
  //   left  = A[*, 0 ..  k-1]  (all rows, first k columns)
  //   right = A[*, k .. 1023]  (all rows, last 1024-k columns)
  //
  // The partition-by-endpoint invariant holds on dim 1:
  //   right.offset[1] = k = left.size[1]
  // but our pass currently only checks dimension 0.
  //
  // Expected: pass produces NO tagging, baseline misses remain after pass.
  // This is a known limitation of the dim-0-only check.
  func.func @column_split(%A: memref<?x1024xf32>, %m: index, %k: index) {
    %c0    = arith.constant 0 : index
    %c1    = arith.constant 1 : index
    %c1024 = arith.constant 1024 : index
    %f1    = arith.constant 1.0 : f32

    %k_right = arith.subi %c1024, %k : index

    // left  cols [0, k),   right cols [k, 1024)
    %left  = memref.subview %A[0, 0][%m, %k][1, 1]
      : memref<?x1024xf32> to memref<?x?xf32, strided<[1024, 1], offset: 0>>
    %right = memref.subview %A[0, %k][%m, %k_right][1, 1]
      : memref<?x1024xf32> to memref<?x?xf32, strided<[1024, 1], offset: ?>>

    // Seed left[0][0].
    memref.store %f1, %left[%c0, %c0]
      : memref<?x?xf32, strided<[1024, 1], offset: 0>>

    // Loop: left[0][0] invariant, right[i][j] stores may alias it in LLVM view.
    scf.for %i = %c0 to %m step %c1 {
      scf.for %j = %c0 to %k_right step %c1 {
        %inv = memref.load  %left[%c0, %c0]
          : memref<?x?xf32, strided<[1024, 1], offset: 0>>
        %x   = memref.load  %right[%i, %j]
          : memref<?x?xf32, strided<[1024, 1], offset: ?>>
        %y   = arith.addf %x, %inv : f32
        memref.store %y, %right[%i, %j]
          : memref<?x?xf32, strided<[1024, 1], offset: ?>>
      }
    }

    return
  }
}
