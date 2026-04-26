# Invalidated Cases Reference

These cases were explored and invalidated — either because LLVM 22 already handles them without metadata, or because the structural basis for a fix is absent.

## What "Invalidated" Means

An invalidated case is one where either:
- LLVM 22 can already prove disjointness by itself (no missed optimization exists in the baseline, or it exists in older LLVM but not in LLVM 22), or
- The proposed fix is structurally unsound (e.g., using `noalias` on params when there is no proof the pointers are from distinct allocations)

Invalidated cases still have pedagogical value: they clarify the boundary of what LLVM can and cannot prove, and they explain why certain approaches that seem obvious are actually wrong.

---

## case_memref_subview_static — INVALIDATED

**Files:** `invalid_cases/case_memref_subview_static.md`, `kernels/mlir/subview_hoist_static.mlir`

**Original claim:** Two static-offset subviews (`A[0..511]` and `A[512..1023]`) produce alias uncertainty in LLVM, blocking LICM.

**Why invalidated:** In LLVM 22, static GEP offsets (512 and 0) are known constants. LLVM's BasicAA can prove that an access at `base + 0` (with element count 512) and an access at `base + 512` are non-overlapping via constant arithmetic. SCEV can also prove this using scalar evolution on the ranges. LICM successfully hoists invariant loads without any metadata in LLVM 22.

**Lesson:** The interesting cases are the *dynamic-offset* ones. When offset values are runtime-determined, LLVM's constant arithmetic does not apply, and alias uncertainty remains.

**Note:** This case worked (LLVM missed the optimization) in older LLVM versions (pre-22). The thesis is LLVM-22-specific.

---

## case_hoist_candidate — INVALIDATED

**Files:** `invalid_cases/case_hoist_candidate.md`, `kernels/mlir/hoist_candidate.mlir`

**Original claim:** A simple function with two ptr args (`A` and `B`, distinct allocations by convention) blocks LICM of a load from `B[0]`.

**Why invalidated:** In LLVM 22, even without `noalias` on the parameters, LLVM's interprocedural analysis can sometimes prove that two function arguments (passed as separate pointers) are unlikely to alias, or the hoist still succeeds via other means. The case did not reproduce a miss in LLVM 22.

**Lesson:** Simple same-function-arg cases may be handled by LLVM 22's improved analysis. The interesting cases involve subviews of the *same* allocation (not separate allocations), where the aliasing ambiguity comes from the shared base pointer.

---

## case_distinct_args — INVALIDATED

**Files:** `invalid_cases/case_distinct_args.md`, `kernels/mlir/distinct_args_hoist_base.mlir`, `kernels/mlir/distinct_args_hoist_distinct.mlir`

**Original claim:** A function with two memref args `%A` and `%B` (from distinct allocations) blocks LICM of `B[0]`. Adding `memref.distinct_objects` fixes it.

**Why invalidated:** This is correct as a finding — `memref.distinct_objects` does help, and the lowering already emits `@llvm.assume ["separate_storage"(...)]`. However, the structural basis for our pass to prove distinctness is absent. Our pass detects disjointness from `memref.subview` structural relationships (partition-by-endpoint). Two function-argument memrefs have no such structural relationship; they could legitimately alias (same buffer passed twice). The pass cannot safely assume function-argument memrefs are distinct without explicit annotation.

**What it shows:** The mechanism that works here (`separate_storage`) is not applicable to subviews of the same allocation. The thesis correctly distinguishes two types of aliasing gaps:
- Separate-allocation gaps (covered by `memref.distinct_objects` / `separate_storage`) — not the thesis focus
- Same-allocation disjoint-region gaps (covered by `!alias.scope`/`!noalias`) — the thesis focus

**Related:** The `memref.distinct_objects` mechanism and `separate_storage` are interesting related work. The thesis should mention them as prior art in the MLIR ecosystem.

---

## case_subview_call_boundary — INVALIDATED

**Files:** `invalid_cases/case_subview_call_boundary.md`, `kernels/mlir/subview_call_boundary.mlir`

**Why invalidated:** Subsumed by `subview_noalias`. The structural scenario is the same: caller creates disjoint subviews, noinline callee sees opaque pointers. `subview_noalias` covers this more cleanly. Having both would be redundant in the thesis.

---

## case_dse_blocked_alias — INVALIDATED

**Files:** `invalid_cases/case_dse_blocked_alias.md`, `kernels/mlir/dse_blocked_alias.mlir`

**Original claim:** DSE (dead store elimination) is blocked by alias uncertainty on two function-argument memrefs.

**Why invalidated:** Same root cause as `case_distinct_args` — the aliasing uncertainty comes from the function argument relationship, not from a subview structural relationship. The pass cannot provide a structural proof for arbitrary function arguments. Additionally, DSE misses are less compelling as evidence than LICM misses, since DSE often has other costs (keeping a dead store has little runtime cost; a missed LICM keeps an extra load every iteration).

---

## Summary: What LLVM 22 Can vs Cannot Prove

| Scenario | LLVM 22 behavior | Thesis opportunity? |
|---|---|---|
| Two GEPs with constant, non-overlapping offsets | Proves disjoint via BasicAA/SCEV | No — LLVM handles it |
| Stride-2 even/odd elements, constant offsets | Proves disjoint via SCEV modular arithmetic | No |
| Runtime split point `n`: `gep base, 0` vs `gep base, n+i` | Cannot prove disjoint without `n >= 1` | Yes — Form A |
| Adjacent tiles: `gep base, tile*N` vs `gep base, tile*N+N+j` | Cannot prove disjoint without `N > 0` | Yes — Form B |
| Noinline callee: two ptr params with same aligned_ptr value | Cannot prove disjoint (conservative for all callers) | Yes — cloning |
| Two separate function args (distinct allocations) | Cannot prove distinct (could be same buffer passed twice) | No — different problem |
| `memref.distinct_objects` lowered | Correctly emits `separate_storage` | Already handled by MLIR |
