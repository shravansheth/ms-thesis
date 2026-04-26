; ModuleID = '/Volumes/ShravsSSD/ms-thesis-copy/pass_outputs/matrix_row_split/baseline/matrix_row_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @matrix_row_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7) local_unnamed_addr #0 {
  store float 1.000000e+00, ptr %1, align 4
  %9 = icmp sgt i64 %7, 0
  br i1 %9, label %.preheader, label %._crit_edge

.preheader:                                       ; preds = %8, %23
  %10 = phi i64 [ %24, %23 ], [ 0, %8 ]
  %.idx = shl nuw nsw i64 %10, 11
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 %.idx
  %12 = add nuw i64 %10, %7
  %.idx1 = shl nuw nsw i64 %12, 11
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 %.idx1
  br label %14

14:                                               ; preds = %.preheader, %14
  %15 = phi i64 [ 0, %.preheader ], [ %21, %14 ]
  %16 = load float, ptr %1, align 4
  %17 = getelementptr inbounds nuw float, ptr %11, i64 %15
  %18 = load float, ptr %17, align 4
  %19 = fadd float %16, %18
  %20 = getelementptr inbounds nuw float, ptr %13, i64 %15
  store float %19, ptr %20, align 4
  %21 = add nuw nsw i64 %15, 1
  %22 = icmp samesign ult i64 %15, 511
  br i1 %22, label %14, label %23

23:                                               ; preds = %14
  %24 = add nuw nsw i64 %10, 1
  %25 = icmp slt i64 %24, %7
  br i1 %25, label %.preheader, label %._crit_edge

._crit_edge:                                      ; preds = %23, %8
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
