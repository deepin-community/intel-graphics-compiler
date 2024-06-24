;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2017-2021 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================

; RUN: igc_opt -igc-wi-func-resolution -S %s -o %t.ll
; RUN: FileCheck %s --input-file=%t.ll

declare i32 @__builtin_IB_get_local_id_x()

define i32 @foo(i32 %dim, <8 x i32> %r0, <8 x i32> %payloadHeader, i16 %localIdX, i16 %localIdY, i16 %localIdZ) nounwind {
  %id = call i32 @__builtin_IB_get_local_id_x()
  ret i32 %id
}

!igc.functions = !{!0}
!0 = !{i32 (i32, <8 x i32>, <8 x i32>, i16, i16, i16)* @foo, !1}
!1 = !{!2, !3}
!2 = !{!"function_type", i32 0}
!3 = !{!"implicit_arg_desc", !4, !5, !6, !7, !8}
!4 = !{i32 0}
!5 = !{i32 1}
!6 = !{i32 7}
!7 = !{i32 8}
!8 = !{i32 9}

; CHECK:         ret i32 %localIdX

; CHECK-NOT:     call i32 @__builtin_IB_get_local_id_x()
