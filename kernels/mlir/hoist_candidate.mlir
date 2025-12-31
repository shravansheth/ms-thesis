module {
  func.func @hoist_candidate(%A: memref<1024xf32>, %B: memref<1024xf32>) {
    %c0 = arith.constant 0 : index
    %c1024 = arith.constant 1024 : index
    %c1 = arith.constant 1 : index

    // Loop-invariant load candidate: B[0] is the same every iteration.
    // If LLVM assumes A and B may alias, it may refuse to hoist this load.
    scf.for %i = %c0 to %c1024 step %c1 {
      %b0 = memref.load %B[%c0] : memref<1024xf32>
      %a  = memref.load %A[%i] : memref<1024xf32>
      %add = arith.addf %a, %b0 : f32
      memref.store %add, %A[%i] : memref<1024xf32>
    }
    return
  }
}
