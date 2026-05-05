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
  %110 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 0
  %111 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 1
  %112 = insertvalue { ptr, ptr, i64 } poison, ptr %110, 0
  %113 = insertvalue { ptr, ptr, i64 } %112, ptr %111, 1
  %114 = insertvalue { ptr, ptr, i64 } %113, i64 0, 2
  %115 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 2
  %116 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 3, 0
  %117 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, 4, 0
  %118 = extractvalue { ptr, ptr, i64 } %114, 0
  %119 = extractvalue { ptr, ptr, i64 } %114, 1
  %120 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %118, 0
  %121 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %120, ptr %119, 1
  %122 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %121, i64 %115, 2
  %123 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %122, i64 %88, 3, 0
  %124 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %123, i64 1, 4, 0
  %125 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 0
  %126 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 1
  %127 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 2
  %128 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 3, 0
  %129 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, 4, 0
  %130 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 0
  %131 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %132 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 2
  %133 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 3, 0
  %134 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 4, 0
  %135 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 0
  %136 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 1
  %137 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 2
  %138 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 3, 0
  %139 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %109, 4, 0
  %140 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 0
  %141 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 1
  %142 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 2
  %143 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 3, 0
  %144 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 4, 0
  call void @kernel_atax.__alias_meta_0(i32 %75, i32 %78, ptr %125, ptr %126, i64 %127, i64 %128, i64 %129, ptr %130, ptr %131, i64 %132, i64 %133, i64 %134, ptr %135, ptr %136, i64 %137, i64 %138, i64 %139, ptr %140, ptr %141, i64 %142, i64 %143, i64 %144)
  ret void
}

