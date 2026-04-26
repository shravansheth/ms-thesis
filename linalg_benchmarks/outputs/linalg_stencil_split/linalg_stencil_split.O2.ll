; ModuleID = 'linalg_benchmarks/outputs/linalg_stencil_split/linalg_stencil_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @linalg_stencil_split(ptr readnone captures(none) %0, ptr captures(none) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  %7 = sub i64 4096, %5
  %8 = icmp sgt i64 %7, 0
  br i1 %8, label %.lr.ph, label %.preheader

.lr.ph:                                           ; preds = %6
  %9 = getelementptr float, ptr %1, i64 %5
  br label %12

.preheader:                                       ; preds = %12, %6
  %10 = icmp sgt i64 %5, 0
  br i1 %10, label %.lr.ph3, label %._crit_edge

.lr.ph3:                                          ; preds = %.preheader
  %11 = getelementptr float, ptr %1, i64 %5
  br label %17

12:                                               ; preds = %.lr.ph, %12
  %13 = phi i64 [ 0, %.lr.ph ], [ %15, %12 ]
  %14 = getelementptr float, ptr %9, i64 %13
  store float 1.000000e+00, ptr %14, align 4
  %15 = add nuw nsw i64 %13, 1
  %16 = icmp slt i64 %15, %7
  br i1 %16, label %12, label %.preheader

17:                                               ; preds = %.lr.ph3, %17
  %18 = phi i64 [ 0, %.lr.ph3 ], [ %25, %17 ]
  %19 = getelementptr inbounds nuw float, ptr %1, i64 %18
  %20 = load float, ptr %19, align 4
  %21 = getelementptr float, ptr %11, i64 %18
  %22 = load float, ptr %21, align 4
  %23 = fadd float %20, %22
  %24 = fadd float %23, 1.000000e+00
  store float %24, ptr %21, align 4
  %25 = add nuw nsw i64 %18, 1
  %26 = icmp slt i64 %25, %5
  br i1 %26, label %17, label %._crit_edge

._crit_edge:                                      ; preds = %17, %.preheader
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
