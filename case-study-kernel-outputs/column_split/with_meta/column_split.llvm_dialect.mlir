module {
  llvm.func @column_split(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64, %arg8: i64) {
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
    %11 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %12 = llvm.sub %10, %arg8 : i64
    %13 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.mlir.constant(1024 : index) : i64
    %15 = llvm.mul %8, %14 overflow<nsw, nuw> : i64
    %16 = llvm.add %15, %8 overflow<nsw, nuw> : i64
    %17 = llvm.getelementptr inbounds|nuw %13[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %11, %17 : f32, !llvm.ptr
    llvm.br ^bb1(%8 : i64)
  ^bb1(%18: i64):  // 2 preds: ^bb0, ^bb5
    %19 = llvm.icmp "slt" %18, %arg7 : i64
    llvm.cond_br %19, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%8 : i64)
  ^bb3(%20: i64):  // 2 preds: ^bb2, ^bb4
    %21 = llvm.icmp "slt" %20, %12 : i64
    llvm.cond_br %21, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %22 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.mlir.constant(1024 : index) : i64
    %24 = llvm.mul %8, %23 overflow<nsw, nuw> : i64
    %25 = llvm.add %24, %8 overflow<nsw, nuw> : i64
    %26 = llvm.getelementptr inbounds|nuw %22[%25] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %27 = llvm.load %26 : !llvm.ptr -> f32
    %28 = llvm.add %arg8, %20 : i64
    %29 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.mlir.constant(1024 : index) : i64
    %31 = llvm.mul %18, %30 overflow<nsw, nuw> : i64
    %32 = llvm.add %31, %28 overflow<nsw, nuw> : i64
    %33 = llvm.getelementptr inbounds|nuw %29[%32] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %34 = llvm.load %33 : !llvm.ptr -> f32
    %35 = llvm.fadd %34, %27 : f32
    %36 = llvm.add %arg8, %20 : i64
    %37 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %38 = llvm.mlir.constant(1024 : index) : i64
    %39 = llvm.mul %18, %38 overflow<nsw, nuw> : i64
    %40 = llvm.add %39, %36 overflow<nsw, nuw> : i64
    %41 = llvm.getelementptr inbounds|nuw %37[%40] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %35, %41 : f32, !llvm.ptr
    %42 = llvm.add %20, %9 : i64
    llvm.br ^bb3(%42 : i64)
  ^bb5:  // pred: ^bb3
    %43 = llvm.add %18, %9 : i64
    llvm.br ^bb1(%43 : i64)
  ^bb6:  // pred: ^bb1
    llvm.return
  }
}

