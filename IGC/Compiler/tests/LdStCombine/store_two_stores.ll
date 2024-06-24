;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2017-2023 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================




 ; Given  store i8
 ;        store i8
 ;   combined into
 ;        store i16
 ;
 ; Given  store i16
 ;        store i16
 ;   combined into
 ;        insertvalue
 ;        insertvalue
 ;        store i32
 ;
 ; CHECK-LABEL: target datalayout
 ; CHECK: %__StructSOALayout_ = type <{ %__StructAOSLayout_ }>
 ; CHECK: %__StructAOSLayout_ = type <{ i8, i8 }>
 ; CHECK: %__StructSOALayout_.[[#SOA1:]] = type <{ %__StructAOSLayout_.[[#AOS1:]] }>
 ; CHECK: %__StructAOSLayout_.[[#AOS1]] = type <{ i16, i16 }>
 ; CHECK-LABEL: define spir_kernel void @test_two_st
 ; // store i8 1; store i8 2 --> store i16 513 (0x201)
 ; CHECK: store i16 513,
 ; CHECK: [[S0TMP1:%.*]] = insertvalue %__StructSOALayout_ undef, i8 %{{.*}}, 0, 0
 ; CHECK: [[S0TMP2:%.*]] = insertvalue %__StructSOALayout_ [[S0TMP1]], i8 %{{.*}}, 0, 1
 ; CHECK: [[S0TMP3:%.*]] = call i16 @llvm.genx.GenISA.bitcastfromstruct.i16.__StructSOALayout_(%__StructSOALayout_ [[S0TMP2]])
 ; CHECK: store i16 [[S0TMP3]]
 ; // store i16 1; store i16 2 --> store i32 131073 (0x20001)
 ; CHECK: store i32 131073,
 ; CHECK: [[S1TMP1:%.*]] = insertvalue %__StructSOALayout_.[[#SOA1]] undef, i16 %{{.*}}, 0, 0
 ; CHECK: [[S1TMP2:%.*]] = insertvalue %__StructSOALayout_.[[#SOA1]] [[S1TMP1]], i16 %{{.*}}, 0, 1
 ; CHECK: [[S1TMP3:%.*]] = call i32 @llvm.genx.GenISA.bitcastfromstruct.i32.__StructSOALayout_.[[#SOA1]](%__StructSOALayout_.[[#SOA1]] [[S1TMP2]])
 ; CHECK: store i32 [[S1TMP3]]
 ; CHECK: ret void

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-n8:16:32"
target triple = "spir64-unknown-unknown"

; Function Attrs: convergent nounwind
define spir_kernel void @test_two_st(i64 addrspace(1)* %d, i32 addrspace(1)* %si, <8 x i32> %r0, <8 x i32> %payloadHeader, i16 %localIdX, i16 %localIdY, i16 %localIdZ) #0 {
entry:
  %conv.i.i = zext i16 %localIdX to i64
  %arrayidx = getelementptr inbounds i32, i32 addrspace(1)* %si, i64 %conv.i.i
  %0 = load i32, i32 addrspace(1)* %arrayidx, align 4
  %add = add nuw nsw i64 %conv.i.i, 5
  %arrayidx1 = getelementptr inbounds i32, i32 addrspace(1)* %si, i64 %add
  %1 = load i32, i32 addrspace(1)* %arrayidx1, align 4
  %2 = bitcast i64 addrspace(1)* %d to i8 addrspace(1)*
  %arrayidx2 = getelementptr inbounds i8, i8 addrspace(1)* %2, i64 %conv.i.i
  store i8 1, i8 addrspace(1)* %arrayidx2, align 1
  %add3 = add nuw nsw i64 %conv.i.i, 1
  %arrayidx4 = getelementptr inbounds i8, i8 addrspace(1)* %2, i64 %add3
  store i8 2, i8 addrspace(1)* %arrayidx4, align 1
  %conv = trunc i32 %0 to i8
  %add5 = add nuw nsw i64 %conv.i.i, 10
  %arrayidx6 = getelementptr inbounds i8, i8 addrspace(1)* %2, i64 %add5
  store i8 %conv, i8 addrspace(1)* %arrayidx6, align 1
  %conv7 = trunc i32 %1 to i8
  %add8 = add nuw nsw i64 %conv.i.i, 11
  %arrayidx9 = getelementptr inbounds i8, i8 addrspace(1)* %2, i64 %add8
  store i8 %conv7, i8 addrspace(1)* %arrayidx9, align 1
  %3 = bitcast i64 addrspace(1)* %d to i16 addrspace(1)*
  %arrayidx10 = getelementptr inbounds i16, i16 addrspace(1)* %3, i64 %conv.i.i
  store i16 1, i16 addrspace(1)* %arrayidx10, align 2
  %arrayidx12 = getelementptr inbounds i16, i16 addrspace(1)* %3, i64 %add3
  store i16 2, i16 addrspace(1)* %arrayidx12, align 2
  %conv13 = trunc i32 %0 to i16
  %arrayidx15 = getelementptr inbounds i16, i16 addrspace(1)* %3, i64 %add5
  store i16 %conv13, i16 addrspace(1)* %arrayidx15, align 2
  %conv16 = trunc i32 %1 to i16
  %arrayidx18 = getelementptr inbounds i16, i16 addrspace(1)* %3, i64 %add8
  store i16 %conv16, i16 addrspace(1)* %arrayidx18, align 2
  ret void
}
