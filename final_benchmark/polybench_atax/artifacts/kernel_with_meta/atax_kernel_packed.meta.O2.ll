; ModuleID = 'benchmark_exploration/source_diffs/polybench_atax_clangir/kernel_with_meta/atax_kernel_packed.meta.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @kernel_atax(i32 %0, i32 %1, ptr readnone captures(none) %2, ptr readonly captures(none) %3, i64 %4, i64 %5, i64 %6, ptr readnone captures(none) %7, ptr readonly captures(none) %8, i64 %9, i64 %10, i64 %11, ptr readnone captures(none) %12, ptr captures(none) %13, i64 %14, i64 %15, i64 %16, ptr readnone captures(none) %17, ptr captures(none) %18, i64 %19, i64 %20, i64 %21) local_unnamed_addr #0 {
  %23 = icmp sgt i32 %1, 0
  br i1 %23, label %.lr.ph, label %.preheader141

.lr.ph:                                           ; preds = %22
  %24 = getelementptr float, ptr %13, i64 %14
  %25 = zext nneg i32 %1 to i64
  %26 = shl nuw nsw i64 %25, 2
  tail call void @llvm.memset.p0.i64(ptr align 4 %24, i8 0, i64 %26, i1 false)
  br label %.preheader141

.preheader141:                                    ; preds = %.lr.ph, %22
  %27 = icmp sgt i32 %0, 0
  br i1 %27, label %.lr.ph148, label %._crit_edge149

.lr.ph148:                                        ; preds = %.preheader141
  %28 = getelementptr float, ptr %18, i64 %19
  %29 = getelementptr float, ptr %8, i64 %9
  %30 = getelementptr float, ptr %13, i64 %14
  %wide.trip.count160 = zext nneg i32 %0 to i64
  %wide.trip.count = zext i32 %1 to i64
  %wide.trip.count155 = zext nneg i32 %1 to i64
  %31 = add i64 %14, %wide.trip.count
  %32 = shl i64 %31, 2
  %scevgep = getelementptr i8, ptr %13, i64 %32
  %33 = add nuw nsw i64 %wide.trip.count160, %wide.trip.count
  %34 = shl nuw nsw i64 %33, 2
  %35 = getelementptr i8, ptr %3, i64 %34
  %scevgep163 = getelementptr i8, ptr %35, i64 -4
  %36 = add i64 %19, %wide.trip.count160
  %37 = shl i64 %36, 2
  %scevgep164 = getelementptr i8, ptr %18, i64 %37
  %38 = add i64 %19, %wide.trip.count160
  %39 = shl i64 %38, 2
  %scevgep172 = getelementptr i8, ptr %18, i64 %39
  %40 = add nuw nsw i64 %wide.trip.count160, %wide.trip.count
  %41 = shl nuw nsw i64 %40, 2
  %42 = getelementptr i8, ptr %3, i64 %41
  %scevgep173 = getelementptr i8, ptr %42, i64 -4
  %43 = add i64 %9, %wide.trip.count
  %44 = shl i64 %43, 2
  %scevgep174 = getelementptr i8, ptr %8, i64 %44
  %min.iters.check183 = icmp ult i32 %1, 8
  %bound0175 = icmp ult ptr %28, %scevgep173
  %bound1176 = icmp ult ptr %3, %scevgep172
  %found.conflict177 = and i1 %bound0175, %bound1176
  %bound0178 = icmp ult ptr %28, %scevgep174
  %bound1179 = icmp ult ptr %29, %scevgep172
  %found.conflict180 = and i1 %bound0178, %bound1179
  %conflict.rdx181 = or i1 %found.conflict177, %found.conflict180
  %n.vec186 = and i64 %wide.trip.count, 2147483640
  %cmp.n195 = icmp eq i64 %n.vec186, %wide.trip.count
  %min.iters.check = icmp ult i32 %1, 8
  %bound0 = icmp ult ptr %30, %scevgep163
  %bound1 = icmp ult ptr %3, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %bound0165 = icmp ult ptr %30, %scevgep164
  %bound1166 = icmp ult ptr %28, %scevgep
  %found.conflict167 = and i1 %bound0165, %bound1166
  %conflict.rdx = or i1 %found.conflict, %found.conflict167
  %n.vec = and i64 %wide.trip.count, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  br label %45

