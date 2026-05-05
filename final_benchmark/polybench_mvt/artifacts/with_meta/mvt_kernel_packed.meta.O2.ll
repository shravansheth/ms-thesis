; ModuleID = 'benchmark_exploration/source_diffs/polybench_mvt_clangir/with_meta/mvt_kernel_packed.meta.ll'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @kernel_mvt(i32 %0, ptr readnone captures(none) %1, ptr captures(none) %2, i64 %3, i64 %4, i64 %5, ptr readnone captures(none) %6, ptr captures(none) %7, i64 %8, i64 %9, i64 %10, ptr readnone captures(none) %11, ptr readonly captures(none) %12, i64 %13, i64 %14, i64 %15, ptr readnone captures(none) %16, ptr readonly captures(none) %17, i64 %18, i64 %19, i64 %20, ptr readnone captures(none) %21, ptr readonly captures(none) %22, i64 %23, i64 %24, i64 %25) local_unnamed_addr #0 {
  %27 = icmp sgt i32 %0, 0
  br i1 %27, label %.preheader134.lr.ph, label %._crit_edge142

.preheader134.lr.ph:                              ; preds = %26
  %28 = getelementptr float, ptr %2, i64 %3
  %29 = getelementptr float, ptr %12, i64 %13
  %wide.trip.count147 = zext nneg i32 %0 to i64
  %30 = add i64 %3, %wide.trip.count147
  %31 = shl i64 %30, 2
  %scevgep = getelementptr i8, ptr %2, i64 %31
  %32 = shl nuw nsw i64 %wide.trip.count147, 3
  %33 = getelementptr i8, ptr %22, i64 %32
  %scevgep159 = getelementptr i8, ptr %33, i64 -4
  %34 = add i64 %13, %wide.trip.count147
  %35 = shl i64 %34, 2
  %scevgep160 = getelementptr i8, ptr %12, i64 %35
  %min.iters.check = icmp ult i32 %0, 8
  %bound0 = icmp ult ptr %28, %scevgep159
  %bound1 = icmp ult ptr %22, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %bound0161 = icmp ult ptr %28, %scevgep160
  %bound1162 = icmp ult ptr %29, %scevgep
  %found.conflict163 = and i1 %bound0161, %bound1162
  %conflict.rdx = or i1 %found.conflict, %found.conflict163
  %n.vec = and i64 %wide.trip.count147, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count147
  br label %.lr.ph

.lr.ph:                                           ; preds = %._crit_edge, %.preheader134.lr.ph
  %indvars.iv144 = phi i64 [ 0, %.preheader134.lr.ph ], [ %indvars.iv.next145, %._crit_edge ]
  %36 = getelementptr inbounds nuw float, ptr %28, i64 %indvars.iv144
  %37 = getelementptr float, ptr %22, i64 %indvars.iv144
  %.promoted = load float, ptr %36, align 4
  %brmerge = select i1 %min.iters.check, i1 true, i1 %conflict.rdx
  br i1 %brmerge, label %scalar.ph.preheader, label %vector.body

vector.body:                                      ; preds = %.lr.ph, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %.lr.ph ]
  %vec.phi = phi float [ %45, %vector.body ], [ %.promoted, %.lr.ph ]
  %38 = getelementptr float, ptr %37, i64 %index
  %39 = getelementptr i8, ptr %38, i64 16
  %wide.load = load <4 x float>, ptr %38, align 4, !alias.scope !1
  %wide.load164 = load <4 x float>, ptr %39, align 4, !alias.scope !1
  %40 = getelementptr inbounds nuw float, ptr %29, i64 %index
  %41 = getelementptr inbounds nuw i8, ptr %40, i64 16
  %wide.load165 = load <4 x float>, ptr %40, align 4, !alias.scope !4
  %wide.load166 = load <4 x float>, ptr %41, align 4, !alias.scope !4
  %42 = fmul <4 x float> %wide.load, %wide.load165
  %43 = fmul <4 x float> %wide.load164, %wide.load166
  %44 = tail call float @llvm.vector.reduce.fadd.v4f32(float %vec.phi, <4 x float> %42)
  %45 = tail call float @llvm.vector.reduce.fadd.v4f32(float %44, <4 x float> %43)
  %index.next = add nuw i64 %index, 8
  %46 = icmp eq i64 %index.next, %n.vec
  br i1 %46, label %middle.block, label %vector.body, !llvm.loop !6

