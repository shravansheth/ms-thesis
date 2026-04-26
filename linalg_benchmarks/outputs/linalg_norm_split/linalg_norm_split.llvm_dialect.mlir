module {
  llvm.func @linalg_norm_split(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %9 = llvm.mlir.constant(2.000000e+00 : f32) : f32
    %10 = llvm.mlir.constant(2048 : index) : i64
    %11 = llvm.sub %10, %arg5 : i64
    %12 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %13 = llvm.getelementptr inbounds|nuw %12[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %8, %13 : f32, !llvm.ptr
    %14 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.getelementptr inbounds|nuw %14[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %9, %15 : f32, !llvm.ptr
    llvm.br ^bb1(%6 : i64)
  ^bb1(%16: i64):  // 2 preds: ^bb0, ^bb2
    %17 = llvm.icmp "slt" %16, %11 : i64
    llvm.cond_br %17, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %18 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.getelementptr inbounds|nuw %18[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %20 = llvm.load %19 : !llvm.ptr -> f32
    %21 = llvm.add %arg5, %16 : i64
    %22 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.getelementptr inbounds|nuw %22[%21] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %24 = llvm.load %23 : !llvm.ptr -> f32
    %25 = llvm.fadd %24, %20 : f32
    %26 = llvm.add %arg5, %16 : i64
    %27 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %28 = llvm.getelementptr inbounds|nuw %27[%26] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %25, %28 : f32, !llvm.ptr
    %29 = llvm.add %16, %7 : i64
    llvm.br ^bb1(%29 : i64)
  ^bb3:  // pred: ^bb1
    llvm.br ^bb4(%6 : i64)
  ^bb4(%30: i64):  // 2 preds: ^bb3, ^bb5
    %31 = llvm.icmp "slt" %30, %11 : i64
    llvm.cond_br %31, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %32 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %33 = llvm.getelementptr inbounds|nuw %32[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %34 = llvm.load %33 : !llvm.ptr -> f32
    %35 = llvm.add %arg5, %30 : i64
    %36 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %37 = llvm.getelementptr inbounds|nuw %36[%35] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %38 = llvm.load %37 : !llvm.ptr -> f32
    %39 = llvm.fmul %38, %34 : f32
    %40 = llvm.add %arg5, %30 : i64
    %41 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %42 = llvm.getelementptr inbounds|nuw %41[%40] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %39, %42 : f32, !llvm.ptr
    %43 = llvm.add %30, %7 : i64
    llvm.br ^bb4(%43 : i64)
  ^bb6:  // pred: ^bb4
    llvm.return
  }
}

