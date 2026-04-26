; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @three_way_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %1, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, i64 %2, 2
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %3, 3, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %4, 4, 0
  %12 = add i64 %5, %5
  %13 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %14 = getelementptr inbounds nuw float, ptr %13, i64 0
  store float 1.000000e+00, ptr %14, align 4
  %15 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %16 = getelementptr inbounds nuw float, ptr %15, i64 %5
  store float 2.000000e+00, ptr %16, align 4
  br label %17

17:                                               ; preds = %20, %6
  %18 = phi i64 [ %32, %20 ], [ 0, %6 ]
  %19 = icmp slt i64 %18, %5
  br i1 %19, label %20, label %33

20:                                               ; preds = %17
  %21 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %22 = getelementptr inbounds nuw float, ptr %21, i64 0
  %23 = load float, ptr %22, align 4
  %24 = add i64 %5, %18
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %26 = getelementptr inbounds nuw float, ptr %25, i64 %24
  %27 = load float, ptr %26, align 4
  %28 = fadd float %27, %23
  %29 = add i64 %5, %18
  %30 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %31 = getelementptr inbounds nuw float, ptr %30, i64 %29
  store float %28, ptr %31, align 4
  %32 = add i64 %18, 1
  br label %17

33:                                               ; preds = %17
  br label %34

34:                                               ; preds = %37, %33
  %35 = phi i64 [ %49, %37 ], [ 0, %33 ]
  %36 = icmp slt i64 %35, %5
  br i1 %36, label %37, label %50

37:                                               ; preds = %34
  %38 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %39 = getelementptr inbounds nuw float, ptr %38, i64 %5
  %40 = load float, ptr %39, align 4
  %41 = add i64 %12, %35
  %42 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %43 = getelementptr inbounds nuw float, ptr %42, i64 %41
  %44 = load float, ptr %43, align 4
  %45 = fadd float %44, %40
  %46 = add i64 %12, %35
  %47 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %48 = getelementptr inbounds nuw float, ptr %47, i64 %46
  store float %45, ptr %48, align 4
  %49 = add i64 %35, 1
  br label %34

50:                                               ; preds = %34
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
