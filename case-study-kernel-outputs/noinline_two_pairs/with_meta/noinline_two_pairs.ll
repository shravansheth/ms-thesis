; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @stencil_a(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10) {
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

define void @stencil_b(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10) {
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

define void @caller(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10) {
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
  %22 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 0
  %23 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %24 = insertvalue { ptr, ptr, i64 } poison, ptr %22, 0
  %25 = insertvalue { ptr, ptr, i64 } %24, ptr %23, 1
  %26 = insertvalue { ptr, ptr, i64 } %25, i64 0, 2
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 2
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 3, 0
  %29 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 4, 0
  %30 = extractvalue { ptr, ptr, i64 } %26, 0
  %31 = extractvalue { ptr, ptr, i64 } %26, 1
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %30, 0
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, ptr %31, 1
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, i64 0, 2
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, i64 512, 3, 0
  %36 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, i64 1, 4, 0
  %37 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 0
  %38 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %39 = insertvalue { ptr, ptr, i64 } poison, ptr %37, 0
  %40 = insertvalue { ptr, ptr, i64 } %39, ptr %38, 1
  %41 = insertvalue { ptr, ptr, i64 } %40, i64 0, 2
  %42 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 2
  %43 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 3, 0
  %44 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 4, 0
  %45 = extractvalue { ptr, ptr, i64 } %41, 0
  %46 = extractvalue { ptr, ptr, i64 } %41, 1
  %47 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %45, 0
  %48 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, ptr %46, 1
  %49 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, i64 512, 2
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %49, i64 512, 3, 0
  %51 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, i64 1, 4, 0
  %52 = sub i64 512, %10
  %53 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 0
  %54 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 1
  %55 = insertvalue { ptr, ptr, i64 } poison, ptr %53, 0
  %56 = insertvalue { ptr, ptr, i64 } %55, ptr %54, 1
  %57 = insertvalue { ptr, ptr, i64 } %56, i64 0, 2
  %58 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 2
  %59 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 3, 0
  %60 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 4, 0
  %61 = extractvalue { ptr, ptr, i64 } %57, 0
  %62 = extractvalue { ptr, ptr, i64 } %57, 1
  %63 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %61, 0
  %64 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %63, ptr %62, 1
  %65 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %64, i64 0, 2
  %66 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %65, i64 %10, 3, 0
  %67 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %66, i64 1, 4, 0
  %68 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 0
  %69 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 1
  %70 = insertvalue { ptr, ptr, i64 } poison, ptr %68, 0
  %71 = insertvalue { ptr, ptr, i64 } %70, ptr %69, 1
  %72 = insertvalue { ptr, ptr, i64 } %71, i64 0, 2
  %73 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 2
  %74 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 3, 0
  %75 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 4, 0
  %76 = extractvalue { ptr, ptr, i64 } %72, 0
  %77 = extractvalue { ptr, ptr, i64 } %72, 1
  %78 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %76, 0
  %79 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, ptr %77, 1
  %80 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %79, i64 %10, 2
  %81 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %80, i64 %52, 3, 0
  %82 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, i64 1, 4, 0
  %83 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, 1
  %84 = getelementptr inbounds nuw float, ptr %83, i64 0
  store float 1.000000e+00, ptr %84, align 4, !alias.scope !1
  %85 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %67, 1
  %86 = getelementptr inbounds nuw float, ptr %85, i64 0
  store float 2.000000e+00, ptr %86, align 4, !alias.scope !4
  %87 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, 0
  %88 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, 1
  %89 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, 2
  %90 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, 3, 0
  %91 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, 4, 0
  %92 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, 0
  %93 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, 1
  %94 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, 2
  %95 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, 3, 0
  %96 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, 4, 0
  call void @stencil_a.__alias_meta_0(ptr %87, ptr %88, i64 %89, i64 %90, i64 %91, ptr %92, ptr %93, i64 %94, i64 %95, i64 %96, i64 512) #0
  %97 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %67, 0
  %98 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %67, 1
  %99 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %67, 2
  %100 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %67, 3, 0
  %101 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %67, 4, 0
  %102 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 0
  %103 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 1
  %104 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 2
  %105 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 3, 0
  %106 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 4, 0
  call void @stencil_b.__alias_meta_1(ptr %97, ptr %98, i64 %99, i64 %100, i64 %101, ptr %102, ptr %103, i64 %104, i64 %105, i64 %106, i64 %52) #0
  ret void
}

define void @stencil_a.__alias_meta_0(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10) {
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

define void @stencil_b.__alias_meta_1(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10) {
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
  %30 = load float, ptr %29, align 4, !alias.scope !4
  %31 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %32 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 2
  %33 = getelementptr float, ptr %31, i64 %32
  %34 = getelementptr inbounds nuw float, ptr %33, i64 %23
  %35 = load float, ptr %34, align 4, !alias.scope !4
  %36 = fadd float %35, %30
  %37 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 1
  %38 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 2
  %39 = getelementptr float, ptr %37, i64 %38
  %40 = getelementptr inbounds nuw float, ptr %39, i64 %23
  store float %36, ptr %40, align 4, !noalias !4
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
!4 = !{!5}
!5 = distinct !{!5, !6, !"pair_1_lo"}
!6 = distinct !{!6, !"pair_1_domain"}
