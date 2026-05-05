; ModuleID = 'benchmark_exploration/imex_softmax_scale_packed/baseline/imex_softmax_scale_packed.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @imex_softmax_scale_packed(ptr readnone captures(none) %0, ptr captures(none) %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7, i64 %8) local_unnamed_addr #0 {
  %10 = icmp sgt i64 %7, 0
  br i1 %10, label %.preheader, label %._crit_edge

.preheader:                                       ; preds = %9, %22
  %11 = phi i64 [ %23, %22 ], [ 0, %9 ]
  %.idx = shl nuw nsw i64 %11, 13
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 %.idx
  %13 = getelementptr float, ptr %12, i64 %8
  br label %14

14:                                               ; preds = %.preheader, %14
  %15 = phi i64 [ 0, %.preheader ], [ %20, %14 ]
  %16 = load float, ptr %12, align 4
  %17 = getelementptr float, ptr %13, i64 %15
  %18 = load float, ptr %17, align 4
  %19 = fdiv float %18, %16
  store float %19, ptr %17, align 4
  %20 = add nuw nsw i64 %15, 1
  %21 = icmp samesign ult i64 %15, 1023
  br i1 %21, label %14, label %22

22:                                               ; preds = %14
  %23 = add nuw nsw i64 %11, 1
  %24 = icmp slt i64 %23, %7
  br i1 %24, label %.preheader, label %._crit_edge

._crit_edge:                                      ; preds = %22, %9
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