middle.block:                                     ; preds = %vector.body
  store float %45, ptr %36, align 4, !alias.scope !9, !noalias !11
  br i1 %cmp.n, label %._crit_edge, label %scalar.ph.preheader

scalar.ph.preheader:                              ; preds = %.lr.ph, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %.lr.ph ], [ %n.vec, %middle.block ]
  %.ph195 = phi float [ %.promoted, %.lr.ph ], [ %45, %middle.block ]
  br label %scalar.ph

.preheader.lr.ph:                                 ; preds = %._crit_edge
  %47 = getelementptr float, ptr %7, i64 %8
  %48 = getelementptr float, ptr %17, i64 %18
  %wide.trip.count157 = zext nneg i32 %0 to i64
  %49 = add i64 %8, %wide.trip.count147
  %50 = shl i64 %49, 2
  %scevgep168 = getelementptr i8, ptr %7, i64 %50
  %51 = shl nuw nsw i64 %wide.trip.count147, 3
  %52 = getelementptr i8, ptr %22, i64 %51
  %scevgep169 = getelementptr i8, ptr %52, i64 -4
  %53 = add i64 %18, %wide.trip.count147
  %54 = shl i64 %53, 2
  %scevgep170 = getelementptr i8, ptr %17, i64 %54
  %min.iters.check179 = icmp ult i32 %0, 8
  %bound0171 = icmp ult ptr %47, %scevgep169
  %bound1172 = icmp ult ptr %22, %scevgep168
  %found.conflict173 = and i1 %bound0171, %bound1172
  %bound0174 = icmp ult ptr %47, %scevgep170
  %bound1175 = icmp ult ptr %48, %scevgep168
  %found.conflict176 = and i1 %bound0174, %bound1175
  %conflict.rdx177 = or i1 %found.conflict173, %found.conflict176
  %n.vec182 = and i64 %wide.trip.count147, 2147483640
  %cmp.n192 = icmp eq i64 %n.vec182, %wide.trip.count147
  br label %.lr.ph138

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %indvars.iv = phi i64 [ %indvars.iv.next, %scalar.ph ], [ %indvars.iv.ph, %scalar.ph.preheader ]
  %55 = phi float [ %61, %scalar.ph ], [ %.ph195, %scalar.ph.preheader ]
  %56 = getelementptr float, ptr %37, i64 %indvars.iv
  %57 = load float, ptr %56, align 4
  %58 = getelementptr inbounds nuw float, ptr %29, i64 %indvars.iv
  %59 = load float, ptr %58, align 4
  %60 = fmul float %57, %59
  %61 = fadd float %55, %60
  store float %61, ptr %36, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count147
  br i1 %exitcond.not, label %._crit_edge, label %scalar.ph, !llvm.loop !12

._crit_edge:                                      ; preds = %scalar.ph, %middle.block
  %indvars.iv.next145 = add nuw nsw i64 %indvars.iv144, 1
  %exitcond148.not = icmp eq i64 %indvars.iv.next145, %wide.trip.count147
  br i1 %exitcond148.not, label %.preheader.lr.ph, label %.lr.ph

.lr.ph138:                                        ; preds = %._crit_edge139, %.preheader.lr.ph
  %indvars.iv154 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvars.iv.next155, %._crit_edge139 ]
  %62 = getelementptr inbounds nuw float, ptr %47, i64 %indvars.iv154
  %invariant.gep = getelementptr float, ptr %22, i64 %indvars.iv154
  %.promoted140 = load float, ptr %62, align 4
  %brmerge198 = select i1 %min.iters.check179, i1 true, i1 %conflict.rdx177
  br i1 %brmerge198, label %scalar.ph178.preheader, label %vector.body183

