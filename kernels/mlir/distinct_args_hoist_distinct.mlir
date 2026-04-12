module {
  func.func @distinct_args_hoist_distinct(
      %A : memref<512xf32>,
      %B : memref<512xf32>) {
    %c0   = arith.constant 0 : index
    %c1   = arith.constant 1 : index
    %c512 = arith.constant 512 : index

    // CONTRACT: A and B do not alias. If they do, behavior is undefined.
    %A2, %B2 = memref.distinct_objects %A, %B
      : memref<512xf32>, memref<512xf32>

    scf.for %i = %c0 to %c512 step %c1 {
      %inv = memref.load %B2[%c0] : memref<512xf32>
      %x   = memref.load %A2[%i]  : memref<512xf32>
      %y   = arith.addf %x, %inv : f32
      memref.store %y, %A2[%i] : memref<512xf32>
    }
    return
  }
}
