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
  %131 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 0
  %132 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 1
  %133 = insertvalue { ptr, ptr, i64 } poison, ptr %131, 0
  %134 = insertvalue { ptr, ptr, i64 } %133, ptr %132, 1
  %135 = insertvalue { ptr, ptr, i64 } %134, i64 0, 2
  %136 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 2
  %137 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 3, 0
  %138 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %102, 4, 0
  %139 = extractvalue { ptr, ptr, i64 } %135, 0
  %140 = extractvalue { ptr, ptr, i64 } %135, 1
  %141 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %139, 0
  %142 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %141, ptr %140, 1
  %143 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %142, i64 %136, 2
  %144 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %143, i64 %103, 3, 0
  %145 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %144, i64 1, 4, 0
  %146 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 0
  %147 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 1
  %148 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 2
  %149 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 3, 0
  %150 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %99, 4, 0
  %151 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %145, 0
  %152 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %145, 1
  %153 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %145, 2
  %154 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %145, 3, 0
  %155 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %145, 4, 0
  %156 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 0
  %157 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 1
  %158 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 2
  %159 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 3, 0
  %160 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %124, 4, 0
  %161 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 0
  %162 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 1
  %163 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 2
  %164 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 3, 0
  %165 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %127, 4, 0
  %166 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 0
  %167 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 1
  %168 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 2
  %169 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 3, 0
  %170 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %130, 4, 0
  call void @kernel_bicg.__alias_meta_0(i32 %93, i32 %96, ptr %146, ptr %147, i64 %148, i64 %149, i64 %150, ptr %151, ptr %152, i64 %153, i64 %154, i64 %155, ptr %156, ptr %157, i64 %158, i64 %159, i64 %160, ptr %161, ptr %162, i64 %163, i64 %164, i64 %165, ptr %166, ptr %167, i64 %168, i64 %169, i64 %170)
  ret void
}