vector.body183:                                   ; preds = %.lr.ph138, %vector.body183
  %index184 = phi i64 [ %index.next190, %vector.body183 ], [ 0, %.lr.ph138 ]
  %vec.phi185 = phi float [ %70, %vector.body183 ], [ %.promoted140, %.lr.ph138 ]
  %63 = getelementptr float, ptr %invariant.gep, i64 %index184
  %64 = getelementptr i8, ptr %63, i64 16
  %wide.load186 = load <4 x float>, ptr %63, align 4, !alias.scope !13
  %wide.load187 = load <4 x float>, ptr %64, align 4, !alias.scope !13
  %65 = getelementptr inbounds nuw float, ptr %48, i64 %index184
  %66 = getelementptr inbounds nuw i8, ptr %65, i64 16
  %wide.load188 = load <4 x float>, ptr %65, align 4, !alias.scope !16
  %wide.load189 = load <4 x float>, ptr %66, align 4, !alias.scope !16
  %67 = fmul <4 x float> %wide.load186, %wide.load188
  %68 = fmul <4 x float> %wide.load187, %wide.load189
  %69 = tail call float @llvm.vector.reduce.fadd.v4f32(float %vec.phi185, <4 x float> %67)
  %70 = tail call float @llvm.vector.reduce.fadd.v4f32(float %69, <4 x float> %68)
  %index.next190 = add nuw i64 %index184, 8
  %71 = icmp eq i64 %index.next190, %n.vec182
  br i1 %71, label %middle.block191, label %vector.body183, !llvm.loop !18

middle.block191:                                  ; preds = %vector.body183
  store float %70, ptr %62, align 4, !alias.scope !19, !noalias !21
  br i1 %cmp.n192, label %._crit_edge139, label %scalar.ph178.preheader

scalar.ph178.preheader:                           ; preds = %.lr.ph138, %middle.block191
  %indvars.iv149.ph = phi i64 [ 0, %.lr.ph138 ], [ %n.vec182, %middle.block191 ]
  %.ph = phi float [ %.promoted140, %.lr.ph138 ], [ %70, %middle.block191 ]
  br label %scalar.ph178

scalar.ph178:                                     ; preds = %scalar.ph178.preheader, %scalar.ph178
  %indvars.iv149 = phi i64 [ %indvars.iv.next150, %scalar.ph178 ], [ %indvars.iv149.ph, %scalar.ph178.preheader ]
  %72 = phi float [ %77, %scalar.ph178 ], [ %.ph, %scalar.ph178.preheader ]
  %gep = getelementptr float, ptr %invariant.gep, i64 %indvars.iv149
  %73 = load float, ptr %gep, align 4
  %74 = getelementptr inbounds nuw float, ptr %48, i64 %indvars.iv149
  %75 = load float, ptr %74, align 4
  %76 = fmul float %73, %75
  %77 = fadd float %72, %76
  store float %77, ptr %62, align 4
  %indvars.iv.next150 = add nuw nsw i64 %indvars.iv149, 1
  %exitcond153.not = icmp eq i64 %indvars.iv.next150, %wide.trip.count157
  br i1 %exitcond153.not, label %._crit_edge139, label %scalar.ph178, !llvm.loop !22

._crit_edge139:                                   ; preds = %scalar.ph178, %middle.block191
  %indvars.iv.next155 = add nuw nsw i64 %indvars.iv154, 1
  %exitcond158.not = icmp eq i64 %indvars.iv.next155, %wide.trip.count157
  br i1 %exitcond158.not, label %._crit_edge142, label %.lr.ph138

._crit_edge142:                                   ; preds = %._crit_edge139, %26
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @run_mvt_packed(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr captures(none) %6, i64 %7, i64 %8, i64 %9, ptr readnone captures(none) %10, ptr readonly captures(none) %11, i64 %12, i64 %13, i64 %14, ptr readnone captures(none) %15, ptr captures(none) %16, i64 %17, i64 %18, i64 %19, i32 %20) local_unnamed_addr #0 {
  %22 = icmp sgt i32 %20, 0
  br i1 %22, label %.preheader134.lr.ph.i, label %kernel_mvt.__alias_meta_0.exit

.preheader134.lr.ph.i:                            ; preds = %21
  %23 = zext nneg i32 %20 to i64
  %24 = getelementptr float, ptr %16, i64 %17
  %25 = getelementptr float, ptr %24, i64 %23
  br label %.lr.ph.i

