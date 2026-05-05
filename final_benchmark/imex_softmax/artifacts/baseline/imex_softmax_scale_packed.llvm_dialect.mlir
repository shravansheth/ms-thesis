module {
  llvm.func @imex_softmax_scale_packed(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64, %arg8: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg6, %6[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.mlir.constant(0 : index) : i64
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.mlir.constant(1024 : index) : i64
    llvm.br ^bb1(%8 : i64)
  ^bb1(%11: i64):  // 2 preds: ^bb0, ^bb5
    %12 = llvm.icmp "slt" %11, %arg7 : i64
    llvm.cond_br %12, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%8 : i64)
  ^bb3(%13: i64):  // 2 preds: ^bb2, ^bb4
    %14 = llvm.icmp "slt" %13, %10 : i64
    llvm.cond_br %14, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %15 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.mlir.constant(2048 : index) : i64
    %17 = llvm.mul %11, %16 overflow<nsw, nuw> : i64
    %18 = llvm.add %17, %8 overflow<nsw, nuw> : i64
    %19 = llvm.getelementptr inbounds|nuw %15[%18] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %20 = llvm.load %19 : !llvm.ptr -> f32
    %21 = llvm.add %arg8, %13 : i64
    %22 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.mlir.constant(2048 : index) : i64
    %24 = llvm.mul %11, %23 overflow<nsw, nuw> : i64
    %25 = llvm.add %24, %21 overflow<nsw, nuw> : i64
    %26 = llvm.getelementptr inbounds|nuw %22[%25] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %27 = llvm.load %26 : !llvm.ptr -> f32
    %28 = llvm.fdiv %27, %20 : f32
    %29 = llvm.add %arg8, %13 : i64
    %30 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %31 = llvm.mlir.constant(2048 : index) : i64
    %32 = llvm.mul %11, %31 overflow<nsw, nuw> : i64
    %33 = llvm.add %32, %29 overflow<nsw, nuw> : i64
    %34 = llvm.getelementptr inbounds|nuw %30[%33] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %28, %34 : f32, !llvm.ptr
    %35 = llvm.add %13, %9 : i64
    llvm.br ^bb3(%35 : i64)
  ^bb5:  // pred: ^bb3
    %36 = llvm.add %11, %9 : i64
    llvm.br ^bb1(%36 : i64)
  ^bb6:  // pred: ^bb1
    llvm.return
  }
}

