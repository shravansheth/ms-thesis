; ModuleID = 'outputs/matrix_row_split/matrix_row_split.oracle.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @matrix_row_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7) local_unnamed_addr #0 {
  store float 1.000000e+00, ptr %1, align 4
  %9 = icmp sgt i64 %7, 0
  br i1 %9, label %.preheader, label %._crit_edge

.preheader:                                       ; preds = %8, %22
  %10 = phi i64 [ %23, %22 ], [ 0, %8 ]
  %.idx = shl nuw nsw i64 %10, 11
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 %.idx
  %12 = add nuw i64 %10, %7
  %.idx1 = shl nuw nsw i64 %12, 11
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 %.idx1
  br label %14

14:                                               ; preds = %.preheader, %14
  %15 = phi i64 [ 0, %.preheader ], [ %20, %14 ]
  %16 = getelementptr inbounds nuw float, ptr %11, i64 %15
  %17 = load float, ptr %16, align 4, !alias.scope !1
  %18 = fadd float %17, 1.000000e+00
  %19 = getelementptr inbounds nuw float, ptr %13, i64 %15
  store float %18, ptr %19, align 4, !noalias !1
  %20 = add nuw nsw i64 %15, 1
  %21 = icmp samesign ult i64 %15, 511
  br i1 %21, label %14, label %22

22:                                               ; preds = %14
  %23 = add nuw nsw i64 %10, 1
  %24 = icmp slt i64 %23, %7
  br i1 %24, label %.preheader, label %._crit_edge

._crit_edge:                                      ; preds = %22, %8
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"matrix_row_split:top_scope"}
!3 = distinct !{!3, !"matrix_row_split:top_domain"}
