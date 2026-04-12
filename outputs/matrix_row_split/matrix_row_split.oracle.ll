; Oracle for matrix_row_split.ll
;
; 2D matrix split at row %m into top (rows [0,m)) and bot (rows [m,2m)).
; Structural disjointness: bot.row_offset (%m) == top.row_size (%m).
; Flat: top[i][j] = base + i*512 + j,  bot[i][j] = base + (m+i)*512 + j.
;
; LLVM cannot prove top and bot are disjoint: it sees loads from (base + 0)
; and (base + i*512 + j) vs stores to (base + (m+i)*512 + j). Without knowing
; m >= 1, it cannot rule out aliasing when i=0, j=0: (m+0)*512+0 = m*512,
; which equals 0 only if m=0 — but LLVM has no basis to assume m >= 1.
;
; Oracle: alias.scope on the two top[] loads, noalias on the bot[] store.
; This encodes the MLIR structural proof that top and bot are disjoint partitions.
;
; Expected LICM: invariant load top[0][0] (= base+0) hoisted out of both loops.

; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @matrix_row_split(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7) {
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %0, 0
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, ptr %1, 1
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 %2, 2
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 %3, 3, 0
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 %5, 4, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 %4, 3, 1
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 %6, 4, 1
  %16 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %17 = getelementptr inbounds nuw float, ptr %16, i64 0
  store float 1.000000e+00, ptr %17, align 4
  br label %18

18:                                               ; preds = %41, %8
  %19 = phi i64 [ %42, %41 ], [ 0, %8 ]
  %20 = icmp slt i64 %19, %7
  br i1 %20, label %21, label %43

21:                                               ; preds = %18
  br label %22

22:                                               ; preds = %25, %21
  %23 = phi i64 [ %40, %25 ], [ 0, %21 ]
  %24 = icmp slt i64 %23, 512
  br i1 %24, label %25, label %41

25:                                               ; preds = %22
  %26 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %27 = getelementptr inbounds nuw float, ptr %26, i64 0
  ; top[0][0]: invariant load — tagged with top scope so LICM can hoist it.
  %28 = load float, ptr %27, align 4, !alias.scope !2
  %29 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %30 = mul nuw nsw i64 %19, 512
  %31 = add nuw nsw i64 %30, %23
  %32 = getelementptr inbounds nuw float, ptr %29, i64 %31
  ; top[i][j]: variant load — also in top scope (same region as top[0][0]).
  %33 = load float, ptr %32, align 4, !alias.scope !2
  %34 = fadd float %33, %28
  %35 = add i64 %7, %19
  %36 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %37 = mul nuw nsw i64 %35, 512
  %38 = add nuw nsw i64 %37, %23
  %39 = getelementptr inbounds nuw float, ptr %36, i64 %38
  ; bot[i][j]: store — does NOT alias any load in top scope.
  store float %34, ptr %39, align 4, !noalias !2
  %40 = add i64 %23, 1
  br label %22

41:                                               ; preds = %22
  %42 = add i64 %19, 1
  br label %18

43:                                               ; preds = %18
  ret void
}

!llvm.module.flags = !{!0}
!0 = !{i32 2, !"Debug Info Version", i32 3}

; Alias scope hierarchy for the top subview region:
!1 = distinct !{!1, !"matrix_row_split:top_domain"}
!3 = distinct !{!3, !1, !"matrix_row_split:top_scope"}
!2 = !{!3}