45:                                               ; preds = %.lr.ph148, %._crit_edge
  %indvars.iv157 = phi i64 [ 0, %.lr.ph148 ], [ %indvars.iv.next158, %._crit_edge ]
  %46 = getelementptr inbounds nuw float, ptr %28, i64 %indvars.iv157
  store float 0.000000e+00, ptr %46, align 4
  br i1 %23, label %.lr.ph144, label %._crit_edge

.lr.ph144:                                        ; preds = %45
  %47 = getelementptr float, ptr %3, i64 %indvars.iv157
  %brmerge = select i1 %min.iters.check183, i1 true, i1 %conflict.rdx181
  br i1 %brmerge, label %scalar.ph182.preheader, label %vector.body187

vector.body187:                                   ; preds = %.lr.ph144, %vector.body187
  %index188 = phi i64 [ %index.next193, %vector.body187 ], [ 0, %.lr.ph144 ]
  %vec.phi = phi float [ %55, %vector.body187 ], [ 0.000000e+00, %.lr.ph144 ]
  %48 = getelementptr float, ptr %47, i64 %index188
  %49 = getelementptr i8, ptr %48, i64 16
  %wide.load189 = load <4 x float>, ptr %48, align 4, !alias.scope !1
  %wide.load190 = load <4 x float>, ptr %49, align 4, !alias.scope !1
  %50 = getelementptr inbounds nuw float, ptr %29, i64 %index188
  %51 = getelementptr inbounds nuw i8, ptr %50, i64 16
  %wide.load191 = load <4 x float>, ptr %50, align 4, !alias.scope !4
  %wide.load192 = load <4 x float>, ptr %51, align 4, !alias.scope !4
  %52 = fmul <4 x float> %wide.load189, %wide.load191
  %53 = fmul <4 x float> %wide.load190, %wide.load192
  %54 = tail call float @llvm.vector.reduce.fadd.v4f32(float %vec.phi, <4 x float> %52)
  %55 = tail call float @llvm.vector.reduce.fadd.v4f32(float %54, <4 x float> %53)
  %index.next193 = add nuw i64 %index188, 8
  %56 = icmp eq i64 %index.next193, %n.vec186
  br i1 %56, label %middle.block194, label %vector.body187, !llvm.loop !6

middle.block194:                                  ; preds = %vector.body187
  store float %55, ptr %46, align 4, !alias.scope !9, !noalias !11
  br i1 %cmp.n195, label %.lr.ph146, label %scalar.ph182.preheader

scalar.ph182.preheader:                           ; preds = %.lr.ph144, %middle.block194
  %indvars.iv.ph = phi i64 [ 0, %.lr.ph144 ], [ %n.vec186, %middle.block194 ]
  %.ph = phi float [ 0.000000e+00, %.lr.ph144 ], [ %55, %middle.block194 ]
  br label %scalar.ph182

.lr.ph146:                                        ; preds = %scalar.ph182, %middle.block194
  %57 = getelementptr float, ptr %3, i64 %indvars.iv157
  %brmerge197 = select i1 %min.iters.check, i1 true, i1 %conflict.rdx
  br i1 %brmerge197, label %scalar.ph.preheader, label %vector.ph

