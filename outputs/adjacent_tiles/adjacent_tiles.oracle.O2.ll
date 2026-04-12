; ModuleID = 'outputs/adjacent_tiles/adjacent_tiles.oracle.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @adjacent_tiles(ptr readnone captures(none) %0, ptr captures(none) %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6) local_unnamed_addr #0 {
  %8 = icmp sgt i64 %6, 0
  br i1 %8, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %7
  %9 = mul i64 %6, %5
  %10 = getelementptr inbounds nuw float, ptr %1, i64 %9
  %11 = load float, ptr %10, align 4, !alias.scope !1
  %12 = getelementptr float, ptr %10, i64 %6
  br label %13

13:                                               ; preds = %.lr.ph, %13
  %14 = phi i64 [ 0, %.lr.ph ], [ %19, %13 ]
  %15 = getelementptr float, ptr %10, i64 %14
  %16 = load float, ptr %15, align 4, !alias.scope !1
  %17 = fadd float %11, %16
  %18 = getelementptr float, ptr %12, i64 %14
  store float %17, ptr %18, align 4, !noalias !1
  %19 = add nuw nsw i64 %14, 1
  %20 = icmp slt i64 %19, %6
  br i1 %20, label %13, label %._crit_edge

._crit_edge:                                      ; preds = %13, %7
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"adjacent_tiles:src_scope"}
!3 = distinct !{!3, !"adjacent_tiles:src_domain"}
