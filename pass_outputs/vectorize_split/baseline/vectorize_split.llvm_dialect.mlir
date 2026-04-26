module {
  llvm.func @vectorize_split(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(1048576 : index) : i64
    %9 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %10 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %11 = llvm.getelementptr inbounds|nuw %10[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %9, %11 : f32, !llvm.ptr
    llvm.br ^bb1(%6 : i64)
  ^bb1(%12: i64):  // 2 preds: ^bb0, ^bb2
    %13 = llvm.icmp "slt" %12, %8 : i64
    llvm.cond_br %13, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %14 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.getelementptr inbounds|nuw %14[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %16 = llvm.load %15 : !llvm.ptr -> f32
    %17 = llvm.add %arg5, %12 : i64
    %18 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.getelementptr inbounds|nuw %18[%17] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %20 = llvm.load %19 : !llvm.ptr -> f32
    %21 = llvm.fadd %20, %16 : f32
    %22 = llvm.add %arg5, %12 : i64
    %23 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.getelementptr inbounds|nuw %23[%22] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %21, %24 : f32, !llvm.ptr
    %25 = llvm.add %12, %7 : i64
    llvm.br ^bb1(%25 : i64)
  ^bb3:  // pred: ^bb1
    llvm.return
  }
}

