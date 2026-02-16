module {
  func.func @subview_hoist_static() {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    %f0 = arith.constant 0.0 : f32

    %A = memref.alloc() : memref<1024xf32>

    // Two disjoint halves: [0..511] and [512..1023]
    %slice0 = memref.subview %A[0]   [512] [1]
      : memref<1024xf32> to memref<512xf32, strided<[1], offset: 0>>
    %slice1 = memref.subview %A[512] [512] [1]
      : memref<1024xf32> to memref<512xf32, strided<[1], offset: 512>>

    // Fill a single element in slice0 so it's a non-trivial load
    //memref.store %c0, %slice0[%c0] : memref<512xf32>  // stores 0.0? (index->f32 mismatch)
    memref.store %f0, %slice0[%c0] 
      : memref<512xf32, strided<[1], offset: 0>>

    scf.for %i = %c0 to %c512 step %c1 {
      %inv = memref.load %slice0[%c0] 
        :  memref<512xf32, strided<[1], offset: 0>>
      %x   = memref.load %slice0[%i] 
        : memref<512xf32, strided<[1], offset: 0>>
      %y   = arith.addf %x, %inv : f32
      memref.store %y, %slice1[%i] 
        : memref<512xf32, strided<[1], offset: 512>>
    }

    memref.dealloc %A : memref<1024xf32>
    return
  }
}
