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
  %9 = phi i64 [ 0, %6 ], [ %89, %8 ]
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
  %19 = load float, ptr %1, align 4
  %20 = getelementptr float, ptr %7, i64 %9
  %21 = getelementptr i8, ptr %20, i64 8
  %22 = load float, ptr %21, align 4
  %23 = fadd float %19, %22
  store float %23, ptr %21, align 4
  %24 = load float, ptr %1, align 4
  %25 = getelementptr float, ptr %7, i64 %9
  %26 = getelementptr i8, ptr %25, i64 12
  %27 = load float, ptr %26, align 4
  %28 = fadd float %24, %27
  store float %28, ptr %26, align 4
  %29 = load float, ptr %1, align 4
  %30 = getelementptr float, ptr %7, i64 %9
  %31 = getelementptr i8, ptr %30, i64 16
  %32 = load float, ptr %31, align 4
  %33 = fadd float %29, %32
  store float %33, ptr %31, align 4
  %34 = load float, ptr %1, align 4
  %35 = getelementptr float, ptr %7, i64 %9
  %36 = getelementptr i8, ptr %35, i64 20
  %37 = load float, ptr %36, align 4
  %38 = fadd float %34, %37
  store float %38, ptr %36, align 4
  %39 = load float, ptr %1, align 4
  %40 = getelementptr float, ptr %7, i64 %9
  %41 = getelementptr i8, ptr %40, i64 24
  %42 = load float, ptr %41, align 4
  %43 = fadd float %39, %42
  store float %43, ptr %41, align 4
  %44 = load float, ptr %1, align 4
  %45 = getelementptr float, ptr %7, i64 %9
  %46 = getelementptr i8, ptr %45, i64 28
  %47 = load float, ptr %46, align 4
  %48 = fadd float %44, %47
  store float %48, ptr %46, align 4
  %49 = load float, ptr %1, align 4
  %50 = getelementptr float, ptr %7, i64 %9
  %51 = getelementptr i8, ptr %50, i64 32
  %52 = load float, ptr %51, align 4
  %53 = fadd float %49, %52
  store float %53, ptr %51, align 4
  %54 = load float, ptr %1, align 4
  %55 = getelementptr float, ptr %7, i64 %9
  %56 = getelementptr i8, ptr %55, i64 36
  %57 = load float, ptr %56, align 4
  %58 = fadd float %54, %57
  store float %58, ptr %56, align 4
  %59 = load float, ptr %1, align 4
  %60 = getelementptr float, ptr %7, i64 %9
  %61 = getelementptr i8, ptr %60, i64 40
  %62 = load float, ptr %61, align 4
  %63 = fadd float %59, %62
  store float %63, ptr %61, align 4
  %64 = load float, ptr %1, align 4
  %65 = getelementptr float, ptr %7, i64 %9
  %66 = getelementptr i8, ptr %65, i64 44
  %67 = load float, ptr %66, align 4
  %68 = fadd float %64, %67
  store float %68, ptr %66, align 4
  %69 = load float, ptr %1, align 4
  %70 = getelementptr float, ptr %7, i64 %9
  %71 = getelementptr i8, ptr %70, i64 48
  %72 = load float, ptr %71, align 4
  %73 = fadd float %69, %72
  store float %73, ptr %71, align 4
  %74 = load float, ptr %1, align 4
  %75 = getelementptr float, ptr %7, i64 %9
  %76 = getelementptr i8, ptr %75, i64 52
  %77 = load float, ptr %76, align 4
  %78 = fadd float %74, %77
  store float %78, ptr %76, align 4
  %79 = load float, ptr %1, align 4
  %80 = getelementptr float, ptr %7, i64 %9
  %81 = getelementptr i8, ptr %80, i64 56
  %82 = load float, ptr %81, align 4
  %83 = fadd float %79, %82
  store float %83, ptr %81, align 4
  %84 = load float, ptr %1, align 4
  %85 = getelementptr float, ptr %7, i64 %9
  %86 = getelementptr i8, ptr %85, i64 60
  %87 = load float, ptr %86, align 4
  %88 = fadd float %84, %87
  store float %88, ptr %86, align 4
  %89 = add nuw nsw i64 %9, 16
  %exitcond.not.15 = icmp eq i64 %89, 1048576
  br i1 %exitcond.not.15, label %90, label %8

90:                                               ; preds = %8
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) "target-cpu"="cortex-a53" }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
