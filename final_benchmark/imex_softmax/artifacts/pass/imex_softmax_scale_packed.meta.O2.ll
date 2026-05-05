; ModuleID = 'benchmark_exploration/imex_softmax_scale_packed/pass/imex_softmax_scale_packed.meta.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @imex_softmax_scale_packed(ptr readnone captures(none) %0, ptr captures(none) %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7, i64 %8) local_unnamed_addr #0 {
  %10 = icmp sgt i64 %7, 0
  br i1 %10, label %.preheader.lr.ph, label %._crit_edge

.preheader.lr.ph:                                 ; preds = %9
  %11 = getelementptr float, ptr %1, i64 %8
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %24
  %12 = phi i64 [ 0, %.preheader.lr.ph ], [ %25, %24 ]
  %13 = shl nuw nsw i64 %12, 11
  %14 = getelementptr inbounds nuw float, ptr %1, i64 %13
  %15 = load float, ptr %14, align 4, !alias.scope !1
  %16 = getelementptr inbounds nuw float, ptr %11, i64 %13
  br label %17

17:                                               ; preds = %.preheader, %17
  %18 = phi i64 [ 0, %.preheader ], [ %22, %17 ]
  %19 = getelementptr inbounds nuw float, ptr %16, i64 %18
  %20 = load float, ptr %19, align 4, !noalias !1
  %21 = fdiv float %20, %15
  store float %21, ptr %19, align 4, !noalias !1
  %22 = add nuw nsw i64 %18, 1
  %23 = icmp samesign ult i64 %18, 1023
  br i1 %23, label %17, label %24

24:                                               ; preds = %17
  %25 = add nuw nsw i64 %12, 1
  %26 = icmp slt i64 %25, %7
  br i1 %26, label %.preheader, label %._crit_edge

._crit_edge:                                      ; preds = %24, %9
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
