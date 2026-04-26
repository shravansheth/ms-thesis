module {
  llvm.func @dynamic_split(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(2048 : index) : i64
    %9 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %10 = llvm.sub %8, %arg5 : i64
    %11 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %12 = llvm.getelementptr inbounds|nuw %11[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %9, %12 : f32, !llvm.ptr
    llvm.br ^bb1(%6 : i64)
  ^bb1(%13: i64):  // 2 preds: ^bb0, ^bb2
    %14 = llvm.icmp "slt" %13, %10 : i64
    llvm.cond_br %14, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %15 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %16 = llvm.getelementptr inbounds|nuw %15[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %17 = llvm.load %16 : !llvm.ptr -> f32
    %18 = llvm.add %arg5, %13 : i64
    %19 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %20 = llvm.getelementptr inbounds|nuw %19[%18] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %21 = llvm.load %20 : !llvm.ptr -> f32
    %22 = llvm.fadd %21, %17 : f32
    %23 = llvm.add %arg5, %13 : i64
    %24 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %25 = llvm.getelementptr inbounds|nuw %24[%23] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %22, %25 : f32, !llvm.ptr
    %26 = llvm.add %13, %7 : i64
    llvm.br ^bb1(%26 : i64)
  ^bb3:  // pred: ^bb1
    llvm.return
  }
}

