; ModuleID = 'bench_outputs/vectorize_split/baseline/vectorize_split.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define void @vectorize_split(ptr readnone captures(none) %0, ptr captures(none) initializes((0, 4)) %1, i64 %2, i64 %3, i64 %4, i64 %5) local_unnamed_addr #0 {
  store float 1.000000e+00, ptr %1, align 4
  %7 = getelementptr float, ptr %1, i64 %5
  br label %8

8:                                                ; preds = %6, %8
  %9 = phi i64 [ 0, %6 ], [ %14, %8 ]
  %10 = load float, ptr %1, align 4
  %11 = getelementptr float, ptr %7, i64 %9
  %12 = load float, ptr %11, align 4
  %13 = fadd float %10, %12
  store float %13, ptr %11, align 4
  %14 = add nuw nsw i64 %9, 1
  %15 = icmp samesign ult i64 %9, 1048575
  br i1 %15, label %8, label %16

16:                                               ; preds = %8
  ret void
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
