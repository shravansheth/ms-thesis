# Case — `memref.distinct_objects` alias information lost during lowering; LICM blocked on function arguments

## Kernels
- Baseline: `kernels/mlir/distinct_args_hoist_base.mlir`
- With distinct annotation: `kernels/mlir/distinct_args_hoist_distinct.mlir`

Intent: A function receives two separate memref arguments `%A` and `%B` (512 floats each).
Inside the loop, read the loop-invariant `B[0]` and store to `A[i]`.

The pattern appears in virtually every ML kernel: buffers passed as separate function arguments are
conceptually distinct (different allocations), but LLVM has no way to prove this without metadata.

## Baseline: no alias annotation (`distinct_args_hoist_base`)
Artifacts:
- `outputs/distinct_args_hoist_base/distinct_args_hoist_base.ll`
- `outputs/distinct_args_hoist_base/distinct_args_hoist_base.O2.ll`
- `outputs/distinct_args_hoist_base/remarks.O2.yml`

LLVM IR structure:
- `%A` and `%B` are passed as two separate pointer groups in the memref descriptor ABI
  (two sets of `ptr alloc, ptr aligned, i64 offset, i64 size, i64 stride`).
- `B[0]` load  = `gep ptr %B_aligned, 0`
- `A[i]` store = `gep ptr %A_aligned, i`
- `%A_aligned` and `%B_aligned` are separate function parameters — LLVM must conservatively
  assume they could point to overlapping memory (e.g., a caller passes the same buffer twice).

Observed behavior:
- In `distinct_args_hoist_base.O2.ll`, the load from `B[0]` **remains inside the loop**.
- Remarks: `licm: LoadWithLoopInvariantAddressInvalidated` (×3).
- Remarks: `gvn: LoadClobbered` (×1) — GVN also blocked.

## With `memref.distinct_objects` annotation (`distinct_args_hoist_distinct`)
Artifacts:
- `outputs/distinct_args_hoist_distinct/distinct_args_hoist_distinct.ll`
- `outputs/distinct_args_hoist_distinct/distinct_args_hoist_distinct.O2.ll`
- `outputs/distinct_args_hoist_distinct/remarks.O2.yml`

MLIR-level change:
```mlir
%A2, %B2 = memref.distinct_objects %A, %B : memref<512xf32>, memref<512xf32>
```
`memref.distinct_objects` asserts that the two memrefs refer to distinct allocations.

LLVM IR that the MLIR lowering produces for this annotation:
```llvm
%A_ptr = extractvalue ... %A2, 1
%B_ptr = extractvalue ... %B2, 1
call void @llvm.assume(i1 true) [ "separate_storage"(ptr %A_ptr, ptr %B_ptr) ]
```
The MLIR lowering correctly emits `@llvm.assume` with the `"separate_storage"` operand bundle,
which LLVM's alias analysis understands as "the two pointer arguments come from distinct allocations."

Observed behavior:
- Remarks: `licm: Hoisted` — **LICM successfully hoists** `B[0]` to the loop preheader.
- The loop body no longer contains the redundant load.

## Root cause of the gap
MLIR's function-argument memrefs carry a structural assumption: in the absence of explicit aliasing
(e.g., the caller passes the same buffer for both `%A` and `%B`), the buffers are treated as distinct
by the compiler pipeline. However, LLVM's ABI for memref descriptors passes each buffer as two raw
`ptr` arguments, with no alias annotation. LLVM conservatively assumes these pointers might alias.

`memref.distinct_objects` is a MLIR mechanism to make the distinctness assumption explicit.
Its lowering already emits `"separate_storage"` via `@llvm.assume`. This case shows:
1. **The metadata exists in MLIR** (via `memref.distinct_objects`).
2. **The lowering CAN emit the right LLVM metadata** (it already does for `distinct_objects`).
3. **The gap is for the common implicit case**: when two memref function arguments are assumed
   distinct (the norm in ML workloads), but `memref.distinct_objects` is not explicitly written,
   the metadata is lost and LICM is blocked.

## Conclusion
This case demonstrates an **implicit-distinctness gap** in the MLIR-to-LLVM lowering:
- Separate memref function arguments are typically (but not always) from distinct allocations.
- When the programmer (or a tiling/splitting pass) knows this is the case, MLIR can express it
  via `memref.distinct_objects`, which lowers to `llvm.assume("separate_storage", ...)`.
- Without the annotation, LLVM stays conservative and misses LICM/GVN on invariant loads.
- This pattern appears in virtually all ML framework kernels: `matmul(A, B, C)` passes three
  distinct buffers, but none carry `noalias` by default after MLIR lowering.

The fix direction: either (a) always emit `separate_storage` for function-argument memrefs in the
absence of aliasing evidence, or (b) insert `memref.distinct_objects` automatically for known-
distinct arguments before lowering.
