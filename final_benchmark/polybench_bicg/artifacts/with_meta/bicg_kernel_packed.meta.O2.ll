; ModuleID = 'benchmark_exploration/source_diffs/polybench_bicg_clangir/with_meta/bicg_kernel_packed.meta.ll'
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
  tail call void @llvm.memset.p0.i64(ptr align 4 %25, i8 0, i64 %27, i1 false), !alias.scope !1
  br label %.preheader.i

.preheader.i:                                     ; preds = %.lr.ph.i, %22
  %28 = icmp sgt i32 %21, 0
  br i1 %28, label %.lr.ph156.i, label %kernel_bicg.__alias_meta_0.exit

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
  %34 = getelementptr float, ptr %30, i64 %indvars.iv160.i
  store float 0.000000e+00, ptr %34, align 4, !noalias !1
  br i1 %24, label %.lr.ph154.i, label %._crit_edge.i

.lr.ph154.i:                                      ; preds = %33
  %35 = getelementptr inbounds nuw float, ptr %31, i64 %indvars.iv160.i
  %36 = getelementptr float, ptr %1, i64 %indvars.iv160.i
  br label %37

37:                                               ; preds = %37, %.lr.ph154.i
  %38 = phi float [ 0.000000e+00, %.lr.ph154.i ], [ %50, %37 ]
  %indvars.iv.i = phi i64 [ 0, %.lr.ph154.i ], [ %indvars.iv.next.i, %37 ]
  %39 = getelementptr float, ptr %29, i64 %indvars.iv.i
  %40 = load float, ptr %39, align 4, !alias.scope !1
  %41 = load float, ptr %35, align 4
  %42 = getelementptr float, ptr %36, i64 %indvars.iv.i
  %43 = load float, ptr %42, align 4
  %44 = fmul float %41, %43
  %45 = fadd float %40, %44
  store float %45, ptr %39, align 4, !alias.scope !1
  %46 = load float, ptr %42, align 4
  %47 = getelementptr inbounds nuw float, ptr %32, i64 %indvars.iv.i
  %48 = load float, ptr %47, align 4
  %49 = fmul float %46, %48
  %50 = fadd float %38, %49
  store float %50, ptr %34, align 4, !noalias !1
  %indvars.iv.next.i = add nuw nsw i64 %indvars.iv.i, 1
  %exitcond.not.i = icmp eq i64 %indvars.iv.next.i, %wide.trip.count.i
  br i1 %exitcond.not.i, label %._crit_edge.i, label %37

._crit_edge.i:                                    ; preds = %37, %33
  %indvars.iv.next161.i = add nuw nsw i64 %indvars.iv160.i, 1
  %exitcond164.not.i = icmp eq i64 %indvars.iv.next161.i, %wide.trip.count163.i
  br i1 %exitcond164.not.i, label %kernel_bicg.__alias_meta_0.exit, label %33

kernel_bicg.__alias_meta_0.exit:                  ; preds = %._crit_edge.i, %.preheader.i
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @kernel_bicg.__alias_meta_0(i32 %0, i32 %1, ptr readnone captures(none) %2, ptr readonly captures(none) %3, i64 %4, i64 %5, i64 %6, ptr readnone captures(none) %7, ptr captures(none) %8, i64 %9, i64 %10, i64 %11, ptr readnone captures(none) %12, ptr writeonly captures(none) %13, i64 %14, i64 %15, i64 %16, ptr readnone captures(none) %17, ptr readonly captures(none) %18, i64 %19, i64 %20, i64 %21, ptr readnone captures(none) %22, ptr readonly captures(none) %23, i64 %24, i64 %25, i64 %26) local_unnamed_addr #0 {
  %28 = icmp sgt i32 %0, 0
  br i1 %28, label %.lr.ph, label %.preheader

