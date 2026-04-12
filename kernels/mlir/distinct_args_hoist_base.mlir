module {
  func.func @distinct_args_hoist_base(
      %A : memref<512xf32>,
      %B : memref<512xf32>) {
    %c0   = arith.constant 0 : index
    %c1   = arith.constant 1 : index
    %c512 = arith.constant 512 : index

    scf.for %i = %c0 to %c512 step %c1 {
      // Loop-invariant address: B[0]
      %inv = memref.load %B[%c0] : memref<512xf32>

      // Loop-variant
      %x = memref.load %A[%i] : memref<512xf32>
      %y = arith.addf %x, %inv : f32
      memref.store %y, %A[%i] : memref<512xf32>
    }
    return
  }
}
