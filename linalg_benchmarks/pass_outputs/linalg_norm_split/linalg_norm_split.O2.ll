; ModuleID = 'linalg_benchmarks/pass_outputs/linalg_norm_split/linalg_norm_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @linalg_norm_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 8)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  %7 = sub i64 2048, %5
  store float 1.000000e+00, ptr %1, align 4, !alias.scope !1
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 4
  store float 2.000000e+00, ptr %8, align 4, !alias.scope !1
  %9 = icmp sgt i64 %7, 0
  br i1 %9, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %6
  %10 = getelementptr float, ptr %1, i64 %5
  br label %12

.lr.ph2:                                          ; preds = %12
  %11 = getelementptr float, ptr %1, i64 %5
  br label %19

12:                                               ; preds = %.lr.ph, %12
  %13 = phi i64 [ 0, %.lr.ph ], [ %17, %12 ]
  %14 = getelementptr inbounds nuw float, ptr %10, i64 %13
  %15 = load float, ptr %14, align 4, !noalias !1
  %16 = fadd float %15, 1.000000e+00
  store float %16, ptr %14, align 4, !noalias !1
  %17 = add nuw nsw i64 %13, 1
  %18 = icmp slt i64 %17, %7
  br i1 %18, label %12, label %.lr.ph2

19:                                               ; preds = %.lr.ph2, %19
  %20 = phi i64 [ 0, %.lr.ph2 ], [ %24, %19 ]
  %21 = getelementptr inbounds nuw float, ptr %11, i64 %20
  %22 = load float, ptr %21, align 4, !noalias !1
  %23 = fmul float %22, 2.000000e+00
  store float %23, ptr %21, align 4, !noalias !1
  %24 = add nuw nsw i64 %20, 1
  %25 = icmp slt i64 %24, %7
  br i1 %25, label %19, label %._crit_edge

._crit_edge:                                      ; preds = %19, %6
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
