; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @column_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7, i64 %8) {
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %0, 0
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, ptr %1, 1
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 %2, 2
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 %3, 3, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 %5, 4, 0
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 %4, 3, 1
  %16 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, i64 %6, 4, 1
  %17 = sub i64 1024, %8
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %19 = getelementptr inbounds nuw float, ptr %18, i64 0
  store float 1.000000e+00, ptr %19, align 4
  br label %20

20:                                               ; preds = %44, %9
  %21 = phi i64 [ %45, %44 ], [ 0, %9 ]
  %22 = icmp slt i64 %21, %7
  br i1 %22, label %23, label %46

23:                                               ; preds = %20
  br label %24

24:                                               ; preds = %27, %23
  %25 = phi i64 [ %43, %27 ], [ 0, %23 ]
  %26 = icmp slt i64 %25, %17
  br i1 %26, label %27, label %44

27:                                               ; preds = %24
  %28 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %29 = getelementptr inbounds nuw float, ptr %28, i64 0
  %30 = load float, ptr %29, align 4
  %31 = add i64 %8, %25
  %32 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %33 = mul nuw nsw i64 %21, 1024
  %34 = add nuw nsw i64 %33, %31
  %35 = getelementptr inbounds nuw float, ptr %32, i64 %34
  %36 = load float, ptr %35, align 4
  %37 = fadd float %36, %30
  %38 = add i64 %8, %25
  %39 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %40 = mul nuw nsw i64 %21, 1024
  %41 = add nuw nsw i64 %40, %38
  %42 = getelementptr inbounds nuw float, ptr %39, i64 %41
  store float %37, ptr %42, align 4
  %43 = add i64 %25, 1
  br label %24

44:                                               ; preds = %24
  %45 = add i64 %21, 1
  br label %20

46:                                               ; preds = %20
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