.lr.ph:                                           ; preds = %27
  %29 = getelementptr float, ptr %8, i64 %9
  %30 = zext nneg i32 %0 to i64
  %31 = shl nuw nsw i64 %30, 2
  tail call void @llvm.memset.p0.i64(ptr align 4 %29, i8 0, i64 %31, i1 false), !alias.scope !4
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
  %wide.trip.count = zext i32 %0 to i64
  %37 = add i64 %9, %wide.trip.count
  %38 = shl i64 %37, 2
  %scevgep = getelementptr i8, ptr %8, i64 %38
  %39 = add i64 %14, %wide.trip.count163
  %40 = shl i64 %39, 2
  %scevgep166 = getelementptr i8, ptr %13, i64 %40
  %41 = add i64 %24, %wide.trip.count163
  %42 = shl i64 %41, 2
  %scevgep167 = getelementptr i8, ptr %23, i64 %42
  %43 = add nuw nsw i64 %wide.trip.count163, %wide.trip.count
  %44 = shl nuw nsw i64 %43, 2
  %45 = getelementptr i8, ptr %3, i64 %44
  %scevgep168 = getelementptr i8, ptr %45, i64 -4
  %46 = add i64 %19, %wide.trip.count
  %47 = shl i64 %46, 2
  %scevgep169 = getelementptr i8, ptr %18, i64 %47
  %min.iters.check = icmp ult i32 %0, 8
  %bound0 = icmp ult ptr %34, %scevgep166
  %bound1 = icmp ult ptr %33, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %bound0170 = icmp ult ptr %34, %scevgep167
  %bound1171 = icmp ult ptr %35, %scevgep
  %found.conflict172 = and i1 %bound0170, %bound1171
  %conflict.rdx = or i1 %found.conflict, %found.conflict172
  %bound0173 = icmp ult ptr %34, %scevgep168
  %bound1174 = icmp ult ptr %3, %scevgep
  %found.conflict175 = and i1 %bound0173, %bound1174
  %conflict.rdx176 = or i1 %conflict.rdx, %found.conflict175
  %bound0177 = icmp ult ptr %34, %scevgep169
  %bound1178 = icmp ult ptr %36, %scevgep
  %found.conflict179 = and i1 %bound0177, %bound1178
  %conflict.rdx180 = or i1 %conflict.rdx176, %found.conflict179
  %bound0181 = icmp ult ptr %33, %scevgep167
  %bound1182 = icmp ult ptr %35, %scevgep166
  %found.conflict183 = and i1 %bound0181, %bound1182
  %conflict.rdx184 = or i1 %conflict.rdx180, %found.conflict183
  %bound0185 = icmp ult ptr %33, %scevgep168
  %bound1186 = icmp ult ptr %3, %scevgep166
  %found.conflict187 = and i1 %bound0185, %bound1186
  %conflict.rdx188 = or i1 %conflict.rdx184, %found.conflict187
  %bound0189 = icmp ult ptr %33, %scevgep169
  %bound1190 = icmp ult ptr %36, %scevgep166
  %found.conflict191 = and i1 %bound0189, %bound1190
  %conflict.rdx192 = or i1 %conflict.rdx188, %found.conflict191
  %n.vec = and i64 %wide.trip.count, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  br label %48

48:                                               ; preds = %.lr.ph156, %._crit_edge
  %indvars.iv160 = phi i64 [ 0, %.lr.ph156 ], [ %indvars.iv.next161, %._crit_edge ]
  %49 = getelementptr float, ptr %33, i64 %indvars.iv160
  store float 0.000000e+00, ptr %49, align 4, !noalias !4
  br i1 %28, label %.lr.ph154, label %._crit_edge

.lr.ph154:                                        ; preds = %48
  %50 = getelementptr inbounds nuw float, ptr %35, i64 %indvars.iv160
  %51 = getelementptr float, ptr %3, i64 %indvars.iv160
  %brmerge = select i1 %min.iters.check, i1 true, i1 %conflict.rdx192
  br i1 %brmerge, label %scalar.ph.preheader, label %vector.ph

