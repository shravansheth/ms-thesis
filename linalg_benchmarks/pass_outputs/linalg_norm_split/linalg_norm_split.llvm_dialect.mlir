#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  llvm.func @linalg_norm_split(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(2048 : index) : i64
    %7 = llvm.mlir.constant(2.000000e+00 : f32) : f32
    %8 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.mlir.constant(0 : index) : i64
    %11 = llvm.sub %6, %arg5 : i64
    %12 = llvm.extractvalue %5[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %13 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %14 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %15 = llvm.insertvalue %12, %14[0] : !llvm.struct<(ptr, ptr, i64)> 
    %16 = llvm.insertvalue %13, %15[1] : !llvm.struct<(ptr, ptr, i64)> 
    %17 = llvm.mlir.constant(0 : index) : i64
    %18 = llvm.insertvalue %17, %16[2] : !llvm.struct<(ptr, ptr, i64)> 
    %19 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %20 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %21 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %22 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %23 = llvm.extractvalue %18[0] : !llvm.struct<(ptr, ptr, i64)> 
    %24 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64)> 
    %25 = llvm.insertvalue %23, %22[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %26 = llvm.insertvalue %24, %25[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = llvm.mlir.constant(0 : index) : i64
    %28 = llvm.insertvalue %27, %26[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %29 = llvm.insertvalue %arg5, %28[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.mlir.constant(1 : index) : i64
    %31 = llvm.insertvalue %30, %29[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %32 = llvm.extractvalue %5[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %33 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %34 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %35 = llvm.insertvalue %32, %34[0] : !llvm.struct<(ptr, ptr, i64)> 
    %36 = llvm.insertvalue %33, %35[1] : !llvm.struct<(ptr, ptr, i64)> 
    %37 = llvm.mlir.constant(0 : index) : i64
    %38 = llvm.insertvalue %37, %36[2] : !llvm.struct<(ptr, ptr, i64)> 
    %39 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %40 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %41 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %42 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %43 = llvm.extractvalue %38[0] : !llvm.struct<(ptr, ptr, i64)> 
    %44 = llvm.extractvalue %38[1] : !llvm.struct<(ptr, ptr, i64)> 
    %45 = llvm.insertvalue %43, %42[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %46 = llvm.insertvalue %44, %45[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %47 = llvm.insertvalue %arg5, %46[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %48 = llvm.insertvalue %11, %47[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %49 = llvm.mlir.constant(1 : index) : i64
    %50 = llvm.insertvalue %49, %48[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %51 = llvm.extractvalue %31[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %52 = llvm.getelementptr inbounds|nuw %51[%10] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %8, %52 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %53 = llvm.extractvalue %31[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %54 = llvm.getelementptr inbounds|nuw %53[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %7, %54 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    llvm.br ^bb1(%10 : i64)
  ^bb1(%55: i64):  // 2 preds: ^bb0, ^bb2
    %56 = llvm.icmp "slt" %55, %11 : i64
    llvm.cond_br %56, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %57 = llvm.extractvalue %31[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %58 = llvm.getelementptr inbounds|nuw %57[%10] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %59 = llvm.load %58 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %60 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %61 = llvm.extractvalue %50[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %62 = llvm.getelementptr %60[%61] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %63 = llvm.getelementptr inbounds|nuw %62[%55] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %64 = llvm.load %63 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %65 = llvm.fadd %64, %59 : f32
    %66 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %67 = llvm.extractvalue %50[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %68 = llvm.getelementptr %66[%67] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %69 = llvm.getelementptr inbounds|nuw %68[%55] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %65, %69 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %70 = llvm.add %55, %9 : i64
    llvm.br ^bb1(%70 : i64)
  ^bb3:  // pred: ^bb1
    llvm.br ^bb4(%10 : i64)
  ^bb4(%71: i64):  // 2 preds: ^bb3, ^bb5
    %72 = llvm.icmp "slt" %71, %11 : i64
    llvm.cond_br %72, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %73 = llvm.extractvalue %31[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %74 = llvm.getelementptr inbounds|nuw %73[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %75 = llvm.load %74 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %76 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %77 = llvm.extractvalue %50[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %78 = llvm.getelementptr %76[%77] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %79 = llvm.getelementptr inbounds|nuw %78[%71] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %80 = llvm.load %79 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %81 = llvm.fmul %80, %75 : f32
    %82 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %83 = llvm.extractvalue %50[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %84 = llvm.getelementptr %82[%83] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %85 = llvm.getelementptr inbounds|nuw %84[%71] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %81, %85 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %86 = llvm.add %71, %9 : i64
    llvm.br ^bb4(%86 : i64)
  ^bb6:  // pred: ^bb4
    llvm.return
  }
}

