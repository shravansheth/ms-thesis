; ModuleID = 'microbench_outputs/column_split/with_meta/column_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @column_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7, i64 %8) local_unnamed_addr #0 {
  %10 = sub i64 1024, %8
  store float 1.000000e+00, ptr %1, align 4
  %11 = icmp sgt i64 %7, 0
  br i1 %11, label %.preheader.lr.ph, label %._crit_edge1

.preheader.lr.ph:                                 ; preds = %9
  %invariant.gep = getelementptr float, ptr %1, i64 %8
  %12 = icmp sgt i64 %10, 0
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %13 = phi i64 [ 0, %.preheader.lr.ph ], [ %22, %._crit_edge ]
  br i1 %12, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader
  %.idx = shl nuw nsw i64 %13, 12
  %gep = getelementptr i8, ptr %invariant.gep, i64 %.idx
  br label %14

14:                                               ; preds = %.lr.ph, %14
  %15 = phi i64 [ 0, %.lr.ph ], [ %20, %14 ]
  %16 = load float, ptr %1, align 4
  %17 = getelementptr float, ptr %gep, i64 %15
  %18 = load float, ptr %17, align 4
  %19 = fadd float %16, %18
  store float %19, ptr %17, align 4
  %20 = add nuw nsw i64 %15, 1
  %21 = icmp slt i64 %20, %10
  br i1 %21, label %14, label %._crit_edge

._crit_edge:                                      ; preds = %14, %.preheader
  %22 = add nuw nsw i64 %13, 1
  %23 = icmp slt i64 %22, %7
  br i1 %23, label %.preheader, label %._crit_edge1

._crit_edge1:                                     ; preds = %._crit_edge, %9
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
