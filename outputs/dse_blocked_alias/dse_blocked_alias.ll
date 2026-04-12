; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @dse_blocked_alias(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9) {
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
  %22 = phi i64 [ %33, %24 ], [ 0, %10 ]
  %23 = icmp slt i64 %22, 512
  br i1 %23, label %24, label %34

24:                                               ; preds = %21
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %26 = getelementptr inbounds nuw float, ptr %25, i64 %22
  store float 0.000000e+00, ptr %26, align 4
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, 1
  %28 = getelementptr inbounds nuw float, ptr %27, i64 %22
  %29 = load float, ptr %28, align 4
  %30 = fmul float %29, %29
  %31 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %32 = getelementptr inbounds nuw float, ptr %31, i64 %22
  store float %30, ptr %32, align 4
  %33 = add i64 %22, 1
  br label %21

34:                                               ; preds = %21
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
