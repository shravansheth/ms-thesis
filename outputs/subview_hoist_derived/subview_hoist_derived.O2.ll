; ModuleID = 'outputs/subview_hoist_derived/subview_hoist_derived.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: nounwind memory(readwrite, argmem: none, target_mem0: none, target_mem1: none)
define void @subview_hoist_derived() local_unnamed_addr #2 {
  %1 = tail call dereferenceable_or_null(8192) ptr @malloc(i64 8192)
  br label %3

.preheader:                                       ; preds = %3
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 2048
  %.pre = load float, ptr %2, align 4
  br label %10

3:                                                ; preds = %0, %3
  %4 = phi i64 [ 0, %0 ], [ %8, %3 ]
  %5 = getelementptr inbounds nuw float, ptr %1, i64 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 2048
  store float 2.000000e+00, ptr %6, align 4
  %7 = getelementptr inbounds nuw i8, ptr %5, i64 3072
  store float 0.000000e+00, ptr %7, align 4
  %8 = add nuw nsw i64 %4, 1
  %9 = icmp samesign ult i64 %4, 255
  br i1 %9, label %3, label %.preheader

10:                                               ; preds = %.preheader, %10
  %11 = phi i64 [ 0, %.preheader ], [ %17, %10 ]
  %12 = getelementptr inbounds nuw float, ptr %1, i64 %11
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 2048
  %14 = load float, ptr %13, align 4
  %15 = fadd float %.pre, %14
  %16 = getelementptr inbounds nuw i8, ptr %12, i64 3072
  store float %15, ptr %16, align 4
  %17 = add nuw nsw i64 %11, 1
  %18 = icmp samesign ult i64 %11, 255
  br i1 %18, label %10, label %19

19:                                               ; preds = %10
  tail call void @free(ptr nonnull %1)
  ret void
}

attributes #0 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { nounwind memory(readwrite, argmem: none, target_mem0: none, target_mem1: none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
