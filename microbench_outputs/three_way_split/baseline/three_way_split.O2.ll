; ModuleID = 'microbench_outputs/three_way_split/baseline/three_way_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @three_way_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  store float 1.000000e+00, ptr %1, align 4
  %7 = getelementptr inbounds nuw float, ptr %1, i64 %5
  store float 2.000000e+00, ptr %7, align 4
  %8 = icmp sgt i64 %5, 0
  br i1 %8, label %.lr.ph, label %._crit_edge

.lr.ph3:                                          ; preds = %.lr.ph
  %.idx = shl i64 %5, 3
  %9 = getelementptr i8, ptr %1, i64 %.idx
  br label %17

.lr.ph:                                           ; preds = %6, %.lr.ph
  %10 = phi i64 [ %15, %.lr.ph ], [ 0, %6 ]
  %11 = load float, ptr %1, align 4
  %12 = getelementptr float, ptr %7, i64 %10
  %13 = load float, ptr %12, align 4
  %14 = fadd float %11, %13
  store float %14, ptr %12, align 4
  %15 = add nuw nsw i64 %10, 1
  %16 = icmp slt i64 %15, %5
  br i1 %16, label %.lr.ph, label %.lr.ph3

17:                                               ; preds = %.lr.ph3, %17
  %18 = phi i64 [ 0, %.lr.ph3 ], [ %23, %17 ]
  %19 = load float, ptr %7, align 4
  %20 = getelementptr float, ptr %9, i64 %18
  %21 = load float, ptr %20, align 4
  %22 = fadd float %19, %21
  store float %22, ptr %20, align 4
  %23 = add nuw nsw i64 %18, 1
  %24 = icmp slt i64 %23, %5
  br i1 %24, label %17, label %._crit_edge

._crit_edge:                                      ; preds = %17, %6
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
