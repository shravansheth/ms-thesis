module {
  // No inline function
  func.func @kernel(%p: memref<?xf32, strided<[1], offset: ?>>,
                    %q: memref<?xf32, strided<[1], offset: ?>>)
      attributes { no_inline } {
    %c0   = arith.constant 0 : index
    %c1   = arith.constant 1 : index
    %c512 = arith.constant 512 : index

    scf.for %i = %c0 to %c512 step %c1 {
      // Loop invariant load.
      %inv = memref.load %p[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %x   = memref.load %p[%i]  : memref<?xf32, strided<[1], offset: ?>>
      %y   = arith.addf %x, %inv : f32
      // Store to q could alias p in the callee's view (p and q are just args).
      memref.store %y, %q[%i] : memref<?xf32, strided<[1], offset: ?>>
    }
    return
  }

  func.func @caller() {
    %c0   = arith.constant 0 : index
    %c1   = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    %f1   = arith.constant 1.0 : f32

    %A = memref.alloc() : memref<1024xf32>

    // Two disjoint halves: [0..511] and [512..1023]
    %slice0 = memref.subview %A[0]   [512] [1]
      : memref<1024xf32> to memref<512xf32, strided<[1], offset: 0>>
    %slice1 = memref.subview %A[512] [512] [1]
      : memref<1024xf32> to memref<512xf32, strided<[1], offset: 512>>

    // Make p[0] nontrivial 
    memref.store %f1, %slice0[%c0] : memref<512xf32, strided<[1], offset: 0>>

    // Cast away static offset info so kernel signature is uniform.
    %p = memref.cast %slice0
      : memref<512xf32, strided<[1], offset: 0>>
     to memref<?xf32, strided<[1], offset: ?>>
    %q = memref.cast %slice1
      : memref<512xf32, strided<[1], offset: 512>>
     to memref<?xf32, strided<[1], offset: ?>>

    func.call @kernel(%p, %q) { no_inline } :
      (memref<?xf32, strided<[1], offset: ?>>,
       memref<?xf32, strided<[1], offset: ?>>) -> ()

    memref.dealloc %A : memref<1024xf32>
    return
  }
}