vector.ph:                                        ; preds = %.lr.ph146
  %58 = load float, ptr %46, align 4, !alias.scope !12
  %broadcast.splatinsert = insertelement <4 x float> poison, float %58, i64 0
  %broadcast.splat = shufflevector <4 x float> %broadcast.splatinsert, <4 x float> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %59 = getelementptr inbounds nuw float, ptr %30, i64 %index
  %60 = getelementptr inbounds nuw i8, ptr %59, i64 16
  %wide.load = load <4 x float>, ptr %59, align 4, !alias.scope !15, !noalias !17
  %wide.load168 = load <4 x float>, ptr %60, align 4, !alias.scope !15, !noalias !17
  %61 = getelementptr float, ptr %57, i64 %index
  %62 = getelementptr i8, ptr %61, i64 16
  %wide.load169 = load <4 x float>, ptr %61, align 4, !alias.scope !19
  %wide.load170 = load <4 x float>, ptr %62, align 4, !alias.scope !19
  %63 = fmul <4 x float> %wide.load169, %broadcast.splat
  %64 = fmul <4 x float> %wide.load170, %broadcast.splat
  %65 = fadd <4 x float> %wide.load, %63
  %66 = fadd <4 x float> %wide.load168, %64
  store <4 x float> %65, ptr %59, align 4, !alias.scope !15, !noalias !17
  store <4 x float> %66, ptr %60, align 4, !alias.scope !15, !noalias !17
  %index.next = add nuw i64 %index, 8
  %67 = icmp eq i64 %index.next, %n.vec
  br i1 %67, label %middle.block, label %vector.body, !llvm.loop !20

middle.block:                                     ; preds = %vector.body
  br i1 %cmp.n, label %._crit_edge, label %scalar.ph.preheader

scalar.ph.preheader:                              ; preds = %.lr.ph146, %middle.block
  %indvars.iv152.ph = phi i64 [ 0, %.lr.ph146 ], [ %n.vec, %middle.block ]
  br label %scalar.ph

scalar.ph182:                                     ; preds = %scalar.ph182.preheader, %scalar.ph182
  %indvars.iv = phi i64 [ %indvars.iv.next, %scalar.ph182 ], [ %indvars.iv.ph, %scalar.ph182.preheader ]
  %68 = phi float [ %74, %scalar.ph182 ], [ %.ph, %scalar.ph182.preheader ]
  %69 = getelementptr float, ptr %47, i64 %indvars.iv
  %70 = load float, ptr %69, align 4
  %71 = getelementptr inbounds nuw float, ptr %29, i64 %indvars.iv
  %72 = load float, ptr %71, align 4
  %73 = fmul float %70, %72
  %74 = fadd float %68, %73
  store float %74, ptr %46, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %.lr.ph146, label %scalar.ph182, !llvm.loop !21

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %indvars.iv152 = phi i64 [ %indvars.iv.next153, %scalar.ph ], [ %indvars.iv152.ph, %scalar.ph.preheader ]
  %75 = getelementptr inbounds nuw float, ptr %30, i64 %indvars.iv152
  %76 = load float, ptr %75, align 4
  %77 = getelementptr float, ptr %57, i64 %indvars.iv152
  %78 = load float, ptr %77, align 4
  %79 = load float, ptr %46, align 4
  %80 = fmul float %78, %79
  %81 = fadd float %76, %80
  store float %81, ptr %75, align 4
  %indvars.iv.next153 = add nuw nsw i64 %indvars.iv152, 1
  %exitcond156.not = icmp eq i64 %indvars.iv.next153, %wide.trip.count155
  br i1 %exitcond156.not, label %._crit_edge, label %scalar.ph, !llvm.loop !22

._crit_edge:                                      ; preds = %scalar.ph, %middle.block, %45
  %indvars.iv.next158 = add nuw nsw i64 %indvars.iv157, 1
  %exitcond161.not = icmp eq i64 %indvars.iv.next158, %wide.trip.count160
  br i1 %exitcond161.not, label %._crit_edge149, label %45

._crit_edge149:                                   ; preds = %._crit_edge, %.preheader141
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @run_atax_packed(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr readonly captures(none) %6, i64 %7, i64 %8, i64 %9, ptr readnone captures(none) %10, ptr captures(none) %11, i64 %12, i64 %13, i64 %14, i32 %15, i32 %16) local_unnamed_addr #0 {
  %18 = sext i32 %15 to i64
  %19 = add i64 %12, %18
  %20 = icmp sgt i32 %16, 0
  br i1 %20, label %.lr.ph.i, label %.preheader141.i

