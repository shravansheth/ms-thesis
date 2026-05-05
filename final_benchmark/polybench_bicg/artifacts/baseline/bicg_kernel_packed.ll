; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "arm64-apple-macosx26.0.0"

define void @kernel_bicg(i32 %0, i32 %1, ptr %2, ptr %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, ptr %12, ptr %13, i64 %14, i64 %15, i64 %16, ptr %17, ptr %18, i64 %19, i64 %20, i64 %21, ptr %22, ptr %23, i64 %24, i64 %25, i64 %26) {
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %22, 0
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, ptr %23, 1
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, i64 %24, 2
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, i64 %25, 3, 0
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, i64 %26, 4, 0
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %17, 0
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, ptr %18, 1
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, i64 %19, 2
  %36 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, i64 %20, 3, 0
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, i64 %21, 4, 0
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %12, 0
  %39 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, ptr %13, 1
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %39, i64 %14, 2
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, i64 %15, 3, 0
  %42 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, i64 %16, 4, 0
  %43 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %7, 0
  %44 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %43, ptr %8, 1
  %45 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, i64 %9, 2
  %46 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %45, i64 %10, 3, 0
  %47 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %46, i64 %11, 4, 0
  %48 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %2, 0
  %49 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, ptr %3, 1
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %49, i64 %4, 2
  %51 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, i64 %5, 3, 0
  %52 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, i64 %6, 4, 0
  %53 = alloca i32, i64 1, align 4
  %54 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %53, 0
  %55 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, ptr %53, 1
  %56 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %55, i64 0, 2
  %57 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %56, i64 1, 3, 0
  %58 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, i64 1, 4, 0
  %59 = alloca i32, i64 1, align 4
  %60 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %59, 0
  %61 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, ptr %59, 1
  %62 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %61, i64 0, 2
  %63 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %62, i64 1, 3, 0
  %64 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %63, i64 1, 4, 0
  %65 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %66 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %65, 0
  %67 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %66, ptr %65, 1
  %68 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %67, i64 0, 2
  %69 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %68, i64 1, 3, 0
  %70 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %69, i64 1, 4, 0
  %71 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %72 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %71, 0
  %73 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %72, ptr %71, 1
  %74 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %73, i64 0, 2
  %75 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %74, i64 1, 3, 0
  %76 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %75, i64 1, 4, 0
  %77 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %78 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %77, 0
  %79 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, ptr %77, 1
  %80 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %79, i64 0, 2
  %81 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %80, i64 1, 3, 0
  %82 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %81, i64 1, 4, 0
  %83 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %84 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %83, 0
  %85 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %84, ptr %83, 1
  %86 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %85, i64 0, 2
  %87 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %86, i64 1, 3, 0
  %88 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %87, i64 1, 4, 0
  %89 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %90 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %89, 0
  %91 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %90, ptr %89, 1
  %92 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %91, i64 0, 2
  %93 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %92, i64 1, 3, 0
  %94 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %93, i64 1, 4, 0
  %95 = alloca i32, i64 1, align 4
  %96 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %95, 0
  %97 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %96, ptr %95, 1
  %98 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %97, i64 0, 2
  %99 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %98, i64 1, 3, 0
  %100 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, i64 1, 4, 0
  %101 = alloca i32, i64 1, align 4
  %102 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %101, 0
  %103 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, ptr %101, 1
  %104 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %103, i64 0, 2
  %105 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %104, i64 1, 3, 0
  %106 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %105, i64 1, 4, 0
  %107 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %58, 1
  %108 = getelementptr inbounds nuw i32, ptr %107, i64 0
  store i32 %0, ptr %108, align 4
  %109 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %64, 1
  %110 = getelementptr inbounds nuw i32, ptr %109, i64 0
  store i32 %1, ptr %110, align 4
  %111 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %70, 1
  %112 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %111, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %52, ptr %112, align 8
  %113 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %76, 1
  %114 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %113, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, ptr %114, align 8
  %115 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 1
  %116 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %115, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, ptr %116, align 8
  %117 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %88, 1
  %118 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %117, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, ptr %118, align 8
  %119 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %94, 1
  %120 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %119, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, ptr %120, align 8
  %121 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %122 = getelementptr inbounds nuw i32, ptr %121, i64 0
  store i32 0, ptr %122, align 4
  br label %123

123:                                              ; preds = %131, %27
  %124 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %125 = getelementptr inbounds nuw i32, ptr %124, i64 0
  %126 = load i32, ptr %125, align 4
  %127 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %58, 1
  %128 = getelementptr inbounds nuw i32, ptr %127, i64 0
  %129 = load i32, ptr %128, align 4
  %130 = icmp slt i32 %126, %129
  br i1 %130, label %131, label %149

131:                                              ; preds = %123
  %132 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %76, 1
  %133 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %132, i64 0
  %134 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %133, align 8
  %135 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %136 = getelementptr inbounds nuw i32, ptr %135, i64 0
  %137 = load i32, ptr %136, align 4
  %138 = sext i32 %137 to i64
  %139 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %134, 1
  %140 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %134, 2
  %141 = getelementptr float, ptr %139, i64 %140
  %142 = getelementptr inbounds nuw float, ptr %141, i64 %138
  store float 0.000000e+00, ptr %142, align 4
  %143 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %144 = getelementptr inbounds nuw i32, ptr %143, i64 0
  %145 = load i32, ptr %144, align 4
  %146 = add i32 %145, 1
  %147 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %148 = getelementptr inbounds nuw i32, ptr %147, i64 0
  store i32 %146, ptr %148, align 4
  br label %123

149:                                              ; preds = %123
  %150 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %151 = getelementptr inbounds nuw i32, ptr %150, i64 0
  store i32 0, ptr %151, align 4
  br label %152

152:                                              ; preds = %263, %149
  %153 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %154 = getelementptr inbounds nuw i32, ptr %153, i64 0
  %155 = load i32, ptr %154, align 4
  %156 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %64, 1
  %157 = getelementptr inbounds nuw i32, ptr %156, i64 0
  %158 = load i32, ptr %157, align 4
  %159 = icmp slt i32 %155, %158
  br i1 %159, label %160, label %270

160:                                              ; preds = %152
  %161 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 1
  %162 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %161, i64 0
  %163 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %162, align 8
  %164 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %165 = getelementptr inbounds nuw i32, ptr %164, i64 0
  %166 = load i32, ptr %165, align 4
  %167 = sext i32 %166 to i64
  %168 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %163, 1
  %169 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %163, 2
  %170 = getelementptr float, ptr %168, i64 %169
  %171 = getelementptr inbounds nuw float, ptr %170, i64 %167
  store float 0.000000e+00, ptr %171, align 4
  %172 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %173 = getelementptr inbounds nuw i32, ptr %172, i64 0
  store i32 0, ptr %173, align 4
  br label %174

174:                                              ; preds = %182, %160
  %175 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %176 = getelementptr inbounds nuw i32, ptr %175, i64 0
  %177 = load i32, ptr %176, align 4
  %178 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %58, 1
  %179 = getelementptr inbounds nuw i32, ptr %178, i64 0
  %180 = load i32, ptr %179, align 4
  %181 = icmp slt i32 %177, %180
  br i1 %181, label %182, label %263

182:                                              ; preds = %174
  %183 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %76, 1
  %184 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %183, i64 0
  %185 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %184, align 8
  %186 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %187 = getelementptr inbounds nuw i32, ptr %186, i64 0
  %188 = load i32, ptr %187, align 4
  %189 = sext i32 %188 to i64
  %190 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %185, 1
  %191 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %185, 2
  %192 = getelementptr float, ptr %190, i64 %191
  %193 = getelementptr inbounds nuw float, ptr %192, i64 %189
  %194 = load float, ptr %193, align 4
  %195 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %94, 1
  %196 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %195, i64 0
  %197 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %196, align 8
  %198 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %199 = getelementptr inbounds nuw i32, ptr %198, i64 0
  %200 = load i32, ptr %199, align 4
  %201 = sext i32 %200 to i64
  %202 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %197, 1
  %203 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %197, 2
  %204 = getelementptr float, ptr %202, i64 %203
  %205 = getelementptr inbounds nuw float, ptr %204, i64 %201
  %206 = load float, ptr %205, align 4
  %207 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %70, 1
  %208 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %207, i64 0
  %209 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %208, align 8
  %210 = add i64 %201, %189
  %211 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 1
  %212 = getelementptr inbounds nuw float, ptr %211, i64 %210
  %213 = load float, ptr %212, align 4
  %214 = fmul float %206, %213
  %215 = fadd float %194, %214
  %216 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %185, 1
  %217 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %185, 2
  %218 = getelementptr float, ptr %216, i64 %217
  %219 = getelementptr inbounds nuw float, ptr %218, i64 %189
  store float %215, ptr %219, align 4
  %220 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 1
  %221 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %220, i64 0
  %222 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %221, align 8
  %223 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %224 = getelementptr inbounds nuw i32, ptr %223, i64 0
  %225 = load i32, ptr %224, align 4
  %226 = sext i32 %225 to i64
  %227 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %222, 1
  %228 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %222, 2
  %229 = getelementptr float, ptr %227, i64 %228
  %230 = getelementptr inbounds nuw float, ptr %229, i64 %226
  %231 = load float, ptr %230, align 4
  %232 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %70, 1
  %233 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %232, i64 0
  %234 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %233, align 8
  %235 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %236 = getelementptr inbounds nuw i32, ptr %235, i64 0
  %237 = load i32, ptr %236, align 4
  %238 = sext i32 %237 to i64
  %239 = add i64 %226, %238
  %240 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 1
  %241 = getelementptr inbounds nuw float, ptr %240, i64 %239
  %242 = load float, ptr %241, align 4
  %243 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %88, 1
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
  %257 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %258 = getelementptr inbounds nuw i32, ptr %257, i64 0
  %259 = load i32, ptr %258, align 4
  %260 = add i32 %259, 1
  %261 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %262 = getelementptr inbounds nuw i32, ptr %261, i64 0
  store i32 %260, ptr %262, align 4
  br label %174

263:                                              ; preds = %174
  %264 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %265 = getelementptr inbounds nuw i32, ptr %264, i64 0
  %266 = load i32, ptr %265, align 4
  %267 = add i32 %266, 1
  %268 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %269 = getelementptr inbounds nuw i32, ptr %268, i64 0
  store i32 %267, ptr %269, align 4
  br label %152

270:                                              ; preds = %152
  ret void
}

