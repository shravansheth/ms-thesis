#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "pair_0_domain">
#alias_scope = #llvm.alias_scope<id = distinct[1]<>, domain = #alias_scope_domain, description = "pair_0_lo">
module {
  llvm.func @adjacent_tiles(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(1 : index) : i64
    %7 = llvm.mlir.constant(0 : index) : i64
    %8 = llvm.mul %arg5, %arg6 : i64
    %9 = llvm.extractvalue %5[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %10 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %11 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %12 = llvm.insertvalue %9, %11[0] : !llvm.struct<(ptr, ptr, i64)> 
    %13 = llvm.insertvalue %10, %12[1] : !llvm.struct<(ptr, ptr, i64)> 
    %14 = llvm.mlir.constant(0 : index) : i64
    %15 = llvm.insertvalue %14, %13[2] : !llvm.struct<(ptr, ptr, i64)> 
    %16 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %17 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %18 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %20 = llvm.extractvalue %15[0] : !llvm.struct<(ptr, ptr, i64)> 
    %21 = llvm.extractvalue %15[1] : !llvm.struct<(ptr, ptr, i64)> 
    %22 = llvm.insertvalue %20, %19[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.insertvalue %21, %22[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.insertvalue %8, %23[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %25 = llvm.insertvalue %arg6, %24[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %26 = llvm.mlir.constant(1 : index) : i64
    %27 = llvm.insertvalue %26, %25[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %28 = llvm.add %8, %arg6 : i64
    %29 = llvm.extractvalue %5[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %31 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64)>
    %32 = llvm.insertvalue %29, %31[0] : !llvm.struct<(ptr, ptr, i64)> 
    %33 = llvm.insertvalue %30, %32[1] : !llvm.struct<(ptr, ptr, i64)> 
    %34 = llvm.mlir.constant(0 : index) : i64
    %35 = llvm.insertvalue %34, %33[2] : !llvm.struct<(ptr, ptr, i64)> 
    %36 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %37 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %39 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %40 = llvm.extractvalue %35[0] : !llvm.struct<(ptr, ptr, i64)> 
    %41 = llvm.extractvalue %35[1] : !llvm.struct<(ptr, ptr, i64)> 
    %42 = llvm.insertvalue %40, %39[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %43 = llvm.insertvalue %41, %42[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %44 = llvm.insertvalue %28, %43[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %45 = llvm.insertvalue %arg6, %44[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %46 = llvm.mlir.constant(1 : index) : i64
    %47 = llvm.insertvalue %46, %45[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.br ^bb1(%7 : i64)
  ^bb1(%48: i64):  // 2 preds: ^bb0, ^bb2
    %49 = llvm.icmp "slt" %48, %arg6 : i64
    llvm.cond_br %49, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %50 = llvm.extractvalue %27[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %51 = llvm.extractvalue %27[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %52 = llvm.getelementptr %50[%51] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %53 = llvm.getelementptr inbounds|nuw %52[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %54 = llvm.load %53 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %55 = llvm.extractvalue %27[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %56 = llvm.extractvalue %27[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %57 = llvm.getelementptr %55[%56] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %58 = llvm.getelementptr inbounds|nuw %57[%48] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %59 = llvm.load %58 {alias_scopes = [#alias_scope]} : !llvm.ptr -> f32
    %60 = llvm.fadd %59, %54 : f32
    %61 = llvm.extractvalue %47[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %62 = llvm.extractvalue %47[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %63 = llvm.getelementptr %61[%62] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %64 = llvm.getelementptr inbounds|nuw %63[%48] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %60, %64 {noalias_scopes = [#alias_scope]} : f32, !llvm.ptr
    %65 = llvm.add %48, %6 : i64
    llvm.br ^bb1(%65 : i64)
  ^bb3:  // pred: ^bb1
    llvm.return
  }
}

