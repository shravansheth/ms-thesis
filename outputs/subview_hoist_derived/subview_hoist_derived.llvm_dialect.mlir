module {
  llvm.func @free(!llvm.ptr)
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @subview_hoist_derived() {
    %0 = llvm.mlir.constant(256 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(1 : index) : i64
    %3 = llvm.mlir.constant(512 : index) : i64
    %4 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %5 = llvm.mlir.constant(2.000000e+00 : f32) : f32
    %6 = llvm.mlir.constant(2048 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.zero : !llvm.ptr
    %9 = llvm.getelementptr %8[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %10 = llvm.ptrtoint %9 : !llvm.ptr to i64
    %11 = llvm.call @malloc(%10) : (i64) -> !llvm.ptr
    %12 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %13 = llvm.insertvalue %11, %12[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %14 = llvm.insertvalue %11, %13[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.mlir.constant(0 : index) : i64
    %16 = llvm.insertvalue %15, %14[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %17 = llvm.insertvalue %6, %16[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %18 = llvm.insertvalue %7, %17[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.br ^bb1(%1 : i64)
  ^bb1(%19: i64):  // 2 preds: ^bb0, ^bb2
    %20 = llvm.icmp "slt" %19, %0 : i64
    llvm.cond_br %20, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %21 = llvm.add %19, %3 : i64
    %22 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.getelementptr inbounds|nuw %22[%21] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %5, %23 : f32, !llvm.ptr
    %24 = llvm.mlir.constant(768 : index) : i64
    %25 = llvm.add %24, %19 : i64
    %26 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = llvm.getelementptr inbounds|nuw %26[%25] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %4, %27 : f32, !llvm.ptr
    %28 = llvm.add %19, %2 : i64
    llvm.br ^bb1(%28 : i64)
  ^bb3:  // pred: ^bb1
    llvm.br ^bb4(%1 : i64)
  ^bb4(%29: i64):  // 2 preds: ^bb3, ^bb5
    %30 = llvm.icmp "slt" %29, %0 : i64
    llvm.cond_br %30, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %31 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %32 = llvm.getelementptr inbounds|nuw %31[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %33 = llvm.load %32 : !llvm.ptr -> f32
    %34 = llvm.add %29, %3 : i64
    %35 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %36 = llvm.getelementptr inbounds|nuw %35[%34] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %37 = llvm.load %36 : !llvm.ptr -> f32
    %38 = llvm.fadd %37, %33 : f32
    %39 = llvm.mlir.constant(768 : index) : i64
    %40 = llvm.add %39, %29 : i64
    %41 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %42 = llvm.getelementptr inbounds|nuw %41[%40] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %38, %42 : f32, !llvm.ptr
    %43 = llvm.add %29, %2 : i64
    llvm.br ^bb4(%43 : i64)
  ^bb6:  // pred: ^bb4
    %44 = llvm.extractvalue %18[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.call @free(%44) : (!llvm.ptr) -> ()
    llvm.return
  }
}

