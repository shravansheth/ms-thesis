; ModuleID = 'outputs/subview_hoist_static/subview_hoist_static.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: nounwind memory(readwrite, argmem: none, target_mem0: none, target_mem1: none)
define void @subview_hoist_static() local_unnamed_addr #2 {
  %1 = tail call dereferenceable_or_null(4096) ptr @malloc(i64 4096)
  store float 0.000000e+00, ptr %1, align 4
  br label %2

2:                                                ; preds = %0, %2
  %3 = phi i64 [ 0, %0 ], [ %8, %2 ]
  %4 = getelementptr inbounds nuw float, ptr %1, i64 %3
  %5 = load float, ptr %4, align 4
  %6 = fadd float %5, 0.000000e+00
  %7 = getelementptr inbounds nuw i8, ptr %4, i64 2048
  store float %6, ptr %7, align 4
  %8 = add nuw nsw i64 %3, 1
  %9 = icmp samesign ult i64 %3, 511
  br i1 %9, label %2, label %10

10:                                               ; preds = %2
  tail call void @free(ptr nonnull %1)
  ret void
}

attributes #0 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { nounwind memory(readwrite, argmem: none, target_mem0: none, target_mem1: none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