.lr.ph.i:                                         ; preds = %._crit_edge.i, %.preheader134.lr.ph.i
  %indvars.iv144.i = phi i64 [ 0, %.preheader134.lr.ph.i ], [ %indvars.iv.next145.i, %._crit_edge.i ]
  %26 = getelementptr float, ptr %24, i64 %indvars.iv144.i
  %27 = getelementptr float, ptr %1, i64 %indvars.iv144.i
  %.promoted.i = load float, ptr %26, align 4, !alias.scope !23
  br label %36

.preheader133.i:                                  ; preds = %._crit_edge.i
  %28 = getelementptr float, ptr %6, i64 %7
  %29 = getelementptr float, ptr %11, i64 %12
  %30 = add i64 %7, %23
  %31 = shl i64 %30, 2
  %scevgep = getelementptr i8, ptr %6, i64 %31
  %32 = shl nuw nsw i64 %23, 3
  %33 = getelementptr i8, ptr %1, i64 %32
  %scevgep92 = getelementptr i8, ptr %33, i64 -4
  %34 = add i64 %12, %23
  %35 = shl i64 %34, 2
  %scevgep93 = getelementptr i8, ptr %11, i64 %35
  %min.iters.check = icmp ult i32 %20, 8
  %bound0 = icmp ult ptr %28, %scevgep92
  %bound1 = icmp ult ptr %1, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %bound094 = icmp ult ptr %28, %scevgep93
  %bound195 = icmp ult ptr %29, %scevgep
  %found.conflict96 = and i1 %bound094, %bound195
  %conflict.rdx = or i1 %found.conflict, %found.conflict96
  %n.vec = and i64 %23, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %23
  br label %.lr.ph138.i

36:                                               ; preds = %36, %.lr.ph.i
  %indvars.iv.i = phi i64 [ 0, %.lr.ph.i ], [ %indvars.iv.next.i, %36 ]
  %37 = phi float [ %.promoted.i, %.lr.ph.i ], [ %43, %36 ]
  %38 = getelementptr float, ptr %27, i64 %indvars.iv.i
  %39 = load float, ptr %38, align 4
  %40 = getelementptr float, ptr %25, i64 %indvars.iv.i
  %41 = load float, ptr %40, align 4, !noalias !23
  %42 = fmul float %39, %41
  %43 = fadd float %37, %42
  store float %43, ptr %26, align 4, !alias.scope !23
  %indvars.iv.next.i = add nuw nsw i64 %indvars.iv.i, 1
  %exitcond.not.i = icmp eq i64 %indvars.iv.next.i, %23
  br i1 %exitcond.not.i, label %._crit_edge.i, label %36

._crit_edge.i:                                    ; preds = %36
  %indvars.iv.next145.i = add nuw nsw i64 %indvars.iv144.i, 1
  %exitcond148.not.i = icmp eq i64 %indvars.iv.next145.i, %23
  br i1 %exitcond148.not.i, label %.preheader133.i, label %.lr.ph.i

.lr.ph138.i:                                      ; preds = %._crit_edge139.i, %.preheader133.i
  %indvars.iv154.i = phi i64 [ 0, %.preheader133.i ], [ %indvars.iv.next155.i, %._crit_edge139.i ]
  %44 = getelementptr inbounds nuw float, ptr %28, i64 %indvars.iv154.i
  %invariant.gep.i = getelementptr float, ptr %1, i64 %indvars.iv154.i
  %.promoted140.i = load float, ptr %44, align 4
  %brmerge = select i1 %min.iters.check, i1 true, i1 %conflict.rdx
  br i1 %brmerge, label %scalar.ph.preheader, label %vector.body

