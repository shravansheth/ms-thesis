module {
  // Vectorization-enabling benchmark kernel.
  //
  // Buffer A (8MB, 2M floats) is split at a runtime offset %n:
  //   lo = A[0 .. n-1]          (dynamic size, Form A lo)
  //   hi = A[n .. n+1048576-1]  (STATIC size 1M, Form A hi)
  //
  // hi.offset = %n = lo.size  -> Form A partition-by-endpoint.
  // Loop runs exactly 1048576 iterations (static trip count).
  //
  // At baseline: LLVM cannot prove n >= 1, so the lo[0] load
  // aliases hi[i] stores -> vectorizer reports UnsafeDep.
  //
  // With pass: alias.scope/noalias metadata resolves the uncertainty.
  // LICM hoists lo[0]; SCCP folds to 1.0; vectorizer vectorizes the loop.
  //
  // The 1M static trip count ensures the vectorizer commits to SIMD code,
  // giving a measurable wall-clock speedup over the scalar baseline.

  func.func @vectorize_split(%A: memref<2097152xf32>, %n: index) {
    %c0   = arith.constant 0       : index
    %c1   = arith.constant 1       : index
    %c1M  = arith.constant 1048576 : index
    %f1   = arith.constant 1.0     : f32

    // lo region: A[0 .. n-1]
    %lo = memref.subview %A[0][%n][1]
      : memref<2097152xf32> to memref<?xf32, strided<[1]>>

    // hi region: A[n .. n+1M-1] — static size (literal), dynamic offset.
    // Using integer literal 1048576 (not SSA %c1M) so MLIR infers a static
    // result dimension, giving the vectorizer a known trip count.
    %hi = memref.subview %A[%n][1048576][1]
      : memref<2097152xf32> to memref<1048576xf32, strided<[1], offset: ?>>

    // Seed lo[0] — not a compile-time visible constant to the caller.
    memref.store %f1, %lo[%c0] : memref<?xf32, strided<[1]>>

    // Hot loop: hi[i] += lo[0]
    // lo[0] is loop-invariant. Blocked by hi[i] stores at baseline.
    // Static trip count 1M -> vectorizer will commit to SIMD once alias resolved.
    scf.for %i = %c0 to %c1M step %c1 {
      %v = memref.load %lo[%c0] : memref<?xf32, strided<[1]>>
      %x = memref.load %hi[%i]  : memref<1048576xf32, strided<[1], offset: ?>>
      %y = arith.addf %x, %v   : f32
      memref.store %y, %hi[%i]  : memref<1048576xf32, strided<[1], offset: ?>>
    }

    return
  }
}
