; ModuleID = 'outputs/dse_blocked_alias/dse_blocked_alias.noalias.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @dse_blocked_alias(ptr noalias readnone captures(none) %0, ptr noalias writeonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr noalias readnone captures(none) %5, ptr noalias readonly captures(none) %6, i64 %7, i64 %8, i64 %9) local_unnamed_addr #0 {
  br label %11

11:                                               ; preds = %10, %11
  %12 = phi i64 [ 0, %10 ], [ %17, %11 ]
  %13 = getelementptr inbounds nuw float, ptr %1, i64 %12
  %14 = getelementptr inbounds nuw float, ptr %6, i64 %12
  %15 = load float, ptr %14, align 4
  %16 = fmul float %15, %15
  store float %16, ptr %13, align 4
  %17 = add nuw nsw i64 %12, 1
  %18 = icmp samesign ult i64 %12, 511
  br i1 %18, label %11, label %19

19:                                               ; preds = %11
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
