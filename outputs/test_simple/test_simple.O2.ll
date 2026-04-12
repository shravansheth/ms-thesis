; ModuleID = 'outputs/test_simple/test_simple.ll'
source_filename = "LLVMDialectModule"

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define void @test_simple(ptr readnone captures(none) %0, ptr captures(none) %1, i64 %2, i64 %3, i64 %4, ptr readnone captures(none) %5, ptr readonly captures(none) %6, i64 %7, i64 %8, i64 %9) local_unnamed_addr #0 {
  %11 = load float, ptr %1, align 4
  %12 = load float, ptr %6, align 4
  %13 = fadd float %11, %12
  store float %13, ptr %1, align 4
  %14 = getelementptr inbounds nuw i8, ptr %1, i64 4
  %15 = load float, ptr %14, align 4
  %16 = getelementptr inbounds nuw i8, ptr %6, i64 4
  %17 = load float, ptr %16, align 4
  %18 = fadd float %15, %17
  store float %18, ptr %14, align 4
  %19 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %20 = load float, ptr %19, align 4
  %21 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %22 = load float, ptr %21, align 4
  %23 = fadd float %20, %22
  store float %23, ptr %19, align 4
  %24 = getelementptr inbounds nuw i8, ptr %1, i64 12
  %25 = load float, ptr %24, align 4
  %26 = getelementptr inbounds nuw i8, ptr %6, i64 12
  %27 = load float, ptr %26, align 4
  %28 = fadd float %25, %27
  store float %28, ptr %24, align 4
  %29 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %30 = load float, ptr %29, align 4
  %31 = getelementptr inbounds nuw i8, ptr %6, i64 16
  %32 = load float, ptr %31, align 4
  %33 = fadd float %30, %32
  store float %33, ptr %29, align 4
  %34 = getelementptr inbounds nuw i8, ptr %1, i64 20
  %35 = load float, ptr %34, align 4
  %36 = getelementptr inbounds nuw i8, ptr %6, i64 20
  %37 = load float, ptr %36, align 4
  %38 = fadd float %35, %37
  store float %38, ptr %34, align 4
  %39 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %40 = load float, ptr %39, align 4
  %41 = getelementptr inbounds nuw i8, ptr %6, i64 24
  %42 = load float, ptr %41, align 4
  %43 = fadd float %40, %42
  store float %43, ptr %39, align 4
  %44 = getelementptr inbounds nuw i8, ptr %1, i64 28
  %45 = load float, ptr %44, align 4
  %46 = getelementptr inbounds nuw i8, ptr %6, i64 28
  %47 = load float, ptr %46, align 4
  %48 = fadd float %45, %47
  store float %48, ptr %44, align 4
  %49 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %50 = load float, ptr %49, align 4
  %51 = getelementptr inbounds nuw i8, ptr %6, i64 32
  %52 = load float, ptr %51, align 4
  %53 = fadd float %50, %52
  store float %53, ptr %49, align 4
  %54 = getelementptr inbounds nuw i8, ptr %1, i64 36
  %55 = load float, ptr %54, align 4
  %56 = getelementptr inbounds nuw i8, ptr %6, i64 36
  %57 = load float, ptr %56, align 4
  %58 = fadd float %55, %57
  store float %58, ptr %54, align 4
  ret void
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
