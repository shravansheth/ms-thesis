; ModuleID = 'bench_outputs/vectorize_split/with_meta/vectorize_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @vectorize_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  store float 1.000000e+00, ptr %1, align 4, !alias.scope !1
  %7 = getelementptr float, ptr %1, i64 %5
  br label %8

8:                                                ; preds = %6, %8
  %9 = phi i64 [ 0, %6 ], [ %13, %8 ]
  %10 = getelementptr inbounds nuw float, ptr %7, i64 %9
  %11 = load float, ptr %10, align 4, !noalias !1
  %12 = fadd float %11, 1.000000e+00
  store float %12, ptr %10, align 4, !noalias !1
  %13 = add nuw nsw i64 %9, 1
  %14 = icmp samesign ult i64 %9, 1048575
  br i1 %14, label %8, label %15

15:                                               ; preds = %8
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