define void @kernel_atax.__alias_meta_0(i32 %0, i32 %1, ptr %2, ptr %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, ptr %12, ptr %13, i64 %14, i64 %15, i64 %16, ptr %17, ptr %18, i64 %19, i64 %20, i64 %21) {
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
  br i1 %112, label %113, label %152

113:                                              ; preds = %105
  %114 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %72, 1
  %115 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %114, i64 0
  %116 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %115, align 8
  %117 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %118 = getelementptr inbounds nuw i32, ptr %117, i64 0
  %119 = load i32, ptr %118, align 4
  %120 = sext i32 %119 to i64
  %121 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %116, 3
  %122 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %121, ptr %122, align 4
  %123 = getelementptr [1 x i64], ptr %122, i32 0, i64 0
  %124 = load i64, ptr %123, align 4
  %125 = sub i64 %124, %120
  %126 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %116, 0
  %127 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %116, 1
  %128 = insertvalue { ptr, ptr, i64 } poison, ptr %126, 0
  %129 = insertvalue { ptr, ptr, i64 } %128, ptr %127, 1
  %130 = insertvalue { ptr, ptr, i64 } %129, i64 0, 2
  %131 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %116, 2
  %132 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %116, 3, 0
  %133 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %116, 4, 0
  %134 = add i64 %131, %120
  %135 = extractvalue { ptr, ptr, i64 } %130, 0
  %136 = extractvalue { ptr, ptr, i64 } %130, 1
  %137 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %135, 0
  %138 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %137, ptr %136, 1
  %139 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %138, i64 %134, 2
  %140 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %139, i64 %125, 3, 0
  %141 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %140, i64 1, 4, 0
  %142 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %141, 1
  %143 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %141, 2
  %144 = getelementptr float, ptr %142, i64 %143
  %145 = getelementptr inbounds nuw float, ptr %144, i64 0
  store float 0.000000e+00, ptr %145, align 4, !noalias !1
  %146 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %147 = getelementptr inbounds nuw i32, ptr %146, i64 0
  %148 = load i32, ptr %147, align 4
  %149 = add i32 %148, 1
  %150 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %151 = getelementptr inbounds nuw i32, ptr %150, i64 0
  store i32 %149, ptr %151, align 4
  br label %105

152:                                              ; preds = %105
  %153 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %154 = getelementptr inbounds nuw i32, ptr %153, i64 0
  store i32 0, ptr %154, align 4
  br label %155

155:                                              ; preds = %368, %152
  %156 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %157 = getelementptr inbounds nuw i32, ptr %156, i64 0
  %158 = load i32, ptr %157, align 4
  %159 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, 1
  %160 = getelementptr inbounds nuw i32, ptr %159, i64 0
  %161 = load i32, ptr %160, align 4
  %162 = icmp slt i32 %158, %161
  br i1 %162, label %163, label %375

163:                                              ; preds = %155
  %164 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, 1
  %165 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %164, i64 0
  %166 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %165, align 8
  %167 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %168 = getelementptr inbounds nuw i32, ptr %167, i64 0
  %169 = load i32, ptr %168, align 4
  %170 = sext i32 %169 to i64
  %171 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %166, 3
  %172 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %171, ptr %172, align 4
  %173 = getelementptr [1 x i64], ptr %172, i32 0, i64 0
  %174 = load i64, ptr %173, align 4
  %175 = sub i64 %174, %170
  %176 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %166, 0
  %177 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %166, 1
  %178 = insertvalue { ptr, ptr, i64 } poison, ptr %176, 0
  %179 = insertvalue { ptr, ptr, i64 } %178, ptr %177, 1
  %180 = insertvalue { ptr, ptr, i64 } %179, i64 0, 2
  %181 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %166, 2
  %182 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %166, 3, 0
  %183 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %166, 4, 0
  %184 = add i64 %181, %170
  %185 = extractvalue { ptr, ptr, i64 } %180, 0
  %186 = extractvalue { ptr, ptr, i64 } %180, 1
  %187 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %185, 0
  %188 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %187, ptr %186, 1
  %189 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %188, i64 %184, 2
  %190 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %189, i64 %175, 3, 0
  %191 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %190, i64 1, 4, 0
  %192 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %191, 1
  %193 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %191, 2
  %194 = getelementptr float, ptr %192, i64 %193
  %195 = getelementptr inbounds nuw float, ptr %194, i64 0
  store float 0.000000e+00, ptr %195, align 4, !alias.scope !1
  %196 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %197 = getelementptr inbounds nuw i32, ptr %196, i64 0
  store i32 0, ptr %197, align 4
  br label %198

198:                                              ; preds = %206, %163
  %199 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %200 = getelementptr inbounds nuw i32, ptr %199, i64 0
  %201 = load i32, ptr %200, align 4
  %202 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 1
  %203 = getelementptr inbounds nuw i32, ptr %202, i64 0
  %204 = load i32, ptr %203, align 4
  %205 = icmp slt i32 %201, %204
  br i1 %205, label %206, label %271

206:                                              ; preds = %198
  %207 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, 1
  %208 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %207, i64 0
  %209 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %208, align 8
  %210 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %211 = getelementptr inbounds nuw i32, ptr %210, i64 0
  %212 = load i32, ptr %211, align 4
  %213 = sext i32 %212 to i64
  %214 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 3
  %215 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %214, ptr %215, align 4
  %216 = getelementptr [1 x i64], ptr %215, i32 0, i64 0
  %217 = load i64, ptr %216, align 4
  %218 = sub i64 %217, %213
  %219 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 0
  %220 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 1
  %221 = insertvalue { ptr, ptr, i64 } poison, ptr %219, 0
  %222 = insertvalue { ptr, ptr, i64 } %221, ptr %220, 1
  %223 = insertvalue { ptr, ptr, i64 } %222, i64 0, 2
  %224 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 2
  %225 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 3, 0
  %226 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 4, 0
  %227 = add i64 %224, %213
  %228 = extractvalue { ptr, ptr, i64 } %223, 0
  %229 = extractvalue { ptr, ptr, i64 } %223, 1
  %230 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %228, 0
  %231 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %230, ptr %229, 1
  %232 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %231, i64 %227, 2
  %233 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %232, i64 %218, 3, 0
  %234 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %233, i64 1, 4, 0
  %235 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 1
  %236 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 2
  %237 = getelementptr float, ptr %235, i64 %236
  %238 = getelementptr inbounds nuw float, ptr %237, i64 0
  %239 = load float, ptr %238, align 4, !alias.scope !1
  %240 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, 1
  %241 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %240, i64 0
  %242 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %241, align 8
  %243 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %244 = getelementptr inbounds nuw i32, ptr %243, i64 0
  %245 = load i32, ptr %244, align 4
  %246 = sext i32 %245 to i64
  %247 = add i64 %213, %246
  %248 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %242, 1
  %249 = getelementptr inbounds nuw float, ptr %248, i64 %247
  %250 = load float, ptr %249, align 4
  %251 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %66, 1
  %252 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %251, i64 0
  %253 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %252, align 8
  %254 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %253, 1
  %255 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %253, 2
  %256 = getelementptr float, ptr %254, i64 %255
  %257 = getelementptr inbounds nuw float, ptr %256, i64 %246
  %258 = load float, ptr %257, align 4
  %259 = fmul float %250, %258
  %260 = fadd float %239, %259
  %261 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 1
  %262 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 2
  %263 = getelementptr float, ptr %261, i64 %262
  %264 = getelementptr inbounds nuw float, ptr %263, i64 0
  store float %260, ptr %264, align 4, !alias.scope !1
  %265 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %266 = getelementptr inbounds nuw i32, ptr %265, i64 0
  %267 = load i32, ptr %266, align 4
  %268 = add i32 %267, 1
  %269 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %270 = getelementptr inbounds nuw i32, ptr %269, i64 0
  store i32 %268, ptr %270, align 4
  br label %198

271:                                              ; preds = %198
  %272 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %273 = getelementptr inbounds nuw i32, ptr %272, i64 0
  store i32 0, ptr %273, align 4
  br label %274

274:                                              ; preds = %282, %271
  %275 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %276 = getelementptr inbounds nuw i32, ptr %275, i64 0
  %277 = load i32, ptr %276, align 4
  %278 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 1
  %279 = getelementptr inbounds nuw i32, ptr %278, i64 0
  %280 = load i32, ptr %279, align 4
  %281 = icmp slt i32 %277, %280
  br i1 %281, label %282, label %368

282:                                              ; preds = %274
  %283 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %72, 1
  %284 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %283, i64 0
  %285 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %284, align 8
  %286 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %287 = getelementptr inbounds nuw i32, ptr %286, i64 0
  %288 = load i32, ptr %287, align 4
  %289 = sext i32 %288 to i64
  %290 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %285, 3
  %291 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %290, ptr %291, align 4
  %292 = getelementptr [1 x i64], ptr %291, i32 0, i64 0
  %293 = load i64, ptr %292, align 4
  %294 = sub i64 %293, %289
  %295 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %285, 0
  %296 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %285, 1
  %297 = insertvalue { ptr, ptr, i64 } poison, ptr %295, 0
  %298 = insertvalue { ptr, ptr, i64 } %297, ptr %296, 1
  %299 = insertvalue { ptr, ptr, i64 } %298, i64 0, 2
  %300 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %285, 2
  %301 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %285, 3, 0
  %302 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %285, 4, 0
  %303 = add i64 %300, %289
  %304 = extractvalue { ptr, ptr, i64 } %299, 0
  %305 = extractvalue { ptr, ptr, i64 } %299, 1
  %306 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %304, 0
  %307 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %306, ptr %305, 1
  %308 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %307, i64 %303, 2
  %309 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %308, i64 %294, 3, 0
  %310 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %309, i64 1, 4, 0
  %311 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %310, 1
  %312 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %310, 2
  %313 = getelementptr float, ptr %311, i64 %312
  %314 = getelementptr inbounds nuw float, ptr %313, i64 0
  %315 = load float, ptr %314, align 4, !noalias !1
  %316 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, 1
  %317 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %316, i64 0
  %318 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %317, align 8
  %319 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %320 = getelementptr inbounds nuw i32, ptr %319, i64 0
  %321 = load i32, ptr %320, align 4
  %322 = sext i32 %321 to i64
  %323 = add i64 %322, %289
  %324 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %318, 1
  %325 = getelementptr inbounds nuw float, ptr %324, i64 %323
  %326 = load float, ptr %325, align 4
  %327 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, 1
  %328 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %327, i64 0
  %329 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %328, align 8
  %330 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %329, 3
  %331 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %330, ptr %331, align 4
  %332 = getelementptr [1 x i64], ptr %331, i32 0, i64 0
  %333 = load i64, ptr %332, align 4
  %334 = sub i64 %333, %322
  %335 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %329, 0
  %336 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %329, 1
  %337 = insertvalue { ptr, ptr, i64 } poison, ptr %335, 0
  %338 = insertvalue { ptr, ptr, i64 } %337, ptr %336, 1
  %339 = insertvalue { ptr, ptr, i64 } %338, i64 0, 2
  %340 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %329, 2
  %341 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %329, 3, 0
  %342 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %329, 4, 0
  %343 = add i64 %340, %322
  %344 = extractvalue { ptr, ptr, i64 } %339, 0
  %345 = extractvalue { ptr, ptr, i64 } %339, 1
  %346 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %344, 0
  %347 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %346, ptr %345, 1
  %348 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %347, i64 %343, 2
  %349 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %348, i64 %334, 3, 0
  %350 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %349, i64 1, 4, 0
  %351 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %350, 1
  %352 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %350, 2
  %353 = getelementptr float, ptr %351, i64 %352
  %354 = getelementptr inbounds nuw float, ptr %353, i64 0
  %355 = load float, ptr %354, align 4, !alias.scope !1
  %356 = fmul float %326, %355
  %357 = fadd float %315, %356
  %358 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %310, 1
  %359 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %310, 2
  %360 = getelementptr float, ptr %358, i64 %359
  %361 = getelementptr inbounds nuw float, ptr %360, i64 0
  store float %357, ptr %361, align 4, !noalias !1
  %362 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %363 = getelementptr inbounds nuw i32, ptr %362, i64 0
  %364 = load i32, ptr %363, align 4
  %365 = add i32 %364, 1
  %366 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, 1
  %367 = getelementptr inbounds nuw i32, ptr %366, i64 0
  store i32 %365, ptr %367, align 4
  br label %274

368:                                              ; preds = %274
  %369 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %370 = getelementptr inbounds nuw i32, ptr %369, i64 0
  %371 = load i32, ptr %370, align 4
  %372 = add i32 %371, 1
  %373 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, 1
  %374 = getelementptr inbounds nuw i32, ptr %373, i64 0
  store i32 %372, ptr %374, align 4
  br label %155

375:                                              ; preds = %155
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
