; ModuleID = 'microbench_outputs/double_invariant/baseline/double_invariant.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @double_invariant(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 8)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  %7 = sub i64 2048, %5
  store float 1.000000e+00, ptr %1, align 4
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 4
  store float 2.000000e+00, ptr %8, align 4
  %9 = icmp sgt i64 %7, 0
  br i1 %9, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %6
  %10 = getelementptr float, ptr %1, i64 %5
  br label %11

11:                                               ; preds = %.lr.ph, %11
  %12 = phi i64 [ 0, %.lr.ph ], [ %19, %11 ]
  %13 = load float, ptr %1, align 4
  %14 = load float, ptr %8, align 4
  %15 = getelementptr float, ptr %10, i64 %12
  %16 = load float, ptr %15, align 4
  %17 = fadd float %13, %16
  %18 = fadd float %14, %17
  store float %18, ptr %15, align 4
  %19 = add nuw nsw i64 %12, 1
  %20 = icmp slt i64 %19, %7
  br i1 %20, label %11, label %._crit_edge

._crit_edge:                                      ; preds = %11, %6
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
