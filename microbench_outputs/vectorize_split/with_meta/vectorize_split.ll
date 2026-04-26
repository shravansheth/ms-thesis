; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @vectorize_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %1, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, i64 %2, 2
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %3, 3, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %4, 4, 0
  %12 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 0
  %13 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %14 = insertvalue { ptr, ptr, i64 } poison, ptr %12, 0
  %15 = insertvalue { ptr, ptr, i64 } %14, ptr %13, 1
  %16 = insertvalue { ptr, ptr, i64 } %15, i64 0, 2
  %17 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 2
  %18 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 3, 0
  %19 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 4, 0
  %20 = extractvalue { ptr, ptr, i64 } %16, 0
  %21 = extractvalue { ptr, ptr, i64 } %16, 1
  %22 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %20, 0
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, ptr %21, 1
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, i64 0, 2
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, i64 %5, 3, 0
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 1, 4, 0
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 0
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %29 = insertvalue { ptr, ptr, i64 } poison, ptr %27, 0
  %30 = insertvalue { ptr, ptr, i64 } %29, ptr %28, 1
  %31 = insertvalue { ptr, ptr, i64 } %30, i64 0, 2
  %32 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 2
  %33 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 3, 0
  %34 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 4, 0
  %35 = extractvalue { ptr, ptr, i64 } %31, 0
  %36 = extractvalue { ptr, ptr, i64 } %31, 1
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %35, 0
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, ptr %36, 1
  %39 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, i64 %5, 2
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %39, i64 1048576, 3, 0
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, i64 1, 4, 0
  %42 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, 1
  %43 = getelementptr inbounds nuw float, ptr %42, i64 0
  store float 1.000000e+00, ptr %43, align 4, !alias.scope !1
  br label %44

44:                                               ; preds = %47, %6
  %45 = phi i64 [ %61, %47 ], [ 0, %6 ]
  %46 = icmp slt i64 %45, 1048576
  br i1 %46, label %47, label %62

47:                                               ; preds = %44
  %48 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, 1
  %49 = getelementptr inbounds nuw float, ptr %48, i64 0
  %50 = load float, ptr %49, align 4, !alias.scope !1
  %51 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, 1
  %52 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, 2
  %53 = getelementptr float, ptr %51, i64 %52
  %54 = getelementptr inbounds nuw float, ptr %53, i64 %45
  %55 = load float, ptr %54, align 4, !noalias !1
  %56 = fadd float %55, %50
  %57 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, 1
  %58 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, 2
  %59 = getelementptr float, ptr %57, i64 %58
  %60 = getelementptr inbounds nuw float, ptr %59, i64 %45
  store float %56, ptr %60, align 4, !noalias !1
  %61 = add i64 %45, 1
  br label %44

62:                                               ; preds = %44
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
