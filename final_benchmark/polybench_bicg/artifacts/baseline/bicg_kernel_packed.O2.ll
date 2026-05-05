; ModuleID = 'benchmark_exploration/source_diffs/polybench_bicg_clangir/baseline/bicg_kernel_packed.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @kernel_bicg(i32 %0, i32 %1, ptr readnone captures(none) %2, ptr readonly captures(none) %3, i64 %4, i64 %5, i64 %6, ptr readnone captures(none) %7, ptr captures(none) %8, i64 %9, i64 %10, i64 %11, ptr readnone captures(none) %12, ptr captures(none) %13, i64 %14, i64 %15, i64 %16, ptr readnone captures(none) %17, ptr readonly captures(none) %18, i64 %19, i64 %20, i64 %21, ptr readnone captures(none) %22, ptr readonly captures(none) %23, i64 %24, i64 %25, i64 %26) local_unnamed_addr #0 {
  %28 = icmp sgt i32 %0, 0
  br i1 %28, label %.lr.ph, label %.preheader

.lr.ph:                                           ; preds = %27
  %29 = getelementptr float, ptr %8, i64 %9
  %30 = zext nneg i32 %0 to i64
  %31 = shl nuw nsw i64 %30, 2
  tail call void @llvm.memset.p0.i64(ptr align 4 %29, i8 0, i64 %31, i1 false)
  br label %.preheader

.preheader:                                       ; preds = %.lr.ph, %27
  %32 = icmp sgt i32 %1, 0
  br i1 %32, label %.lr.ph156, label %._crit_edge157

.lr.ph156:                                        ; preds = %.preheader
  %33 = getelementptr float, ptr %13, i64 %14
  %34 = getelementptr float, ptr %8, i64 %9
  %35 = getelementptr float, ptr %23, i64 %24
  %36 = getelementptr float, ptr %18, i64 %19
  %wide.trip.count163 = zext nneg i32 %1 to i64
  %wide.trip.count = zext nneg i32 %0 to i64
  br label %37

37:                                               ; preds = %.lr.ph156, %._crit_edge
  %indvars.iv160 = phi i64 [ 0, %.lr.ph156 ], [ %indvars.iv.next161, %._crit_edge ]
  %38 = getelementptr inbounds nuw float, ptr %33, i64 %indvars.iv160
  store float 0.000000e+00, ptr %38, align 4
  br i1 %28, label %.lr.ph154, label %._crit_edge

.lr.ph154:                                        ; preds = %37
  %39 = getelementptr inbounds nuw float, ptr %35, i64 %indvars.iv160
  %40 = getelementptr float, ptr %3, i64 %indvars.iv160
  br label %41

41:                                               ; preds = %.lr.ph154, %41
  %indvars.iv = phi i64 [ 0, %.lr.ph154 ], [ %indvars.iv.next, %41 ]
  %42 = getelementptr inbounds nuw float, ptr %34, i64 %indvars.iv
  %43 = load float, ptr %42, align 4
  %44 = load float, ptr %39, align 4
  %45 = getelementptr float, ptr %40, i64 %indvars.iv
  %46 = load float, ptr %45, align 4
  %47 = fmul float %44, %46
  %48 = fadd float %43, %47
  store float %48, ptr %42, align 4
  %49 = load float, ptr %38, align 4
  %50 = load float, ptr %45, align 4
  %51 = getelementptr inbounds nuw float, ptr %36, i64 %indvars.iv
  %52 = load float, ptr %51, align 4
  %53 = fmul float %50, %52
  %54 = fadd float %49, %53
  store float %54, ptr %38, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %._crit_edge, label %41

._crit_edge:                                      ; preds = %41, %37
  %indvars.iv.next161 = add nuw nsw i64 %indvars.iv160, 1
  %exitcond164.not = icmp eq i64 %indvars.iv.next161, %wide.trip.count163
  br i1 %exitcond164.not, label %._crit_edge157, label %37

