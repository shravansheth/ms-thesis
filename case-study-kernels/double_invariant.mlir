module {
  // Two loop-invariant loads from lo instead of one.
  //
  // lo = A[0 .. n-1]  (offset 0, size n)
  // hi = A[n .. 2047] (offset n, size 2048-n)
  //
  // Kernel seeds lo[0]=1.0 and lo[1]=2.0, then: hi[i] = hi[i] + lo[0] + lo[1].
  // Both lo[0] and lo[1] are loop-invariant; at baseline both are blocked by
  // hi[i] stores potentially aliasing them.  With the pass both should be
  // hoisted, giving two additional successful LICM hoists.
  func.func @double_invariant(%A: memref<2048xf32>, %n: index) {
    %c0    = arith.constant 0 : index
    %c1    = arith.constant 1 : index
    %c2048 = arith.constant 2048 : index
    %f1    = arith.constant 1.0 : f32
    %f2    = arith.constant 2.0 : f32

    %hi_size = arith.subi %c2048, %n : index

    %lo = memref.subview %A[0][%n][1]
      : memref<2048xf32> to memref<?xf32, strided<[1]>>
    %hi = memref.subview %A[%n][%hi_size][1]
      : memref<2048xf32> to memref<?xf32, strided<[1], offset: ?>>

    // Seed two invariant values.
    memref.store %f1, %lo[%c0] : memref<?xf32, strided<[1]>>
    memref.store %f2, %lo[%c1] : memref<?xf32, strided<[1]>>

    // Loop: two invariant loads from lo; hi[i] stores block both at baseline.
    scf.for %i = %c0 to %hi_size step %c1 {
      %inv0 = memref.load %lo[%c0] : memref<?xf32, strided<[1]>>
      %inv1 = memref.load %lo[%c1] : memref<?xf32, strided<[1]>>
      %x    = memref.load %hi[%i]  : memref<?xf32, strided<[1], offset: ?>>
      %y    = arith.addf %x,    %inv0 : f32
      %z    = arith.addf %y,    %inv1 : f32
      memref.store %z, %hi[%i] : memref<?xf32, strided<[1], offset: ?>>
    }

    return
  }
}
