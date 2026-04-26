#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  llvm.func @split_accumulate(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %7 = llvm.mlir.constant(2048 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(0 : index) : i64
    %10 = llvm.sub %7, %arg5 : i64
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
    %47 = llvm.insertvalue %10, %46[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %48 = llvm.mlir.constant(1 : index) : i64
    %49 = llvm.insertvalue %48, %47[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %50 = llvm.extractvalue %49[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %51 = llvm.extractvalue %49[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %52 = llvm.getelementptr %50[%51] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %53 = llvm.getelementptr inbounds|nuw %52[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %6, %53 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    llvm.br ^bb1(%9 : i64)
  ^bb1(%54: i64):  // 2 preds: ^bb0, ^bb2
    %55 = llvm.icmp "slt" %54, %arg5 : i64
    llvm.cond_br %55, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %56 = llvm.extractvalue %49[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %57 = llvm.extractvalue %49[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %58 = llvm.getelementptr %56[%57] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %59 = llvm.getelementptr inbounds|nuw %58[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %60 = llvm.load %59 {noalias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %61 = llvm.extractvalue %30[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %62 = llvm.getelementptr inbounds|nuw %61[%54] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %63 = llvm.load %62 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %64 = llvm.fadd %63, %60 : f32
    %65 = llvm.extractvalue %30[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %66 = llvm.getelementptr inbounds|nuw %65[%54] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %64, %66 {alias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %67 = llvm.add %54, %8 : i64
    llvm.br ^bb1(%67 : i64)
  ^bb3:  // pred: ^bb1
    llvm.return
  }
}

