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
  br label %23

23:                                               ; preds = %44, %12
  %24 = phi i64 [ %45, %44 ], [ 0, %12 ]
  %25 = icmp slt i64 %24, %11
  br i1 %25, label %26, label %46

26:                                               ; preds = %23
  br label %27

27:                                               ; preds = %30, %26
  %28 = phi i64 [ %43, %30 ], [ 0, %26 ]
  %29 = icmp slt i64 %28, %10
  br i1 %29, label %30, label %44

30:                                               ; preds = %27
  %31 = mul i64 %28, %11
  %32 = add i64 %31, %24
  %33 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 1
  %34 = getelementptr inbounds nuw float, ptr %33, i64 %24
  %35 = load float, ptr %34, align 4
  %36 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, 1
  %37 = getelementptr inbounds nuw float, ptr %36, i64 %32
  %38 = load float, ptr %37, align 4
  %39 = fadd float %38, %35
  %40 = add i64 %11, %32
  %41 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, 1
  %42 = getelementptr inbounds nuw float, ptr %41, i64 %40
  store float %39, ptr %42, align 4
  %43 = add i64 %28, 1
  br label %27

44:                                               ; preds = %27
  %45 = add i64 %24, 1
  br label %23

46:                                               ; preds = %23
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
