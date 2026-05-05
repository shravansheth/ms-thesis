module {
  // The split point %n is a function argument (runtime value).
  //
  // At the MLIR level, lo and hi are STRUCTURALLY DISJOINT:
  //   lo = A[0 .. n-1]  (offset 0, size n)
  //   hi = A[n .. 2047] (offset n, size 2048-n)
  // hi starts exactly where lo ends — zero overlap by construction.
  //
  // After lowering to LLVM IR:
  //   - Both subviews derive from the same base pointer.
  //   - lo[0] -> load from (base + 0)
  //   - hi[i] -> store to  (base + n + i)
  //
  // LLVM cannot prove non-aliasing without knowing n >= 1.
  // MLIR knows this structurally: the subview construction guarantees disjointness
  // as long as n > 0 (a typical precondition from the caller / tiling pass).
  //
  // Expected: LICM misses hoisting the load of lo[0] out of the loop.
  // Oracle:   add @llvm.assume(n >= 1) before the loop -> LICM hoists.
  func.func @dynamic_split(%A: memref<2048xf32>, %n: index) {
    %c0    = arith.constant 0 : index
    %c1    = arith.constant 1 : index
    %c2048 = arith.constant 2048 : index
    %f1    = arith.constant 1.0 : f32

    // Complement size: number of elements in the high half.
    %hi_size = arith.subi %c2048, %n : index

    // lo = A[0 .. n-1]: n elements at offset 0 (static).
    %lo = memref.subview %A[0][%n][1]
      : memref<2048xf32> to memref<?xf32, strided<[1]>>

    // hi = A[n .. 2047]: (2048-n) elements at dynamic offset n.
    // MLIR structural guarantee: hi.offset == lo.size => non-overlapping.
    %hi = memref.subview %A[%n][%hi_size][1]
      : memref<2048xf32> to memref<?xf32, strided<[1], offset: ?>>

    // Seed lo[0] with a non-trivial value.
    memref.store %f1, %lo[%c0] : memref<?xf32, strided<[1]>>

    // Loop: lo[0] is loop-invariant; hi[i] is the write target.
    // LLVM sees: load (base+0) vs store (base+n+i).
    // Without n >= 1, LLVM conservatively assumes they may alias.
    scf.for %i = %c0 to %hi_size step %c1 {
      %inv = memref.load %lo[%c0] : memref<?xf32, strided<[1]>>
      %x   = memref.load %hi[%i]  : memref<?xf32, strided<[1], offset: ?>>
      %y   = arith.addf %x, %inv : f32
      memref.store %y, %hi[%i] : memref<?xf32, strided<[1], offset: ?>>
    }

    return
  }
}
