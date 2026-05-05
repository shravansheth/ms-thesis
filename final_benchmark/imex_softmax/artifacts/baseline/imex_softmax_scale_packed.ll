; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @imex_softmax_scale_packed(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7, i64 %8) {
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %0, 0
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, ptr %1, 1
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 %2, 2
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 %3, 3, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 %5, 4, 0
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 %4, 3, 1
  %16 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, i64 %6, 4, 1
  br label %17

17:                                               ; preds = %43, %9
  %18 = phi i64 [ %44, %43 ], [ 0, %9 ]
  %19 = icmp slt i64 %18, %7
  br i1 %19, label %20, label %45

20:                                               ; preds = %17
  br label %21

21:                                               ; preds = %24, %20
  %22 = phi i64 [ %42, %24 ], [ 0, %20 ]
  %23 = icmp slt i64 %22, 1024
  br i1 %23, label %24, label %43

24:                                               ; preds = %21
  %25 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %26 = mul nuw nsw i64 %18, 2048
  %27 = add nuw nsw i64 %26, 0
  %28 = getelementptr inbounds nuw float, ptr %25, i64 %27
  %29 = load float, ptr %28, align 4
  %30 = add i64 %8, %22
  %31 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %32 = mul nuw nsw i64 %18, 2048
  %33 = add nuw nsw i64 %32, %30
  %34 = getelementptr inbounds nuw float, ptr %31, i64 %33
  %35 = load float, ptr %34, align 4
  %36 = fdiv float %35, %29
  %37 = add i64 %8, %22
  %38 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %39 = mul nuw nsw i64 %18, 2048
  %40 = add nuw nsw i64 %39, %37
  %41 = getelementptr inbounds nuw float, ptr %38, i64 %40
  store float %36, ptr %41, align 4
  %42 = add i64 %22, 1
  br label %21

43:                                               ; preds = %21
  %44 = add i64 %18, 1
  br label %17

45:                                               ; preds = %17
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
