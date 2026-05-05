module {
  // Pattern: initialize A[i] to a default, load from B[i] (may alias A[i]), overwrite A[i].
  //
  // At the MLIR level: %A and %B are separate function arguments.
  // If the caller guarantees they're distinct allocations, the first store to A[i]
  // is a DEAD STORE: A[i] is unconditionally overwritten before any observable read.
  //
  // After lowering: both pointers are raw `ptr` args. LLVM must assume they may alias.
  // The first store is kept alive because the load from B[i] could be observing A[i].
  //
  // Expected: DSE misses the elimination of the "init" store to A[i].
  // Oracle:   add memref.distinct_objects (or noalias/separate_storage in LLVM IR) -> DSE fires.
  func.func @dse_blocked_alias(%A: memref<512xf32>, %B: memref<512xf32>) {
    %c0   = arith.constant 0 : index
    %c1   = arith.constant 1 : index
    %c512 = arith.constant 512 : index
    %f0   = arith.constant 0.0 : f32

    scf.for %i = %c0 to %c512 step %c1 {
      // DEAD STORE (if A and B are distinct): A[i] is always overwritten below
      // before any read of A[i] that could observe this value.
      // But LLVM must keep it because B[i] load might be a load from A[i].
      memref.store %f0, %A[%i] : memref<512xf32>

      // Load from B — if B aliases A, this reads the 0.0 just stored.
      %b = memref.load %B[%i] : memref<512xf32>

      // Overwrite A[i] unconditionally — kills the dead store above (only if A != B).
      %result = arith.mulf %b, %b : f32
      memref.store %result, %A[%i] : memref<512xf32>
    }

    return
  }
}
