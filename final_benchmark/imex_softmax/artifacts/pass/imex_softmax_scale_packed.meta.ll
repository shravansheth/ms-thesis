; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @imex_softmax_scale_packed(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7, i64 %8) {
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %0, 0
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, ptr %1, 1
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 %2, 2
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 %3, 3, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 %5, 4, 0
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 %4, 3, 1
  %16 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, i64 %6, 4, 1
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 0
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %19 = insertvalue { ptr, ptr, i64 } poison, ptr %17, 0
  %20 = insertvalue { ptr, ptr, i64 } %19, ptr %18, 1
  %21 = insertvalue { ptr, ptr, i64 } %20, i64 0, 2
  %22 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 2
  %23 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 3, 0
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 3, 1
  %25 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 4, 0
  %26 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 4, 1
  %27 = extractvalue { ptr, ptr, i64 } %21, 0
  %28 = extractvalue { ptr, ptr, i64 } %21, 1
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %27, 0
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, ptr %28, 1
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 0, 2
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 %7, 3, 0
  %33 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, i64 2048, 4, 0
  %34 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, i64 %8, 3, 1
  %35 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, i64 1, 4, 1
  %36 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 0
  %37 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %38 = insertvalue { ptr, ptr, i64 } poison, ptr %36, 0
  %39 = insertvalue { ptr, ptr, i64 } %38, ptr %37, 1
  %40 = insertvalue { ptr, ptr, i64 } %39, i64 0, 2
  %41 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 2
  %42 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 3, 0
  %43 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 3, 1
  %44 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 4, 0
  %45 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 4, 1
  %46 = extractvalue { ptr, ptr, i64 } %40, 0
  %47 = extractvalue { ptr, ptr, i64 } %40, 1
  %48 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %46, 0
  %49 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %48, ptr %47, 1
  %50 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %49, i64 %8, 2
  %51 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %50, i64 %7, 3, 0
  %52 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %51, i64 2048, 4, 0
  %53 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %52, i64 1024, 3, 1
  %54 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %53, i64 1, 4, 1
  br label %55

55:                                               ; preds = %83, %9
  %56 = phi i64 [ %84, %83 ], [ 0, %9 ]
  %57 = icmp slt i64 %56, %7
  br i1 %57, label %58, label %85

58:                                               ; preds = %55
  br label %59

59:                                               ; preds = %62, %58
  %60 = phi i64 [ %82, %62 ], [ 0, %58 ]
  %61 = icmp slt i64 %60, 1024
  br i1 %61, label %62, label %83

62:                                               ; preds = %59
  %63 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %35, 1
  %64 = mul nuw nsw i64 %56, 2048
  %65 = add nuw nsw i64 %64, 0
  %66 = getelementptr inbounds nuw float, ptr %63, i64 %65
  %67 = load float, ptr %66, align 4, !alias.scope !1
  %68 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %54, 1
  %69 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %54, 2
  %70 = getelementptr float, ptr %68, i64 %69
  %71 = mul nuw nsw i64 %56, 2048
  %72 = add nuw nsw i64 %71, %60
  %73 = getelementptr inbounds nuw float, ptr %70, i64 %72
  %74 = load float, ptr %73, align 4, !noalias !1
  %75 = fdiv float %74, %67
  %76 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %54, 1
  %77 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %54, 2
  %78 = getelementptr float, ptr %76, i64 %77
  %79 = mul nuw nsw i64 %56, 2048
  %80 = add nuw nsw i64 %79, %60
  %81 = getelementptr inbounds nuw float, ptr %78, i64 %80
  store float %75, ptr %81, align 4, !noalias !1
  %82 = add i64 %60, 1
  br label %59

83:                                               ; preds = %59
  %84 = add i64 %56, 1
  br label %55

85:                                               ; preds = %55
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
