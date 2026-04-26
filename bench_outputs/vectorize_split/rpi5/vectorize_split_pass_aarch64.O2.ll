; ModuleID = '/Users/shravansheth/ShravsSSD/ms-thesis-copy/microbench_outputs/vectorize_split/with_meta/vectorize_split.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @vectorize_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
vector.ph:
  store float 1.000000e+00, ptr %1, align 4, !alias.scope !1
  %6 = getelementptr float, ptr %1, i64 %5
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next.1, %vector.body ]
  %7 = getelementptr inbounds nuw float, ptr %6, i64 %index
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 16
  %wide.load = load <4 x float>, ptr %7, align 4, !noalias !1
  %wide.load1 = load <4 x float>, ptr %8, align 4, !noalias !1
  %9 = fadd <4 x float> %wide.load, splat (float 1.000000e+00)
  %10 = fadd <4 x float> %wide.load1, splat (float 1.000000e+00)
  store <4 x float> %9, ptr %7, align 4, !noalias !1
  store <4 x float> %10, ptr %8, align 4, !noalias !1
  %11 = getelementptr inbounds nuw float, ptr %6, i64 %index
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 32
  %13 = getelementptr inbounds nuw i8, ptr %11, i64 48
  %wide.load.1 = load <4 x float>, ptr %12, align 4, !noalias !1
  %wide.load1.1 = load <4 x float>, ptr %13, align 4, !noalias !1
  %14 = fadd <4 x float> %wide.load.1, splat (float 1.000000e+00)
  %15 = fadd <4 x float> %wide.load1.1, splat (float 1.000000e+00)
  store <4 x float> %14, ptr %12, align 4, !noalias !1
  store <4 x float> %15, ptr %13, align 4, !noalias !1
  %index.next.1 = add nuw nsw i64 %index, 16
  %16 = icmp eq i64 %index.next.1, 1048576
  br i1 %16, label %middle.block, label %vector.body, !llvm.loop !4

middle.block:                                     ; preds = %vector.body
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) "target-cpu"="cortex-a76" }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
!4 = distinct !{!4, !5, !6}
!5 = !{!"llvm.loop.isvectorized", i32 1}
!6 = !{!"llvm.loop.unroll.runtime.disable"}
