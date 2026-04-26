; ModuleID = '/Volumes/ShravsSSD/ms-thesis-copy/microbench_outputs/vectorize_split/baseline/vectorize_split.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @vectorize_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  store float 1.000000e+00, ptr %1, align 4
  %7 = getelementptr float, ptr %1, i64 %5
  br label %8

8:                                                ; preds = %8, %6
  %9 = phi i64 [ 0, %6 ], [ %19, %8 ]
  %10 = load float, ptr %1, align 4
  %11 = getelementptr float, ptr %7, i64 %9
  %12 = load float, ptr %11, align 4
  %13 = fadd float %10, %12
  store float %13, ptr %11, align 4
  %14 = load float, ptr %1, align 4
  %15 = getelementptr float, ptr %7, i64 %9
  %16 = getelementptr i8, ptr %15, i64 4
  %17 = load float, ptr %16, align 4
  %18 = fadd float %14, %17
  store float %18, ptr %16, align 4
  %19 = add nuw nsw i64 %9, 2
  %exitcond.not.1 = icmp eq i64 %19, 1048576
  br i1 %exitcond.not.1, label %20, label %8

20:                                               ; preds = %8
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) "target-cpu"="cortex-a72" }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
