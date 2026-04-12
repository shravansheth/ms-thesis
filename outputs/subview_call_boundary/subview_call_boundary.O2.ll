; ModuleID = 'outputs/subview_call_boundary/subview_call_boundary.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr nocapture noundef) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @kernel(ptr nocapture readnone %0, ptr nocapture readonly %1, i64 %2, i64 %3, i64 %4, ptr nocapture readnone %5, ptr nocapture writeonly %6, i64 %7, i64 %8, i64 %9) local_unnamed_addr #2 {
  %11 = getelementptr i8, ptr %6, i64 2048
  br label %12

12:                                               ; preds = %10, %12
  %13 = phi i64 [ 0, %10 ], [ %19, %12 ]
  %14 = load float, ptr %1, align 4
  %15 = getelementptr float, ptr %1, i64 %13
  %16 = load float, ptr %15, align 4
  %17 = fadd float %14, %16
  %18 = getelementptr float, ptr %11, i64 %13
  store float %17, ptr %18, align 4
  %19 = add nuw nsw i64 %13, 1
  %20 = icmp samesign ult i64 %13, 511
  br i1 %20, label %12, label %21

21:                                               ; preds = %12
  ret void
}

; Function Attrs: nounwind memory(readwrite, argmem: none)
define void @subview_call_boundary() local_unnamed_addr #3 {
  %1 = tail call dereferenceable_or_null(4096) ptr @malloc(i64 4096)
  store float 0.000000e+00, ptr %1, align 4
  %2 = getelementptr i8, ptr %1, i64 2048
  br label %3

3:                                                ; preds = %3, %0
  %4 = phi i64 [ 0, %0 ], [ %10, %3 ]
  %5 = load float, ptr %1, align 4
  %6 = getelementptr float, ptr %1, i64 %4
  %7 = load float, ptr %6, align 4
  %8 = fadd float %5, %7
  %9 = getelementptr float, ptr %2, i64 %4
  store float %8, ptr %9, align 4
  %10 = add nuw nsw i64 %4, 1
  %11 = icmp samesign ult i64 %4, 511
  br i1 %11, label %3, label %kernel.exit

kernel.exit:                                      ; preds = %3
  tail call void @free(ptr nonnull %1)
  ret void
}

attributes #0 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }
attributes #3 = { nounwind memory(readwrite, argmem: none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
