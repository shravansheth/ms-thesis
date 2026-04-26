; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @linalg_stencil_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %1, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, i64 %2, 2
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %3, 3, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %4, 4, 0
  %12 = sub i64 4096, %5
  %13 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 0
  %14 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %15 = insertvalue { ptr, ptr, i64 } poison, ptr %13, 0
  %16 = insertvalue { ptr, ptr, i64 } %15, ptr %14, 1
  %17 = insertvalue { ptr, ptr, i64 } %16, i64 0, 2
  %18 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 2
  %19 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 3, 0
  %20 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 4, 0
  %21 = extractvalue { ptr, ptr, i64 } %17, 0
  %22 = extractvalue { ptr, ptr, i64 } %17, 1
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %21, 0
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, ptr %22, 1
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, i64 0, 2
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 %5, 3, 0
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, i64 1, 4, 0
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 0
  %29 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %30 = insertvalue { ptr, ptr, i64 } poison, ptr %28, 0
  %31 = insertvalue { ptr, ptr, i64 } %30, ptr %29, 1
  %32 = insertvalue { ptr, ptr, i64 } %31, i64 0, 2
  %33 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 2
  %34 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 3, 0
  %35 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 4, 0
  %36 = extractvalue { ptr, ptr, i64 } %32, 0
  %37 = extractvalue { ptr, ptr, i64 } %32, 1
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %36, 0
  %39 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, ptr %37, 1
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %39, i64 %5, 2
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, i64 %12, 3, 0
  %42 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, i64 1, 4, 0
  br label %43

43:                                               ; preds = %46, %6
  %44 = phi i64 [ %51, %46 ], [ 0, %6 ]
  %45 = icmp slt i64 %44, %12
  br i1 %45, label %46, label %52

46:                                               ; preds = %43
  %47 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %48 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %49 = getelementptr float, ptr %47, i64 %48
  %50 = getelementptr inbounds nuw float, ptr %49, i64 %44
  store float 1.000000e+00, ptr %50, align 4, !noalias !1
  %51 = add i64 %44, 1
  br label %43

52:                                               ; preds = %43
  br label %53

53:                                               ; preds = %56, %52
  %54 = phi i64 [ %71, %56 ], [ 0, %52 ]
  %55 = icmp slt i64 %54, %5
  br i1 %55, label %56, label %72

56:                                               ; preds = %53
  %57 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, 1
  %58 = getelementptr inbounds nuw float, ptr %57, i64 %54
  %59 = load float, ptr %58, align 4, !alias.scope !1
  %60 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %61 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %62 = getelementptr float, ptr %60, i64 %61
  %63 = getelementptr inbounds nuw float, ptr %62, i64 %54
  %64 = load float, ptr %63, align 4, !noalias !1
  %65 = fadd float %64, %59
  %66 = fadd float %65, 1.000000e+00
  %67 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %68 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %69 = getelementptr float, ptr %67, i64 %68
  %70 = getelementptr inbounds nuw float, ptr %69, i64 %54
  store float %66, ptr %70, align 4, !noalias !1
  %71 = add i64 %54, 1
  br label %53

72:                                               ; preds = %53
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
