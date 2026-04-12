; ModuleID = 'outputs/memref_subview_stride/memref_subview_stride.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: nounwind memory(readwrite, argmem: none, target_mem0: none, target_mem1: none)
define void @case_stride_even_odd() local_unnamed_addr #2 {
  %1 = tail call dereferenceable_or_null(8192) ptr @malloc(i64 8192)
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 2048
  store float 2.000000e+00, ptr %2, align 4
  br label %3

3:                                                ; preds = %0, %3
  %4 = phi i64 [ 0, %0 ], [ %10, %3 ]
  %.idx = shl nuw nsw i64 %4, 3
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 %.idx
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 2048
  %7 = load float, ptr %6, align 4
  %8 = fadd float %7, 2.000000e+00
  %9 = getelementptr inbounds nuw i8, ptr %5, i64 2052
  store float %8, ptr %9, align 4
  %10 = add nuw nsw i64 %4, 1
  %11 = icmp samesign ult i64 %4, 255
  br i1 %11, label %3, label %12

12:                                               ; preds = %3
  tail call void @free(ptr nonnull %1)
  ret void
}

attributes #0 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { nounwind memory(readwrite, argmem: none, target_mem0: none, target_mem1: none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
