; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @adjacent_tiles(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6) {
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, ptr %1, 1
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %2, 2
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %3, 3, 0
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, i64 %4, 4, 0
  %13 = mul i64 %5, %6
  %14 = add i64 %13, %6
  br label %15

15:                                               ; preds = %18, %7
  %16 = phi i64 [ %30, %18 ], [ 0, %7 ]
  %17 = icmp slt i64 %16, %6
  br i1 %17, label %18, label %31

18:                                               ; preds = %15
  %19 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 1
  %20 = getelementptr inbounds nuw float, ptr %19, i64 %13
  %21 = load float, ptr %20, align 4
  %22 = add i64 %13, %16
  %23 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 1
  %24 = getelementptr inbounds nuw float, ptr %23, i64 %22
  %25 = load float, ptr %24, align 4
  %26 = fadd float %25, %21
  %27 = add i64 %14, %16
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, 1
  %29 = getelementptr inbounds nuw float, ptr %28, i64 %27
  store float %26, ptr %29, align 4
  %30 = add i64 %16, 1
  br label %15

31:                                               ; preds = %15
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
