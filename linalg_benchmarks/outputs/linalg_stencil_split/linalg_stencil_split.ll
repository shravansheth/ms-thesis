; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @linalg_stencil_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %1, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, i64 %2, 2
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %3, 3, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %4, 4, 0
  %12 = sub i64 4096, %5
  br label %13

13:                                               ; preds = %16, %6
  %14 = phi i64 [ %20, %16 ], [ 0, %6 ]
  %15 = icmp slt i64 %14, %12
  br i1 %15, label %16, label %21

16:                                               ; preds = %13
  %17 = add i64 %5, %14
  %18 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %19 = getelementptr inbounds nuw float, ptr %18, i64 %17
  store float 1.000000e+00, ptr %19, align 4
  %20 = add i64 %14, 1
  br label %13

21:                                               ; preds = %13
  br label %22

22:                                               ; preds = %25, %21
  %23 = phi i64 [ %38, %25 ], [ 0, %21 ]
  %24 = icmp slt i64 %23, %5
  br i1 %24, label %25, label %39

25:                                               ; preds = %22
  %26 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %27 = getelementptr inbounds nuw float, ptr %26, i64 %23
  %28 = load float, ptr %27, align 4
  %29 = add i64 %5, %23
  %30 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %31 = getelementptr inbounds nuw float, ptr %30, i64 %29
  %32 = load float, ptr %31, align 4
  %33 = fadd float %32, %28
  %34 = fadd float %33, 1.000000e+00
  %35 = add i64 %5, %23
  %36 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %37 = getelementptr inbounds nuw float, ptr %36, i64 %35
  store float %34, ptr %37, align 4
  %38 = add i64 %23, 1
  br label %22

39:                                               ; preds = %22
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
