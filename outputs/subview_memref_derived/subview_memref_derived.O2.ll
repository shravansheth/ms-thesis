; ModuleID = 'outputs/subview_memref_derived/subview_memref_derived.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr nocapture noundef) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: nounwind memory(readwrite, argmem: none)
define void @subview_hoist_derived() local_unnamed_addr #2 {
  %1 = tail call dereferenceable_or_null(8192) ptr @malloc(i64 8192)
  br label %3

.preheader:                                       ; preds = %3
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 2048
  %.pre = load float, ptr %2, align 4
  br label %11

3:                                                ; preds = %0, %3
  %4 = phi i64 [ 0, %0 ], [ %9, %3 ]
  %5 = or disjoint i64 %4, 512
  %6 = getelementptr inbounds nuw float, ptr %1, i64 %5
  store float 2.000000e+00, ptr %6, align 4
  %7 = or disjoint i64 %4, 768
  %8 = getelementptr inbounds nuw float, ptr %1, i64 %7
  store float 0.000000e+00, ptr %8, align 4
  %9 = add nuw nsw i64 %4, 1
  %10 = icmp samesign ult i64 %4, 255
  br i1 %10, label %3, label %.preheader

11:                                               ; preds = %.preheader, %11
  %12 = phi i64 [ 0, %.preheader ], [ %19, %11 ]
  %13 = or disjoint i64 %12, 512
  %14 = getelementptr inbounds nuw float, ptr %1, i64 %13
  %15 = load float, ptr %14, align 4
  %16 = fadd float %.pre, %15
  %17 = or disjoint i64 %12, 768
  %18 = getelementptr inbounds nuw float, ptr %1, i64 %17
  store float %16, ptr %18, align 4
  %19 = add nuw nsw i64 %12, 1
  %20 = icmp samesign ult i64 %12, 255
  br i1 %20, label %11, label %21

21:                                               ; preds = %11
  tail call void @free(ptr nonnull %1)
  ret void
}

attributes #0 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { nounwind memory(readwrite, argmem: none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
