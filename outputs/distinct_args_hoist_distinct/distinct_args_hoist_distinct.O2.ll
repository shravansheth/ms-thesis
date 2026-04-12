; ModuleID = 'outputs/distinct_args_hoist_distinct/distinct_args_hoist_distinct.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite, inaccessiblemem: write)
define void @distinct_args_hoist_distinct(ptr readnone captures(none) %0, ptr captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr readonly captures(none) %6, i64 %7, i64 %8, i64 %9) local_unnamed_addr #0 {
  call void @llvm.assume(i1 true) [ "separate_storage"(ptr %1, ptr %6) ]
  %11 = load float, ptr %6, align 4
  br label %12

12:                                               ; preds = %10, %12
  %13 = phi i64 [ 0, %10 ], [ %17, %12 ]
  %14 = getelementptr inbounds nuw float, ptr %1, i64 %13
  %15 = load float, ptr %14, align 4
  %16 = fadd float %11, %15
  store float %16, ptr %14, align 4
  %17 = add nuw nsw i64 %13, 1
  %18 = icmp samesign ult i64 %13, 511
  br i1 %18, label %12, label %19

19:                                               ; preds = %12
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite, inaccessiblemem: write) }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
