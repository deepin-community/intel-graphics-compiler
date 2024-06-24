;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2023 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================
; REQUIRES: regkeys
; RUN: igc_opt --regkey EnableSOAPromotionDisablingHeuristic=1 --igc-private-mem-resolution --platformtgllp -S < %s 2>&1 | FileCheck %s

; The stored vector has the same baseType and number of elements as alloca type
; Apply SOA, but preserve the vector store (vectorSOA)
define spir_kernel void @test_pmem(i32 addrspace(1)* %dst, i32 addrspace(1)* %src, <8 x i32> %r0, <8 x i32> %payloadHeader, i8* %privateBase, i32 %bufferOffset, i32 %bufferOffset1) #0 {
; CHECK-LABEL: @test_pmem(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SIMDLANEID16:%.*]] = call i16 @llvm.genx.GenISA.simdLaneId()
; CHECK-NEXT:    [[SIMDLANEID:%.*]] = zext i16 [[SIMDLANEID16]] to i32
; CHECK-NEXT:    [[SIMDSIZE:%.*]] = call i32 @llvm.genx.GenISA.simdSize()
; CHECK-NEXT:    [[R0_5:%.*]] = extractelement <8 x i32> [[R0:%.*]], i32 5
; CHECK-NEXT:    [[PRIVATEBASE1:%.*]] = and i32 [[R0_5]], -1024
; CHECK-NEXT:    [[OUT_SIMDBUFFEROFFSET:%.*]] = mul i32 [[SIMDSIZE]], 0
; CHECK-NEXT:    [[PERLANEOFFSET:%.*]] = mul i32 [[SIMDLANEID]], 16
; CHECK-NEXT:    [[OUT_TOTALOFFSET:%.*]] = add i32 [[OUT_SIMDBUFFEROFFSET]], [[PERLANEOFFSET]]
; CHECK-NEXT:    [[OUT_THREADOFFSET:%.*]] = add i32 [[PRIVATEBASE1]], [[OUT_TOTALOFFSET]]
; CHECK-NEXT:    [[OUT_PRIVATEBUFFERPTR:%.*]] = inttoptr i32 [[OUT_THREADOFFSET]] to [7 x <4 x i32>]*
; CHECK-NEXT:    [[TMP0:%.*]] = mul i32 [[SIMDSIZE]], 16
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 0, [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[OUT_THREADOFFSET]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = inttoptr i32 [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> zeroinitializer, <4 x i32>* [[TMP3]], align 32
; CHECK-NEXT:    ret void
;
entry:
  %out = alloca [7 x <4 x i32>], align 32
  %memset_vdst = bitcast [7 x <4 x i32>]* %out to <4 x i32>*
  store <4 x i32> zeroinitializer, <4 x i32>* %memset_vdst, align 32
  ret void
}

attributes #0 = { convergent noinline nounwind optnone "less-precise-fpmad"="true" }

!IGCMetadata = !{!3}
!igc.functions = !{!17}

!3 = !{!"ModuleMD", !4, !7, !13, !10}
!4 = !{!"compOpt", !5, !6}
!5 = !{!"OptDisable", i1 false}
!6 = !{!"UseScratchSpacePrivateMemory", i1 true}
!7 = !{!"FuncMD", !11, !12}
!10 = !{!"privateMemoryPerWI", i32 0}
!11 = !{!"FuncMDMap[0]", void (i32 addrspace(1)*, i32 addrspace(1)*, <8 x i32>, <8 x i32>, i8*, i32, i32)* @test_pmem}
!12 = !{!"FuncMDValue[0]", !10}
!13 = !{!"MinNOSPushConstantSize", i32 0}
!17 = !{void (i32 addrspace(1)*, i32 addrspace(1)*, <8 x i32>, <8 x i32>, i8*, i32, i32)* @test_pmem, !18}
!18 = !{!19, !20}
!19 = !{!"function_type", i32 0}
!20 = !{!"implicit_arg_desc", !21, !22, !23, !24, !26}
!21 = !{i32 0}
!22 = !{i32 1}
!23 = !{i32 12}
!24 = !{i32 14, !25}
!25 = !{!"explicit_arg_num", i32 0}
!26 = !{i32 14, !27}
!27 = !{!"explicit_arg_num", i32 1}
