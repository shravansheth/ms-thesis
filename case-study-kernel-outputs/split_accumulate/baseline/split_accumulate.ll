; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @split_accumulate(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %1, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, i64 %2, 2
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %3, 3, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %4, 4, 0
  %12 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %13 = getelementptr inbounds nuw float, ptr %12, i64 %5
  store float 1.000000e+00, ptr %13, align 4
  br label %14

14:                                               ; preds = %17, %6
  %15 = phi i64 [ %27, %17 ], [ 0, %6 ]
  %16 = icmp slt i64 %15, %5
  br i1 %16, label %17, label %28

17:                                               ; preds = %14
  %18 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %19 = getelementptr inbounds nuw float, ptr %18, i64 %5
  %20 = load float, ptr %19, align 4
  %21 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %22 = getelementptr inbounds nuw float, ptr %21, i64 %15
  %23 = load float, ptr %22, align 4
  %24 = fadd float %23, %20
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %26 = getelementptr inbounds nuw float, ptr %25, i64 %15
  store float %24, ptr %26, align 4
  %27 = add i64 %15, 1
  br label %14

28:                                               ; preds = %14
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
