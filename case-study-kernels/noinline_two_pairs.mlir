module {
  // Two independent noinline callees, each receiving a different disjoint pair.
  // Tests that the pass creates two separate clones and tags correctly.
  //
  // Buffer A split into lo_A | hi_A.  Buffer B split into lo_B | hi_B.
  // Both stencils: dst[i] = src[i] + src[0], where src[0] is the invariant.
  //
  // Expected: pass creates @stencil_a.__alias_meta_0 and @stencil_b.__alias_meta_1
  // (or two clones of the respective callees), each with correctly tagged ops.

  func.func @stencil_a(%src: memref<?xf32, strided<[1], offset: ?>>,
                        %dst: memref<?xf32, strided<[1], offset: ?>>,
                        %sz: index) attributes {no_inline} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %i = %c0 to %sz step %c1 {
      %inv = memref.load %src[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %x   = memref.load %src[%i]  : memref<?xf32, strided<[1], offset: ?>>
      %y   = arith.addf %x, %inv   : f32
      memref.store %y, %dst[%i]   : memref<?xf32, strided<[1], offset: ?>>
    }
    return
  }

  func.func @stencil_b(%src: memref<?xf32, strided<[1], offset: ?>>,
                        %dst: memref<?xf32, strided<[1], offset: ?>>,
                        %sz: index) attributes {no_inline} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %i = %c0 to %sz step %c1 {
      %inv = memref.load %src[%c0] : memref<?xf32, strided<[1], offset: ?>>
      %x   = memref.load %src[%i]  : memref<?xf32, strided<[1], offset: ?>>
      %y   = arith.addf %x, %inv   : f32
      memref.store %y, %dst[%i]   : memref<?xf32, strided<[1], offset: ?>>
    }
    return
  }

  func.func @caller(%A: memref<1024xf32>, %B: memref<1024xf32>, %n: index) {
    %c0   = arith.constant 0 : index
    %c1   = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    %f1   = arith.constant 1.0 : f32
    %f2   = arith.constant 2.0 : f32

    // A split: lo_A[0..511], hi_A[512..1023]  (static, Form C)
    %lo_A = memref.subview %A[0]  [512][1]
      : memref<1024xf32> to memref<512xf32, strided<[1], offset: 0>>
    %hi_A = memref.subview %A[512][512][1]
      : memref<1024xf32> to memref<512xf32, strided<[1], offset: 512>>

    // B split: lo_B[0..n-1], hi_B[n..1023]  (dynamic, Form A)
    %hi_B_sz = arith.subi %c512, %n : index
    %lo_B = memref.subview %B[0][%n][1]
      : memref<1024xf32> to memref<?xf32, strided<[1]>>
    %hi_B = memref.subview %B[%n][%hi_B_sz][1]
      : memref<1024xf32> to memref<?xf32, strided<[1], offset: ?>>

    memref.store %f1, %lo_A[%c0] : memref<512xf32, strided<[1], offset: 0>>
    memref.store %f2, %lo_B[%c0] : memref<?xf32, strided<[1]>>

    %pa = memref.cast %lo_A : memref<512xf32, strided<[1], offset: 0>>
                           to memref<?xf32, strided<[1], offset: ?>>
    %qa = memref.cast %hi_A : memref<512xf32, strided<[1], offset: 512>>
                           to memref<?xf32, strided<[1], offset: ?>>

    func.call @stencil_a(%pa, %qa, %c512) { no_inline }
      : (memref<?xf32, strided<[1], offset: ?>>,
         memref<?xf32, strided<[1], offset: ?>>, index) -> ()

    %pb = memref.cast %lo_B : memref<?xf32, strided<[1]>>
                           to memref<?xf32, strided<[1], offset: ?>>

    func.call @stencil_b(%pb, %hi_B, %hi_B_sz) { no_inline }
      : (memref<?xf32, strided<[1], offset: ?>>,
         memref<?xf32, strided<[1], offset: ?>>, index) -> ()

    return
  }
}
