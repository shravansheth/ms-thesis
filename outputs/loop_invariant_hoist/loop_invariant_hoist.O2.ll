; ModuleID = 'outputs/loop_invariant_hoist/loop_invariant_hoist.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @loop_invariant_hoist(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr readonly captures(none) %6, i64 %7, i64 %8, i64 %9, ptr readnone captures(none) %10, ptr writeonly captures(none) %11, i64 %12, i64 %13, i64 %14, i64 %15) local_unnamed_addr #0 {
  %17 = icmp sgt i64 %15, 0
  br i1 %17, label %.lr.ph.preheader, label %._crit_edge5

.lr.ph.preheader:                                 ; preds = %16, %._crit_edge
  %18 = phi i64 [ %29, %._crit_edge ], [ 0, %16 ]
  %19 = getelementptr inbounds nuw float, ptr %1, i64 %18
  %20 = load float, ptr %19, align 4
  br label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph.preheader, %.lr.ph
  %21 = phi i64 [ %27, %.lr.ph ], [ 0, %.lr.ph.preheader ]
  %22 = getelementptr inbounds nuw float, ptr %6, i64 %21
  %23 = load float, ptr %22, align 4
  %24 = fmul float %20, %23
  %25 = fadd float %24, 0.000000e+00
  %26 = getelementptr inbounds nuw float, ptr %11, i64 %21
  store float %25, ptr %26, align 4
  %27 = add nuw nsw i64 %21, 1
  %28 = icmp slt i64 %27, %15
  br i1 %28, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph
  %29 = add nuw nsw i64 %18, 1
  %30 = icmp slt i64 %29, %15
  br i1 %30, label %.lr.ph.preheader, label %._crit_edge5

._crit_edge5:                                     ; preds = %._crit_edge, %16
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
