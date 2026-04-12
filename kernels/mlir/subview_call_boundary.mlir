module {
  // Callee: operates on two disjoint views of the same base buffer.
  // In a real pipeline, these could come from tiling/slicing passes.
  func.func @kernel(%src: memref<512xf32, strided<[1]>>,
                    %dst: memref<512xf32, strided<[1], offset: 512>>) {
    %c0   = arith.constant 0 : index
    %c1   = arith.constant 1 : index
    %c512 = arith.constant 512 : index

    scf.for %i = %c0 to %c512 step %c1 {
      // Loop-invariant address (src[0]) but inside loop.
      %inv = memref.load %src[%c0] : memref<512xf32, strided<[1]>>
      %x   = memref.load %src[%i]  : memref<512xf32, strided<[1]>>
      %y   = arith.addf %x, %inv : f32
      memref.store %y, %dst[%i] : memref<512xf32, strided<[1], offset: 512>>
    }
    return
  }

  // Caller: allocate a base buffer and form two disjoint halves as subviews.
  func.func @subview_call_boundary() {
    %c0   = arith.constant 0 : index
    %f0   = arith.constant 0.0 : f32

    %A = memref.alloc() : memref<1024xf32>

    // Make src half: [0..511]
    %slice0 = memref.subview %A[0] [512] [1]
      : memref<1024xf32> to memref<512xf32, strided<[1]>>

    // Make dst half: [512..1023]
    %slice1 = memref.subview %A[512] [512] [1]
      : memref<1024xf32> to memref<512xf32, strided<[1], offset: 512>>

    // Initialize src[0] so invariant load isn't undefined.
    memref.store %f0, %A[%c0] : memref<1024xf32>

    func.call @kernel(%slice0, %slice1)
      : (memref<512xf32, strided<[1]>>,
         memref<512xf32, strided<[1], offset: 512>>) -> ()

    memref.dealloc %A : memref<1024xf32>
    return
  }
}
