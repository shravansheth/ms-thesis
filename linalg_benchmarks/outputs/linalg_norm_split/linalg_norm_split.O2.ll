; ModuleID = 'linalg_benchmarks/outputs/linalg_norm_split/linalg_norm_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @linalg_norm_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 8)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  %7 = sub i64 2048, %5
  store float 1.000000e+00, ptr %1, align 4
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 4
  store float 2.000000e+00, ptr %8, align 4
  %9 = icmp sgt i64 %7, 0
  br i1 %9, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %6
  %10 = getelementptr float, ptr %1, i64 %5
  br label %12

.lr.ph2:                                          ; preds = %12
  %11 = getelementptr float, ptr %1, i64 %5
  br label %20

12:                                               ; preds = %.lr.ph, %12
  %13 = phi i64 [ 0, %.lr.ph ], [ %18, %12 ]
  %14 = load float, ptr %1, align 4
  %15 = getelementptr float, ptr %10, i64 %13
  %16 = load float, ptr %15, align 4
  %17 = fadd float %14, %16
  store float %17, ptr %15, align 4
  %18 = add nuw nsw i64 %13, 1
  %19 = icmp slt i64 %18, %7
  br i1 %19, label %12, label %.lr.ph2

20:                                               ; preds = %.lr.ph2, %20
  %21 = phi i64 [ 0, %.lr.ph2 ], [ %26, %20 ]
  %22 = load float, ptr %8, align 4
  %23 = getelementptr float, ptr %11, i64 %21
  %24 = load float, ptr %23, align 4
  %25 = fmul float %22, %24
  store float %25, ptr %23, align 4
  %26 = add nuw nsw i64 %21, 1
  %27 = icmp slt i64 %26, %7
  br i1 %27, label %20, label %._crit_edge

._crit_edge:                                      ; preds = %20, %6
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
