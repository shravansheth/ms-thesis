module {
  func.func @subview_hoist_derived() {
    %c0   = arith.constant 0 : index
    %c1   = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c512 = arith.constant 512 : index

    %f0 = arith.constant 0.0 : f32
    %f2 = arith.constant 2.0 : f32

    %A = memref.alloc() : memref<2048xf32>

    // Derived constant: split = 128 + 128 = 256
    %split = arith.addi %c128, %c128 : index

    // Derived constant: midOff = 512 + 0 (still SSA-derived)
    %midOff = arith.addi %c512, %c0 : index

    // sizes are static literals => result types can be static
    %mid = memref.subview %A[%midOff] [1024] [1]
      : memref<2048xf32> to memref<1024xf32, strided<[1], offset: ?>>

    // Subview-of-subview, with derived offset for the second slice
    %slice0 = memref.subview %mid[0] [256] [1]
      : memref<1024xf32, strided<[1], offset: ?>> to memref<256xf32, strided<[1], offset: ?>>

    %slice1 = memref.subview %mid[%split] [256] [1]
      : memref<1024xf32, strided<[1], offset: ?>> to memref<256xf32, strided<[1], offset: ?>>

    // Init slices
    scf.for %j = %c0 to %split step %c1 {
      memref.store %f2, %slice0[%j] : memref<256xf32, strided<[1], offset: ?>>
      memref.store %f0, %slice1[%j] : memref<256xf32, strided<[1], offset: ?>>
    }

    // Main loop: invariant load from slice0[0], stores into slice1[i]
    scf.for %i = %c0 to %split step %c1 {
      %inv = memref.load %slice0[%c0] : memref<256xf32, strided<[1], offset: ?>>
      %x   = memref.load %slice0[%i]  : memref<256xf32, strided<[1], offset: ?>>
      %y   = arith.addf %x, %inv : f32
      memref.store %y, %slice1[%i] : memref<256xf32, strided<[1], offset: ?>>
    }

    memref.dealloc %A : memref<2048xf32>
    return
  }
}
