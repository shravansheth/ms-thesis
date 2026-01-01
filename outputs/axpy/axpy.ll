; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @axpy(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9) {
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %5, 0
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, ptr %6, 1
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, i64 %7, 2
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, i64 %8, 3, 0
  %15 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, i64 %9, 4, 0
  %16 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %0, 0
  %17 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, ptr %1, 1
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, i64 %2, 2
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, i64 %3, 3, 0
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 %4, 4, 0
  br label %21

21:                                               ; preds = %24, %10
  %22 = phi i64 [ %35, %24 ], [ 0, %10 ]
  %23 = icmp slt i64 %22, 1024
  br i1 %23, label %24, label %36

24:                                               ; preds = %21
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, 1
  %26 = getelementptr float, ptr %25, i64 %22
  %27 = load float, ptr %26, align 4
  %28 = fmul float %27, 2.000000e+00
  %29 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %30 = getelementptr float, ptr %29, i64 %22
  %31 = load float, ptr %30, align 4
  %32 = fadd float %31, %28
  %33 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %34 = getelementptr float, ptr %33, i64 %22
  store float %32, ptr %34, align 4
  %35 = add i64 %22, 1
  br label %21

36:                                               ; preds = %21
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
