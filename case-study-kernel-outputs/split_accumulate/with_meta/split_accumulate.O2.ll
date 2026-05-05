; ModuleID = 'microbench_outputs/split_accumulate/with_meta/split_accumulate.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @split_accumulate(ptr readnone captures(none) %0, ptr captures(none) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  %7 = getelementptr float, ptr %1, i64 %5
  store float 1.000000e+00, ptr %7, align 4, !noalias !1
  %8 = icmp sgt i64 %5, 0
  br i1 %8, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %6, %.lr.ph
  %9 = phi i64 [ %13, %.lr.ph ], [ 0, %6 ]
  %10 = getelementptr inbounds nuw float, ptr %1, i64 %9
  %11 = load float, ptr %10, align 4, !alias.scope !1
  %12 = fadd float %11, 1.000000e+00
  store float %12, ptr %10, align 4, !alias.scope !1
  %13 = add nuw nsw i64 %9, 1
  %14 = icmp slt i64 %13, %5
  br i1 %14, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %6
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
