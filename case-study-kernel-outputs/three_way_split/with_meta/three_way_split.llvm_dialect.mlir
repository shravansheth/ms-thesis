#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope_domain1 = #llvm.alias_scope_domain<id = distinct[1]<>, description = "pair_1_domain">
#alias_scope = #llvm.alias_scope<id = distinct[2]<>, domain = #alias_scope_domain, description = "pair_0_lo">
#alias_scope1 = #llvm.alias_scope<id = distinct[3]<>, domain = #alias_scope_domain1, description = "pair_1_lo">
module {
  llvm.func @three_way_split(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(2.000000e+00 : f32) : f32
    %7 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(0 : index) : i64
    %10 = llvm.add %arg5, %arg5 : i64
    %11 = llvm.extractvalue %5[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %12 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %13 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %14 = llvm.insertvalue %11, %13[0] : !llvm.struct<(ptr, ptr, i64)> 
    %15 = llvm.insertvalue %12, %14[1] : !llvm.struct<(ptr, ptr, i64)> 
    %16 = llvm.mlir.constant(0 : index) : i64
    %17 = llvm.insertvalue %16, %15[2] : !llvm.struct<(ptr, ptr, i64)> 
    %18 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %20 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %21 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %22 = llvm.extractvalue %17[0] : !llvm.struct<(ptr, ptr, i64)> 
    %23 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64)> 
    %24 = llvm.insertvalue %22, %21[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %25 = llvm.insertvalue %23, %24[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %26 = llvm.mlir.constant(0 : index) : i64
    %27 = llvm.insertvalue %26, %25[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %28 = llvm.insertvalue %arg5, %27[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %29 = llvm.mlir.constant(1 : index) : i64
    %30 = llvm.insertvalue %29, %28[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %31 = llvm.extractvalue %5[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %32 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %33 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %34 = llvm.insertvalue %31, %33[0] : !llvm.struct<(ptr, ptr, i64)> 
    %35 = llvm.insertvalue %32, %34[1] : !llvm.struct<(ptr, ptr, i64)> 
    %36 = llvm.mlir.constant(0 : index) : i64
    %37 = llvm.insertvalue %36, %35[2] : !llvm.struct<(ptr, ptr, i64)> 
    %38 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %39 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %40 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %41 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %42 = llvm.extractvalue %37[0] : !llvm.struct<(ptr, ptr, i64)> 
    %43 = llvm.extractvalue %37[1] : !llvm.struct<(ptr, ptr, i64)> 
    %44 = llvm.insertvalue %42, %41[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %45 = llvm.insertvalue %43, %44[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %46 = llvm.insertvalue %arg5, %45[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %47 = llvm.insertvalue %arg5, %46[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %48 = llvm.mlir.constant(1 : index) : i64
    %49 = llvm.insertvalue %48, %47[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %50 = llvm.extractvalue %5[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %51 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %52 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %53 = llvm.insertvalue %50, %52[0] : !llvm.struct<(ptr, ptr, i64)> 
    %54 = llvm.insertvalue %51, %53[1] : !llvm.struct<(ptr, ptr, i64)> 
    %55 = llvm.mlir.constant(0 : index) : i64
    %56 = llvm.insertvalue %55, %54[2] : !llvm.struct<(ptr, ptr, i64)> 
    %57 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %58 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %59 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %60 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %61 = llvm.extractvalue %56[0] : !llvm.struct<(ptr, ptr, i64)> 
    %62 = llvm.extractvalue %56[1] : !llvm.struct<(ptr, ptr, i64)> 
    %63 = llvm.insertvalue %61, %60[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %64 = llvm.insertvalue %62, %63[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %65 = llvm.insertvalue %10, %64[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %66 = llvm.insertvalue %arg5, %65[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %67 = llvm.mlir.constant(1 : index) : i64
    %68 = llvm.insertvalue %67, %66[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %69 = llvm.extractvalue %30[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %70 = llvm.getelementptr inbounds|nuw %69[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %7, %70 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %71 = llvm.extractvalue %49[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %72 = llvm.extractvalue %49[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %73 = llvm.getelementptr %71[%72] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %74 = llvm.getelementptr inbounds|nuw %73[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %6, %74 {alias_scopes = [#alias_scope1]} : f32, !llvm.ptr
    llvm.br ^bb1(%9 : i64)
  ^bb1(%75: i64):  // 2 preds: ^bb0, ^bb2
    %76 = llvm.icmp "slt" %75, %arg5 : i64
    llvm.cond_br %76, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %77 = llvm.extractvalue %30[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %78 = llvm.getelementptr inbounds|nuw %77[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %79 = llvm.load %78 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %80 = llvm.extractvalue %49[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %81 = llvm.extractvalue %49[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %82 = llvm.getelementptr %80[%81] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %83 = llvm.getelementptr inbounds|nuw %82[%75] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %84 = llvm.load %83 {alias_scopes = [#alias_scope1]} : !llvm.ptr -> f32
    %85 = llvm.fadd %84, %79 : f32
    %86 = llvm.extractvalue %49[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %87 = llvm.extractvalue %49[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %88 = llvm.getelementptr %86[%87] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %89 = llvm.getelementptr inbounds|nuw %88[%75] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %85, %89 {alias_scopes = [#alias_scope1]} : f32, !llvm.ptr
    %90 = llvm.add %75, %8 : i64
    llvm.br ^bb1(%90 : i64)
  ^bb3:  // pred: ^bb1
    llvm.br ^bb4(%9 : i64)
  ^bb4(%91: i64):  // 2 preds: ^bb3, ^bb5
    %92 = llvm.icmp "slt" %91, %arg5 : i64
    llvm.cond_br %92, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %93 = llvm.extractvalue %49[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %94 = llvm.extractvalue %49[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %95 = llvm.getelementptr %93[%94] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %96 = llvm.getelementptr inbounds|nuw %95[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %97 = llvm.load %96 {alias_scopes = [#alias_scope1]} : !llvm.ptr -> f32
    %98 = llvm.extractvalue %68[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %99 = llvm.extractvalue %68[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %100 = llvm.getelementptr %98[%99] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %101 = llvm.getelementptr inbounds|nuw %100[%91] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %102 = llvm.load %101 {noalias_scopes = [#alias_scope1]} : !llvm.ptr -> f32
    %103 = llvm.fadd %102, %97 : f32
    %104 = llvm.extractvalue %68[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %105 = llvm.extractvalue %68[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %106 = llvm.getelementptr %104[%105] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %107 = llvm.getelementptr inbounds|nuw %106[%91] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %103, %107 {noalias_scopes = [#alias_scope1]} : f32, !llvm.ptr
    %108 = llvm.add %91, %8 : i64
    llvm.br ^bb4(%108 : i64)
  ^bb6:  // pred: ^bb4
    llvm.return
  }
}

