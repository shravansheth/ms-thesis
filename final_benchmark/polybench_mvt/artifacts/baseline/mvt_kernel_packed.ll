; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "arm64-apple-macosx26.0.0"

define void @kernel_mvt(i32 %0, ptr %1, ptr %2, i64 %3, i64 %4, i64 %5, ptr %6, ptr %7, i64 %8, i64 %9, i64 %10, ptr %11, ptr %12, i64 %13, i64 %14, i64 %15, ptr %16, ptr %17, i64 %18, i64 %19, i64 %20, ptr %21, ptr %22, i64 %23, i64 %24, i64 %25) {
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %21, 0
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, ptr %22, 1
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, i64 %23, 2
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, i64 %24, 3, 0
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, i64 %25, 4, 0
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %16, 0
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, ptr %17, 1
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, i64 %18, 2
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, i64 %19, 3, 0
  %36 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, i64 %20, 4, 0
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %11, 0
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, ptr %12, 1
  %39 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, i64 %13, 2
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %39, i64 %14, 3, 0
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, i64 %15, 4, 0
  %42 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %6, 0
  %43 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, ptr %7, 1
  %44 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %43, i64 %8, 2
  %45 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, i64 %9, 3, 0
  %46 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %45, i64 %10, 4, 0
  %47 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %1, 0
  %48 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, ptr %2, 1
  %49 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, i64 %3, 2
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %49, i64 %4, 3, 0
  %51 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, i64 %5, 4, 0
  %52 = alloca i32, i64 1, align 4
  %53 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %52, 0
  %54 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, ptr %52, 1
  %55 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, i64 0, 2
  %56 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %55, i64 1, 3, 0
  %57 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %56, i64 1, 4, 0
  %58 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %59 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %58, 0
  %60 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %59, ptr %58, 1
  %61 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, i64 0, 2
  %62 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %61, i64 1, 3, 0
  %63 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %62, i64 1, 4, 0
  %64 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %65 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %64, 0
  %66 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %65, ptr %64, 1
  %67 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %66, i64 0, 2
  %68 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %67, i64 1, 3, 0
  %69 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %68, i64 1, 4, 0
  %70 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %71 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %70, 0
  %72 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %71, ptr %70, 1
  %73 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %72, i64 0, 2
  %74 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %73, i64 1, 3, 0
  %75 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %74, i64 1, 4, 0
  %76 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %77 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %76, 0
  %78 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %77, ptr %76, 1
  %79 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, i64 0, 2
  %80 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %79, i64 1, 3, 0
  %81 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %80, i64 1, 4, 0
  %82 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %83 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %82, 0
  %84 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %83, ptr %82, 1
  %85 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, i64 0, 2
  %86 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %85, i64 1, 3, 0
  %87 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %86, i64 1, 4, 0
  %88 = alloca i32, i64 1, align 4
  %89 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %88, 0
  %90 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %89, ptr %88, 1
  %91 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, i64 0, 2
  %92 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %91, i64 1, 3, 0
  %93 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %92, i64 1, 4, 0
  %94 = alloca i32, i64 1, align 4
  %95 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %94, 0
  %96 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %95, ptr %94, 1
  %97 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %96, i64 0, 2
  %98 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %97, i64 1, 3, 0
  %99 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %98, i64 1, 4, 0
  %100 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, 1
  %101 = getelementptr inbounds nuw i32, ptr %100, i64 0
  store i32 %0, ptr %101, align 4
  %102 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %63, 1
  %103 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %102, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, ptr %103, align 8
  %104 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %69, 1
  %105 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %104, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %46, ptr %105, align 8
  %106 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %75, 1
  %107 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %106, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, ptr %107, align 8
  %108 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 1
  %109 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %108, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, ptr %109, align 8
  %110 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 1
  %111 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %110, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, ptr %111, align 8
  %112 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %113 = getelementptr inbounds nuw i32, ptr %112, i64 0
  store i32 0, ptr %113, align 4
  br label %114

114:                                              ; preds = %177, %26
  %115 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %116 = getelementptr inbounds nuw i32, ptr %115, i64 0
  %117 = load i32, ptr %116, align 4
  %118 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, 1
  %119 = getelementptr inbounds nuw i32, ptr %118, i64 0
  %120 = load i32, ptr %119, align 4
  %121 = icmp slt i32 %117, %120
  br i1 %121, label %122, label %184

122:                                              ; preds = %114
  %123 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %124 = getelementptr inbounds nuw i32, ptr %123, i64 0
  store i32 0, ptr %124, align 4
  br label %125

125:                                              ; preds = %133, %122
  %126 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %127 = getelementptr inbounds nuw i32, ptr %126, i64 0
  %128 = load i32, ptr %127, align 4
  %129 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, 1
  %130 = getelementptr inbounds nuw i32, ptr %129, i64 0
  %131 = load i32, ptr %130, align 4
  %132 = icmp slt i32 %128, %131
  br i1 %132, label %133, label %177

133:                                              ; preds = %125
  %134 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %63, 1
  %135 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %134, i64 0
  %136 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %135, align 8
  %137 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %138 = getelementptr inbounds nuw i32, ptr %137, i64 0
  %139 = load i32, ptr %138, align 4
  %140 = sext i32 %139 to i64
  %141 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %136, 1
  %142 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %136, 2
  %143 = getelementptr float, ptr %141, i64 %142
  %144 = getelementptr inbounds nuw float, ptr %143, i64 %140
  %145 = load float, ptr %144, align 4
  %146 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 1
  %147 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %146, i64 0
  %148 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %147, align 8
  %149 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %150 = getelementptr inbounds nuw i32, ptr %149, i64 0
  %151 = load i32, ptr %150, align 4
  %152 = sext i32 %151 to i64
  %153 = add i64 %140, %152
  %154 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %148, 1
  %155 = getelementptr inbounds nuw float, ptr %154, i64 %153
  %156 = load float, ptr %155, align 4
  %157 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %75, 1
  %158 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %157, i64 0
  %159 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %158, align 8
  %160 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %159, 1
  %161 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %159, 2
  %162 = getelementptr float, ptr %160, i64 %161
  %163 = getelementptr inbounds nuw float, ptr %162, i64 %152
  %164 = load float, ptr %163, align 4
  %165 = fmul float %156, %164
  %166 = fadd float %145, %165
  %167 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %136, 1
  %168 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %136, 2
  %169 = getelementptr float, ptr %167, i64 %168
  %170 = getelementptr inbounds nuw float, ptr %169, i64 %140
  store float %166, ptr %170, align 4
  %171 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %172 = getelementptr inbounds nuw i32, ptr %171, i64 0
  %173 = load i32, ptr %172, align 4
  %174 = add i32 %173, 1
  %175 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %176 = getelementptr inbounds nuw i32, ptr %175, i64 0
  store i32 %174, ptr %176, align 4
  br label %125

177:                                              ; preds = %125
  %178 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %179 = getelementptr inbounds nuw i32, ptr %178, i64 0
  %180 = load i32, ptr %179, align 4
  %181 = add i32 %180, 1
  %182 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %183 = getelementptr inbounds nuw i32, ptr %182, i64 0
  store i32 %181, ptr %183, align 4
  br label %114

184:                                              ; preds = %114
  %185 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %186 = getelementptr inbounds nuw i32, ptr %185, i64 0
  store i32 0, ptr %186, align 4
  br label %187

187:                                              ; preds = %250, %184
  %188 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %189 = getelementptr inbounds nuw i32, ptr %188, i64 0
  %190 = load i32, ptr %189, align 4
  %191 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, 1
  %192 = getelementptr inbounds nuw i32, ptr %191, i64 0
  %193 = load i32, ptr %192, align 4
  %194 = icmp slt i32 %190, %193
  br i1 %194, label %195, label %257

195:                                              ; preds = %187
  %196 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %197 = getelementptr inbounds nuw i32, ptr %196, i64 0
  store i32 0, ptr %197, align 4
  br label %198

198:                                              ; preds = %206, %195
  %199 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %200 = getelementptr inbounds nuw i32, ptr %199, i64 0
  %201 = load i32, ptr %200, align 4
  %202 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, 1
  %203 = getelementptr inbounds nuw i32, ptr %202, i64 0
  %204 = load i32, ptr %203, align 4
  %205 = icmp slt i32 %201, %204
  br i1 %205, label %206, label %250

206:                                              ; preds = %198
  %207 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %69, 1
  %208 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %207, i64 0
  %209 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %208, align 8
  %210 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %211 = getelementptr inbounds nuw i32, ptr %210, i64 0
  %212 = load i32, ptr %211, align 4
  %213 = sext i32 %212 to i64
  %214 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 1
  %215 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 2
  %216 = getelementptr float, ptr %214, i64 %215
  %217 = getelementptr inbounds nuw float, ptr %216, i64 %213
  %218 = load float, ptr %217, align 4
  %219 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 1
  %220 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %219, i64 0
  %221 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %220, align 8
  %222 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %223 = getelementptr inbounds nuw i32, ptr %222, i64 0
  %224 = load i32, ptr %223, align 4
  %225 = sext i32 %224 to i64
  %226 = add i64 %225, %213
  %227 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %221, 1
  %228 = getelementptr inbounds nuw float, ptr %227, i64 %226
  %229 = load float, ptr %228, align 4
  %230 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 1
  %231 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %230, i64 0
  %232 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %231, align 8
  %233 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %232, 1
  %234 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %232, 2
  %235 = getelementptr float, ptr %233, i64 %234
  %236 = getelementptr inbounds nuw float, ptr %235, i64 %225
  %237 = load float, ptr %236, align 4
  %238 = fmul float %229, %237
  %239 = fadd float %218, %238
  %240 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 1
  %241 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 2
  %242 = getelementptr float, ptr %240, i64 %241
  %243 = getelementptr inbounds nuw float, ptr %242, i64 %213
  store float %239, ptr %243, align 4
  %244 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %245 = getelementptr inbounds nuw i32, ptr %244, i64 0
  %246 = load i32, ptr %245, align 4
  %247 = add i32 %246, 1
  %248 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %249 = getelementptr inbounds nuw i32, ptr %248, i64 0
  store i32 %247, ptr %249, align 4
  br label %198

250:                                              ; preds = %198
  %251 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %252 = getelementptr inbounds nuw i32, ptr %251, i64 0
  %253 = load i32, ptr %252, align 4
  %254 = add i32 %253, 1
  %255 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, 1
  %256 = getelementptr inbounds nuw i32, ptr %255, i64 0
  store i32 %254, ptr %256, align 4
  br label %187

257:                                              ; preds = %187
  ret void
}

