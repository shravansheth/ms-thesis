; ModuleID = 'outputs/hoist/hoist.noalias.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @hoist_candidate(ptr noalias nocapture readnone %0, ptr noalias nocapture %1, i64 %2, i64 %3, i64 %4, ptr noalias nocapture readnone %5, ptr noalias nocapture readonly %6, i64 %7, i64 %8, i64 %9) local_unnamed_addr #0 {
  %11 = load float, ptr %6, align 4
  br label %12

12:                                               ; preds = %10, %12
  %13 = phi i64 [ 0, %10 ], [ %17, %12 ]
  %14 = getelementptr float, ptr %1, i64 %13
  %15 = load float, ptr %14, align 4
  %16 = fadd float %11, %15
  store float %16, ptr %14, align 4
  %17 = add nuw nsw i64 %13, 1
  %18 = icmp samesign ult i64 %13, 1023
  br i1 %18, label %12, label %19

19:                                               ; preds = %12
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
