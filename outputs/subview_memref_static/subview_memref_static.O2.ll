; ModuleID = 'outputs/subview_memref_static/subview_memref_static.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr nocapture noundef) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: nounwind memory(readwrite, argmem: none)
define void @subview_hoist_static() local_unnamed_addr #2 {
  %1 = tail call dereferenceable_or_null(4096) ptr @malloc(i64 4096)
  store float 0.000000e+00, ptr %1, align 4
  br label %2

2:                                                ; preds = %0, %2
  %3 = phi i64 [ 0, %0 ], [ %10, %2 ]
  %4 = load float, ptr %1, align 4
  %5 = getelementptr float, ptr %1, i64 %3
  %6 = load float, ptr %5, align 4
  %7 = fadd float %4, %6
  %8 = or disjoint i64 %3, 512
  %9 = getelementptr float, ptr %1, i64 %8
  store float %7, ptr %9, align 4
  %10 = add nuw nsw i64 %3, 1
  %11 = icmp samesign ult i64 %3, 511
  br i1 %11, label %2, label %12

12:                                               ; preds = %2
  tail call void @free(ptr nonnull %1)
  ret void
}

attributes #0 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { nounwind memory(readwrite, argmem: none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
