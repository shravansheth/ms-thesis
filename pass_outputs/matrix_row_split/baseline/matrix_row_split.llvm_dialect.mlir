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
    %8 = llvm.mlir.constant(0 : index) : i64
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.mlir.constant(512 : index) : i64
    %11 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %12 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.mlir.constant(512 : index) : i64
    %14 = llvm.mul %8, %13 overflow<nsw, nuw> : i64
    %15 = llvm.add %14, %8 overflow<nsw, nuw> : i64
    %16 = llvm.getelementptr inbounds|nuw %12[%15] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %11, %16 : f32, !llvm.ptr
    llvm.br ^bb1(%8 : i64)
  ^bb1(%17: i64):  // 2 preds: ^bb0, ^bb5
    %18 = llvm.icmp "slt" %17, %arg7 : i64
    llvm.cond_br %18, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%8 : i64)
  ^bb3(%19: i64):  // 2 preds: ^bb2, ^bb4
    %20 = llvm.icmp "slt" %19, %10 : i64
    llvm.cond_br %20, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %21 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.mlir.constant(512 : index) : i64
    %23 = llvm.mul %8, %22 overflow<nsw, nuw> : i64
    %24 = llvm.add %23, %8 overflow<nsw, nuw> : i64
    %25 = llvm.getelementptr inbounds|nuw %21[%24] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %26 = llvm.load %25 : !llvm.ptr -> f32
    %27 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %28 = llvm.mlir.constant(512 : index) : i64
    %29 = llvm.mul %17, %28 overflow<nsw, nuw> : i64
    %30 = llvm.add %29, %19 overflow<nsw, nuw> : i64
    %31 = llvm.getelementptr inbounds|nuw %27[%30] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %32 = llvm.load %31 : !llvm.ptr -> f32
    %33 = llvm.fadd %32, %26 : f32
    %34 = llvm.add %arg7, %17 : i64
    %35 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.mlir.constant(512 : index) : i64
    %37 = llvm.mul %34, %36 overflow<nsw, nuw> : i64
    %38 = llvm.add %37, %19 overflow<nsw, nuw> : i64
    %39 = llvm.getelementptr inbounds|nuw %35[%38] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %33, %39 : f32, !llvm.ptr
    %40 = llvm.add %19, %9 : i64
    llvm.br ^bb3(%40 : i64)
  ^bb5:  // pred: ^bb3
    %41 = llvm.add %17, %9 : i64
    llvm.br ^bb1(%41 : i64)
  ^bb6:  // pred: ^bb1
    llvm.return
  }
}

