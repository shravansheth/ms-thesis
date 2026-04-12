; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @dynamic_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
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
  %43 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, 1
  %44 = getelementptr inbounds nuw float, ptr %43, i64 0
  store float 1.000000e+00, ptr %44, align 4, !alias.scope !1
  br label %45

45:                                               ; preds = %48, %6
  %46 = phi i64 [ %62, %48 ], [ 0, %6 ]
  %47 = icmp slt i64 %46, %12
  br i1 %47, label %48, label %63

48:                                               ; preds = %45
  %49 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, 1
  %50 = getelementptr inbounds nuw float, ptr %49, i64 0
  %51 = load float, ptr %50, align 4, !alias.scope !1
  %52 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %53 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %54 = getelementptr float, ptr %52, i64 %53
  %55 = getelementptr inbounds nuw float, ptr %54, i64 %46
  %56 = load float, ptr %55, align 4, !noalias !1
  %57 = fadd float %56, %51
  %58 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 1
  %59 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, 2
  %60 = getelementptr float, ptr %58, i64 %59
  %61 = getelementptr inbounds nuw float, ptr %60, i64 %46
  store float %57, ptr %61, align 4, !noalias !1
  %62 = add i64 %46, 1
  br label %45

63:                                               ; preds = %45
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
