module {
  // IREE/Torch bias-add-derived candidate.
  //
  // IREE test suites include generated Torch benchmark cases such as
  //   matmul(A, B) + C
  // under torch_ops/generated/InterestingShapesBiasAdd.
  //
  // This candidate isolates the post-matmul bias-add stage:
  //   out[row, col] = input[row, col] + bias[col]
  //
  // Semantic-preserving benchmark manipulation:
  // pack the original bias vector and output matrix into one workspace:
  //   bias = work[0 .. cols)
  //   out  = work[cols .. cols + rows*cols)
  //
  // The arithmetic is unchanged. The packing exposes a subview endpoint proof.
  func.func @iree_bias_add_packed(
      %input: memref<?xf32>,
      %work: memref<?xf32>,
      %rows: index,
      %cols: index) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index

    %total = arith.muli %rows, %cols : index

    %bias = memref.subview %work[0][%cols][1]
      : memref<?xf32> to memref<?xf32, strided<[1]>>
    %out = memref.subview %work[%cols][%total][1]
      : memref<?xf32> to memref<?xf32, strided<[1], offset: ?>>

    // Loop order intentionally makes bias[col] loop-invariant in the inner
    // row loop, matching the LICM pattern this thesis studies.
    scf.for %j = %c0 to %cols step %c1 {
      scf.for %i = %c0 to %rows step %c1 {
        %row_off = arith.muli %i, %cols : index
        %idx = arith.addi %row_off, %j : index
        %b = memref.load %bias[%j] : memref<?xf32, strided<[1]>>
        %x = memref.load %input[%idx] : memref<?xf32>
        %y = arith.addf %x, %b : f32
        memref.store %y, %out[%idx]
          : memref<?xf32, strided<[1], offset: ?>>
      }
    }

    return
  }
}
