; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "arm64-apple-macosx26.0.0"

define void @kernel_atax(i32 %0, i32 %1, ptr %2, ptr %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, ptr %12, ptr %13, i64 %14, i64 %15, i64 %16, ptr %17, ptr %18, i64 %19, i64 %20, i64 %21) {
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %17, 0
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, ptr %18, 1
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, i64 %19, 2
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 %20, 3, 0
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, i64 %21, 4, 0
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %12, 0
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, ptr %13, 1
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, i64 %14, 2
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, i64 %15, 3, 0
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, i64 %16, 4, 0
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %7, 0
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, ptr %8, 1
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, i64 %9, 2
  %36 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, i64 %10, 3, 0
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, i64 %11, 4, 0
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %2, 0
  %39 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, ptr %3, 1
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %39, i64 %4, 2
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, i64 %5, 3, 0
  %42 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, i64 %6, 4, 0
  %43 = alloca i32, i64 1, align 4
  %44 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %43, 0
  %45 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, ptr %43, 1
  %46 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %45, i64 0, 2
  %47 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %46, i64 1, 3, 0
  %48 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, i64 1, 4, 0
  %49 = alloca i32, i64 1, align 4
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %49, 0
  %51 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, ptr %49, 1
  %52 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, i64 0, 2
  %53 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %52, i64 1, 3, 0
  %54 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, i64 1, 4, 0
  %55 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %56 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %55, 0
  %57 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %56, ptr %55, 1
  %58 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, i64 0, 2
  %59 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %58, i64 1, 3, 0
  %60 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %59, i64 1, 4, 0
  %61 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %62 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %61, 0
  %63 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %62, ptr %61, 1
  %64 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %63, i64 0, 2
  %65 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %64, i64 1, 3, 0
  %66 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %65, i64 1, 4, 0
  %67 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %68 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %67, 0
  %69 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %68, ptr %67, 1
  %70 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %69, i64 0, 2
  %71 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %70, i64 1, 3, 0
  %72 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %71, i64 1, 4, 0
  %73 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %74 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %73, 0
  %75 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %74, ptr %73, 1
  %76 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %75, i64 0, 2
  %77 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %76, i64 1, 3, 0
  %78 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %77, i64 1, 4, 0
  %79 = alloca i32, i64 1, align 4
  %80 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %79, 0
  %81 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %80, ptr %79, 1
  %82 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, i64 0, 2
  %83 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, i64 1, 3, 0
  %84 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %83, i64 1, 4, 0
  %85 = alloca i32, i64 1, align 4
  %86 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %85, 0
  %87 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %86, ptr %85, 1
  %88 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, i64 0, 2
  %89 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %88, i64 1, 3, 0
  %90 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %89, i64 1, 4, 0
  %91 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, 1
  %92 = getelementptr inbounds nuw i32, ptr %91, i64 0
  store i32 %0, ptr %92, align 4
  %93 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 1
  %94 = getelementptr inbounds nuw i32, ptr %93, i64 0
  store i32 %1, ptr %94, align 4
  %95 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, 1
  %96 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %95, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, ptr %96, align 8
  %97 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %66, 1
  %98 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %97, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, ptr %98, align 8
  %99 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %72, 1
  %100 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %99, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, ptr %100, align 8
  %101 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, 1
  %102 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %101, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, ptr %102, align 8
  %103 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %104 = getelementptr inbounds nuw i32, ptr %103, i64 0
  store i32 0, ptr %104, align 4
  br label %105

105:                                              ; preds = %113, %22
  %106 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %107 = getelementptr inbounds nuw i32, ptr %106, i64 0
  %108 = load i32, ptr %107, align 4
  %109 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 1
  %110 = getelementptr inbounds nuw i32, ptr %109, i64 0
  %111 = load i32, ptr %110, align 4
  %112 = icmp slt i32 %108, %111
  br i1 %112, label %113, label %131

113:                                              ; preds = %105
  %114 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %72, 1
  %115 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %114, i64 0
  %116 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %115, align 8
  %117 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %118 = getelementptr inbounds nuw i32, ptr %117, i64 0
  %119 = load i32, ptr %118, align 4
  %120 = sext i32 %119 to i64
  %121 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %116, 1
  %122 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %116, 2
  %123 = getelementptr float, ptr %121, i64 %122
  %124 = getelementptr inbounds nuw float, ptr %123, i64 %120
  store float 0.000000e+00, ptr %124, align 4
  %125 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %126 = getelementptr inbounds nuw i32, ptr %125, i64 0
  %127 = load i32, ptr %126, align 4
  %128 = add i32 %127, 1
  %129 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %130 = getelementptr inbounds nuw i32, ptr %129, i64 0
  store i32 %128, ptr %130, align 4
  br label %105

131:                                              ; preds = %105
  %132 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %133 = getelementptr inbounds nuw i32, ptr %132, i64 0
  store i32 0, ptr %133, align 4
  br label %134

134:                                              ; preds = %263, %131
  %135 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %136 = getelementptr inbounds nuw i32, ptr %135, i64 0
  %137 = load i32, ptr %136, align 4
  %138 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, 1
  %139 = getelementptr inbounds nuw i32, ptr %138, i64 0
  %140 = load i32, ptr %139, align 4
  %141 = icmp slt i32 %137, %140
  br i1 %141, label %142, label %270

142:                                              ; preds = %134
  %143 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, 1
  %144 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %143, i64 0
  %145 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %144, align 8
  %146 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %147 = getelementptr inbounds nuw i32, ptr %146, i64 0
  %148 = load i32, ptr %147, align 4
  %149 = sext i32 %148 to i64
  %150 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %145, 1
  %151 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %145, 2
  %152 = getelementptr float, ptr %150, i64 %151
  %153 = getelementptr inbounds nuw float, ptr %152, i64 %149
  store float 0.000000e+00, ptr %153, align 4
  %154 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %155 = getelementptr inbounds nuw i32, ptr %154, i64 0
  store i32 0, ptr %155, align 4
  br label %156

156:                                              ; preds = %164, %142
  %157 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %158 = getelementptr inbounds nuw i32, ptr %157, i64 0
  %159 = load i32, ptr %158, align 4
  %160 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 1
  %161 = getelementptr inbounds nuw i32, ptr %160, i64 0
  %162 = load i32, ptr %161, align 4
  %163 = icmp slt i32 %159, %162
  br i1 %163, label %164, label %208

164:                                              ; preds = %156
  %165 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, 1
  %166 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %165, i64 0
  %167 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %166, align 8
  %168 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %169 = getelementptr inbounds nuw i32, ptr %168, i64 0
  %170 = load i32, ptr %169, align 4
  %171 = sext i32 %170 to i64
  %172 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %167, 1
  %173 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %167, 2
  %174 = getelementptr float, ptr %172, i64 %173
  %175 = getelementptr inbounds nuw float, ptr %174, i64 %171
  %176 = load float, ptr %175, align 4
  %177 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, 1
  %178 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %177, i64 0
  %179 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %178, align 8
  %180 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %181 = getelementptr inbounds nuw i32, ptr %180, i64 0
  %182 = load i32, ptr %181, align 4
  %183 = sext i32 %182 to i64
  %184 = add i64 %171, %183
  %185 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %179, 1
  %186 = getelementptr inbounds nuw float, ptr %185, i64 %184
  %187 = load float, ptr %186, align 4
  %188 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %66, 1
  %189 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %188, i64 0
  %190 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %189, align 8
  %191 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %190, 1
  %192 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %190, 2
  %193 = getelementptr float, ptr %191, i64 %192
  %194 = getelementptr inbounds nuw float, ptr %193, i64 %183
  %195 = load float, ptr %194, align 4
  %196 = fmul float %187, %195
  %197 = fadd float %176, %196
  %198 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %167, 1
  %199 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %167, 2
  %200 = getelementptr float, ptr %198, i64 %199
  %201 = getelementptr inbounds nuw float, ptr %200, i64 %171
  store float %197, ptr %201, align 4
  %202 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %203 = getelementptr inbounds nuw i32, ptr %202, i64 0
  %204 = load i32, ptr %203, align 4
  %205 = add i32 %204, 1
  %206 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %207 = getelementptr inbounds nuw i32, ptr %206, i64 0
  store i32 %205, ptr %207, align 4
  br label %156

208:                                              ; preds = %156
  %209 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %210 = getelementptr inbounds nuw i32, ptr %209, i64 0
  store i32 0, ptr %210, align 4
  br label %211

211:                                              ; preds = %219, %208
  %212 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %213 = getelementptr inbounds nuw i32, ptr %212, i64 0
  %214 = load i32, ptr %213, align 4
  %215 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 1
  %216 = getelementptr inbounds nuw i32, ptr %215, i64 0
  %217 = load i32, ptr %216, align 4
  %218 = icmp slt i32 %214, %217
  br i1 %218, label %219, label %263

219:                                              ; preds = %211
  %220 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %72, 1
  %221 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %220, i64 0
  %222 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %221, align 8
  %223 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %224 = getelementptr inbounds nuw i32, ptr %223, i64 0
  %225 = load i32, ptr %224, align 4
  %226 = sext i32 %225 to i64
  %227 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %222, 1
  %228 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %222, 2
  %229 = getelementptr float, ptr %227, i64 %228
  %230 = getelementptr inbounds nuw float, ptr %229, i64 %226
  %231 = load float, ptr %230, align 4
  %232 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, 1
  %233 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %232, i64 0
  %234 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %233, align 8
  %235 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %236 = getelementptr inbounds nuw i32, ptr %235, i64 0
  %237 = load i32, ptr %236, align 4
  %238 = sext i32 %237 to i64
  %239 = add i64 %238, %226
  %240 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 1
  %241 = getelementptr inbounds nuw float, ptr %240, i64 %239
  %242 = load float, ptr %241, align 4
  %243 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, 1
  %244 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %243, i64 0
  %245 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %244, align 8
  %246 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %245, 1
  %247 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %245, 2
  %248 = getelementptr float, ptr %246, i64 %247
  %249 = getelementptr inbounds nuw float, ptr %248, i64 %238
  %250 = load float, ptr %249, align 4
  %251 = fmul float %242, %250
  %252 = fadd float %231, %251
  %253 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %222, 1
  %254 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %222, 2
  %255 = getelementptr float, ptr %253, i64 %254
  %256 = getelementptr inbounds nuw float, ptr %255, i64 %226
  store float %252, ptr %256, align 4
  %257 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %258 = getelementptr inbounds nuw i32, ptr %257, i64 0
  %259 = load i32, ptr %258, align 4
  %260 = add i32 %259, 1
  %261 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %262 = getelementptr inbounds nuw i32, ptr %261, i64 0
  store i32 %260, ptr %262, align 4
  br label %211

263:                                              ; preds = %211
  %264 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %265 = getelementptr inbounds nuw i32, ptr %264, i64 0
  %266 = load i32, ptr %265, align 4
  %267 = add i32 %266, 1
  %268 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %269 = getelementptr inbounds nuw i32, ptr %268, i64 0
  store i32 %267, ptr %269, align 4
  br label %134

270:                                              ; preds = %134
  ret void
}