vector.ph:                                        ; preds = %.lr.ph154
  %52 = load float, ptr %50, align 4, !alias.scope !7
  %broadcast.splatinsert = insertelement <4 x float> poison, float %52, i64 0
  %broadcast.splat = shufflevector <4 x float> %broadcast.splatinsert, <4 x float> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi float [ 0.000000e+00, %vector.ph ], [ %66, %vector.body ]
  %53 = getelementptr float, ptr %34, i64 %index
  %54 = getelementptr i8, ptr %53, i64 16
  %wide.load = load <4 x float>, ptr %53, align 4, !alias.scope !10, !noalias !12
  %wide.load193 = load <4 x float>, ptr %54, align 4, !alias.scope !10, !noalias !12
  %55 = getelementptr float, ptr %51, i64 %index
  %56 = getelementptr i8, ptr %55, i64 16
  %wide.load194 = load <4 x float>, ptr %55, align 4, !alias.scope !16
  %wide.load195 = load <4 x float>, ptr %56, align 4, !alias.scope !16
  %57 = fmul <4 x float> %broadcast.splat, %wide.load194
  %58 = fmul <4 x float> %broadcast.splat, %wide.load195
  %59 = fadd <4 x float> %wide.load, %57
  %60 = fadd <4 x float> %wide.load193, %58
  store <4 x float> %59, ptr %53, align 4, !alias.scope !10, !noalias !12
  store <4 x float> %60, ptr %54, align 4, !alias.scope !10, !noalias !12
  %wide.load196 = load <4 x float>, ptr %55, align 4, !alias.scope !16
  %wide.load197 = load <4 x float>, ptr %56, align 4, !alias.scope !16
  %61 = getelementptr inbounds nuw float, ptr %36, i64 %index
  %62 = getelementptr inbounds nuw i8, ptr %61, i64 16
  %wide.load198 = load <4 x float>, ptr %61, align 4, !alias.scope !17
  %wide.load199 = load <4 x float>, ptr %62, align 4, !alias.scope !17
  %63 = fmul <4 x float> %wide.load196, %wide.load198
  %64 = fmul <4 x float> %wide.load197, %wide.load199
  %65 = tail call float @llvm.vector.reduce.fadd.v4f32(float %vec.phi, <4 x float> %63)
  %66 = tail call float @llvm.vector.reduce.fadd.v4f32(float %65, <4 x float> %64)
  %index.next = add nuw i64 %index, 8
  %67 = icmp eq i64 %index.next, %n.vec
  br i1 %67, label %middle.block, label %vector.body, !llvm.loop !18

middle.block:                                     ; preds = %vector.body
  store float %66, ptr %49, align 4, !alias.scope !21, !noalias !22
  br i1 %cmp.n, label %._crit_edge, label %scalar.ph.preheader

scalar.ph.preheader:                              ; preds = %.lr.ph154, %middle.block
  %.ph = phi float [ 0.000000e+00, %.lr.ph154 ], [ %66, %middle.block ]
  %indvars.iv.ph = phi i64 [ 0, %.lr.ph154 ], [ %n.vec, %middle.block ]
  br label %scalar.ph

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %68 = phi float [ %80, %scalar.ph ], [ %.ph, %scalar.ph.preheader ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %scalar.ph ], [ %indvars.iv.ph, %scalar.ph.preheader ]
  %69 = getelementptr float, ptr %34, i64 %indvars.iv
  %70 = load float, ptr %69, align 4, !alias.scope !4
  %71 = load float, ptr %50, align 4
  %72 = getelementptr float, ptr %51, i64 %indvars.iv
  %73 = load float, ptr %72, align 4
  %74 = fmul float %71, %73
  %75 = fadd float %70, %74
  store float %75, ptr %69, align 4, !alias.scope !4
  %76 = load float, ptr %72, align 4
  %77 = getelementptr inbounds nuw float, ptr %36, i64 %indvars.iv
  %78 = load float, ptr %77, align 4
  %79 = fmul float %76, %78
  %80 = fadd float %68, %79
  store float %80, ptr %49, align 4, !noalias !4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %._crit_edge, label %scalar.ph, !llvm.loop !23

._crit_edge:                                      ; preds = %scalar.ph, %middle.block, %48
  %indvars.iv.next161 = add nuw nsw i64 %indvars.iv160, 1
  %exitcond164.not = icmp eq i64 %indvars.iv.next161, %wide.trip.count163
  br i1 %exitcond164.not, label %._crit_edge157, label %48

._crit_edge157:                                   ; preds = %._crit_edge, %.preheader
  ret void
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fadd.v4f32(float, <4 x float>) #2

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
!4 = !{!5}
!5 = distinct !{!5, !6, !"pair_0_lo"}
!6 = distinct !{!6, !"pair_0_domain"}
!7 = !{!8}
!8 = distinct !{!8, !9}
!9 = distinct !{!9, !"LVerDomain"}
!10 = !{!5, !11}
!11 = distinct !{!11, !9}
!12 = !{!13, !8, !14, !15}
!13 = distinct !{!13, !9}
!14 = distinct !{!14, !9}
!15 = distinct !{!15, !9}
!16 = !{!14}
!17 = !{!15}
!18 = distinct !{!18, !19, !20}
!19 = !{!"llvm.loop.isvectorized", i32 1}
!20 = !{!"llvm.loop.unroll.runtime.disable"}
!21 = !{!13}
!22 = !{!5, !8, !14, !15}
!23 = distinct !{!23, !19}