.lr.ph.i:                                         ; preds = %17
  %21 = getelementptr float, ptr %11, i64 %19
  %22 = zext nneg i32 %16 to i64
  %23 = shl nuw nsw i64 %22, 2
  tail call void @llvm.memset.p0.i64(ptr align 4 %21, i8 0, i64 %23, i1 false), !noalias !23
  br label %.preheader141.i

.preheader141.i:                                  ; preds = %.lr.ph.i, %17
  %24 = icmp sgt i32 %15, 0
  br i1 %24, label %.lr.ph148.i, label %kernel_atax.__alias_meta_0.exit

.lr.ph148.i:                                      ; preds = %.preheader141.i
  %25 = getelementptr float, ptr %11, i64 %12
  %26 = getelementptr float, ptr %6, i64 %7
  %27 = getelementptr float, ptr %11, i64 %19
  %wide.trip.count160.i = zext nneg i32 %15 to i64
  %wide.trip.count.i = zext i32 %16 to i64
  %28 = add i64 %19, %wide.trip.count.i
  %29 = shl i64 %28, 2
  %scevgep = getelementptr i8, ptr %11, i64 %29
  %30 = add nuw nsw i64 %wide.trip.count160.i, %wide.trip.count.i
  %31 = shl nuw nsw i64 %30, 2
  %32 = getelementptr i8, ptr %1, i64 %31
  %scevgep68 = getelementptr i8, ptr %32, i64 -4
  %min.iters.check = icmp ult i32 %16, 8
  %bound0 = icmp ult ptr %27, %scevgep68
  %bound1 = icmp ult ptr %1, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %n.vec = and i64 %wide.trip.count.i, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count.i
  br label %33

33:                                               ; preds = %._crit_edge.i, %.lr.ph148.i
  %indvars.iv157.i = phi i64 [ 0, %.lr.ph148.i ], [ %indvars.iv.next158.i, %._crit_edge.i ]
  %34 = getelementptr float, ptr %25, i64 %indvars.iv157.i
  store float 0.000000e+00, ptr %34, align 4, !alias.scope !23
  br i1 %20, label %.lr.ph144.i, label %._crit_edge.i

.lr.ph144.i:                                      ; preds = %33
  %35 = getelementptr float, ptr %1, i64 %indvars.iv157.i
  br label %36

36:                                               ; preds = %36, %.lr.ph144.i
  %indvars.iv.i = phi i64 [ 0, %.lr.ph144.i ], [ %indvars.iv.next.i, %36 ]
  %37 = phi float [ 0.000000e+00, %.lr.ph144.i ], [ %43, %36 ]
  %38 = getelementptr float, ptr %35, i64 %indvars.iv.i
  %39 = load float, ptr %38, align 4
  %40 = getelementptr inbounds nuw float, ptr %26, i64 %indvars.iv.i
  %41 = load float, ptr %40, align 4
  %42 = fmul float %39, %41
  %43 = fadd float %37, %42
  store float %43, ptr %34, align 4, !alias.scope !23
  %indvars.iv.next.i = add nuw nsw i64 %indvars.iv.i, 1
  %exitcond.not.i = icmp eq i64 %indvars.iv.next.i, %wide.trip.count.i
  br i1 %exitcond.not.i, label %.lr.ph146.i.preheader, label %36

.lr.ph146.i.preheader:                            ; preds = %36
  %brmerge = select i1 %min.iters.check, i1 true, i1 %found.conflict
  br i1 %brmerge, label %.lr.ph146.i.preheader72, label %vector.ph

