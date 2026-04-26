module {
  llvm.func @linalg_stencil_split(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(1 : index) : i64
    %7 = llvm.mlir.constant(0 : index) : i64
    %8 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %9 = llvm.mlir.constant(4096 : index) : i64
    %10 = llvm.sub %9, %arg5 : i64
    llvm.br ^bb1(%7 : i64)
  ^bb1(%11: i64):  // 2 preds: ^bb0, ^bb2
    %12 = llvm.icmp "slt" %11, %10 : i64
    llvm.cond_br %12, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %13 = llvm.add %arg5, %11 : i64
    %14 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.getelementptr inbounds|nuw %14[%13] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %8, %15 : f32, !llvm.ptr
    %16 = llvm.add %11, %6 : i64
    llvm.br ^bb1(%16 : i64)
  ^bb3:  // pred: ^bb1
    llvm.br ^bb4(%7 : i64)
  ^bb4(%17: i64):  // 2 preds: ^bb3, ^bb5
    %18 = llvm.icmp "slt" %17, %arg5 : i64
    llvm.cond_br %18, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %19 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %20 = llvm.getelementptr inbounds|nuw %19[%17] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %21 = llvm.load %20 : !llvm.ptr -> f32
    %22 = llvm.add %arg5, %17 : i64
    %23 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.getelementptr inbounds|nuw %23[%22] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %25 = llvm.load %24 : !llvm.ptr -> f32
    %26 = llvm.fadd %25, %21 : f32
    %27 = llvm.fadd %26, %8 : f32
    %28 = llvm.add %arg5, %17 : i64
    %29 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.getelementptr inbounds|nuw %29[%28] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %27, %30 : f32, !llvm.ptr
    %31 = llvm.add %17, %6 : i64
    llvm.br ^bb4(%31 : i64)
  ^bb6:  // pred: ^bb4
    llvm.return
  }
}

