;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2022 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================
;
; RUN: igc_opt --igc-private-mem-resolution --platformpvc -S < %s 2>&1 | FileCheck %s

define spir_kernel void @testallocabig(i8* %privateBase) {
entry:
  %0 = alloca [50000 x float], align 4
  ret void
; CHECK-LABEL: entry:
; CHECK:  [[simdLaneId16:%[A-z0-9]*]] = call i16 @llvm.genx.GenISA.simdLaneId()
; CHECK:  [[simdLaneId:%[A-z0-9]*]] = zext i16 [[simdLaneId16]] to i32
; CHECK:  [[simdSize:%[A-z0-9]*]] = call i32 @llvm.genx.GenISA.simdSize()
; CHECK:  [[totalPrivateMemPerThread:%[A-z0-9]*]] = mul i32 [[simdSize]], 200000
; CHECK:  [[ZXT0:%[A-z0-9]*]] = zext i32 [[totalPrivateMemPerThread]] to i64
; CHECK:  [[CAL0:%[A-z0-9]*]] = call i32 @llvm.genx.GenISA.hw.thread.id.alloca.i32()
; CHECK:  [[ZXT1:%[A-z0-9]*]] = zext i32 [[CAL0]] to i64
; CHECK:  [[perThreadOffset:%[A-z0-9]*]] = mul i64 [[ZXT1]], [[ZXT0]]
; CHECK:  [[SIMDBufferOffset:%[.A-z0-9]*]] = mul i32 [[simdSize]], 0
; CHECK:  [[ZXT2:%[A-z0-9]*]] = zext i32 [[SIMDBufferOffset]] to i64
; CHECK:  [[bufferOffsetForThread:%[.A-z0-9]*]] = add i64 [[perThreadOffset]], [[ZXT2]]
; CHECK:  [[perLaneOffset:%[A-z0-9]*]] = mul i32 [[simdLaneId]], 200000
; CHECK:  [[ZXT3:%[A-z0-9]*]] = zext i32 [[perLaneOffset]] to i64
; CHECK:  [[totalOffset:%[.A-z0-9]*]] = add i64 [[bufferOffsetForThread]], [[ZXT3]]
; CHECK:  [[privateBufferGEP:%[.A-z0-9]*]] = getelementptr i8, i8* %privateBase, i64 [[totalOffset]]
; CHECK:  [[privateBuffer:%[.A-z0-9]*]] = bitcast i8* [[privateBufferGEP]] to [50000 x float]*
; CHECK:  ret void
}

!IGCMetadata = !{!0}
!igc.functions = !{!1}

!0 = !{!"ModuleMD"}
!1 = !{void (i8*)* @testallocabig, !2}
!2 = !{!3, !4}
!3 = !{!"function_type", i32 0}
!4 = !{!"implicit_arg_desc", !5}
!5 = !{i32 12}
