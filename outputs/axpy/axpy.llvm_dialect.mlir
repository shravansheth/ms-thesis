module {
  llvm.func @axpy(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: i64, %arg8: i64, %arg9: i64) {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg5, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg6, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg7, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg8, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg9, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %7 = llvm.insertvalue %arg0, %6[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %8 = llvm.insertvalue %arg1, %7[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %9 = llvm.insertvalue %arg2, %8[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %10 = llvm.insertvalue %arg3, %9[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %11 = llvm.insertvalue %arg4, %10[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %12 = llvm.mlir.constant(0 : index) : i64
    %13 = llvm.mlir.constant(1024 : index) : i64
    %14 = llvm.mlir.constant(1 : index) : i64
    %15 = llvm.mlir.constant(2.000000e+00 : f32) : f32
    llvm.br ^bb1(%12 : i64)
  ^bb1(%16: i64):  // 2 preds: ^bb0, ^bb2
    %17 = llvm.icmp "slt" %16, %13 : i64
    llvm.cond_br %17, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %18 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.getelementptr %18[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %20 = llvm.load %19 : !llvm.ptr -> f32
    %21 = llvm.fmul %20, %15 : f32
    %22 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.getelementptr %22[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %24 = llvm.load %23 : !llvm.ptr -> f32
    %25 = llvm.fadd %24, %21 : f32
    %26 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = llvm.getelementptr %26[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %25, %27 : f32, !llvm.ptr
    %28 = llvm.add %16, %14 : i64
    llvm.br ^bb1(%28 : i64)
  ^bb3:  // pred: ^bb1
    llvm.return
  }
}

