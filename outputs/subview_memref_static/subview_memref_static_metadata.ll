; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare void @free(ptr)

declare ptr @malloc(i64)

define void @subview_hoist_static() {
  %1 = call ptr @malloc(i64 ptrtoint (ptr getelementptr (float, ptr null, i64 1024) to i64))
  %2 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %1, 0
  %3 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, ptr %1, 1
  %4 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, i64 0, 2
  %5 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, i64 1024, 3, 0
  %6 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, i64 1, 4, 0
  %7 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %8 = getelementptr float, ptr %7, i64 0
  store float 0.000000e+00, ptr %8, align 4
  br label %9

9:                                                ; preds = %12, %0
  %10 = phi i64 [ %23, %12 ], [ 0, %0 ]
  %11 = icmp slt i64 %10, 512
  br i1 %11, label %12, label %24

12:                                               ; preds = %9
  %13 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %14 = getelementptr float, ptr %13, i64 0
  %15 = load float, ptr %14, align 4, !alias.scope !{!2}, !noalias !{!3}
  %16 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %17 = getelementptr float, ptr %16, i64 %10
  %18 = load float, ptr %17, align 4
  %19 = fadd float %18, %15
  %20 = add i64 %10, 512
  %21 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %22 = getelementptr float, ptr %21, i64 %20
  store float %19, ptr %22, align 4, !alias.scope !{!3}, !noalias !{!2}
  %23 = add i64 %10, 1
  br label %9

24:                                               ; preds = %9
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  call void @free(ptr %25)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}

!1 = distinct !{!"subview.domain"}
!2 = distinct !{!"subview.r0", !1}
!3 = distinct !{!"subview.r1", !1}

!scope.r0 = !{!2}
!scope.r1 = !{!3}
