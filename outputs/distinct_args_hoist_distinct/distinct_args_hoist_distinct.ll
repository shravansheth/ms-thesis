; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @distinct_args_hoist_distinct(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9) {
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
  %21 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %22 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, 1
  call void @llvm.assume(i1 true) [ "separate_storage"(ptr %21, ptr %22) ]
  br label %23

23:                                               ; preds = %26, %10
  %24 = phi i64 [ %36, %26 ], [ 0, %10 ]
  %25 = icmp slt i64 %24, 512
  br i1 %25, label %26, label %37

26:                                               ; preds = %23
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, 1
  %28 = getelementptr inbounds nuw float, ptr %27, i64 0
  %29 = load float, ptr %28, align 4
  %30 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %31 = getelementptr inbounds nuw float, ptr %30, i64 %24
  %32 = load float, ptr %31, align 4
  %33 = fadd float %32, %29
  %34 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, 1
  %35 = getelementptr inbounds nuw float, ptr %34, i64 %24
  store float %33, ptr %35, align 4
  %36 = add i64 %24, 1
  br label %23

37:                                               ; preds = %23
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #0

attributes #0 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
