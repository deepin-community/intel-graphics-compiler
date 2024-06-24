;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2022 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================

; RUN: igc_opt %s -S -o - -opt-reduce-pass | FileCheck %s
; UNSUPPORTED: khronos-translator

declare spir_func <3 x i64> @__builtin_spirv_BuiltInGlobalSize()
declare spir_func <3 x i64> @__builtin_spirv_BuiltInGlobalOffset()
declare spir_func <3 x i64> @__builtin_spirv_BuiltInGlobalInvocationId()
declare spir_func i32 @__builtin_spirv_OpGroupIMulKHR_i32_i32_i32(i32, i32, i32)

define spir_kernel void @kernel1(i32 addrspace(1)* %arg0, i32 addrspace(1)* %arg1) {
  %size = call spir_func <3 x i64> @__builtin_spirv_BuiltInGlobalSize()
  %size1 = extractelement <3 x i64> %size, i32 1
  %size0 = extractelement <3 x i64> %size, i32 0
  %id = call spir_func <3 x i64> @__builtin_spirv_BuiltInGlobalInvocationId()
  %id2 = extractelement <3 x i64> %id, i32 2
  %id1 = extractelement <3 x i64> %id, i32 1
  %id0 = extractelement <3 x i64> %id, i32 0
  %offset = call spir_func <3 x i64> @__builtin_spirv_BuiltInGlobalOffset()
  %offset2 = extractelement <3 x i64> %offset, i32 2
  %offset1 = extractelement <3 x i64> %offset, i32 1
  %offset0 = extractelement <3 x i64> %offset, i32 0
  %sub0 = sub i64 %id2, %offset2
  %mul0 = mul i64 %sub0, %size1
  %sub1 = sub i64 %id1, %offset1
  %add0 = add i64 %mul0, %sub1
  %mul1 = mul i64 %add0, %size0
  %sub2 = sub i64 %id0, %offset0
  %add1 = add i64 %mul1, %sub2
  %gep0 = getelementptr inbounds i32, i32 addrspace(1)* %arg0, i64 %add1
  %addr0 = addrspacecast i32 addrspace(1)* %gep0 to i32 addrspace(4)*
  %ld = load i32, i32 addrspace(4)* %addr0, align 4
  %red = call spir_func i32 @__builtin_spirv_OpGroupIMulKHR_i32_i32_i32(i32 2, i32 0, i32 %ld)
  %cnd = icmp eq i64 %add1, 0
  %tof = sitofp i32 %red to float
  ; This pass optimized only reduce instruction
  ;
  ; CHECK:    [[LD:%.*]] = load i32, i32 addrspace(4)* {{.*}}, align 4
  ; CHECK:    [[TMP1:%.*]] = call spir_func i32 @__builtin_IB_WorkGroupReduce_WI0_IMulKHR_i32(i32 [[LD]])
  ; CHECK:    [[TOF:%.*]] = sitofp i32 [[TMP1]] to float
  %fadd0 = fadd float %tof, 1.000000e+02
  %toi = fptosi float %fadd0 to i32
  %sel0 = select i1 %cnd, i32 %toi, i32 0
  %gep1 = getelementptr inbounds i32, i32 addrspace(1)* %arg1, i64 %add1
  %addr1 = addrspacecast i32 addrspace(1)* %gep1 to i32 addrspace(4)*
  store i32 %sel0, i32 addrspace(4)* %addr1, align 4
  ret void
}


declare spir_func i32 @__builtin_spirv_OpGroupIAdd_i32_i32_i32(i32, i32, i32)
declare spir_func <3 x i64> @__builtin_spirv_BuiltInLocalInvocationId()
declare spir_func <3 x i64> @__builtin_spirv_BuiltInWorkgroupSize()

define spir_kernel void @kernel2(i32 addrspace(1)* %arg0, i32 addrspace(1)* %arg1) {
  %size = call spir_func <3 x i64> @__builtin_spirv_BuiltInWorkgroupSize()
  %size1 = extractelement <3 x i64> %size, i32 1
  %size0 = extractelement <3 x i64> %size, i32 0
  %lid = call spir_func <3 x i64> @__builtin_spirv_BuiltInLocalInvocationId()
  %lid2 = extractelement <3 x i64> %lid, i32 2
  %lid1 = extractelement <3 x i64> %lid, i32 1
  %lid0 = extractelement <3 x i64> %lid, i32 0
  %mul0 = mul i64 %lid2, %size1
  %add0 = add i64 %mul0, %lid1
  %mul1 = mul i64 %add0, %size0
  %add1 = add i64 %mul1, %lid0
  %gep0 = getelementptr inbounds i32, i32 addrspace(1)* %arg0, i64 %add1
  %addr0 = addrspacecast i32 addrspace(1)* %gep0 to i32 addrspace(4)*
  %ld0 = load i32, i32 addrspace(4)* %addr0, align 4
  %red = call spir_func i32 @__builtin_spirv_OpGroupIAdd_i32_i32_i32(i32 2, i32 0, i32 %ld0)
  %cnd = icmp eq i64 %add1, 0
  %add2 = add nsw i32 %red, 100
  ; This pass optimized only reduce instruction
  ;
  ; CHECK:    [[LD0:%.*]] = load i32, i32 addrspace(4)* {{.*}}, align
  ; CHECK:    [[TMP1:%.*]] = call spir_func i32 @__builtin_IB_WorkGroupReduce_WI0_IAdd_i32(i32 [[LD0]])
  ; CHECK:    [[ADD2:%.*]] = add nsw i32 [[TMP1:%.*]], 100
  %sel = select i1 %cnd, i32 %add2, i32 0
  %gep1 = getelementptr inbounds i32, i32 addrspace(1)* %arg1, i64 %add1
  %addr1 = addrspacecast i32 addrspace(1)* %gep1 to i32 addrspace(4)*
  store i32 %sel, i32 addrspace(4)* %addr1, align 4
  ret void
}

