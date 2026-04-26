; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @matrix_row_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7) {
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %0, 0
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, ptr %1, 1
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 %2, 2
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 %3, 3, 0
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 %5, 4, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 %4, 3, 1
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 %6, 4, 1
  %16 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 0
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %18 = insertvalue { ptr, ptr, i64 } poison, ptr %16, 0
  %19 = insertvalue { ptr, ptr, i64 } %18, ptr %17, 1
  %20 = insertvalue { ptr, ptr, i64 } %19, i64 0, 2
  %21 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 2
  %22 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3, 0
  %23 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3, 1
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %25 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 1
  %26 = extractvalue { ptr, ptr, i64 } %20, 0
  %27 = extractvalue { ptr, ptr, i64 } %20, 1
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %26, 0
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, ptr %27, 1
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, i64 0, 2
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 %7, 3, 0
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 512, 4, 0
  %33 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, i64 512, 3, 1
  %34 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, i64 1, 4, 1
  %35 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 0
  %36 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %37 = insertvalue { ptr, ptr, i64 } poison, ptr %35, 0
  %38 = insertvalue { ptr, ptr, i64 } %37, ptr %36, 1
  %39 = insertvalue { ptr, ptr, i64 } %38, i64 0, 2
  %40 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 2
  %41 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3, 0
  %42 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3, 1
  %43 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %44 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 1
  %45 = mul nsw i64 %7, 512
  %46 = extractvalue { ptr, ptr, i64 } %39, 0
  %47 = extractvalue { ptr, ptr, i64 } %39, 1
  %48 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %46, 0
  %49 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %48, ptr %47, 1
  %50 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %49, i64 %45, 2
  %51 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %50, i64 %7, 3, 0
  %52 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %51, i64 512, 4, 0
  %53 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %52, i64 512, 3, 1
  %54 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %53, i64 1, 4, 1
  %55 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, 1
  %56 = getelementptr inbounds nuw float, ptr %55, i64 0
  store float 1.000000e+00, ptr %56, align 4, !alias.scope !1
  br label %57

57:                                               ; preds = %81, %8
  %58 = phi i64 [ %82, %81 ], [ 0, %8 ]
  %59 = icmp slt i64 %58, %7
  br i1 %59, label %60, label %83

60:                                               ; preds = %57
  br label %61

61:                                               ; preds = %64, %60
  %62 = phi i64 [ %80, %64 ], [ 0, %60 ]
  %63 = icmp slt i64 %62, 512
  br i1 %63, label %64, label %81

64:                                               ; preds = %61
  %65 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, 1
  %66 = getelementptr inbounds nuw float, ptr %65, i64 0
  %67 = load float, ptr %66, align 4, !alias.scope !1
  %68 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, 1
  %69 = mul nuw nsw i64 %58, 512
  %70 = add nuw nsw i64 %69, %62
  %71 = getelementptr inbounds nuw float, ptr %68, i64 %70
  %72 = load float, ptr %71, align 4, !alias.scope !1
  %73 = fadd float %72, %67
  %74 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %54, 1
  %75 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %54, 2
  %76 = getelementptr float, ptr %74, i64 %75
  %77 = mul nuw nsw i64 %58, 512
  %78 = add nuw nsw i64 %77, %62
  %79 = getelementptr inbounds nuw float, ptr %76, i64 %78
  store float %73, ptr %79, align 4, !noalias !1
  %80 = add i64 %62, 1
  br label %61

81:                                               ; preds = %61
  %82 = add i64 %58, 1
  br label %57

83:                                               ; preds = %57
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
