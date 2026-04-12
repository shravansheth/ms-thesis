; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare void @free(ptr)

declare ptr @malloc(i64)

define void @kernel(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9) {
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, ptr %6, 1
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, i64 %7, 2
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, i64 %8, 3, 0
  %15 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, i64 %9, 4, 0
  %16 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %17 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, ptr %1, 1
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, i64 %2, 2
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, i64 %3, 3, 0
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 %4, 4, 0
  br label %21

21:                                               ; preds = %24, %10
  %22 = phi i64 [ %40, %24 ], [ 0, %10 ]
  %23 = icmp slt i64 %22, 512
  br i1 %23, label %24, label %41

24:                                               ; preds = %21
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %26 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 2
  %27 = getelementptr float, ptr %25, i64 %26
  %28 = getelementptr inbounds nuw float, ptr %27, i64 0
  %29 = load float, ptr %28, align 4, !alias.scope !1
  %30 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %31 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 2
  %32 = getelementptr float, ptr %30, i64 %31
  %33 = getelementptr inbounds nuw float, ptr %32, i64 %22
  %34 = load float, ptr %33, align 4, !alias.scope !1
  %35 = fadd float %34, %29
  %36 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, 1
  %37 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, 2
  %38 = getelementptr float, ptr %36, i64 %37
  %39 = getelementptr inbounds nuw float, ptr %38, i64 %22
  store float %35, ptr %39, align 4, !noalias !1
  %40 = add i64 %22, 1
  br label %21

41:                                               ; preds = %21
  ret void
}

define void @caller() {
  %1 = call ptr @malloc(i64 4096)
  %2 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %1, 0
  %3 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, ptr %1, 1
  %4 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, i64 0, 2
  %5 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, i64 1024, 3, 0
  %6 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, i64 1, 4, 0
  %7 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  %8 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %7, 0
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, ptr %8, 1
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 0, 2
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, i64 512, 3, 0
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, i64 1, 4, 0
  %14 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  %15 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %16 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %14, 0
  %17 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, ptr %15, 1
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, i64 512, 2
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, i64 512, 3, 0
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 1, 4, 0
  %21 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, 1
  %22 = getelementptr inbounds nuw float, ptr %21, i64 0
  store float 1.000000e+00, ptr %22, align 4, !alias.scope !1
  %23 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, 0
  %24 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, 1
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, 2
  %26 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, 3, 0
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, 4, 0
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 0
  %29 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %30 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 2
  %31 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 3, 0
  %32 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 4, 0
  call void @kernel(ptr %23, ptr %24, i64 %25, i64 %26, i64 %27, ptr %28, ptr %29, i64 %30, i64 %31, i64 %32) #0
  %33 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  call void @free(ptr %33)
  ret void
}

attributes #0 = { noinline }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
