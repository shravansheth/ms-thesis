; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

; Oracle: declare @llvm.assume so we can express the precondition n >= 1
declare void @llvm.assume(i1 noundef)

define void @dynamic_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5) {
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %8 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %1, 1
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, i64 %2, 2
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, i64 %3, 3, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %4, 4, 0
  %12 = sub i64 2048, %5
  %13 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %14 = getelementptr inbounds nuw float, ptr %13, i64 0
  store float 1.000000e+00, ptr %14, align 4
  ; Oracle: assert n >= 1 (the structural precondition from the MLIR subview construction).
  ; At the MLIR level: hi starts at offset n, lo covers [0..n-1] — disjoint iff n >= 1.
  ; This assumption tells LLVM: the store at (base + n + i) cannot alias the load at (base + 0),
  ; because n >= 1 implies (n + i) >= 1 > 0 for all i >= 0.
  %n_ge_1 = icmp sge i64 %5, 1
  call void @llvm.assume(i1 %n_ge_1)
  br label %15

15:                                               ; preds = %18, %6
  %16 = phi i64 [ %30, %18 ], [ 0, %6 ]
  %17 = icmp slt i64 %16, %12
  br i1 %17, label %18, label %31

18:                                               ; preds = %15
  %19 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %20 = getelementptr inbounds nuw float, ptr %19, i64 0
  %21 = load float, ptr %20, align 4
  %22 = add i64 %5, %16
  %23 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %24 = getelementptr inbounds nuw float, ptr %23, i64 %22
  %25 = load float, ptr %24, align 4
  %26 = fadd float %25, %21
  %27 = add i64 %5, %16
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %29 = getelementptr inbounds nuw float, ptr %28, i64 %27
  store float %26, ptr %29, align 4
  %30 = add i64 %16, 1
  br label %15

31:                                               ; preds = %15
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