define void @run_atax_packed(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, ptr %10, ptr %11, i64 %12, i64 %13, i64 %14, i32 %15, i32 %16) {
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %10, 0
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, ptr %11, 1
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 %12, 2
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 %13, 3, 0
  %22 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, i64 %14, 4, 0
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, ptr %6, 1
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, i64 %7, 2
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 %8, 3, 0
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, i64 %9, 4, 0
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, ptr %1, 1
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, i64 %2, 2
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, i64 %3, 3, 0
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, i64 %4, 4, 0
  %33 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %33, 0
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, ptr %33, 1
  %36 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, i64 0, 2
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, i64 1, 3, 0
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, i64 1, 4, 0
  %39 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %39, 0
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, ptr %39, 1
  %42 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, i64 0, 2
  %43 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, i64 1, 3, 0
  %44 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %43, i64 1, 4, 0
  %45 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %46 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %45, 0
  %47 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %46, ptr %45, 1
  %48 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, i64 0, 2
  %49 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, i64 1, 3, 0
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %49, i64 1, 4, 0
  %51 = alloca i32, i64 1, align 4
  %52 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %51, 0
  %53 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %52, ptr %51, 1
  %54 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, i64 0, 2
  %55 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, i64 1, 3, 0
  %56 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %55, i64 1, 4, 0
  %57 = alloca i32, i64 1, align 4
  %58 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %57, 0
  %59 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %58, ptr %57, 1
  %60 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %59, i64 0, 2
  %61 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, i64 1, 3, 0
  %62 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %61, i64 1, 4, 0
  %63 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, 1
  %64 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %63, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, ptr %64, align 8
  %65 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, 1
  %66 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %65, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, ptr %66, align 8
  %67 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, 1
  %68 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %67, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, ptr %68, align 8
  %69 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %56, 1
  %70 = getelementptr inbounds nuw i32, ptr %69, i64 0
  store i32 %15, ptr %70, align 4
  %71 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %62, 1
  %72 = getelementptr inbounds nuw i32, ptr %71, i64 0
  store i32 %16, ptr %72, align 4
  %73 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %56, 1
  %74 = getelementptr inbounds nuw i32, ptr %73, i64 0
  %75 = load i32, ptr %74, align 4
  %76 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %62, 1
  %77 = getelementptr inbounds nuw i32, ptr %76, i64 0
  %78 = load i32, ptr %77, align 4
  %79 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, 1
  %80 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %79, i64 0
  %81 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %80, align 8
  %82 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, 1
  %83 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %82, i64 0
  %84 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %83, align 8
  %85 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, 1
  %86 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %85, i64 0
  %87 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %86, align 8
  %88 = sext i32 %75 to i64
  %89 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 3
  %90 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %89, ptr %90, align 4
  %91 = getelementptr [1 x i64], ptr %90, i32 0, i64 0
  %92 = load i64, ptr %91, align 4
  %93 = sub i64 %92, %88
  %94 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 0
  %95 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 1
  %96 = insertvalue { ptr, ptr, i64 } poison, ptr %94, 0
  %97 = insertvalue { ptr, ptr, i64 } %96, ptr %95, 1
  %98 = insertvalue { ptr, ptr, i64 } %97, i64 0, 2
  %99 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 2
  %100 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 3, 0
  %101 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 4, 0
  %102 = add i64 %99, %88
  %103 = extractvalue { ptr, ptr, i64 } %98, 0
  %104 = extractvalue { ptr, ptr, i64 } %98, 1
  %105 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %103, 0
  %106 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %105, ptr %104, 1
  %107 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, i64 %102, 2
  %108 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %107, i64 %93, 3, 0
  %109 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %108, i64 1, 4, 0
  %110 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 0
  %111 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 1
  %112 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 2
  %113 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 3, 0
  %114 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 4, 0
  %115 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 0
  %116 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %117 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 2
  %118 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 3, 0
  %119 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 4, 0
  %120 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 0
  %121 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 1
  %122 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 2
  %123 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 3, 0
  %124 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 4, 0
  %125 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 0
  %126 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 1
  %127 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 2
  %128 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 3, 0
  %129 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 4, 0
  call void @kernel_atax(i32 %75, i32 %78, ptr %110, ptr %111, i64 %112, i64 %113, i64 %114, ptr %115, ptr %116, i64 %117, i64 %118, i64 %119, ptr %120, ptr %121, i64 %122, i64 %123, i64 %124, ptr %125, ptr %126, i64 %127, i64 %128, i64 %129)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
