#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  llvm.func @vectorize_split(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %7 = llvm.mlir.constant(1048576 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(0 : index) : i64
    %10 = llvm.extractvalue %5[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %11 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %12 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %13 = llvm.insertvalue %10, %12[0] : !llvm.struct<(ptr, ptr, i64)> 
    %14 = llvm.insertvalue %11, %13[1] : !llvm.struct<(ptr, ptr, i64)> 
    %15 = llvm.mlir.constant(0 : index) : i64
    %16 = llvm.insertvalue %15, %14[2] : !llvm.struct<(ptr, ptr, i64)> 
    %17 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %18 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %20 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %21 = llvm.extractvalue %16[0] : !llvm.struct<(ptr, ptr, i64)> 
    %22 = llvm.extractvalue %16[1] : !llvm.struct<(ptr, ptr, i64)> 
    %23 = llvm.insertvalue %21, %20[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.insertvalue %22, %23[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %25 = llvm.mlir.constant(0 : index) : i64
    %26 = llvm.insertvalue %25, %24[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = llvm.insertvalue %arg5, %26[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %28 = llvm.mlir.constant(1 : index) : i64
    %29 = llvm.insertvalue %28, %27[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.extractvalue %5[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %31 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %32 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %33 = llvm.insertvalue %30, %32[0] : !llvm.struct<(ptr, ptr, i64)> 
    %34 = llvm.insertvalue %31, %33[1] : !llvm.struct<(ptr, ptr, i64)> 
    %35 = llvm.mlir.constant(0 : index) : i64
    %36 = llvm.insertvalue %35, %34[2] : !llvm.struct<(ptr, ptr, i64)> 
    %37 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %39 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %40 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %41 = llvm.extractvalue %36[0] : !llvm.struct<(ptr, ptr, i64)> 
    %42 = llvm.extractvalue %36[1] : !llvm.struct<(ptr, ptr, i64)> 
    %43 = llvm.insertvalue %41, %40[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %44 = llvm.insertvalue %42, %43[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %45 = llvm.insertvalue %arg5, %44[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %46 = llvm.mlir.constant(1048576 : index) : i64
    %47 = llvm.insertvalue %46, %45[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %48 = llvm.mlir.constant(1 : index) : i64
    %49 = llvm.insertvalue %48, %47[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %50 = llvm.extractvalue %29[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %51 = llvm.getelementptr inbounds|nuw %50[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %6, %51 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    llvm.br ^bb1(%9 : i64)
  ^bb1(%52: i64):  // 2 preds: ^bb0, ^bb2
    %53 = llvm.icmp "slt" %52, %7 : i64
    llvm.cond_br %53, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %54 = llvm.extractvalue %29[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %55 = llvm.getelementptr inbounds|nuw %54[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %56 = llvm.load %55 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %57 = llvm.extractvalue %49[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %58 = llvm.extractvalue %49[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %59 = llvm.getelementptr %57[%58] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %60 = llvm.getelementptr inbounds|nuw %59[%52] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %61 = llvm.load %60 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %62 = llvm.fadd %61, %56 : f32
    %63 = llvm.extractvalue %49[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %64 = llvm.extractvalue %49[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %65 = llvm.getelementptr %63[%64] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %66 = llvm.getelementptr inbounds|nuw %65[%52] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %62, %66 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %67 = llvm.add %52, %8 : i64
    llvm.br ^bb1(%67 : i64)
  ^bb3:  // pred: ^bb1
    llvm.return
  }
}

