; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare void @free(ptr)

declare ptr @malloc(i64)

define void @subview_hoist_derived() {
  %1 = call ptr @malloc(i64 8192)
  %2 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %1, 0
  %3 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, ptr %1, 1
  %4 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, i64 0, 2
  %5 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, i64 2048, 3, 0
  %6 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, i64 1, 4, 0
  br label %7

7:                                                ; preds = %10, %0
  %8 = phi i64 [ %17, %10 ], [ 0, %0 ]
  %9 = icmp slt i64 %8, 256
  br i1 %9, label %10, label %18

10:                                               ; preds = %7
  %11 = add i64 %8, 512
  %12 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %13 = getelementptr inbounds nuw float, ptr %12, i64 %11
  store float 2.000000e+00, ptr %13, align 4
  %14 = add i64 768, %8
  %15 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %16 = getelementptr inbounds nuw float, ptr %15, i64 %14
  store float 0.000000e+00, ptr %16, align 4
  %17 = add i64 %8, 1
  br label %7

18:                                               ; preds = %7
  br label %19

19:                                               ; preds = %22, %18
  %20 = phi i64 [ %34, %22 ], [ 0, %18 ]
  %21 = icmp slt i64 %20, 256
  br i1 %21, label %22, label %35

22:                                               ; preds = %19
  %23 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %24 = getelementptr inbounds nuw float, ptr %23, i64 512
  %25 = load float, ptr %24, align 4
  %26 = add i64 %20, 512
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %28 = getelementptr inbounds nuw float, ptr %27, i64 %26
  %29 = load float, ptr %28, align 4
  %30 = fadd float %29, %25
  %31 = add i64 768, %20
  %32 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %33 = getelementptr inbounds nuw float, ptr %32, i64 %31
  store float %30, ptr %33, align 4
  %34 = add i64 %20, 1
  br label %19

35:                                               ; preds = %19
  %36 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  call void @free(ptr %36)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