vector.body:                                      ; preds = %.lr.ph138.i, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %.lr.ph138.i ]
  %vec.phi = phi float [ %52, %vector.body ], [ %.promoted140.i, %.lr.ph138.i ]
  %45 = getelementptr float, ptr %invariant.gep.i, i64 %index
  %46 = getelementptr i8, ptr %45, i64 16
  %wide.load = load <4 x float>, ptr %45, align 4, !alias.scope !26
  %wide.load97 = load <4 x float>, ptr %46, align 4, !alias.scope !26
  %47 = getelementptr inbounds nuw float, ptr %29, i64 %index
  %48 = getelementptr inbounds nuw i8, ptr %47, i64 16
  %wide.load98 = load <4 x float>, ptr %47, align 4, !alias.scope !29
  %wide.load99 = load <4 x float>, ptr %48, align 4, !alias.scope !29
  %49 = fmul <4 x float> %wide.load, %wide.load98
  %50 = fmul <4 x float> %wide.load97, %wide.load99
  %51 = tail call float @llvm.vector.reduce.fadd.v4f32(float %vec.phi, <4 x float> %49)
  %52 = tail call float @llvm.vector.reduce.fadd.v4f32(float %51, <4 x float> %50)
  %index.next = add nuw i64 %index, 8
  %53 = icmp eq i64 %index.next, %n.vec
  br i1 %53, label %middle.block, label %vector.body, !llvm.loop !31

middle.block:                                     ; preds = %vector.body
  store float %52, ptr %44, align 4, !alias.scope !32, !noalias !34
  br i1 %cmp.n, label %._crit_edge139.i, label %scalar.ph.preheader

scalar.ph.preheader:                              ; preds = %.lr.ph138.i, %middle.block
  %indvars.iv149.i.ph = phi i64 [ 0, %.lr.ph138.i ], [ %n.vec, %middle.block ]
  %.ph = phi float [ %.promoted140.i, %.lr.ph138.i ], [ %52, %middle.block ]
  br label %scalar.ph

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %indvars.iv149.i = phi i64 [ %indvars.iv.next150.i, %scalar.ph ], [ %indvars.iv149.i.ph, %scalar.ph.preheader ]
  %54 = phi float [ %59, %scalar.ph ], [ %.ph, %scalar.ph.preheader ]
  %gep.i = getelementptr float, ptr %invariant.gep.i, i64 %indvars.iv149.i
  %55 = load float, ptr %gep.i, align 4
  %56 = getelementptr inbounds nuw float, ptr %29, i64 %indvars.iv149.i
  %57 = load float, ptr %56, align 4
  %58 = fmul float %55, %57
  %59 = fadd float %54, %58
  store float %59, ptr %44, align 4
  %indvars.iv.next150.i = add nuw nsw i64 %indvars.iv149.i, 1
  %exitcond153.not.i = icmp eq i64 %indvars.iv.next150.i, %23
  br i1 %exitcond153.not.i, label %._crit_edge139.i, label %scalar.ph, !llvm.loop !35

._crit_edge139.i:                                 ; preds = %scalar.ph, %middle.block
  %indvars.iv.next155.i = add nuw nsw i64 %indvars.iv154.i, 1
  %exitcond158.not.i = icmp eq i64 %indvars.iv.next155.i, %23
  br i1 %exitcond158.not.i, label %kernel_mvt.__alias_meta_0.exit, label %.lr.ph138.i

kernel_mvt.__alias_meta_0.exit:                   ; preds = %._crit_edge139.i, %21
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @kernel_mvt.__alias_meta_0(i32 %0, ptr readnone captures(none) %1, ptr captures(none) %2, i64 %3, i64 %4, i64 %5, ptr readnone captures(none) %6, ptr captures(none) %7, i64 %8, i64 %9, i64 %10, ptr readnone captures(none) %11, ptr readonly captures(none) %12, i64 %13, i64 %14, i64 %15, ptr readnone captures(none) %16, ptr readonly captures(none) %17, i64 %18, i64 %19, i64 %20, ptr readnone captures(none) %21, ptr readonly captures(none) %22, i64 %23, i64 %24, i64 %25) local_unnamed_addr #0 {
  %27 = icmp sgt i32 %0, 0
  br i1 %27, label %.preheader134.lr.ph, label %._crit_edge142