define void @run_mvt_packed(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, ptr %10, ptr %11, i64 %12, i64 %13, i64 %14, ptr %15, ptr %16, i64 %17, i64 %18, i64 %19, i32 %20) {
  %22 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %15, 0
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, ptr %16, 1
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, i64 %17, 2
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, i64 %18, 3, 0
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 %19, 4, 0
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %10, 0
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, ptr %11, 1
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, i64 %12, 2
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, i64 %13, 3, 0
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, i64 %14, 4, 0
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, ptr %6, 1
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, i64 %7, 2
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, i64 %8, 3, 0
  %36 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, i64 %9, 4, 0
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, ptr %1, 1
  %39 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, i64 %2, 2
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %39, i64 %3, 3, 0
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, i64 %4, 4, 0
  %42 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %43 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %42, 0
  %44 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %43, ptr %42, 1
  %45 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, i64 0, 2
  %46 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %45, i64 1, 3, 0
  %47 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %46, i64 1, 4, 0
  %48 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %49 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %48, 0
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %49, ptr %48, 1
  %51 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, i64 0, 2
  %52 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, i64 1, 3, 0
  %53 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %52, i64 1, 4, 0
  %54 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %55 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %54, 0
  %56 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %55, ptr %54, 1
  %57 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %56, i64 0, 2
  %58 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, i64 1, 3, 0
  %59 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %58, i64 1, 4, 0
  %60 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %61 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %60, 0
  %62 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %61, ptr %60, 1
  %63 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %62, i64 0, 2
  %64 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %63, i64 1, 3, 0
  %65 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %64, i64 1, 4, 0
  %66 = alloca i32, i64 1, align 4
  %67 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %66, 0
  %68 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %67, ptr %66, 1
  %69 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %68, i64 0, 2
  %70 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %69, i64 1, 3, 0
  %71 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %70, i64 1, 4, 0
  %72 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, 1
  %73 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %72, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, ptr %73, align 8
  %74 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, 1
  %75 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %74, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, ptr %75, align 8
  %76 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %59, 1
  %77 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %76, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, ptr %77, align 8
  %78 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %65, 1
  %79 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %78, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, ptr %79, align 8
  %80 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %71, 1
  %81 = getelementptr inbounds nuw i32, ptr %80, i64 0
  store i32 %20, ptr %81, align 4
  %82 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %71, 1
  %83 = getelementptr inbounds nuw i32, ptr %82, i64 0
  %84 = load i32, ptr %83, align 4
  %85 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %65, 1
  %86 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %85, i64 0
  %87 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %86, align 8
  %88 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, 1
  %89 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %88, i64 0
  %90 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %89, align 8
  %91 = sext i32 %84 to i64
  %92 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 3
  %93 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %92, ptr %93, align 4
  %94 = getelementptr [1 x i64], ptr %93, i32 0, i64 0
  %95 = load i64, ptr %94, align 4
  %96 = sub i64 %95, %91
  %97 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 0
  %98 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 1
  %99 = insertvalue { ptr, ptr, i64 } poison, ptr %97, 0
  %100 = insertvalue { ptr, ptr, i64 } %99, ptr %98, 1
  %101 = insertvalue { ptr, ptr, i64 } %100, i64 0, 2
  %102 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 2
  %103 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 3, 0
  %104 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 4, 0
  %105 = add i64 %102, %91
  %106 = extractvalue { ptr, ptr, i64 } %101, 0
  %107 = extractvalue { ptr, ptr, i64 } %101, 1
  %108 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %106, 0
  %109 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %108, ptr %107, 1
  %110 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, i64 %105, 2
  %111 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %110, i64 %96, 3, 0
  %112 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %111, i64 1, 4, 0
  %113 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %59, 1
  %114 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %113, i64 0
  %115 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %114, align 8
  %116 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, 1
  %117 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %116, i64 0
  %118 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %117, align 8
  %119 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 0
  %120 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 1
  %121 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 2
  %122 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 3, 0
  %123 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 4, 0
  %124 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 0
  %125 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %126 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 2
  %127 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 3, 0
  %128 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 4, 0
  %129 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %112, 0
  %130 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %112, 1
  %131 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %112, 2
  %132 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %112, 3, 0
  %133 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %112, 4, 0
  %134 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %115, 0
  %135 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %115, 1
  %136 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %115, 2
  %137 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %115, 3, 0
  %138 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %115, 4, 0
  %139 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %118, 0
  %140 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %118, 1
  %141 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %118, 2
  %142 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %118, 3, 0
  %143 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %118, 4, 0
  call void @kernel_mvt(i32 %84, ptr %119, ptr %120, i64 %121, i64 %122, i64 %123, ptr %124, ptr %125, i64 %126, i64 %127, i64 %128, ptr %129, ptr %130, i64 %131, i64 %132, i64 %133, ptr %134, ptr %135, i64 %136, i64 %137, i64 %138, ptr %139, ptr %140, i64 %141, i64 %142, i64 %143)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
