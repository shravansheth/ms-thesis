; ModuleID = 'microbench_outputs/noinline_two_pairs/baseline/noinline_two_pairs.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @stencil_a(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr writeonly captures(none) %6, i64 %7, i64 %8, i64 %9, i64 %10) local_unnamed_addr #0 {
  %12 = icmp sgt i64 %10, 0
  br i1 %12, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %11
  %13 = getelementptr float, ptr %1, i64 %2
  %14 = getelementptr float, ptr %6, i64 %7
  br label %15

15:                                               ; preds = %.lr.ph, %15
  %16 = phi i64 [ 0, %.lr.ph ], [ %22, %15 ]
  %17 = load float, ptr %13, align 4
  %18 = getelementptr inbounds nuw float, ptr %13, i64 %16
  %19 = load float, ptr %18, align 4
  %20 = fadd float %17, %19
  %21 = getelementptr inbounds nuw float, ptr %14, i64 %16
  store float %20, ptr %21, align 4
  %22 = add nuw nsw i64 %16, 1
  %23 = icmp slt i64 %22, %10
  br i1 %23, label %15, label %._crit_edge

._crit_edge:                                      ; preds = %15, %11
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @stencil_b(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr writeonly captures(none) %6, i64 %7, i64 %8, i64 %9, i64 %10) local_unnamed_addr #0 {
  %12 = icmp sgt i64 %10, 0
  br i1 %12, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %11
  %13 = getelementptr float, ptr %1, i64 %2
  %14 = getelementptr float, ptr %6, i64 %7
  br label %15

15:                                               ; preds = %.lr.ph, %15
  %16 = phi i64 [ 0, %.lr.ph ], [ %22, %15 ]
  %17 = load float, ptr %13, align 4
  %18 = getelementptr inbounds nuw float, ptr %13, i64 %16
  %19 = load float, ptr %18, align 4
  %20 = fadd float %17, %19
  %21 = getelementptr inbounds nuw float, ptr %14, i64 %16
  store float %20, ptr %21, align 4
  %22 = add nuw nsw i64 %16, 1
  %23 = icmp slt i64 %22, %10
  br i1 %23, label %15, label %._crit_edge

._crit_edge:                                      ; preds = %15, %11
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @caller(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr captures(none) initializes((0, 4)) %6, i64 %7, i64 %8, i64 %9, i64 %10) local_unnamed_addr #0 {
  %12 = sub i64 512, %10
  store float 1.000000e+00, ptr %1, align 4
  store float 2.000000e+00, ptr %6, align 4
  tail call void @stencil_a(ptr poison, ptr nonnull %1, i64 0, i64 poison, i64 poison, ptr poison, ptr nonnull %1, i64 512, i64 poison, i64 poison, i64 512) #1
  tail call void @stencil_b(ptr poison, ptr nonnull %6, i64 0, i64 poison, i64 poison, ptr poison, ptr nonnull %6, i64 %10, i64 poison, i64 poison, i64 %12) #1
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }
attributes #1 = { noinline }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