.preheader134.lr.ph:                              ; preds = %26
  %28 = getelementptr float, ptr %2, i64 %3
  %29 = getelementptr float, ptr %12, i64 %13
  %wide.trip.count147 = zext nneg i32 %0 to i64
  %30 = add i64 %3, %wide.trip.count147
  %31 = shl i64 %30, 2
  %scevgep = getelementptr i8, ptr %2, i64 %31
  %32 = shl nuw nsw i64 %wide.trip.count147, 3
  %33 = getelementptr i8, ptr %22, i64 %32
  %scevgep159 = getelementptr i8, ptr %33, i64 -4
  %34 = add i64 %13, %wide.trip.count147
  %35 = shl i64 %34, 2
  %scevgep160 = getelementptr i8, ptr %12, i64 %35
  %min.iters.check = icmp ult i32 %0, 8
  %bound0 = icmp ult ptr %28, %scevgep159
  %bound1 = icmp ult ptr %22, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %bound0161 = icmp ult ptr %28, %scevgep160
  %bound1162 = icmp ult ptr %29, %scevgep
  %found.conflict163 = and i1 %bound0161, %bound1162
  %conflict.rdx = or i1 %found.conflict, %found.conflict163
  %n.vec = and i64 %wide.trip.count147, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count147
  br label %.lr.ph

.lr.ph:                                           ; preds = %._crit_edge, %.preheader134.lr.ph
  %indvars.iv144 = phi i64 [ 0, %.preheader134.lr.ph ], [ %indvars.iv.next145, %._crit_edge ]
  %36 = getelementptr float, ptr %28, i64 %indvars.iv144
  %37 = getelementptr float, ptr %22, i64 %indvars.iv144
  %.promoted = load float, ptr %36, align 4, !alias.scope !36
  %brmerge = select i1 %min.iters.check, i1 true, i1 %conflict.rdx
  br i1 %brmerge, label %scalar.ph.preheader, label %vector.body

vector.body:                                      ; preds = %.lr.ph, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %.lr.ph ]
  %vec.phi = phi float [ %45, %vector.body ], [ %.promoted, %.lr.ph ]
  %38 = getelementptr float, ptr %37, i64 %index
  %39 = getelementptr i8, ptr %38, i64 16
  %wide.load = load <4 x float>, ptr %38, align 4, !alias.scope !39
  %wide.load164 = load <4 x float>, ptr %39, align 4, !alias.scope !39
  %40 = getelementptr float, ptr %29, i64 %index
  %41 = getelementptr i8, ptr %40, i64 16
  %wide.load165 = load <4 x float>, ptr %40, align 4, !alias.scope !42, !noalias !36
  %wide.load166 = load <4 x float>, ptr %41, align 4, !alias.scope !42, !noalias !36
  %42 = fmul <4 x float> %wide.load, %wide.load165
  %43 = fmul <4 x float> %wide.load164, %wide.load166
  %44 = tail call float @llvm.vector.reduce.fadd.v4f32(float %vec.phi, <4 x float> %42)
  %45 = tail call float @llvm.vector.reduce.fadd.v4f32(float %44, <4 x float> %43)
  %index.next = add nuw i64 %index, 8
  %46 = icmp eq i64 %index.next, %n.vec
  br i1 %46, label %middle.block, label %vector.body, !llvm.loop !44

middle.block:                                     ; preds = %vector.body
  store float %45, ptr %36, align 4, !alias.scope !45, !noalias !47
  br i1 %cmp.n, label %._crit_edge, label %scalar.ph.preheader

scalar.ph.preheader:                              ; preds = %.lr.ph, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %.lr.ph ], [ %n.vec, %middle.block ]
  %.ph195 = phi float [ %.promoted, %.lr.ph ], [ %45, %middle.block ]
  br label %scalar.ph