define void @run_bicg_packed(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, ptr %10, ptr %11, i64 %12, i64 %13, i64 %14, ptr %15, ptr %16, i64 %17, i64 %18, i64 %19, i32 %20, i32 %21) {
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %15, 0
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, ptr %16, 1
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, i64 %17, 2
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 %18, 3, 0
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, i64 %19, 4, 0
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %10, 0
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, ptr %11, 1
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, i64 %12, 2
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, i64 %13, 3, 0
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, i64 %14, 4, 0
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, ptr %6, 1
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, i64 %7, 2
  %36 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, i64 %8, 3, 0
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, i64 %9, 4, 0
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %39 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, ptr %1, 1
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %39, i64 %2, 2
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, i64 %3, 3, 0
  %42 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, i64 %4, 4, 0
  %43 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  %44 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %43, 0
  %45 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, ptr %43, 1
  %46 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %45, i64 0, 2
  %47 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %46, i64 1, 3, 0
  %48 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, i64 1, 4, 0
  %49 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
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
  %67 = alloca i32, i64 1, align 4
  %68 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %67, 0
  %69 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %68, ptr %67, 1
  %70 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %69, i64 0, 2
  %71 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %70, i64 1, 3, 0
  %72 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %71, i64 1, 4, 0
  %73 = alloca i32, i64 1, align 4
  %74 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %73, 0
  %75 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %74, ptr %73, 1
  %76 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %75, i64 0, 2
  %77 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %76, i64 1, 3, 0
  %78 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %77, i64 1, 4, 0
  %79 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, 1
  %80 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %79, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, ptr %80, align 8
  %81 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 1
  %82 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %81, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, ptr %82, align 8
  %83 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, 1
  %84 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %83, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, ptr %84, align 8
  %85 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %66, 1
  %86 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %85, i64 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, ptr %86, align 8
  %87 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %72, 1
  %88 = getelementptr inbounds nuw i32, ptr %87, i64 0
  store i32 %20, ptr %88, align 4
  %89 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, 1
  %90 = getelementptr inbounds nuw i32, ptr %89, i64 0
  store i32 %21, ptr %90, align 4
  %91 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %72, 1
  %92 = getelementptr inbounds nuw i32, ptr %91, i64 0
  %93 = load i32, ptr %92, align 4
  %94 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %78, 1
  %95 = getelementptr inbounds nuw i32, ptr %94, i64 0
  %96 = load i32, ptr %95, align 4
  %97 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, 1
  %98 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %97, i64 0
  %99 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %98, align 8
  %100 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %66, 1
  %101 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %100, i64 0
  %102 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %101, align 8
  %103 = sext i32 %93 to i64
  %104 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 3
  %105 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %104, ptr %105, align 4
  %106 = getelementptr [1 x i64], ptr %105, i32 0, i64 0
  %107 = load i64, ptr %106, align 4
  %108 = sub i64 %107, %103
  %109 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 0
  %110 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 1
  %111 = insertvalue { ptr, ptr, i64 } poison, ptr %109, 0
  %112 = insertvalue { ptr, ptr, i64 } %111, ptr %110, 1
  %113 = insertvalue { ptr, ptr, i64 } %112, i64 0, 2
  %114 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 2
  %115 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 3, 0
  %116 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 4, 0
  %117 = add i64 %114, %103
  %118 = extractvalue { ptr, ptr, i64 } %113, 0
  %119 = extractvalue { ptr, ptr, i64 } %113, 1
  %120 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %118, 0
  %121 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %120, ptr %119, 1
  %122 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %121, i64 %117, 2
  %123 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %122, i64 %108, 3, 0
  %124 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %123, i64 1, 4, 0
  %125 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 1
  %126 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %125, i64 0
  %127 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %126, align 8
  %128 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %60, 1
  %129 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %128, i64 0
  %130 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %129, align 8
  %131 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 0
  %132 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %133 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 2
  %134 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 3, 0
  %135 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 4, 0
  %136 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 0
  %137 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 1
  %138 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 2
  %139 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 3, 0
  %140 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 4, 0
  %141 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 0
  %142 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 1
  %143 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 2
  %144 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 3, 0
  %145 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 4, 0
  %146 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 0
  %147 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 1
  %148 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 2
  %149 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 3, 0
  %150 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 4, 0
  %151 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 0
  %152 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 1
  %153 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 2
  %154 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 3, 0
  %155 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 4, 0
  call void @kernel_bicg(i32 %93, i32 %96, ptr %131, ptr %132, i64 %133, i64 %134, i64 %135, ptr %136, ptr %137, i64 %138, i64 %139, i64 %140, ptr %141, ptr %142, i64 %143, i64 %144, i64 %145, ptr %146, ptr %147, i64 %148, i64 %149, i64 %150, ptr %151, ptr %152, i64 %153, i64 %154, i64 %155)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