._crit_edge157:                                   ; preds = %._crit_edge, %.preheader
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @run_bicg_packed(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr readonly captures(none) %6, i64 %7, i64 %8, i64 %9, ptr readnone captures(none) %10, ptr readonly captures(none) %11, i64 %12, i64 %13, i64 %14, ptr readnone captures(none) %15, ptr captures(none) %16, i64 %17, i64 %18, i64 %19, i32 %20, i32 %21) local_unnamed_addr #0 {
  %23 = sext i32 %20 to i64
  %24 = icmp sgt i32 %20, 0
  br i1 %24, label %.lr.ph.i, label %.preheader.i

.lr.ph.i:                                         ; preds = %22
  %25 = getelementptr float, ptr %16, i64 %17
  %26 = zext nneg i32 %20 to i64
  %27 = shl nuw nsw i64 %26, 2
  tail call void @llvm.memset.p0.i64(ptr align 4 %25, i8 0, i64 %27, i1 false)
  br label %.preheader.i

.preheader.i:                                     ; preds = %.lr.ph.i, %22
  %28 = icmp sgt i32 %21, 0
  br i1 %28, label %.lr.ph156.i, label %kernel_bicg.exit

.lr.ph156.i:                                      ; preds = %.preheader.i
  %29 = getelementptr float, ptr %16, i64 %17
  %30 = getelementptr float, ptr %29, i64 %23
  %31 = getelementptr float, ptr %11, i64 %12
  %32 = getelementptr float, ptr %6, i64 %7
  %wide.trip.count163.i = zext nneg i32 %21 to i64
  %wide.trip.count.i = zext nneg i32 %20 to i64
  br label %33

33:                                               ; preds = %._crit_edge.i, %.lr.ph156.i
  %indvars.iv160.i = phi i64 [ 0, %.lr.ph156.i ], [ %indvars.iv.next161.i, %._crit_edge.i ]
  %34 = getelementptr inbounds nuw float, ptr %30, i64 %indvars.iv160.i
  store float 0.000000e+00, ptr %34, align 4
  br i1 %24, label %.lr.ph154.i, label %._crit_edge.i

.lr.ph154.i:                                      ; preds = %33
  %35 = getelementptr inbounds nuw float, ptr %31, i64 %indvars.iv160.i
  %36 = getelementptr float, ptr %1, i64 %indvars.iv160.i
  br label %37

37:                                               ; preds = %37, %.lr.ph154.i
  %indvars.iv.i = phi i64 [ 0, %.lr.ph154.i ], [ %indvars.iv.next.i, %37 ]
  %38 = getelementptr inbounds nuw float, ptr %29, i64 %indvars.iv.i
  %39 = load float, ptr %38, align 4
  %40 = load float, ptr %35, align 4
  %41 = getelementptr float, ptr %36, i64 %indvars.iv.i
  %42 = load float, ptr %41, align 4
  %43 = fmul float %40, %42
  %44 = fadd float %39, %43
  store float %44, ptr %38, align 4
  %45 = load float, ptr %34, align 4
  %46 = load float, ptr %41, align 4
  %47 = getelementptr inbounds nuw float, ptr %32, i64 %indvars.iv.i
  %48 = load float, ptr %47, align 4
  %49 = fmul float %46, %48
  %50 = fadd float %45, %49
  store float %50, ptr %34, align 4
  %indvars.iv.next.i = add nuw nsw i64 %indvars.iv.i, 1
  %exitcond.not.i = icmp eq i64 %indvars.iv.next.i, %wide.trip.count.i
  br i1 %exitcond.not.i, label %._crit_edge.i, label %37

._crit_edge.i:                                    ; preds = %37, %33
  %indvars.iv.next161.i = add nuw nsw i64 %indvars.iv160.i, 1
  %exitcond164.not.i = icmp eq i64 %indvars.iv.next161.i, %wide.trip.count163.i
  br i1 %exitcond164.not.i, label %kernel_bicg.exit, label %33

kernel_bicg.exit:                                 ; preds = %._crit_edge.i, %.preheader.i
  ret void
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #1

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
