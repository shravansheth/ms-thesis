; Manual oracle for dynamic_split.ll
;
; The baseline IR misses LICM/GVN because LLVM cannot prove that
; the store to hi[i] = base + n + i  does not alias the load from lo[0] = base + 0,
; since n is a runtime value with no known lower bound.
;
; Oracle fix: add !alias.scope / !noalias metadata to encode the MLIR structural fact:
;   lo = A[0 .. n-1] and hi = A[n .. 2047] are disjoint by construction (n >= 1).
;
; These scopes represent what our future MLIR->LLVM alias-metadata pass would emit
; when it recognises two non-overlapping subviews of the same base memref.
;
; The load from lo[0] is tagged with !alias.scope !{!lo_scope},
; and all stores to hi are tagged with !noalias !{!lo_scope}.
; This tells LLVM: "hi stores never alias lo loads" — enabling LICM to hoist.
;
; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

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
  br label %15

15:                                               ; preds = %18, %6
  %16 = phi i64 [ %30, %18 ], [ 0, %6 ]
  %17 = icmp slt i64 %16, %12
  br i1 %17, label %18, label %31

18:                                               ; preds = %15
  ; lo[0] load — tagged as belonging to the "lo" alias scope.
  ; Our pass would emit this scope whenever it lowers a load through
  ; a subview that was statically proven disjoint from other subviews in MLIR.
  %19 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %20 = getelementptr inbounds nuw float, ptr %19, i64 0
  %21 = load float, ptr %20, align 4, !alias.scope !2

  ; hi[i] load and store — tagged !noalias !lo_scope to say
  ; "these hi accesses do not alias anything in the lo scope."
  %22 = add i64 %5, %16
  %23 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %24 = getelementptr inbounds nuw float, ptr %23, i64 %22
  %25 = load float, ptr %24, align 4, !noalias !2
  %26 = fadd float %25, %21
  %27 = add i64 %5, %16
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, 1
  %29 = getelementptr inbounds nuw float, ptr %28, i64 %27
  store float %26, ptr %29, align 4, !noalias !2
  %30 = add i64 %16, 1
  br label %15

31:                                               ; preds = %15
  ret void
}

!llvm.module.flags = !{!0}
!0 = !{i32 2, !"Debug Info Version", i32 3}

; Alias scope hierarchy:
;   !1 = lo_domain  (top-level domain for the lo subview region)
;   !3 = lo_scope   (the scope assigned to all lo-region accesses)
;   !2 = the scope list { !lo_scope } — used in !alias.scope and !noalias
!1 = !{!1, !"dynamic_split:lo_domain"}
!3 = !{!3, !1, !"dynamic_split:lo_scope"}
!2 = !{!3}
