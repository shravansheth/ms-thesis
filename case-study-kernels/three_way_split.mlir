module {
  // Buffer B split into three equal partitions: lo | mid | hi, each N elements.
  //
  // Two sequential loops, each targeting one pair:
  //   Loop 1 (pair lo/mid): reads lo[0] as invariant, writes mid[i]
  //   Loop 2 (pair mid/hi): reads mid[0] as invariant, writes hi[j]
  //
  // Pairs detected by the pass:
  //   Pair 0 (lo, mid): mid.offset = N = lo.size  -> Form A
  //   Pair 1 (mid, hi): hi.offset = addi(N, N) = mid.offset + mid.size -> Form B
  //
  // Known limitation to test: the mid subview is the "hi" of pair 0 AND the "lo"
  // of pair 1.  tagUsesOfValue runs for pair 0's hi (tags mid ops with groupId=1)
  // and then for pair 1's lo (overwrites those mid ops with groupId=2).
  // This means mid ops only carry pair 1 metadata after the second tagging,
  // losing the pair 0 hi tag needed to tell pair 0's scope the stores don't
  // alias lo[0].  Loop 1's hoist may therefore fail even with the pass.
  // Loop 2's hoist should succeed (hi ops correctly tagged as pair 1 hi).
  func.func @three_way_split(%B: memref<3072xf32>, %N: index) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %f1 = arith.constant 1.0 : f32
    %f2 = arith.constant 2.0 : f32

    // mid_off = N,  hi_off = 2*N
    %hi_off  = arith.addi %N, %N : index

    %lo  = memref.subview %B[0][%N][1]
      : memref<3072xf32> to memref<?xf32, strided<[1]>>
    %mid = memref.subview %B[%N][%N][1]
      : memref<3072xf32> to memref<?xf32, strided<[1], offset: ?>>
    %hi  = memref.subview %B[%hi_off][%N][1]
      : memref<3072xf32> to memref<?xf32, strided<[1], offset: ?>>

    memref.store %f1, %lo[%c0]  : memref<?xf32, strided<[1]>>
    memref.store %f2, %mid[%c0] : memref<?xf32, strided<[1], offset: ?>>

    // Loop 1: lo[0] invariant, writes mid[i].  Pair (lo, mid).
    scf.for %i = %c0 to %N step %c1 {
      %inv0 = memref.load %lo[%c0]  : memref<?xf32, strided<[1]>>
      %x    = memref.load %mid[%i]  : memref<?xf32, strided<[1], offset: ?>>
      %y    = arith.addf %x, %inv0  : f32
      memref.store %y, %mid[%i]    : memref<?xf32, strided<[1], offset: ?>>
    }

    // Loop 2: mid[0] invariant, writes hi[j].  Pair (mid, hi).
    scf.for %j = %c0 to %N step %c1 {
      %inv1 = memref.load %mid[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %z    = memref.load %hi[%j]   : memref<?xf32, strided<[1], offset: ?>>
      %w    = arith.addf %z, %inv1  : f32
      memref.store %w, %hi[%j]     : memref<?xf32, strided<[1], offset: ?>>
    }

    return
  }
}
