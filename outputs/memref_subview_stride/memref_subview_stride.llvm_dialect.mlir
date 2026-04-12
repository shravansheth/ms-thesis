module {
  llvm.func @free(!llvm.ptr)
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @case_stride_even_odd() {
    %0 = llvm.mlir.constant(512 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(1 : index) : i64
    %3 = llvm.mlir.constant(256 : index) : i64
    %4 = llvm.mlir.constant(2.000000e+00 : f32) : f32
    %5 = llvm.mlir.constant(2048 : index) : i64
    %6 = llvm.mlir.constant(1 : index) : i64
    %7 = llvm.mlir.zero : !llvm.ptr
    %8 = llvm.getelementptr %7[%5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %9 = llvm.ptrtoint %8 : !llvm.ptr to i64
    %10 = llvm.call @malloc(%9) : (i64) -> !llvm.ptr
    %11 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %12 = llvm.insertvalue %10, %11[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %13 = llvm.insertvalue %10, %12[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %14 = llvm.mlir.constant(0 : index) : i64
    %15 = llvm.insertvalue %14, %13[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %16 = llvm.insertvalue %5, %15[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %17 = llvm.insertvalue %6, %16[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %18 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.getelementptr inbounds|nuw %18[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %4, %19 : f32, !llvm.ptr
    llvm.br ^bb1(%1 : i64)
  ^bb1(%20: i64):  // 2 preds: ^bb0, ^bb2
    %21 = llvm.icmp "slt" %20, %3 : i64
    llvm.cond_br %21, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %22 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.getelementptr inbounds|nuw %22[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %24 = llvm.load %23 : !llvm.ptr -> f32
    %25 = llvm.mlir.constant(2 : index) : i64
    %26 = llvm.mul %20, %25 overflow<nsw> : i64
    %27 = llvm.mlir.constant(512 : index) : i64
    %28 = llvm.add %26, %27 : i64
    %29 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.getelementptr inbounds|nuw %29[%28] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %31 = llvm.load %30 : !llvm.ptr -> f32
    %32 = llvm.fadd %31, %24 : f32
    %33 = llvm.mlir.constant(2 : index) : i64
    %34 = llvm.mul %20, %33 overflow<nsw> : i64
    %35 = llvm.mlir.constant(513 : index) : i64
    %36 = llvm.add %34, %35 : i64
    %37 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.getelementptr inbounds|nuw %37[%36] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %32, %38 : f32, !llvm.ptr
    %39 = llvm.add %20, %2 : i64
    llvm.br ^bb1(%39 : i64)
  ^bb3:  // pred: ^bb1
    %40 = llvm.extractvalue %17[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.call @free(%40) : (!llvm.ptr) -> ()
    llvm.return
  }
}

