# Thesis Argument and Framing Reference

## Thesis Statement (from thesis_stmt.txt)

> This thesis focuses on preserving provably disjoint memref subview semantics during MLIR-to-LLVM lowering for CPU targets. For a restricted subset of subviews (rank-1 (potentially rank-2), unit stride, same base allocation, non-overlapping intervals), we detect disjointness at the MLIR level before view canonicalization/expansion, and materialize it as LLVM instruction-level scoped alias metadata (`!alias.scope`/`!noalias`) on the lowered `llvm.load`/`llvm.store` operations in llvm-dialect MLIR. We evaluate the approach on a micro-suite of kernels where LLVM's middle-end optimizations are blocked by alias conservatism in the baseline, and show that the emitted metadata unlocks optimizations without introducing a new general alias analysis.

## Core Problem

MLIR is an intermediate representation used by compilers like IREE, Triton, and MLIR-based ML compilers. It operates at a higher level of abstraction than LLVM IR, encoding structural information about memory regions via typed `memref` operations. A key operation is `memref.subview`, which creates a typed view into a sub-region of an existing memref, making the partition structure explicit: the type carries offset, size, and stride information.

When MLIR is lowered to LLVM IR for CPU execution, this structure is decomposed into scalar GEP arithmetic. Two subviews of the same base memref — even if provably disjoint at the MLIR level — become two GEP computations from the same `ptr`. LLVM's alias analysis then conservatively assumes they may overlap, blocking loop-invariant code motion (LICM), GVN, and vectorization.

This is not a bug in LLVM's analysis. LLVM is correct to be conservative: without additional information, two GEPs from the same pointer may indeed alias. The problem is an information loss at the MLIR-to-LLVM boundary.

## The Approach

Rather than improving LLVM's alias analysis (which would require solving harder problems), the approach is to carry the MLIR-level proof across the boundary in a form LLVM already understands: `!alias.scope`/`!noalias` metadata. This metadata is LLVM's standard mechanism for programmer/compiler-annotated alias disambiguation. It is recognized by LICM, GVN, DSE, the vectorizer, and other LLVM passes.

The pass detects the partition-by-endpoint structural invariant (`hi.offset == lo.offset + lo.size`) in MLIR before lowering, and emits the corresponding metadata on the `llvm.load`/`llvm.store` ops it produces. The rest of the lowering pipeline proceeds unchanged.

## What Makes This Non-Trivial

1. **Dynamic offsets.** The interesting cases involve runtime-computed partition points (`%n`, `tile*N`, etc.). LLVM cannot prove non-overlapping ranges for these without explicit metadata.

2. **Intra-allocation disjointness.** Standard LLVM mechanisms for alias disambiguation (`noalias` on function params, `separate_storage` intrinsic) apply to *separate allocations*. For two subviews of the same allocation, those mechanisms are undefined behaviour (the aligned pointers are equal). Scoped alias metadata on individual load/store instructions is the only correct mechanism.

3. **Noinline call boundaries.** When the disjointness proof exists in the caller but the computation happens in a noinline callee, the proof is lost at the function boundary. The callee's LLVM IR has no knowledge of how its arguments were derived. Function specialization (cloning the callee for the proven-disjoint call site) propagates the proof without unsound use of pointer-level annotations.

4. **Pass ordering.** The detection must happen before the structural information is discarded (before `finalize-memref-to-llvm`), but the metadata must be attached to LLVM-level ops (which don't exist yet during detection). The two-pass solution with discardable attribute bridging is the minimal correct solution.

## Scope and Limitations

**In scope:**
- 1D and 2D memrefs (the 2D case with static column count is handled)
- Unit-stride subviews
- Same-base-allocation partitions
- Three forms of partition-by-endpoint: SSA identity (Form A), arith.addi chain (Form B), all-constant (Form C)
- Noinline callee case with single-level propagation

**Out of scope (for this thesis):**
- Multi-dimensional splits on non-zero dimensions
- Non-unit-stride subviews
- Recursive noinline call chains
- Linalg-generated tiling (deferred — would be a good extension)
- General alias analysis (the thesis explicitly avoids this)

**Known incompleteness (not miscompilation):**
- Form B detection requires both `lo.offset` and `lo.size` to be live SSA `Value`s. If either is a folded compile-time constant in an `OpFoldResult`, the cast to `Value` fails and the pair goes undetected. Form C does not rescue the mixed case.
- The dimension-0-only check is conservative: all 5 kernels split on dimension 0, but a full implementation would check all dimensions.

## Positioning Relative to Prior Work

- **TBAA (Type-Based Alias Analysis):** MLIR's memref type hierarchy could potentially be used for TBAA, but TBAA applies when accesses have different element types. All our cases use `f32` throughout.
- **`memref.distinct_objects`:** MLIR already has a mechanism for marking two memrefs as coming from distinct allocations, which lowers to `separate_storage`. This covers separate-buffer cases (like two distinct function arguments) but not same-buffer subview cases (the thesis target).
- **Polyhedral analysis:** Polyhedral compilers (Pluto, PPCG) perform dependence analysis on affine loop nests. MLIR's Affine dialect has polyhedral support, but by the time we are at the `memref.subview` + lowering stage, we are beyond the affine dialect. Our approach is more general: it works on non-affine, dynamically-sized partitions.
- **Restrict pointers (C):** C99 `restrict` is the C-level mechanism for asserting pointer non-aliasing. It produces `noalias` in LLVM IR. Not applicable for subviews of the same allocation.

## Evaluation Strategy

Six hand-written kernels, each exercising one structural pattern. For each:
1. Validate that the baseline LLVM IR misses the optimization (confirmed via O2 remarks)
2. Write a hand-annotated oracle LLVM IR file showing the desired metadata structure
3. Validate that the oracle enables the optimization (confirmed via O2 remarks on oracle)
4. Run the full pass pipeline and confirm the generated metadata matches the oracle structure
5. Confirm the pass output remarks match the oracle remarks (misses drop to 0)

The oracle step (step 2–3) is critical: it proves the thesis hypothesis independently of the pass implementation. Even if the pass had bugs, the oracle shows that the metadata approach is sound.

## Key Claims

1. MLIR's `memref.subview` encodes structural disjointness that is discarded during lowering to LLVM IR. *(Demonstrated by: all 6 kernels showing misses in baseline)*

2. This information loss blocks optimization passes that LLVM would otherwise apply. *(Demonstrated by: 32 miss remarks across 6 kernels in baseline)*

3. The information can be re-introduced as `!alias.scope`/`!noalias` metadata without introducing a new general alias analysis. *(The two-pass implementation is ~600 lines of C++ across two source files, with no new analysis infrastructure)*

4. The re-introduced metadata enables the missed optimizations. *(Demonstrated by: 32 → 0 miss remarks, 13 → 16 hoisted, 2 → 1 loads/iter across the case-study kernels)*
