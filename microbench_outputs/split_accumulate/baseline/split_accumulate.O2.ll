; ModuleID = 'microbench_outputs/split_accumulate/baseline/split_accumulate.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @split_accumulate(ptr readnone captures(none) %0, ptr captures(none) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  %7 = getelementptr inbounds nuw float, ptr %1, i64 %5
  store float 1.000000e+00, ptr %7, align 4
  %8 = icmp sgt i64 %5, 0
  br i1 %8, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %6, %.lr.ph
  %9 = phi i64 [ %14, %.lr.ph ], [ 0, %6 ]
  %10 = load float, ptr %7, align 4
  %11 = getelementptr inbounds nuw float, ptr %1, i64 %9
  %12 = load float, ptr %11, align 4
  %13 = fadd float %10, %12
  store float %13, ptr %11, align 4
  %14 = add nuw nsw i64 %9, 1
  %15 = icmp slt i64 %14, %5
  br i1 %15, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %6
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
