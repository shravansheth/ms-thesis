; ModuleID = 'pass_outputs/vectorize_split/with_meta/vectorize_split.meta.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @vectorize_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
vector.ph:
  store float 1.000000e+00, ptr %1, align 4, !alias.scope !1
  %6 = getelementptr float, ptr %1, i64 %5
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %7 = getelementptr inbounds nuw float, ptr %6, i64 %index
  %wide.load = load <4 x float>, ptr %7, align 4, !noalias !1
  %8 = fadd <4 x float> %wide.load, splat (float 1.000000e+00)
  store <4 x float> %8, ptr %7, align 4, !noalias !1
  %index.next = add nuw i64 %index, 4
  %9 = icmp eq i64 %index.next, 1048576
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !4

middle.block:                                     ; preds = %vector.body
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
!4 = distinct !{!4, !5, !6}
!5 = !{!"llvm.loop.isvectorized", i32 1}
!6 = !{!"llvm.loop.unroll.runtime.disable"}
