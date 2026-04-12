; ModuleID = 'outputs/subview_noalias/subview_noalias_dup.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite, inaccessiblemem: write)
define void @kernel.noalias(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr writeonly captures(none) %6, i64 %7, i64 %8, i64 %9) local_unnamed_addr #2 {
  call void @llvm.assume(i1 true) [ "separate_storage"(ptr %1, ptr %6) ]
  %11 = getelementptr float, ptr %1, i64 %2
  %12 = load float, ptr %11, align 4
  %13 = getelementptr float, ptr %6, i64 %7
  br label %14

14:                                               ; preds = %10, %14
  %15 = phi i64 [ 0, %10 ], [ %20, %14 ]
  %16 = getelementptr inbounds nuw float, ptr %11, i64 %15
  %17 = load float, ptr %16, align 4
  %18 = fadd float %12, %17
  %19 = getelementptr inbounds nuw float, ptr %13, i64 %15
  store float %18, ptr %19, align 4
  %20 = add nuw nsw i64 %15, 1
  %21 = icmp samesign ult i64 %15, 511
  br i1 %21, label %14, label %22

22:                                               ; preds = %14
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @kernel(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr writeonly captures(none) %6, i64 %7, i64 %8, i64 %9) local_unnamed_addr #3 {
  %11 = getelementptr float, ptr %1, i64 %2
  %12 = getelementptr float, ptr %6, i64 %7
  br label %13

13:                                               ; preds = %10, %13
  %14 = phi i64 [ 0, %10 ], [ %20, %13 ]
  %15 = load float, ptr %11, align 4
  %16 = getelementptr inbounds nuw float, ptr %11, i64 %14
  %17 = load float, ptr %16, align 4
  %18 = fadd float %15, %17
  %19 = getelementptr inbounds nuw float, ptr %12, i64 %14
  store float %18, ptr %19, align 4
  %20 = add nuw nsw i64 %14, 1
  %21 = icmp samesign ult i64 %14, 511
  br i1 %21, label %13, label %22

22:                                               ; preds = %13
  ret void
}

; Function Attrs: nounwind memory(readwrite, argmem: none, target_mem0: none, target_mem1: none)
define void @caller() local_unnamed_addr #4 {
  %1 = tail call dereferenceable_or_null(4096) ptr @malloc(i64 4096)
  store float 1.000000e+00, ptr %1, align 4
  tail call void @kernel(ptr nonnull poison, ptr nonnull %1, i64 0, i64 poison, i64 poison, ptr nonnull poison, ptr nonnull %1, i64 512, i64 poison, i64 poison) #6
  tail call void @free(ptr %1)
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #5

attributes #0 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { nofree norecurse nosync nounwind memory(argmem: readwrite, inaccessiblemem: write) }
attributes #3 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }
attributes #4 = { nounwind memory(readwrite, argmem: none, target_mem0: none, target_mem1: none) }
attributes #5 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #6 = { noinline }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
