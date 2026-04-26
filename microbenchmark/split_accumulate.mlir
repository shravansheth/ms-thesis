module {
  // Roles reversed from dynamic_split: lo is the WRITE target, hi[0] is the invariant READ.
  //
  // lo = A[0 .. n-1]  (offset 0, size n)
  // hi = A[n .. 2047] (offset n, size 2048-n)
  //
  // Kernel stores 1.0 to hi[0] before the loop, then: lo[i] += hi[0].
  // hi[0] is loop-invariant; LLVM cannot hoist it because lo[i] stores write
  // to (base + i), and LLVM cannot prove (base + i) != (base + n) without
  // knowing i < n.  This is the mirror of dynamic_split — same structural gap,
  // different access role assignment.
  func.func @split_accumulate(%A: memref<2048xf32>, %n: index) {
    %c0    = arith.constant 0 : index
    %c1    = arith.constant 1 : index
    %c2048 = arith.constant 2048 : index
    %f1    = arith.constant 1.0 : f32

    %hi_size = arith.subi %c2048, %n : index

    %lo = memref.subview %A[0][%n][1]
      : memref<2048xf32> to memref<?xf32, strided<[1]>>
    %hi = memref.subview %A[%n][%hi_size][1]
      : memref<2048xf32> to memref<?xf32, strided<[1], offset: ?>>

    // Seed hi[0] with a known value.
    memref.store %f1, %hi[%c0] : memref<?xf32, strided<[1], offset: ?>>

    // Loop: hi[0] is loop-invariant; lo[i] stores may alias hi[0] in LLVM's view.
    scf.for %i = %c0 to %n step %c1 {
      %inv = memref.load %hi[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %x   = memref.load %lo[%i]  : memref<?xf32, strided<[1]>>
      %y   = arith.addf %x, %inv  : f32
      memref.store %y, %lo[%i]   : memref<?xf32, strided<[1]>>
    }

    return
  }
}
