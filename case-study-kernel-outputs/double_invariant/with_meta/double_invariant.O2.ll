; ModuleID = 'microbench_outputs/double_invariant/with_meta/double_invariant.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @double_invariant(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 8)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  %7 = sub i64 2048, %5
  store float 1.000000e+00, ptr %1, align 4, !alias.scope !1
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 4
  store float 2.000000e+00, ptr %8, align 4, !alias.scope !1
  %9 = icmp sgt i64 %7, 0
  br i1 %9, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %6
  %10 = getelementptr float, ptr %1, i64 %5
  br label %11

11:                                               ; preds = %.lr.ph, %11
  %12 = phi i64 [ 0, %.lr.ph ], [ %17, %11 ]
  %13 = getelementptr inbounds nuw float, ptr %10, i64 %12
  %14 = load float, ptr %13, align 4, !noalias !1
  %15 = fadd float %14, 1.000000e+00
  %16 = fadd float %15, 2.000000e+00
  store float %16, ptr %13, align 4, !noalias !1
  %17 = add nuw nsw i64 %12, 1
  %18 = icmp slt i64 %17, %7
  br i1 %18, label %11, label %._crit_edge

._crit_edge:                                      ; preds = %11, %6
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
