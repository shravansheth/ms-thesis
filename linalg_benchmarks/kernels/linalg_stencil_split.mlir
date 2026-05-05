module {
  // linalg.generic-derived element-wise stencil on a split buffer.
  //
  // The flat buffer %buf (4096 floats) is partitioned at runtime point %n:
  //   lo = buf[0 .. n-1]    — input partition (read-only source)
  //   hi = buf[n .. 4095]   — output partition (write target)
  //
  // Partition-by-endpoint (Form A): hi.offset == lo.size (both are %n).
  //
  // The linalg.generic maps:
  //   ins(%lo)  with affine_map<(d0) -> (d0)>: reads lo[d0]
  //   outs(%hi) with affine_map<(d0) -> (d0)>: reads/writes hi[d0]
  //
  // After --convert-linalg-to-loops, this becomes:
  //   for d0 in [0, min(dim(lo,0), dim(hi,0))):
  //     x = memref.load  %lo[d0]        <- varies with d0, not invariant
  //     y = memref.load  %hi[d0]
  //     memref.store %hi[d0], x + y + 1.0
  //
  // The alias-based BLOCKED optimization here is VECTORIZATION, not LICM.
  //
  // LLVM's SLP/Loop vectorizer emits an UnsafeDep remark:
  //   "unsafe dependent memory operations in loop. Use #pragma loop distribute..."
  // because lo[d0] and hi[d0] share the same base pointer. The vectorizer must
  // assume they may overlap and refuses to issue SIMD loads + stores.
  //
  // With !alias.scope / !noalias metadata the vectorizer knows lo and hi are
  // disjoint -> emits SIMD vector loads/stores -> significant throughput gain
  // on Apple Silicon (NEON) and ARMv8 targets.
  //
  // Represents: element-wise kernel (copy+arithmetic) between input/output
  // partitions of a single buffer — common in in-place DSP and stencil passes.
  func.func @linalg_stencil_split(%buf: memref<4096xf32>, %n: index) {
    %c0    = arith.constant 0 : index
    %f1    = arith.constant 1.0 : f32
    %c4096 = arith.constant 4096 : index

    %hi_size = arith.subi %c4096, %n : index

    // lo = buf[0 .. n-1], hi = buf[n .. 4095].
    // Form A: hi.offset (%n) == lo.size (%n).
    %lo = memref.subview %buf[0][%n][1]
      : memref<4096xf32> to memref<?xf32, strided<[1]>>
    %hi = memref.subview %buf[%n][%hi_size][1]
      : memref<4096xf32> to memref<?xf32, strided<[1], offset: ?>>

    // Initialize hi to known values before the stencil pass.
    // (Logically: hi is the previous-timestep output buffer.)
    linalg.generic {
      indexing_maps = [affine_map<(d0) -> (d0)>],
      iterator_types = ["parallel"]
    } outs(%hi : memref<?xf32, strided<[1], offset: ?>>) {
    ^bb0(%val: f32):
      linalg.yield %f1 : f32
    }

    // Stencil pass: hi[d0] = lo[d0] + hi[d0] + 1.0
    // lo and hi are disjoint partitions; LLVM must assume they may alias.
    // Vectorization is blocked: UnsafeDep remark fired for this loop.
    linalg.generic {
      indexing_maps = [
        affine_map<(d0) -> (d0)>,    // lo: element d0 (input)
        affine_map<(d0) -> (d0)>     // hi: element d0 (output)
      ],
      iterator_types = ["parallel"]
    } ins(%lo : memref<?xf32, strided<[1]>>)
      outs(%hi : memref<?xf32, strided<[1], offset: ?>>) {
    ^bb0(%src: f32, %dst: f32):
      %sum = arith.addf %dst, %src : f32
      %result = arith.addf %sum, %f1 : f32
      linalg.yield %result : f32
    }

    return
  }
}
