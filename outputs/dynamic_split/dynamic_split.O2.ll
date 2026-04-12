; ModuleID = 'outputs/dynamic_split/dynamic_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @dynamic_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  %7 = sub i64 2048, %5
  store float 1.000000e+00, ptr %1, align 4
  %8 = icmp sgt i64 %7, 0
  br i1 %8, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %6
  %9 = getelementptr float, ptr %1, i64 %5
  br label %10

10:                                               ; preds = %.lr.ph, %10
  %11 = phi i64 [ 0, %.lr.ph ], [ %16, %10 ]
  %12 = load float, ptr %1, align 4
  %13 = getelementptr float, ptr %9, i64 %11
  %14 = load float, ptr %13, align 4
  %15 = fadd float %12, %14
  store float %15, ptr %13, align 4
  %16 = add nuw nsw i64 %11, 1
  %17 = icmp slt i64 %16, %7
  br i1 %17, label %10, label %._crit_edge

._crit_edge:                                      ; preds = %10, %6
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
