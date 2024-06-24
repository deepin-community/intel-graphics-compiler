;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2023 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================
;
; RUN: igc_opt -enable-debugify --igc-sub-group-func-resolution -S < %s 2>&1 | FileCheck %s
; ------------------------------------------------
; SubGroupFuncsResolution
; ------------------------------------------------
; This test checks that SubGroupFuncsResolution pass follows
; 'How to Update Debug Info' llvm guideline.
;
; And was reduced from ocl test kernel:
;
; __kernel void test_broadcast(global int *dst, int src)
; {
;     int shuf = sub_group_broadcast(src, 0);
;     dst[0] = shuf;
; }
;

; Debug-info related check
;
; CHECK-NOT: WARNING
; CHECK: CheckModuleDebugify: PASS


define spir_kernel void @test_broadcast(i32 addrspace(1)* %dst, i32 %src) #0 {
; CHECK-LABEL: @test_broadcast(
; CHECK-NEXT:  entry:
; CHECK:    [[DST_ADDR:%.*]] = alloca i32 addrspace(1)*, align 8
; CHECK:    [[SRC_ADDR:%.*]] = alloca i32, align 4
; CHECK:    [[SHUF:%.*]] = alloca i32, align 4
; CHECK:    store i32 addrspace(1)* [[DST:%.*]], i32 addrspace(1)** [[DST_ADDR]], align 8
; CHECK:    store i32 [[SRC:%.*]], i32* [[SRC_ADDR]], align 4
; CHECK:    [[TMP0:%.*]] = load i32, i32* [[SRC_ADDR]], align 4
; CHECK:    [[SIMDBROADCAST:%.*]] = call i32 @llvm.genx.GenISA.WaveBroadcast.i32(i32 [[TMP0]], i32 0, i32 0)
; CHECK:    store i32 [[SIMDBROADCAST]], i32* [[SHUF]], align 4
;
entry:
  %dst.addr = alloca i32 addrspace(1)*, align 8
  %src.addr = alloca i32, align 4
  %shuf = alloca i32, align 4
  store i32 addrspace(1)* %dst, i32 addrspace(1)** %dst.addr, align 8
  store i32 %src, i32* %src.addr, align 4
  %0 = load i32, i32* %src.addr, align 4
  %call.i.i = call spir_func i32 @__builtin_IB_simd_broadcast(i32 %0, i32 0)
  store i32 %call.i.i, i32* %shuf, align 4
  %1 = load i32, i32* %shuf, align 4
  %2 = load i32 addrspace(1)*, i32 addrspace(1)** %dst.addr, align 8
  %arrayidx = getelementptr inbounds i32, i32 addrspace(1)* %2, i64 0
  store i32 %1, i32 addrspace(1)* %arrayidx, align 4
  ret void
}

declare spir_func i32 @__builtin_IB_simd_broadcast(i32, i32) local_unnamed_addr #2

attributes #0 = { convergent noinline nounwind optnone }
attributes #2 = { convergent }