.preheader.lr.ph:                                 ; preds = %._crit_edge
  %47 = getelementptr float, ptr %7, i64 %8
  %48 = getelementptr float, ptr %17, i64 %18
  %wide.trip.count157 = zext nneg i32 %0 to i64
  %49 = add i64 %8, %wide.trip.count147
  %50 = shl i64 %49, 2
  %scevgep168 = getelementptr i8, ptr %7, i64 %50
  %51 = shl nuw nsw i64 %wide.trip.count147, 3
  %52 = getelementptr i8, ptr %22, i64 %51
  %scevgep169 = getelementptr i8, ptr %52, i64 -4
  %53 = add i64 %18, %wide.trip.count147
  %54 = shl i64 %53, 2
  %scevgep170 = getelementptr i8, ptr %17, i64 %54
  %min.iters.check179 = icmp ult i32 %0, 8
  %bound0171 = icmp ult ptr %47, %scevgep169
  %bound1172 = icmp ult ptr %22, %scevgep168
  %found.conflict173 = and i1 %bound0171, %bound1172
  %bound0174 = icmp ult ptr %47, %scevgep170
  %bound1175 = icmp ult ptr %48, %scevgep168
  %found.conflict176 = and i1 %bound0174, %bound1175
  %conflict.rdx177 = or i1 %found.conflict173, %found.conflict176
  %n.vec182 = and i64 %wide.trip.count147, 2147483640
  %cmp.n192 = icmp eq i64 %n.vec182, %wide.trip.count147
  br label %.lr.ph138

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %indvars.iv = phi i64 [ %indvars.iv.next, %scalar.ph ], [ %indvars.iv.ph, %scalar.ph.preheader ]
  %55 = phi float [ %61, %scalar.ph ], [ %.ph195, %scalar.ph.preheader ]
  %56 = getelementptr float, ptr %37, i64 %indvars.iv
  %57 = load float, ptr %56, align 4
  %58 = getelementptr float, ptr %29, i64 %indvars.iv
  %59 = load float, ptr %58, align 4, !noalias !36
  %60 = fmul float %57, %59
  %61 = fadd float %55, %60
  store float %61, ptr %36, align 4, !alias.scope !36
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count147
  br i1 %exitcond.not, label %._crit_edge, label %scalar.ph, !llvm.loop !48

._crit_edge:                                      ; preds = %scalar.ph, %middle.block
  %indvars.iv.next145 = add nuw nsw i64 %indvars.iv144, 1
  %exitcond148.not = icmp eq i64 %indvars.iv.next145, %wide.trip.count147
  br i1 %exitcond148.not, label %.preheader.lr.ph, label %.lr.ph

.lr.ph138:                                        ; preds = %._crit_edge139, %.preheader.lr.ph
  %indvars.iv154 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvars.iv.next155, %._crit_edge139 ]
  %62 = getelementptr inbounds nuw float, ptr %47, i64 %indvars.iv154
  %invariant.gep = getelementptr float, ptr %22, i64 %indvars.iv154
  %.promoted140 = load float, ptr %62, align 4
  %brmerge198 = select i1 %min.iters.check179, i1 true, i1 %conflict.rdx177
  br i1 %brmerge198, label %scalar.ph178.preheader, label %vector.body183

vector.body183:                                   ; preds = %.lr.ph138, %vector.body183
  %index184 = phi i64 [ %index.next190, %vector.body183 ], [ 0, %.lr.ph138 ]
  %vec.phi185 = phi float [ %70, %vector.body183 ], [ %.promoted140, %.lr.ph138 ]
  %63 = getelementptr float, ptr %invariant.gep, i64 %index184
  %64 = getelementptr i8, ptr %63, i64 16
  %wide.load186 = load <4 x float>, ptr %63, align 4, !alias.scope !49
  %wide.load187 = load <4 x float>, ptr %64, align 4, !alias.scope !49
  %65 = getelementptr inbounds nuw float, ptr %48, i64 %index184
  %66 = getelementptr inbounds nuw i8, ptr %65, i64 16
  %wide.load188 = load <4 x float>, ptr %65, align 4, !alias.scope !52
  %wide.load189 = load <4 x float>, ptr %66, align 4, !alias.scope !52
  %67 = fmul <4 x float> %wide.load186, %wide.load188
  %68 = fmul <4 x float> %wide.load187, %wide.load189
  %69 = tail call float @llvm.vector.reduce.fadd.v4f32(float %vec.phi185, <4 x float> %67)
  %70 = tail call float @llvm.vector.reduce.fadd.v4f32(float %69, <4 x float> %68)
  %index.next190 = add nuw i64 %index184, 8
  %71 = icmp eq i64 %index.next190, %n.vec182
  br i1 %71, label %middle.block191, label %vector.body183, !llvm.loop !54

