module {
  llvm.func @double_invariant(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) {
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
    %10 = llvm.mlir.constant(2.000000e+00 : f32) : f32
    %11 = llvm.sub %8, %arg5 : i64
    %12 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %13 = llvm.getelementptr inbounds|nuw %12[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %9, %13 : f32, !llvm.ptr
    %14 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.getelementptr inbounds|nuw %14[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %10, %15 : f32, !llvm.ptr
    llvm.br ^bb1(%6 : i64)
  ^bb1(%16: i64):  // 2 preds: ^bb0, ^bb2
    %17 = llvm.icmp "slt" %16, %11 : i64
    llvm.cond_br %17, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %18 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.getelementptr inbounds|nuw %18[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %20 = llvm.load %19 : !llvm.ptr -> f32
    %21 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %22 = llvm.getelementptr inbounds|nuw %21[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %23 = llvm.load %22 : !llvm.ptr -> f32
    %24 = llvm.add %arg5, %16 : i64
    %25 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %26 = llvm.getelementptr inbounds|nuw %25[%24] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %27 = llvm.load %26 : !llvm.ptr -> f32
    %28 = llvm.fadd %27, %20 : f32
    %29 = llvm.fadd %28, %23 : f32
    %30 = llvm.add %arg5, %16 : i64
    %31 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %32 = llvm.getelementptr inbounds|nuw %31[%30] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %29, %32 : f32, !llvm.ptr
    %33 = llvm.add %16, %7 : i64
    llvm.br ^bb1(%33 : i64)
  ^bb3:  // pred: ^bb1
    llvm.return
  }
}

