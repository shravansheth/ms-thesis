; ModuleID = 'outputs/subview_memref_static/subview_memref_static_metadata.ll'
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
  %3 = phi i64 [ 0, %0 ], [ %9, %2 ]
  %4 = getelementptr float, ptr %1, i64 %3
  %5 = load float, ptr %4, align 4
  %6 = fadd float %5, 0.000000e+00
  %7 = or disjoint i64 %3, 512
  %8 = getelementptr float, ptr %1, i64 %7
  store float %6, ptr %8, align 4, !alias.scope !4, !noalias !5
  %9 = add nuw nsw i64 %3, 1
  %10 = icmp samesign ult i64 %3, 511
  br i1 %10, label %2, label %11

11:                                               ; preds = %2
  tail call void @free(ptr nonnull %1)
  ret void
}

attributes #0 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { nounwind memory(readwrite, argmem: none) }

!llvm.module.flags = !{!0}
!scope.r0 = !{!1}
!scope.r1 = !{!3}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !{!"subview.r0", !2}
!2 = distinct !{!"subview.domain"}
!3 = distinct !{!"subview.r1", !2}
!4 = !{!3}
!5 = !{!1}