vector.ph:                                        ; preds = %.lr.ph146.i.preheader
  %broadcast.splatinsert = insertelement <4 x float> poison, float %43, i64 0
  %broadcast.splat = shufflevector <4 x float> %broadcast.splatinsert, <4 x float> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %44 = getelementptr float, ptr %27, i64 %index
  %45 = getelementptr i8, ptr %44, i64 16
  %wide.load = load <4 x float>, ptr %44, align 4, !alias.scope !26, !noalias !29
  %wide.load69 = load <4 x float>, ptr %45, align 4, !alias.scope !26, !noalias !29
  %46 = getelementptr float, ptr %35, i64 %index
  %47 = getelementptr i8, ptr %46, i64 16
  %wide.load70 = load <4 x float>, ptr %46, align 4, !alias.scope !31
  %wide.load71 = load <4 x float>, ptr %47, align 4, !alias.scope !31
  %48 = fmul <4 x float> %broadcast.splat, %wide.load70
  %49 = fmul <4 x float> %broadcast.splat, %wide.load71
  %50 = fadd <4 x float> %wide.load, %48
  %51 = fadd <4 x float> %wide.load69, %49
  store <4 x float> %50, ptr %44, align 4, !alias.scope !26, !noalias !29
  store <4 x float> %51, ptr %45, align 4, !alias.scope !26, !noalias !29
  %index.next = add nuw i64 %index, 8
  %52 = icmp eq i64 %index.next, %n.vec
  br i1 %52, label %middle.block, label %vector.body, !llvm.loop !32

middle.block:                                     ; preds = %vector.body
  br i1 %cmp.n, label %._crit_edge.i, label %.lr.ph146.i.preheader72

.lr.ph146.i.preheader72:                          ; preds = %.lr.ph146.i.preheader, %middle.block
  %indvars.iv152.i.ph = phi i64 [ 0, %.lr.ph146.i.preheader ], [ %n.vec, %middle.block ]
  br label %.lr.ph146.i

.lr.ph146.i:                                      ; preds = %.lr.ph146.i.preheader72, %.lr.ph146.i
  %indvars.iv152.i = phi i64 [ %indvars.iv.next153.i, %.lr.ph146.i ], [ %indvars.iv152.i.ph, %.lr.ph146.i.preheader72 ]
  %53 = getelementptr float, ptr %27, i64 %indvars.iv152.i
  %54 = load float, ptr %53, align 4, !noalias !23
  %55 = getelementptr float, ptr %35, i64 %indvars.iv152.i
  %56 = load float, ptr %55, align 4
  %57 = fmul float %43, %56
  %58 = fadd float %54, %57
  store float %58, ptr %53, align 4, !noalias !23
  %indvars.iv.next153.i = add nuw nsw i64 %indvars.iv152.i, 1
  %exitcond156.not.i = icmp eq i64 %indvars.iv.next153.i, %wide.trip.count.i
  br i1 %exitcond156.not.i, label %._crit_edge.i, label %.lr.ph146.i, !llvm.loop !33

._crit_edge.i:                                    ; preds = %.lr.ph146.i, %middle.block, %33
  %indvars.iv.next158.i = add nuw nsw i64 %indvars.iv157.i, 1
  %exitcond161.not.i = icmp eq i64 %indvars.iv.next158.i, %wide.trip.count160.i
  br i1 %exitcond161.not.i, label %kernel_atax.__alias_meta_0.exit, label %33

kernel_atax.__alias_meta_0.exit:                  ; preds = %._crit_edge.i, %.preheader141.i
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @kernel_atax.__alias_meta_0(i32 %0, i32 %1, ptr readnone captures(none) %2, ptr readonly captures(none) %3, i64 %4, i64 %5, i64 %6, ptr readnone captures(none) %7, ptr readonly captures(none) %8, i64 %9, i64 %10, i64 %11, ptr readnone captures(none) %12, ptr captures(none) %13, i64 %14, i64 %15, i64 %16, ptr readnone captures(none) %17, ptr writeonly captures(none) %18, i64 %19, i64 %20, i64 %21) local_unnamed_addr #0 {
  %23 = icmp sgt i32 %1, 0
  br i1 %23, label %.lr.ph, label %.preheader141

