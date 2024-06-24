;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2024 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================
;
; RUN: igc_opt --platformpvc --igc-joint-matrix-resolution -S 2>&1 < %s | FileCheck %s
; ------------------------------------------------
; JointMatrixFuncsResolutionPass
; ------------------------------------------------
%spirv.JointMatrixINTEL._float_16_16_3_3_2 = type opaque
%spirv.JointMatrixINTEL._float_8_16_3_3_2 = type opaque
%spirv.JointMatrixINTEL._float_32_64_3_3_2 = type opaque

; CHECK-LABEL: define spir_kernel void @test_fill_store(
; CHECK-SAME: float addrspace(1)* [[DST0:%.*]], float addrspace(1)* [[DST1:%.*]], float addrspace(1)* [[DST2:%.*]]) {
define spir_kernel void @test_fill_store(float addrspace(1)* %dst0, float addrspace(1)* %dst1, float addrspace(1)* %dst2){
; CHECK-NEXT:    [[TMP5:%.*]] = alloca [2 x <32 x i64>]
; CHECK-NEXT:    [[TMP3:%.*]] = alloca <8 x float>
; CHECK-NEXT:    [[TMP1:%.*]] = alloca <16 x float>
; CHECK-NEXT:    store <16 x float> <float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00>, <16 x float>* [[TMP1]]
  %1 = call spir_func %spirv.JointMatrixINTEL._float_16_16_3_3_2 addrspace(1)* @_Z26__spirv_CompositeConstructf(float 5.000000e+00)

; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <16 x float>* [[TMP1]] to i8*
; CHECK-NEXT:    call void @__builtin_spriv_OpJointMatrixStoreINTEL_Accumulator_RowMajor_SG16_16x16_i32_16_global_pi64_v8i8(float addrspace(1)* [[DST0]], i8* [[TMP2]], i64 16)
  call spir_func void @_Z29__spirv_JointMatrixStoreINTELPU3AS1fPU3AS143__spirv_JointMatrixINTEL__float_16_16_3_3_2liii(float addrspace(1)* %dst0, %spirv.JointMatrixINTEL._float_16_16_3_3_2 addrspace(1)* %1, i64 16, i32 0, i32 3, i32 0)

; CHECK-NEXT:    store <8 x float> <float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00, float 5.000000e+00>, <8 x float>* [[TMP3]]
  %2 = call spir_func %spirv.JointMatrixINTEL._float_8_16_3_3_2 addrspace(1)* @_Z26__spirv_CompositeConstructf.1(float 5.000000e+00)

; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <8 x float>* [[TMP3]] to i8*
; CHECK-NEXT:    call void @__builtin_spriv_OpJointMatrixStoreINTEL_Accumulator_RowMajor_SG16_8x16_i32_8_global_pi64_v8i8(float addrspace(1)* [[DST1]], i8* [[TMP4]], i64 16)
  call spir_func void @_Z29__spirv_JointMatrixStoreINTELPU3AS1fPU3AS142__spirv_JointMatrixINTEL__float_8_16_3_3_2liii(float addrspace(1)* %dst1, %spirv.JointMatrixINTEL._float_8_16_3_3_2 addrspace(1)* %2, i64 16, i32 0, i32 3, i32 0)

; CHECK-NEXT:    store [2 x <32 x i64>] [<32 x i64> <i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448>, <32 x i64> <i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448, i64 4656722015785320448>], [2 x <32 x i64>]* [[TMP5]]
  %3 = call spir_func %spirv.JointMatrixINTEL._float_32_64_3_3_2 addrspace(1)* @_Z26__spirv_CompositeConstructf.2(float 5.000000e+00)

; CHECK-NEXT:    [[TMP6:%.*]] = bitcast [2 x <32 x i64>]* [[TMP5]] to i8*
; CHECK-NEXT:    call void @__builtin_spriv_OpJointMatrixStoreINTEL_Accumulator_RowMajor_SG16_32x64_i32_128_global_pi64_v8i8(float addrspace(1)* [[DST2]], i8* [[TMP6]], i64 64)
  call spir_func void @_Z29__spirv_JointMatrixStoreINTELPU3AS1fPU3AS143__spirv_JointMatrixINTEL__float_32_64_3_3_2liii(float addrspace(1)* %dst2, %spirv.JointMatrixINTEL._float_32_64_3_3_2 addrspace(1)* %3, i64 64, i32 0, i32 3, i32 0)

  ret void
}

declare spir_func %spirv.JointMatrixINTEL._float_16_16_3_3_2 addrspace(1)* @_Z26__spirv_CompositeConstructf(float)
declare spir_func void @_Z29__spirv_JointMatrixStoreINTELPU3AS1fPU3AS143__spirv_JointMatrixINTEL__float_16_16_3_3_2liii(float addrspace(1)*, %spirv.JointMatrixINTEL._float_16_16_3_3_2 addrspace(1)*, i64, i32, i32, i32)

declare spir_func %spirv.JointMatrixINTEL._float_8_16_3_3_2 addrspace(1)* @_Z26__spirv_CompositeConstructf.1(float)
declare spir_func void @_Z29__spirv_JointMatrixStoreINTELPU3AS1fPU3AS142__spirv_JointMatrixINTEL__float_8_16_3_3_2liii(float addrspace(1)*, %spirv.JointMatrixINTEL._float_8_16_3_3_2 addrspace(1)*, i64, i32, i32, i32)

declare spir_func %spirv.JointMatrixINTEL._float_32_64_3_3_2 addrspace(1)* @_Z26__spirv_CompositeConstructf.2(float)
declare spir_func void @_Z29__spirv_JointMatrixStoreINTELPU3AS1fPU3AS143__spirv_JointMatrixINTEL__float_32_64_3_3_2liii(float addrspace(1)*, %spirv.JointMatrixINTEL._float_32_64_3_3_2 addrspace(1)*, i64, i32, i32, i32)

!igc.functions = !{!0}
!0 = !{void (float addrspace(1)*, float addrspace(1)*, float addrspace(1)*)* @test_fill_store, !1}
!1 = !{!2, !3}
!2 = !{!"function_type", i32 0}
!3 = !{!"sub_group_size", i32 16}
