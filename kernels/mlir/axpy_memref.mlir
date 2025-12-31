module {
  func.func @axpy(%A: memref<1024xf32>, %B: memref<1024xf32>) {
    %c0 = arith.constant 0 : index
    %c1024 = arith.constant 1024 : index
    %c1 = arith.constant 1 : index
    %alpha = arith.constant 2.0 : f32
    scf.for %i = %c0 to %c1024 step %c1 {
      %b = memref.load %B[%i] : memref<1024xf32>
      %mul = arith.mulf %alpha, %b : f32
      %a = memref.load %A[%i] : memref<1024xf32>
      %add = arith.addf %a, %mul : f32
      memref.store %add, %A[%i] : memref<1024xf32>
    }
    return
  }
}
