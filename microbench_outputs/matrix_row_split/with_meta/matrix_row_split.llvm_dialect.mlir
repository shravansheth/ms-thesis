#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  llvm.func @matrix_row_split(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg6, %6[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.mlir.constant(512 : index) : i64
    %9 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %10 = llvm.mlir.constant(512 : index) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(0 : index) : i64
    %13 = llvm.extractvalue %7[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %16 = llvm.insertvalue %13, %15[0] : !llvm.struct<(ptr, ptr, i64)> 
    %17 = llvm.insertvalue %14, %16[1] : !llvm.struct<(ptr, ptr, i64)> 
    %18 = llvm.mlir.constant(0 : index) : i64
    %19 = llvm.insertvalue %18, %17[2] : !llvm.struct<(ptr, ptr, i64)> 
    %20 = llvm.extractvalue %7[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.extractvalue %7[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.extractvalue %7[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.extractvalue %7[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %26 = llvm.extractvalue %19[0] : !llvm.struct<(ptr, ptr, i64)> 
    %27 = llvm.extractvalue %19[1] : !llvm.struct<(ptr, ptr, i64)> 
    %28 = llvm.insertvalue %26, %25[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %29 = llvm.insertvalue %27, %28[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.mlir.constant(0 : index) : i64
    %31 = llvm.insertvalue %30, %29[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %32 = llvm.insertvalue %arg7, %31[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.mlir.constant(512 : index) : i64
    %34 = llvm.insertvalue %33, %32[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.mlir.constant(512 : index) : i64
    %36 = llvm.insertvalue %35, %34[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.mlir.constant(1 : index) : i64
    %38 = llvm.insertvalue %37, %36[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.extractvalue %7[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %41 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %42 = llvm.insertvalue %39, %41[0] : !llvm.struct<(ptr, ptr, i64)> 
    %43 = llvm.insertvalue %40, %42[1] : !llvm.struct<(ptr, ptr, i64)> 
    %44 = llvm.mlir.constant(0 : index) : i64
    %45 = llvm.insertvalue %44, %43[2] : !llvm.struct<(ptr, ptr, i64)> 
    %46 = llvm.extractvalue %7[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %47 = llvm.extractvalue %7[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.extractvalue %7[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %49 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %50 = llvm.extractvalue %7[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %51 = llvm.mlir.constant(512 : index) : i64
    %52 = llvm.mul %arg7, %51 overflow<nsw> : i64
    %53 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %54 = llvm.extractvalue %45[0] : !llvm.struct<(ptr, ptr, i64)> 
    %55 = llvm.extractvalue %45[1] : !llvm.struct<(ptr, ptr, i64)> 
    %56 = llvm.insertvalue %54, %53[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %57 = llvm.insertvalue %55, %56[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %58 = llvm.insertvalue %52, %57[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %59 = llvm.insertvalue %arg7, %58[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %60 = llvm.mlir.constant(512 : index) : i64
    %61 = llvm.insertvalue %60, %59[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %62 = llvm.mlir.constant(512 : index) : i64
    %63 = llvm.insertvalue %62, %61[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %64 = llvm.mlir.constant(1 : index) : i64
    %65 = llvm.insertvalue %64, %63[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %66 = llvm.extractvalue %38[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %67 = llvm.mul %12, %8 overflow<nsw, nuw> : i64
    %68 = llvm.add %67, %12 overflow<nsw, nuw> : i64
    %69 = llvm.getelementptr inbounds|nuw %66[%68] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %9, %69 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    llvm.br ^bb1(%12 : i64)
  ^bb1(%70: i64):  // 2 preds: ^bb0, ^bb5
    %71 = llvm.icmp "slt" %70, %arg7 : i64
    llvm.cond_br %71, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%12 : i64)
  ^bb3(%72: i64):  // 2 preds: ^bb2, ^bb4
    %73 = llvm.icmp "slt" %72, %10 : i64
    llvm.cond_br %73, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %74 = llvm.extractvalue %38[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %75 = llvm.mul %12, %8 overflow<nsw, nuw> : i64
    %76 = llvm.add %75, %12 overflow<nsw, nuw> : i64
    %77 = llvm.getelementptr inbounds|nuw %74[%76] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %78 = llvm.load %77 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %79 = llvm.extractvalue %38[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %80 = llvm.mul %70, %8 overflow<nsw, nuw> : i64
    %81 = llvm.add %80, %72 overflow<nsw, nuw> : i64
    %82 = llvm.getelementptr inbounds|nuw %79[%81] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %83 = llvm.load %82 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %84 = llvm.fadd %83, %78 : f32
    %85 = llvm.extractvalue %65[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %86 = llvm.extractvalue %65[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %87 = llvm.getelementptr %85[%86] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %88 = llvm.mul %70, %8 overflow<nsw, nuw> : i64
    %89 = llvm.add %88, %72 overflow<nsw, nuw> : i64
    %90 = llvm.getelementptr inbounds|nuw %87[%89] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %84, %90 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %91 = llvm.add %72, %11 : i64
    llvm.br ^bb3(%91 : i64)
  ^bb5:  // pred: ^bb3
    %92 = llvm.add %70, %11 : i64
    llvm.br ^bb1(%92 : i64)
  ^bb6:  // pred: ^bb1
    llvm.return
  }
}