middle.block191:                                  ; preds = %vector.body183
  store float %70, ptr %62, align 4, !alias.scope !55, !noalias !57
  br i1 %cmp.n192, label %._crit_edge139, label %scalar.ph178.preheader

scalar.ph178.preheader:                           ; preds = %.lr.ph138, %middle.block191
  %indvars.iv149.ph = phi i64 [ 0, %.lr.ph138 ], [ %n.vec182, %middle.block191 ]
  %.ph = phi float [ %.promoted140, %.lr.ph138 ], [ %70, %middle.block191 ]
  br label %scalar.ph178

scalar.ph178:                                     ; preds = %scalar.ph178.preheader, %scalar.ph178
  %indvars.iv149 = phi i64 [ %indvars.iv.next150, %scalar.ph178 ], [ %indvars.iv149.ph, %scalar.ph178.preheader ]
  %72 = phi float [ %77, %scalar.ph178 ], [ %.ph, %scalar.ph178.preheader ]
  %gep = getelementptr float, ptr %invariant.gep, i64 %indvars.iv149
  %73 = load float, ptr %gep, align 4
  %74 = getelementptr inbounds nuw float, ptr %48, i64 %indvars.iv149
  %75 = load float, ptr %74, align 4
  %76 = fmul float %73, %75
  %77 = fadd float %72, %76
  store float %77, ptr %62, align 4
  %indvars.iv.next150 = add nuw nsw i64 %indvars.iv149, 1
  %exitcond153.not = icmp eq i64 %indvars.iv.next150, %wide.trip.count157
  br i1 %exitcond153.not, label %._crit_edge139, label %scalar.ph178, !llvm.loop !58

._crit_edge139:                                   ; preds = %scalar.ph178, %middle.block191
  %indvars.iv.next155 = add nuw nsw i64 %indvars.iv154, 1
  %exitcond158.not = icmp eq i64 %indvars.iv.next155, %wide.trip.count157
  br i1 %exitcond158.not, label %._crit_edge142, label %.lr.ph138

._crit_edge142:                                   ; preds = %._crit_edge139, %26
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.vector.reduce.fadd.v4f32(float, <4 x float>) #1

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

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
!12 = distinct !{!12, !7}
!13 = !{!14}
!14 = distinct !{!14, !15}
!15 = distinct !{!15, !"LVerDomain"}
!16 = !{!17}
!17 = distinct !{!17, !15}
!18 = distinct !{!18, !7, !8}
!19 = !{!20}
!20 = distinct !{!20, !15}
!21 = !{!14, !17}
!22 = distinct !{!22, !7}
!23 = !{!24}
!24 = distinct !{!24, !25, !"pair_0_lo"}
!25 = distinct !{!25, !"pair_0_domain"}
!26 = !{!27}
!27 = distinct !{!27, !28}
!28 = distinct !{!28, !"LVerDomain"}
!29 = !{!30}
!30 = distinct !{!30, !28}
!31 = distinct !{!31, !7, !8}
!32 = !{!33}
!33 = distinct !{!33, !28}
!34 = !{!27, !30}
!35 = distinct !{!35, !7}
!36 = !{!37}
!37 = distinct !{!37, !38, !"pair_0_lo"}
!38 = distinct !{!38, !"pair_0_domain"}
!39 = !{!40}
!40 = distinct !{!40, !41}
!41 = distinct !{!41, !"LVerDomain"}
!42 = !{!43}
!43 = distinct !{!43, !41}
!44 = distinct !{!44, !7, !8}
!45 = !{!37, !46}
!46 = distinct !{!46, !41}
!47 = !{!40, !43}
!48 = distinct !{!48, !7}
!49 = !{!50}
!50 = distinct !{!50, !51}
!51 = distinct !{!51, !"LVerDomain"}
!52 = !{!53}
!53 = distinct !{!53, !51}
!54 = distinct !{!54, !7, !8}
!55 = !{!56}
!56 = distinct !{!56, !51}
!57 = !{!50, !53}
!58 = distinct !{!58, !7}
