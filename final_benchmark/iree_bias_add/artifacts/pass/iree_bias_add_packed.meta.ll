; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @iree_bias_add_packed(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10, i64 %11) {
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, ptr %6, 1
  %15 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, i64 %7, 2
  %16 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, i64 %8, 3, 0
  %17 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, i64 %9, 4, 0
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, ptr %1, 1
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 %2, 2
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 %3, 3, 0
  %22 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, i64 %4, 4, 0
  %23 = mul i64 %10, %11
  %24 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 0
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 1
  %26 = insertvalue { ptr, ptr, i64 } poison, ptr %24, 0
  %27 = insertvalue { ptr, ptr, i64 } %26, ptr %25, 1
  %28 = insertvalue { ptr, ptr, i64 } %27, i64 0, 2
  %29 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 2
  %30 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 3, 0
  %31 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 4, 0
  %32 = extractvalue { ptr, ptr, i64 } %28, 0
  %33 = extractvalue { ptr, ptr, i64 } %28, 1
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %32, 0
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, ptr %33, 1
  %36 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, i64 0, 2
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, i64 %11, 3, 0
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, i64 1, 4, 0
  %39 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 0
  %40 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 1
  %41 = insertvalue { ptr, ptr, i64 } poison, ptr %39, 0
  %42 = insertvalue { ptr, ptr, i64 } %41, ptr %40, 1
  %43 = insertvalue { ptr, ptr, i64 } %42, i64 0, 2
  %44 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 2
  %45 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 3, 0
  %46 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 4, 0
  %47 = extractvalue { ptr, ptr, i64 } %43, 0
  %48 = extractvalue { ptr, ptr, i64 } %43, 1
  %49 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %47, 0
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %49, ptr %48, 1
  %51 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, i64 %11, 2
  %52 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, i64 %23, 3, 0
  %53 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %52, i64 1, 4, 0
  br label %54

54:                                               ; preds = %76, %12
  %55 = phi i64 [ %77, %76 ], [ 0, %12 ]
  %56 = icmp slt i64 %55, %11
  br i1 %56, label %57, label %78

57:                                               ; preds = %54
  br label %58

58:                                               ; preds = %61, %57
  %59 = phi i64 [ %75, %61 ], [ 0, %57 ]
  %60 = icmp slt i64 %59, %10
  br i1 %60, label %61, label %76

61:                                               ; preds = %58
  %62 = mul i64 %59, %11
  %63 = add i64 %62, %55
  %64 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, 1
  %65 = getelementptr inbounds nuw float, ptr %64, i64 %55
  %66 = load float, ptr %65, align 4, !alias.scope !1
  %67 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, 1
  %68 = getelementptr inbounds nuw float, ptr %67, i64 %63
  %69 = load float, ptr %68, align 4
  %70 = fadd float %69, %66
  %71 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, 1
  %72 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, 2
  %73 = getelementptr float, ptr %71, i64 %72
  %74 = getelementptr inbounds nuw float, ptr %73, i64 %63
  store float %70, ptr %74, align 4, !noalias !1
  %75 = add i64 %59, 1
  br label %58

76:                                               ; preds = %58
  %77 = add i64 %55, 1
  br label %54

78:                                               ; preds = %54
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
