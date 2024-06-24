;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2017-2023 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================
;
;

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-n8:16:32"
target triple = "spir64-unknown-unknown"

;
; CHECK-LABEL: define spir_kernel void @test_vector_creation
;
; Function Attrs: convergent nounwind
define spir_kernel void @test_vector_creation(i8 addrspace(1)* %src, <4 x i8> addrspace(1)* %result) #0 {
entry:
;
; case 0: 4 load i8 --> load i32 --> bitcast <4 x i8> --> store
;         handle insertelement
; CHECK-LABEL: c0.base
; CHECK: [[T0_0:%.*]] = load i32
; CHECK: {{.*}} = bitcast i32 [[T0_0]] to <4 x i8>
;
  %c0.base = getelementptr inbounds i8, i8 addrspace(1)* %src, i64 0
  %c0.0 = load i8, i8 addrspace(1)* %c0.base, align 1
  %c0.arrayidx1 = getelementptr inbounds i8, i8 addrspace(1)* %c0.base, i64 1
  %c0.1 = load i8, i8 addrspace(1)* %c0.arrayidx1, align 1
  %c0.arrayidx3 = getelementptr inbounds i8, i8 addrspace(1)* %c0.base, i64 2
  %c0.2 = load i8, i8 addrspace(1)* %c0.arrayidx3, align 1
  %c0.arrayidx5 = getelementptr inbounds i8, i8 addrspace(1)* %c0.base, i64 3
  %c0.3 = load i8, i8 addrspace(1)* %c0.arrayidx5, align 1
  %c0.v.0 = insertelement <4 x i8> undef,   i8 %c0.0, i32 0
  %c0.v.1 = insertelement <4 x i8> %c0.v.0, i8 %c0.1, i32 1
  %c0.v.2 = insertelement <4 x i8> %c0.v.1, i8 %c0.2, i32 2
  %c0.v.3 = insertelement <4 x i8> %c0.v.2, i8 %c0.3, i32 3
  %c0.dst = getelementptr inbounds <4 x i8>, <4 x i8> addrspace(1)* %result, i64 0
  store <4 x i8> %c0.v.3, <4 x i8> addrspace(1)* %c0.dst, align 4

;
; case 1: [i8, i8, <2 x i8>] --> load i32
;         handle insertelement and shufflevector
;
; CHECK-LABEL: c1.base
; CHECK: [[T1_0:%.*]] = load i32
; CHECK: {{.*}} = bitcast i32 [[T1_0]] to <4 x i8>
;
  %c1.base = getelementptr inbounds i8, i8 addrspace(1)* %src, i64 16
  %c1.0 = load i8, i8 addrspace(1)* %c1.base, align 1
  %c1.arrayidx1 = getelementptr inbounds i8, i8 addrspace(1)* %c1.base, i64 1
  %c1.1 = load i8, i8 addrspace(1)* %c1.arrayidx1, align 1
  %c1.arrayidx3 = getelementptr inbounds i8, i8 addrspace(1)* %c1.base, i64 2
  %c1.arrayidx3.0 = bitcast i8 addrspace(1)* %c1.arrayidx3 to <2 x i8> addrspace(1)*
  %c1.2 = load <2 x i8>, <2 x i8> addrspace(1)* %c1.arrayidx3.0, align 1
  %c1.2.0 = shufflevector <2 x i8> %c1.2, <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %c1.v.0 = insertelement <4 x i8> undef,   i8 %c1.0, i32 0
  %c1.v.1 = insertelement <4 x i8> %c1.v.0, i8 %c1.1, i32 1
  %c1.v.2 = shufflevector <4 x i8> %c1.v.1, <4 x i8> %c1.2.0, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  %c1.dst = getelementptr inbounds <4 x i8>, <4 x i8> addrspace(1)* %result, i64 2
  store <4 x i8> %c1.v.2, <4 x i8> addrspace(1)* %c1.dst, align 4

;
; case 2: [i8, <2 x i8>, i8] --> load i32
;         handle extractelement and insertelement
;
; CHECK-LABEL: c2.base
; CHECK: [[T2_0:%.*]] = load i32
; CHECK: {{.*}} = bitcast i32 [[T2_0]] to <4 x i8>
;
  %c2.base = getelementptr inbounds i8, i8 addrspace(1)* %src, i64 32
  %c2.0 = load i8, i8 addrspace(1)* %c2.base, align 1
  %c2.arrayidx1 = getelementptr inbounds i8, i8 addrspace(1)* %c2.base, i64 1
  %c2.arrayidx1.0 = bitcast i8 addrspace(1)* %c2.arrayidx1 to <2 x i8> addrspace(1)*
  %c2.1 = load <2 x i8>, <2 x i8> addrspace(1)* %c2.arrayidx1.0, align 1
  %c2.1.0 = extractelement <2 x i8> %c2.1, i32 0
  %c2.1.1 = extractelement <2 x i8> %c2.1, i32 1
  %c2.arrayidx3 = getelementptr inbounds i8, i8 addrspace(1)* %c2.base, i64 3
  %c2.2 = load i8, i8 addrspace(1)* %c2.arrayidx3, align 1
  %c2.v.0 = insertelement <4 x i8> undef,   i8 %c2.0,   i32 0
  %c2.v.1 = insertelement <4 x i8> %c2.v.0, i8 %c2.1.0, i32 1
  %c2.v.2 = insertelement <4 x i8> %c2.v.1, i8 %c2.1.1, i32 2
  %c2.v.3 = insertelement <4 x i8> %c2.v.2, i8 %c2.2,   i32 3
  %c2.dst = getelementptr inbounds <4 x i8>, <4 x i8> addrspace(1)* %result, i64 4
  store <4 x i8> %c2.v.3, <4 x i8> addrspace(1)* %c2.dst, align 4

;
; case 3 : [ <2 x i8> <2 x i8> ] --> i32
;        handle shufflevector
;
; CHECK-LABEL: c3.base
; CHECK: [[T3_0:%.*]] = load i32
; CHECK: {{.*}} = bitcast i32 [[T3_0]] to <4 x i8>
;
; CHECK: ret void
;
  %c3.base = getelementptr inbounds i8, i8 addrspace(1)* %src, i64 48
  %c3.base.0 = bitcast i8 addrspace(1)* %c3.base to <2 x i8> addrspace(1)*
  %c3.arrayidx1 = getelementptr inbounds <2 x i8>, <2 x i8> addrspace(1)* %c3.base.0, i64 0
  %c3.0 = load <2 x i8>, <2 x i8> addrspace(1)* %c3.arrayidx1, align 1
  %c3.arrayidx3 = getelementptr inbounds <2 x i8>, <2 x i8> addrspace(1)* %c3.base.0, i64 1
  %c3.1 = load <2 x i8>, <2 x i8> addrspace(1)* %c3.arrayidx3, align 1
  %c3.v = shufflevector <2 x i8> %c3.0, <2 x i8> %c3.1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %c3.dst = getelementptr inbounds <4 x i8>, <4 x i8> addrspace(1)* %result, i64 10
  store <4 x i8> %c3.v, <4 x i8> addrspace(1)* %c3.dst, align 4

  ret void
}

attributes #0 = { convergent nounwind "less-precise-fpmad"="true" "null-pointer-is-valid"="true" }
