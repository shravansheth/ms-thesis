; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @split_accumulate(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %1, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, i64 %2, 2
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %3, 3, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %4, 4, 0
  %12 = sub i64 2048, %5
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
  %43 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %44 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %45 = getelementptr float, ptr %43, i64 %44
  %46 = getelementptr inbounds nuw float, ptr %45, i64 0
  store float 1.000000e+00, ptr %46, align 4, !noalias !1
  br label %47

47:                                               ; preds = %50, %6
  %48 = phi i64 [ %62, %50 ], [ 0, %6 ]
  %49 = icmp slt i64 %48, %5
  br i1 %49, label %50, label %63

50:                                               ; preds = %47
  %51 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %52 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %53 = getelementptr float, ptr %51, i64 %52
  %54 = getelementptr inbounds nuw float, ptr %53, i64 0
  %55 = load float, ptr %54, align 4, !noalias !1
  %56 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, 1
  %57 = getelementptr inbounds nuw float, ptr %56, i64 %48
  %58 = load float, ptr %57, align 4, !alias.scope !1
  %59 = fadd float %58, %55
  %60 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, 1
  %61 = getelementptr inbounds nuw float, ptr %60, i64 %48
  store float %59, ptr %61, align 4, !alias.scope !1
  %62 = add i64 %48, 1
  br label %47

63:                                               ; preds = %47
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
