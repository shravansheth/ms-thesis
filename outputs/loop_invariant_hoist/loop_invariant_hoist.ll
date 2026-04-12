; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @loop_invariant_hoist(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, ptr %10, ptr %11, i64 %12, i64 %13, i64 %14, i64 %15) {
  %17 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %10, 0
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, ptr %11, 1
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, i64 %12, 2
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 %13, 3, 0
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 %14, 4, 0
  %22 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, ptr %6, 1
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, i64 %7, 2
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, i64 %8, 3, 0
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 %9, 4, 0
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, ptr %1, 1
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, i64 %2, 2
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, i64 %3, 3, 0
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, i64 %4, 4, 0
  br label %32

32:                                               ; preds = %51, %16
  %33 = phi i64 [ %52, %51 ], [ 0, %16 ]
  %34 = icmp slt i64 %33, %15
  br i1 %34, label %35, label %53

35:                                               ; preds = %32
  %36 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, 1
  %37 = getelementptr inbounds nuw float, ptr %36, i64 %33
  %38 = load float, ptr %37, align 4
  br label %39

39:                                               ; preds = %42, %35
  %40 = phi i64 [ %50, %42 ], [ 0, %35 ]
  %41 = icmp slt i64 %40, %15
  br i1 %41, label %42, label %51

42:                                               ; preds = %39
  %43 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, 1
  %44 = getelementptr inbounds nuw float, ptr %43, i64 %40
  %45 = load float, ptr %44, align 4
  %46 = fmul float %38, %45
  %47 = fadd float %46, 0.000000e+00
  %48 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %49 = getelementptr inbounds nuw float, ptr %48, i64 %40
  store float %47, ptr %49, align 4
  %50 = add i64 %40, 1
  br label %39

51:                                               ; preds = %39
  %52 = add i64 %33, 1
  br label %32

53:                                               ; preds = %32
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
