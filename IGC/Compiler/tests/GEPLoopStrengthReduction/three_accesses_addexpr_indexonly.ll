;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2023 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================

; REQUIRES: regkeys
; RUN: igc_opt --regkey=EnableGEPLSRToPreheader=0 -debugify --igc-gep-loop-strength-reduction -check-debugify -S < %s 2>&1 | FileCheck %s
;
; Test pass when reduction to preheader is disabled. Optimize function:
;
;     kernel void test(global int* p, int n) {
;       int id = get_global_id(0);
;       for (int i = 32; i < n - 32; i += 32) {
;         p[id + i] = p[id + i + 32] * p[id + i - 32];
;       }
;     }
;
; Loop has three accesses that can be grouped together, start addresses are expressed with SCEVAddExpr.
; Result:
;
;     kernel void test(global int* p, int n) {
;       int id = get_global_id(0);
;       for (int i = 32; i < n - 32; i += 32) {
;         global int* tmp = p + id + 64;
;         *(tmp - 32) = *tmp * *(tmp - 64);
;       }
;     }

; Debug-info related check
; CHECK: CheckModuleDebugify: PASS

define spir_kernel void @test(i32 addrspace(1)* %p, i32 %n, <8 x i32> %r0, <8 x i32> %payloadHeader, <3 x i32> %enqueuedLocalSize, i16 %localIdX, i16 %localIdY, i16 %localIdZ, i32 %bufferOffset) #0 {
entry:
  %payloadHeader.scalar = extractelement <8 x i32> %payloadHeader, i64 0
  %enqueuedLocalSize.scalar = extractelement <3 x i32> %enqueuedLocalSize, i64 0
  %r0.scalar17 = extractelement <8 x i32> %r0, i64 1
  %mul.i.i.i = mul i32 %enqueuedLocalSize.scalar, %r0.scalar17
  %localIdX2 = zext i16 %localIdX to i32
  %add.i.i.i = add i32 %mul.i.i.i, %localIdX2
  %add4.i.i.i = add i32 %add.i.i.i, %payloadHeader.scalar
  %sub = add nsw i32 %n, -32
  %cmp33 = icmp slt i32 32, %sub
  br i1 %cmp33, label %for.body.lr.ph, label %for.end

; CHECK-LABEL: for.body.lr.ph:
; CHECK:         br label %for.body
for.body.lr.ph:                                   ; preds = %entry
  br label %for.body

; CHECK-LABEL: for.body:
; CHECK:         %i.034 = phi i32 [ 32, %for.body.lr.ph ], [ %add10, %for.body ]
; CHECK:         %add = add nsw i32 %add4.i.i.i, %i.034
; CHECK:         %add2 = add nsw i32 %add, 32
; CHECK:         %idxprom = sext i32 %add2 to i64
; CHECK:         [[GEP0:%.*]] = getelementptr inbounds i32, i32 addrspace(1)* %p, i64 %idxprom
; CHECK:         [[LOAD0:%.*]] = load i32, i32 addrspace(1)* [[GEP0]], align 4
; CHECK:         [[GEP64:%.*]] = getelementptr i32, i32 addrspace(1)* [[GEP0]], i64 -64
; CHECK:         [[LOAD64:%.*]] = load i32, i32 addrspace(1)* [[GEP64]], align 4
; CHECK:         [[MUL:%.*]] = mul nsw i32 [[LOAD0]], [[LOAD64]]
; CHECK:         [[GEP32:%.*]] = getelementptr i32, i32 addrspace(1)* [[GEP0]], i64 -32
; CHECK:         store i32 [[MUL]], i32 addrspace(1)* [[GEP32]], align 4
; CHECK:         %add10 = add nuw nsw i32 %i.034, 32
; CHECK:         %cmp = icmp slt i32 %add10, %sub
; CHECK:         br i1 %cmp, label %for.body, label %for.cond.for.end_crit_edge
for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %i.034 = phi i32 [ 32, %for.body.lr.ph ], [ %add10, %for.body ]
  %add = add nsw i32 %add4.i.i.i, %i.034
  %add2 = add nsw i32 %add, 32
  %idxprom = sext i32 %add2 to i64
  %arrayidx = getelementptr inbounds i32, i32 addrspace(1)* %p, i64 %idxprom
  %0 = load i32, i32 addrspace(1)* %arrayidx, align 4
  %sub4 = add nsw i32 %add, -32
  %idxprom5 = sext i32 %sub4 to i64
  %arrayidx6 = getelementptr inbounds i32, i32 addrspace(1)* %p, i64 %idxprom5
  %1 = load i32, i32 addrspace(1)* %arrayidx6, align 4
  %mul = mul nsw i32 %0, %1
  %idxprom8 = sext i32 %add to i64
  %arrayidx9 = getelementptr inbounds i32, i32 addrspace(1)* %p, i64 %idxprom8
  store i32 %mul, i32 addrspace(1)* %arrayidx9, align 4
  %add10 = add nuw nsw i32 %i.034, 32
  %cmp = icmp slt i32 %add10, %sub
  br i1 %cmp, label %for.body, label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.cond.for.end_crit_edge, %entry
  ret void
}

!igc.functions = !{!0}

!0 = !{void (i32 addrspace(1)*, i32, <8 x i32>, <8 x i32>, <3 x i32>, i16, i16, i16, i32)* @test, !1}
!1 = !{!2}
!2 = !{!"function_type", i32 0}
