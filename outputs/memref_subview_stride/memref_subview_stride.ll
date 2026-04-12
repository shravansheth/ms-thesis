; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare void @free(ptr)

declare ptr @malloc(i64)

define void @case_stride_even_odd() {
  %1 = call ptr @malloc(i64 8192)
  %2 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %1, 0
  %3 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, ptr %1, 1
  %4 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, i64 0, 2
  %5 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, i64 2048, 3, 0
  %6 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, i64 1, 4, 0
  %7 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %8 = getelementptr inbounds nuw float, ptr %7, i64 512
  store float 2.000000e+00, ptr %8, align 4
  br label %9

9:                                                ; preds = %12, %0
  %10 = phi i64 [ %26, %12 ], [ 0, %0 ]
  %11 = icmp slt i64 %10, 256
  br i1 %11, label %12, label %27

12:                                               ; preds = %9
  %13 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %14 = getelementptr inbounds nuw float, ptr %13, i64 512
  %15 = load float, ptr %14, align 4
  %16 = mul nsw i64 %10, 2
  %17 = add i64 %16, 512
  %18 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %19 = getelementptr inbounds nuw float, ptr %18, i64 %17
  %20 = load float, ptr %19, align 4
  %21 = fadd float %20, %15
  %22 = mul nsw i64 %10, 2
  %23 = add i64 %22, 513
  %24 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %25 = getelementptr inbounds nuw float, ptr %24, i64 %23
  store float %21, ptr %25, align 4
  %26 = add i64 %10, 1
  br label %9

27:                                               ; preds = %9
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  call void @free(ptr %28)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
