; ModuleID = 'benchmark_exploration/iree_bias_add_packed/pass/iree_bias_add_packed.meta.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @iree_bias_add_packed(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr captures(none) %6, i64 %7, i64 %8, i64 %9, i64 %10, i64 %11) local_unnamed_addr #0 {
  %13 = icmp sgt i64 %11, 0
  br i1 %13, label %.preheader.lr.ph, label %._crit_edge1

.preheader.lr.ph:                                 ; preds = %12
  %14 = icmp sgt i64 %10, 0
  %15 = getelementptr float, ptr %6, i64 %11
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %16 = phi i64 [ 0, %.preheader.lr.ph ], [ %29, %._crit_edge ]
  br i1 %14, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader
  %17 = getelementptr inbounds nuw float, ptr %6, i64 %16
  %18 = load float, ptr %17, align 4, !alias.scope !1
  br label %19

19:                                               ; preds = %.lr.ph, %19
  %20 = phi i64 [ 0, %.lr.ph ], [ %27, %19 ]
  %21 = mul i64 %20, %11
  %22 = add i64 %21, %16
  %23 = getelementptr inbounds nuw float, ptr %1, i64 %22
  %24 = load float, ptr %23, align 4
  %25 = fadd float %18, %24
  %26 = getelementptr inbounds nuw float, ptr %15, i64 %22
  store float %25, ptr %26, align 4, !noalias !1
  %27 = add nuw nsw i64 %20, 1
  %28 = icmp slt i64 %27, %10
  br i1 %28, label %19, label %._crit_edge

._crit_edge:                                      ; preds = %19, %.preheader
  %29 = add nuw nsw i64 %16, 1
  %30 = icmp slt i64 %29, %11
  br i1 %30, label %.preheader, label %._crit_edge1

._crit_edge1:                                     ; preds = %._crit_edge, %12
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
