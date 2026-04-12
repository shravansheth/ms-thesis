module {
  llvm.func @free(!llvm.ptr)
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @subview_hoist_derived() {
    %0 = llvm.mlir.constant(768 : index) : i64
    %1 = llvm.mlir.constant(256 : index) : i64
    %2 = llvm.mlir.constant(0 : index) : i64
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mlir.constant(512 : index) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %6 = llvm.mlir.constant(2.000000e+00 : f32) : f32
    %7 = llvm.mlir.constant(2048 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.zero : !llvm.ptr
    %10 = llvm.getelementptr %9[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %11 = llvm.ptrtoint %10 : !llvm.ptr to i64
    %12 = llvm.call @malloc(%11) : (i64) -> !llvm.ptr
    %13 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %14 = llvm.insertvalue %12, %13[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.insertvalue %12, %14[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %16 = llvm.mlir.constant(0 : index) : i64
    %17 = llvm.insertvalue %16, %15[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %18 = llvm.insertvalue %7, %17[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.insertvalue %8, %18[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.br ^bb1(%2 : i64)
  ^bb1(%20: i64):  // 2 preds: ^bb0, ^bb2
    %21 = llvm.icmp "slt" %20, %1 : i64
    llvm.cond_br %21, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %22 = llvm.add %20, %4 : i64
    %23 = llvm.extractvalue %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.getelementptr inbounds|nuw %23[%22] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %6, %24 : f32, !llvm.ptr
    %25 = llvm.add %20, %0 : i64
    %26 = llvm.extractvalue %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = llvm.getelementptr inbounds|nuw %26[%25] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %5, %27 : f32, !llvm.ptr
    %28 = llvm.add %20, %3 : i64
    llvm.br ^bb1(%28 : i64)
  ^bb3:  // pred: ^bb1
    llvm.br ^bb4(%2 : i64)
  ^bb4(%29: i64):  // 2 preds: ^bb3, ^bb5
    %30 = llvm.icmp "slt" %29, %1 : i64
    llvm.cond_br %30, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %31 = llvm.extractvalue %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %32 = llvm.getelementptr inbounds|nuw %31[%4] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %33 = llvm.load %32 : !llvm.ptr -> f32
    %34 = llvm.add %29, %4 : i64
    %35 = llvm.extractvalue %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %36 = llvm.getelementptr inbounds|nuw %35[%34] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %37 = llvm.load %36 : !llvm.ptr -> f32
    %38 = llvm.fadd %37, %33 : f32
    %39 = llvm.add %29, %0 : i64
    %40 = llvm.extractvalue %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %41 = llvm.getelementptr inbounds|nuw %40[%39] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %38, %41 : f32, !llvm.ptr
    %42 = llvm.add %29, %3 : i64
    llvm.br ^bb4(%42 : i64)
  ^bb6:  // pred: ^bb4
    %43 = llvm.extractvalue %19[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.call @free(%43) : (!llvm.ptr) -> ()
    llvm.return
  }
}

