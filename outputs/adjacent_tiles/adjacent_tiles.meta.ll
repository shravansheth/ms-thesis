; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @adjacent_tiles(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6) {
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
  br label %45

45:                                               ; preds = %48, %7
  %46 = phi i64 [ %64, %48 ], [ 0, %7 ]
  %47 = icmp slt i64 %46, %6
  br i1 %47, label %48, label %65

48:                                               ; preds = %45
  %49 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 1
  %50 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 2
  %51 = getelementptr float, ptr %49, i64 %50
  %52 = getelementptr inbounds nuw float, ptr %51, i64 0
  %53 = load float, ptr %52, align 4, !alias.scope !1
  %54 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 1
  %55 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 2
  %56 = getelementptr float, ptr %54, i64 %55
  %57 = getelementptr inbounds nuw float, ptr %56, i64 %46
  %58 = load float, ptr %57, align 4, !alias.scope !1
  %59 = fadd float %58, %53
  %60 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, 1
  %61 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, 2
  %62 = getelementptr float, ptr %60, i64 %61
  %63 = getelementptr inbounds nuw float, ptr %62, i64 %46
  store float %59, ptr %63, align 4, !noalias !1
  %64 = add i64 %46, 1
  br label %45

65:                                               ; preds = %45
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
