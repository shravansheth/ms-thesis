; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @hoist_candidate(
    ptr noalias %0, ptr noalias %1, i64 %2, i64 %3, i64 %4,
    ptr noalias %5, ptr noalias %6, i64 %7, i64 %8, i64 %9) {
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
  %22 = phi i64 [ %34, %24 ], [ 0, %10 ]
  %23 = icmp slt i64 %22, 1024
  br i1 %23, label %24, label %35

24:                                               ; preds = %21
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, 1
  %26 = getelementptr float, ptr %25, i64 0
  %27 = load float, ptr %26, align 4
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %29 = getelementptr float, ptr %28, i64 %22
  %30 = load float, ptr %29, align 4
  %31 = fadd float %30, %27
  %32 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %33 = getelementptr float, ptr %32, i64 %22
  store float %31, ptr %33, align 4
  %34 = add i64 %22, 1
  br label %21

35:                                               ; preds = %21
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