.lr.ph:                                           ; preds = %22
  %24 = getelementptr float, ptr %13, i64 %14
  %25 = zext nneg i32 %1 to i64
  %26 = shl nuw nsw i64 %25, 2
  tail call void @llvm.memset.p0.i64(ptr align 4 %24, i8 0, i64 %26, i1 false), !noalias !34
  br label %.preheader141

.preheader141:                                    ; preds = %.lr.ph, %22
  %27 = icmp sgt i32 %0, 0
  br i1 %27, label %.lr.ph148, label %._crit_edge149

.lr.ph148:                                        ; preds = %.preheader141
  %28 = getelementptr float, ptr %18, i64 %19
  %29 = getelementptr float, ptr %8, i64 %9
  %30 = getelementptr float, ptr %13, i64 %14
  %wide.trip.count160 = zext nneg i32 %0 to i64
  %wide.trip.count = zext i32 %1 to i64
  %wide.trip.count155 = zext nneg i32 %1 to i64
  %31 = add i64 %14, %wide.trip.count
  %32 = shl i64 %31, 2
  %scevgep = getelementptr i8, ptr %13, i64 %32
  %33 = add nuw nsw i64 %wide.trip.count160, %wide.trip.count
  %34 = shl nuw nsw i64 %33, 2
  %35 = getelementptr i8, ptr %3, i64 %34
  %scevgep163 = getelementptr i8, ptr %35, i64 -4
  %min.iters.check = icmp ult i32 %1, 8
  %bound0 = icmp ult ptr %30, %scevgep163
  %bound1 = icmp ult ptr %3, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %n.vec = and i64 %wide.trip.count, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  br label %36

36:                                               ; preds = %.lr.ph148, %._crit_edge
  %indvars.iv157 = phi i64 [ 0, %.lr.ph148 ], [ %indvars.iv.next158, %._crit_edge ]
  %37 = getelementptr float, ptr %28, i64 %indvars.iv157
  store float 0.000000e+00, ptr %37, align 4, !alias.scope !34
  br i1 %23, label %.lr.ph144, label %._crit_edge

.lr.ph144:                                        ; preds = %36
  %38 = getelementptr float, ptr %3, i64 %indvars.iv157
  br label %49

.lr.ph146:                                        ; preds = %49
  %39 = getelementptr float, ptr %3, i64 %indvars.iv157
  %brmerge = select i1 %min.iters.check, i1 true, i1 %found.conflict
  br i1 %brmerge, label %scalar.ph.preheader, label %vector.ph

vector.ph:                                        ; preds = %.lr.ph146
  %broadcast.splatinsert = insertelement <4 x float> poison, float %56, i64 0
  %broadcast.splat = shufflevector <4 x float> %broadcast.splatinsert, <4 x float> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %40 = getelementptr float, ptr %30, i64 %index
  %41 = getelementptr i8, ptr %40, i64 16
  %wide.load = load <4 x float>, ptr %40, align 4, !alias.scope !37, !noalias !40
  %wide.load164 = load <4 x float>, ptr %41, align 4, !alias.scope !37, !noalias !40
  %42 = getelementptr float, ptr %39, i64 %index
  %43 = getelementptr i8, ptr %42, i64 16
  %wide.load165 = load <4 x float>, ptr %42, align 4, !alias.scope !42
  %wide.load166 = load <4 x float>, ptr %43, align 4, !alias.scope !42
  %44 = fmul <4 x float> %wide.load165, %broadcast.splat
  %45 = fmul <4 x float> %wide.load166, %broadcast.splat
  %46 = fadd <4 x float> %wide.load, %44
  %47 = fadd <4 x float> %wide.load164, %45
  store <4 x float> %46, ptr %40, align 4, !alias.scope !37, !noalias !40
  store <4 x float> %47, ptr %41, align 4, !alias.scope !37, !noalias !40
  %index.next = add nuw i64 %index, 8
  %48 = icmp eq i64 %index.next, %n.vec
  br i1 %48, label %middle.block, label %vector.body, !llvm.loop !43

middle.block:                                     ; preds = %vector.body
  br i1 %cmp.n, label %._crit_edge, label %scalar.ph.preheader

