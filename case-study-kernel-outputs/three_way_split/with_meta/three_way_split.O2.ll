; ModuleID = 'microbench_outputs/three_way_split/with_meta/three_way_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @three_way_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  store float 1.000000e+00, ptr %1, align 4, !alias.scope !1
  %7 = getelementptr float, ptr %1, i64 %5
  store float 2.000000e+00, ptr %7, align 4, !alias.scope !4
  %8 = icmp sgt i64 %5, 0
  br i1 %8, label %.lr.ph, label %._crit_edge

.lr.ph2:                                          ; preds = %.lr.ph
  %9 = load float, ptr %7, align 4, !alias.scope !4
  %.idx = shl i64 %5, 3
  %10 = getelementptr i8, ptr %1, i64 %.idx
  br label %18

.lr.ph:                                           ; preds = %6, %.lr.ph
  %11 = phi i64 [ %16, %.lr.ph ], [ 0, %6 ]
  %12 = load float, ptr %1, align 4, !alias.scope !1
  %13 = getelementptr inbounds nuw float, ptr %7, i64 %11
  %14 = load float, ptr %13, align 4, !alias.scope !4
  %15 = fadd float %12, %14
  store float %15, ptr %13, align 4, !alias.scope !4
  %16 = add nuw nsw i64 %11, 1
  %17 = icmp slt i64 %16, %5
  br i1 %17, label %.lr.ph, label %.lr.ph2

18:                                               ; preds = %.lr.ph2, %18
  %19 = phi i64 [ 0, %.lr.ph2 ], [ %23, %18 ]
  %20 = getelementptr inbounds nuw float, ptr %10, i64 %19
  %21 = load float, ptr %20, align 4, !noalias !4
  %22 = fadd float %9, %21
  store float %22, ptr %20, align 4, !noalias !4
  %23 = add nuw nsw i64 %19, 1
  %24 = icmp slt i64 %23, %5
  br i1 %24, label %18, label %._crit_edge

._crit_edge:                                      ; preds = %18, %6
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
!4 = !{!5}
!5 = distinct !{!5, !6, !"pair_1_lo"}
!6 = distinct !{!6, !"pair_1_domain"}
