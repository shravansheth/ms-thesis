; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @tile_stencil(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10) {
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, ptr %6, 1
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, i64 %7, 2
  %15 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, i64 %8, 3, 0
  %16 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, i64 %9, 4, 0
  %17 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, ptr %1, 1
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, i64 %2, 2
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 %3, 3, 0
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 %4, 4, 0
  br label %22

22:                                               ; preds = %25, %11
  %23 = phi i64 [ %41, %25 ], [ 0, %11 ]
  %24 = icmp slt i64 %23, %10
  br i1 %24, label %25, label %42

25:                                               ; preds = %22
  %26 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 2
  %28 = getelementptr float, ptr %26, i64 %27
  %29 = getelementptr inbounds nuw float, ptr %28, i64 0
  %30 = load float, ptr %29, align 4
  %31 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %32 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 2
  %33 = getelementptr float, ptr %31, i64 %32
  %34 = getelementptr inbounds nuw float, ptr %33, i64 %23
  %35 = load float, ptr %34, align 4
  %36 = fadd float %35, %30
  %37 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 1
  %38 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 2
  %39 = getelementptr float, ptr %37, i64 %38
  %40 = getelementptr inbounds nuw float, ptr %39, i64 %23
  store float %36, ptr %40, align 4
  %41 = add i64 %23, 1
  br label %22

42:                                               ; preds = %22
  ret void
}

define void @tiling_caller(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6) {
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, ptr %1, 1
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %2, 2
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %3, 3, 0
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, i64 %4, 4, 0
  %13 = mul i64 %5, %6
  %14 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 0
  %15 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 1
  %16 = insertvalue { ptr, ptr, i64 } poison, ptr %14, 0
  %17 = insertvalue { ptr, ptr, i64 } %16, ptr %15, 1
  %18 = insertvalue { ptr, ptr, i64 } %17, i64 0, 2
  %19 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 2
  %20 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 3, 0
  %21 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 4, 0
  %22 = extractvalue { ptr, ptr, i64 } %18, 0
  %23 = extractvalue { ptr, ptr, i64 } %18, 1
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %22, 0
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, ptr %23, 1
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 %13, 2
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, i64 %6, 3, 0
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, i64 1, 4, 0
  %29 = add i64 %13, %6
  %30 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 0
  %31 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 1
  %32 = insertvalue { ptr, ptr, i64 } poison, ptr %30, 0
  %33 = insertvalue { ptr, ptr, i64 } %32, ptr %31, 1
  %34 = insertvalue { ptr, ptr, i64 } %33, i64 0, 2
  %35 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 2
  %36 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 3, 0
  %37 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 4, 0
  %38 = extractvalue { ptr, ptr, i64 } %34, 0
  %39 = extractvalue { ptr, ptr, i64 } %34, 1
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %38, 0
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, ptr %39, 1
  %42 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, i64 %29, 2
  %43 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, i64 %6, 3, 0
  %44 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %43, i64 1, 4, 0
  %45 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 0
  %46 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 1
  %47 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 2
  %48 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 3, 0
  %49 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 4, 0
  %50 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, 0
  %51 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, 1
  %52 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, 2
  %53 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, 3, 0
  %54 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, 4, 0
  call void @tile_stencil.__alias_meta_0(ptr %45, ptr %46, i64 %47, i64 %48, i64 %49, ptr %50, ptr %51, i64 %52, i64 %53, i64 %54, i64 %6) #0
  ret void
}

define void @tile_stencil.__alias_meta_0(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10) {
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, ptr %6, 1
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, i64 %7, 2
  %15 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, i64 %8, 3, 0
  %16 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, i64 %9, 4, 0
  %17 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, ptr %1, 1
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, i64 %2, 2
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 %3, 3, 0
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 %4, 4, 0
  br label %22

22:                                               ; preds = %25, %11
  %23 = phi i64 [ %41, %25 ], [ 0, %11 ]
  %24 = icmp slt i64 %23, %10
  br i1 %24, label %25, label %42

25:                                               ; preds = %22
  %26 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 2
  %28 = getelementptr float, ptr %26, i64 %27
  %29 = getelementptr inbounds nuw float, ptr %28, i64 0
  %30 = load float, ptr %29, align 4, !alias.scope !1
  %31 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %32 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 2
  %33 = getelementptr float, ptr %31, i64 %32
  %34 = getelementptr inbounds nuw float, ptr %33, i64 %23
  %35 = load float, ptr %34, align 4, !alias.scope !1
  %36 = fadd float %35, %30
  %37 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 1
  %38 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 2
  %39 = getelementptr float, ptr %37, i64 %38
  %40 = getelementptr inbounds nuw float, ptr %39, i64 %23
  store float %36, ptr %40, align 4, !noalias !1
  %41 = add i64 %23, 1
  br label %22

42:                                               ; preds = %22
  ret void
}

attributes #0 = { noinline }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
