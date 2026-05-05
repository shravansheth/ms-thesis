; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @double_invariant(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %1, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, i64 %2, 2
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %3, 3, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %4, 4, 0
  %12 = sub i64 2048, %5
  %13 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %14 = getelementptr inbounds nuw float, ptr %13, i64 0
  store float 1.000000e+00, ptr %14, align 4
  %15 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %16 = getelementptr inbounds nuw float, ptr %15, i64 1
  store float 2.000000e+00, ptr %16, align 4
  br label %17

17:                                               ; preds = %20, %6
  %18 = phi i64 [ %36, %20 ], [ 0, %6 ]
  %19 = icmp slt i64 %18, %12
  br i1 %19, label %20, label %37

20:                                               ; preds = %17
  %21 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %22 = getelementptr inbounds nuw float, ptr %21, i64 0
  %23 = load float, ptr %22, align 4
  %24 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %25 = getelementptr inbounds nuw float, ptr %24, i64 1
  %26 = load float, ptr %25, align 4
  %27 = add i64 %5, %18
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %29 = getelementptr inbounds nuw float, ptr %28, i64 %27
  %30 = load float, ptr %29, align 4
  %31 = fadd float %30, %23
  %32 = fadd float %31, %26
  %33 = add i64 %5, %18
  %34 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %35 = getelementptr inbounds nuw float, ptr %34, i64 %33
  store float %32, ptr %35, align 4
  %36 = add i64 %18, 1
  br label %17

37:                                               ; preds = %17
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