define void @kernel_bicg.__alias_meta_0(i32 %0, i32 %1, ptr %2, ptr %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, ptr %12, ptr %13, i64 %14, i64 %15, i64 %16, ptr %17, ptr %18, i64 %19, i64 %20, i64 %21, ptr %22, ptr %23, i64 %24, i64 %25, i64 %26) {
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
  br i1 %130, label %131, label %170

131:                                              ; preds = %123
  %132 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %76, 1
  %133 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %132, i64 0
  %134 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %133, align 8
  %135 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %136 = getelementptr inbounds nuw i32, ptr %135, i64 0
  %137 = load i32, ptr %136, align 4
  %138 = sext i32 %137 to i64
  %139 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %134, 3
  %140 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %139, ptr %140, align 4
  %141 = getelementptr [1 x i64], ptr %140, i32 0, i64 0
  %142 = load i64, ptr %141, align 4
  %143 = sub i64 %142, %138
  %144 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %134, 0
  %145 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %134, 1
  %146 = insertvalue { ptr, ptr, i64 } poison, ptr %144, 0
  %147 = insertvalue { ptr, ptr, i64 } %146, ptr %145, 1
  %148 = insertvalue { ptr, ptr, i64 } %147, i64 0, 2
  %149 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %134, 2
  %150 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %134, 3, 0
  %151 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %134, 4, 0
  %152 = add i64 %149, %138
  %153 = extractvalue { ptr, ptr, i64 } %148, 0
  %154 = extractvalue { ptr, ptr, i64 } %148, 1
  %155 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %153, 0
  %156 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %155, ptr %154, 1
  %157 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %156, i64 %152, 2
  %158 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %157, i64 %143, 3, 0
  %159 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %158, i64 1, 4, 0
  %160 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %159, 1
  %161 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %159, 2
  %162 = getelementptr float, ptr %160, i64 %161
  %163 = getelementptr inbounds nuw float, ptr %162, i64 0
  store float 0.000000e+00, ptr %163, align 4, !alias.scope !1
  %164 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %165 = getelementptr inbounds nuw i32, ptr %164, i64 0
  %166 = load i32, ptr %165, align 4
  %167 = add i32 %166, 1
  %168 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %169 = getelementptr inbounds nuw i32, ptr %168, i64 0
  store i32 %167, ptr %169, align 4
  br label %123

170:                                              ; preds = %123
  %171 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %172 = getelementptr inbounds nuw i32, ptr %171, i64 0
  store i32 0, ptr %172, align 4
  br label %173

173:                                              ; preds = %347, %170
  %174 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %175 = getelementptr inbounds nuw i32, ptr %174, i64 0
  %176 = load i32, ptr %175, align 4
  %177 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %64, 1
  %178 = getelementptr inbounds nuw i32, ptr %177, i64 0
  %179 = load i32, ptr %178, align 4
  %180 = icmp slt i32 %176, %179
  br i1 %180, label %181, label %354

181:                                              ; preds = %173
  %182 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 1
  %183 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %182, i64 0
  %184 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %183, align 8
  %185 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %186 = getelementptr inbounds nuw i32, ptr %185, i64 0
  %187 = load i32, ptr %186, align 4
  %188 = sext i32 %187 to i64
  %189 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %184, 3
  %190 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %189, ptr %190, align 4
  %191 = getelementptr [1 x i64], ptr %190, i32 0, i64 0
  %192 = load i64, ptr %191, align 4
  %193 = sub i64 %192, %188
  %194 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %184, 0
  %195 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %184, 1
  %196 = insertvalue { ptr, ptr, i64 } poison, ptr %194, 0
  %197 = insertvalue { ptr, ptr, i64 } %196, ptr %195, 1
  %198 = insertvalue { ptr, ptr, i64 } %197, i64 0, 2
  %199 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %184, 2
  %200 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %184, 3, 0
  %201 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %184, 4, 0
  %202 = add i64 %199, %188
  %203 = extractvalue { ptr, ptr, i64 } %198, 0
  %204 = extractvalue { ptr, ptr, i64 } %198, 1
  %205 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %203, 0
  %206 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %205, ptr %204, 1
  %207 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %206, i64 %202, 2
  %208 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %207, i64 %193, 3, 0
  %209 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %208, i64 1, 4, 0
  %210 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 1
  %211 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %209, 2
  %212 = getelementptr float, ptr %210, i64 %211
  %213 = getelementptr inbounds nuw float, ptr %212, i64 0
  store float 0.000000e+00, ptr %213, align 4, !noalias !1
  %214 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %215 = getelementptr inbounds nuw i32, ptr %214, i64 0
  store i32 0, ptr %215, align 4
  br label %216

216:                                              ; preds = %224, %181
  %217 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %218 = getelementptr inbounds nuw i32, ptr %217, i64 0
  %219 = load i32, ptr %218, align 4
  %220 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %58, 1
  %221 = getelementptr inbounds nuw i32, ptr %220, i64 0
  %222 = load i32, ptr %221, align 4
  %223 = icmp slt i32 %219, %222
  br i1 %223, label %224, label %347

224:                                              ; preds = %216
  %225 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %76, 1
  %226 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %225, i64 0
  %227 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %226, align 8
  %228 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %229 = getelementptr inbounds nuw i32, ptr %228, i64 0
  %230 = load i32, ptr %229, align 4
  %231 = sext i32 %230 to i64
  %232 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %227, 3
  %233 = alloca [1 x i64], i64 1, align 8
  store [1 x i64] %232, ptr %233, align 4
  %234 = getelementptr [1 x i64], ptr %233, i32 0, i64 0
  %235 = load i64, ptr %234, align 4
  %236 = sub i64 %235, %231
  %237 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %227, 0
  %238 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %227, 1
  %239 = insertvalue { ptr, ptr, i64 } poison, ptr %237, 0
  %240 = insertvalue { ptr, ptr, i64 } %239, ptr %238, 1
  %241 = insertvalue { ptr, ptr, i64 } %240, i64 0, 2
  %242 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %227, 2
  %243 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %227, 3, 0
  %244 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %227, 4, 0
  %245 = add i64 %242, %231
  %246 = extractvalue { ptr, ptr, i64 } %241, 0
  %247 = extractvalue { ptr, ptr, i64 } %241, 1
  %248 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %246, 0
  %249 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %248, ptr %247, 1
  %250 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %249, i64 %245, 2
  %251 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %250, i64 %236, 3, 0
  %252 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %251, i64 1, 4, 0
  %253 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %252, 1
  %254 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %252, 2
  %255 = getelementptr float, ptr %253, i64 %254
  %256 = getelementptr inbounds nuw float, ptr %255, i64 0
  %257 = load float, ptr %256, align 4, !alias.scope !1
  %258 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %94, 1
  %259 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %258, i64 0
  %260 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %259, align 8
  %261 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %262 = getelementptr inbounds nuw i32, ptr %261, i64 0
  %263 = load i32, ptr %262, align 4
  %264 = sext i32 %263 to i64
  %265 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %260, 1
  %266 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %260, 2
  %267 = getelementptr float, ptr %265, i64 %266
  %268 = getelementptr inbounds nuw float, ptr %267, i64 %264
  %269 = load float, ptr %268, align 4
  %270 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %70, 1
  %271 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %270, i64 0
  %272 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %271, align 8
  %273 = add i64 %264, %231
  %274 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %272, 1
  %275 = getelementptr inbounds nuw float, ptr %274, i64 %273
  %276 = load float, ptr %275, align 4
  %277 = fmul float %269, %276
  %278 = fadd float %257, %277
  %279 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %252, 1
  %280 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %252, 2
  %281 = getelementptr float, ptr %279, i64 %280
  %282 = getelementptr inbounds nuw float, ptr %281, i64 0
  store float %278, ptr %282, align 4, !alias.scope !1
  %283 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %82, 1
  %284 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %283, i64 0
  %285 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %284, align 8
  %286 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
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
  %316 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %70, 1
  %317 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %316, i64 0
  %318 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %317, align 8
  %319 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %320 = getelementptr inbounds nuw i32, ptr %319, i64 0
  %321 = load i32, ptr %320, align 4
  %322 = sext i32 %321 to i64
  %323 = add i64 %289, %322
  %324 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %318, 1
  %325 = getelementptr inbounds nuw float, ptr %324, i64 %323
  %326 = load float, ptr %325, align 4
  %327 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %88, 1
  %328 = getelementptr inbounds nuw { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %327, i64 0
  %329 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %328, align 8
  %330 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %329, 1
  %331 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %329, 2
  %332 = getelementptr float, ptr %330, i64 %331
  %333 = getelementptr inbounds nuw float, ptr %332, i64 %322
  %334 = load float, ptr %333, align 4
  %335 = fmul float %326, %334
  %336 = fadd float %315, %335
  %337 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %310, 1
  %338 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %310, 2
  %339 = getelementptr float, ptr %337, i64 %338
  %340 = getelementptr inbounds nuw float, ptr %339, i64 0
  store float %336, ptr %340, align 4, !noalias !1
  %341 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %342 = getelementptr inbounds nuw i32, ptr %341, i64 0
  %343 = load i32, ptr %342, align 4
  %344 = add i32 %343, 1
  %345 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %106, 1
  %346 = getelementptr inbounds nuw i32, ptr %345, i64 0
  store i32 %344, ptr %346, align 4
  br label %216

347:                                              ; preds = %216
  %348 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %349 = getelementptr inbounds nuw i32, ptr %348, i64 0
  %350 = load i32, ptr %349, align 4
  %351 = add i32 %350, 1
  %352 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %100, 1
  %353 = getelementptr inbounds nuw i32, ptr %352, i64 0
  store i32 %351, ptr %353, align 4
  br label %173

354:                                              ; preds = %173
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = distinct !{!2, !3, !"pair_0_lo"}
!3 = distinct !{!3, !"pair_0_domain"}