scalar.ph.preheader:                              ; preds = %.lr.ph146, %middle.block
  %indvars.iv152.ph = phi i64 [ 0, %.lr.ph146 ], [ %n.vec, %middle.block ]
  br label %scalar.ph

49:                                               ; preds = %.lr.ph144, %49
  %indvars.iv = phi i64 [ 0, %.lr.ph144 ], [ %indvars.iv.next, %49 ]
  %50 = phi float [ 0.000000e+00, %.lr.ph144 ], [ %56, %49 ]
  %51 = getelementptr float, ptr %38, i64 %indvars.iv
  %52 = load float, ptr %51, align 4
  %53 = getelementptr inbounds nuw float, ptr %29, i64 %indvars.iv
  %54 = load float, ptr %53, align 4
  %55 = fmul float %52, %54
  %56 = fadd float %50, %55
  store float %56, ptr %37, align 4, !alias.scope !34
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %.lr.ph146, label %49

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %indvars.iv152 = phi i64 [ %indvars.iv.next153, %scalar.ph ], [ %indvars.iv152.ph, %scalar.ph.preheader ]
  %57 = getelementptr float, ptr %30, i64 %indvars.iv152
  %58 = load float, ptr %57, align 4, !noalias !34
  %59 = getelementptr float, ptr %39, i64 %indvars.iv152
  %60 = load float, ptr %59, align 4
  %61 = fmul float %60, %56
  %62 = fadd float %58, %61
  store float %62, ptr %57, align 4, !noalias !34
  %indvars.iv.next153 = add nuw nsw i64 %indvars.iv152, 1
  %exitcond156.not = icmp eq i64 %indvars.iv.next153, %wide.trip.count155
  br i1 %exitcond156.not, label %._crit_edge, label %scalar.ph, !llvm.loop !44

._crit_edge:                                      ; preds = %scalar.ph, %middle.block, %36
  %indvars.iv.next158 = add nuw nsw i64 %indvars.iv157, 1
  %exitcond161.not = icmp eq i64 %indvars.iv.next158, %wide.trip.count160
  br i1 %exitcond161.not, label %._crit_edge149, label %36

._crit_edge149:                                   ; preds = %._crit_edge, %.preheader141
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
!2 = distinct !{!2, !3}
!3 = distinct !{!3, !"LVerDomain"}
!4 = !{!5}
!5 = distinct !{!5, !3}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.isvectorized", i32 1}
!8 = !{!"llvm.loop.unroll.runtime.disable"}
!9 = !{!10}
!10 = distinct !{!10, !3}
!11 = !{!2, !5}
!12 = !{!13}
!13 = distinct !{!13, !14}
!14 = distinct !{!14, !"LVerDomain"}
!15 = !{!16}
!16 = distinct !{!16, !14}
!17 = !{!18, !13}
!18 = distinct !{!18, !14}
!19 = !{!18}
!20 = distinct !{!20, !7, !8}
!21 = distinct !{!21, !7}
!22 = distinct !{!22, !7}
!23 = !{!24}
!24 = distinct !{!24, !25, !"pair_0_lo"}
!25 = distinct !{!25, !"pair_0_domain"}
!26 = !{!27}
!27 = distinct !{!27, !28}
!28 = distinct !{!28, !"LVerDomain"}
!29 = !{!24, !30}
!30 = distinct !{!30, !28}
!31 = !{!30}
!32 = distinct !{!32, !7, !8}
!33 = distinct !{!33, !7}
!34 = !{!35}
!35 = distinct !{!35, !36, !"pair_0_lo"}
!36 = distinct !{!36, !"pair_0_domain"}
!37 = !{!38}
!38 = distinct !{!38, !39}
!39 = distinct !{!39, !"LVerDomain"}
!40 = !{!35, !41}
!41 = distinct !{!41, !39}
!42 = !{!41}
!43 = distinct !{!43, !7, !8}
!44 = distinct !{!44, !7}
