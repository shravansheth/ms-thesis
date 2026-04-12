; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare void @free(ptr)

declare ptr @malloc(i64)

define void @subview_hoist_static() {
  %1 = call ptr @malloc(i64 4096)
  %2 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %1, 0
  %3 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, ptr %1, 1
  %4 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, i64 0, 2
  %5 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, i64 1024, 3, 0
  %6 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, i64 1, 4, 0
  %7 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %8 = getelementptr inbounds nuw float, ptr %7, i64 0
  store float 0.000000e+00, ptr %8, align 4
  %9 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %10 = getelementptr inbounds nuw float, ptr %9, i64 1
  store float 0.000000e+00, ptr %10, align 4
  br label %11

11:                                               ; preds = %14, %0
  %12 = phi i64 [ %25, %14 ], [ 0, %0 ]
  %13 = icmp slt i64 %12, 512
  br i1 %13, label %14, label %26

14:                                               ; preds = %11
  %15 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %16 = getelementptr inbounds nuw float, ptr %15, i64 1
  %17 = load float, ptr %16, align 4
  %18 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %19 = getelementptr inbounds nuw float, ptr %18, i64 %12
  %20 = load float, ptr %19, align 4
  %21 = fadd float %20, %17
  %22 = add i64 %12, 512
  %23 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %24 = getelementptr inbounds nuw float, ptr %23, i64 %22
  store float %21, ptr %24, align 4
  %25 = add i64 %12, 1
  br label %11

26:                                               ; preds = %11
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  call void @free(ptr %27)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
