; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @three_way_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %1, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, i64 %2, 2
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %3, 3, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %4, 4, 0
  %12 = add i64 %5, %5
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
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, i64 %5, 3, 0
  %42 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, i64 1, 4, 0
  %43 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 0
  %44 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %45 = insertvalue { ptr, ptr, i64 } poison, ptr %43, 0
  %46 = insertvalue { ptr, ptr, i64 } %45, ptr %44, 1
  %47 = insertvalue { ptr, ptr, i64 } %46, i64 0, 2
  %48 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 2
  %49 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 3, 0
  %50 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 4, 0
  %51 = extractvalue { ptr, ptr, i64 } %47, 0
  %52 = extractvalue { ptr, ptr, i64 } %47, 1
  %53 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %51, 0
  %54 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, ptr %52, 1
  %55 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, i64 %12, 2
  %56 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %55, i64 %5, 3, 0
  %57 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %56, i64 1, 4, 0
  %58 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, 1
  %59 = getelementptr inbounds nuw float, ptr %58, i64 0
  store float 1.000000e+00, ptr %59, align 4, !alias.scope !1
  %60 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %61 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %62 = getelementptr float, ptr %60, i64 %61
  %63 = getelementptr inbounds nuw float, ptr %62, i64 0
  store float 2.000000e+00, ptr %63, align 4, !alias.scope !4
  br label %64

64:                                               ; preds = %67, %6
  %65 = phi i64 [ %81, %67 ], [ 0, %6 ]
  %66 = icmp slt i64 %65, %5
  br i1 %66, label %67, label %82

67:                                               ; preds = %64
  %68 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, 1
  %69 = getelementptr inbounds nuw float, ptr %68, i64 0
  %70 = load float, ptr %69, align 4, !alias.scope !1
  %71 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %72 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %73 = getelementptr float, ptr %71, i64 %72
  %74 = getelementptr inbounds nuw float, ptr %73, i64 %65
  %75 = load float, ptr %74, align 4, !alias.scope !4
  %76 = fadd float %75, %70
  %77 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %78 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %79 = getelementptr float, ptr %77, i64 %78
  %80 = getelementptr inbounds nuw float, ptr %79, i64 %65
  store float %76, ptr %80, align 4, !alias.scope !4
  %81 = add i64 %65, 1
  br label %64

82:                                               ; preds = %64
  br label %83

83:                                               ; preds = %86, %82
  %84 = phi i64 [ %102, %86 ], [ 0, %82 ]
  %85 = icmp slt i64 %84, %5
  br i1 %85, label %86, label %103

86:                                               ; preds = %83
  %87 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %88 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %89 = getelementptr float, ptr %87, i64 %88
  %90 = getelementptr inbounds nuw float, ptr %89, i64 0
  %91 = load float, ptr %90, align 4, !alias.scope !4
  %92 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, 1
  %93 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, 2
  %94 = getelementptr float, ptr %92, i64 %93
  %95 = getelementptr inbounds nuw float, ptr %94, i64 %84
  %96 = load float, ptr %95, align 4, !noalias !4
  %97 = fadd float %96, %91
  %98 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, 1
  %99 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, 2
  %100 = getelementptr float, ptr %98, i64 %99
  %101 = getelementptr inbounds nuw float, ptr %100, i64 %84
  store float %97, ptr %101, align 4, !noalias !4
  %102 = add i64 %84, 1
  br label %83

103:                                              ; preds = %83
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
!4 = !{!5}
!5 = distinct !{!5, !6, !"pair_1_lo"}
!6 = distinct !{!6, !"pair_1_domain"}
