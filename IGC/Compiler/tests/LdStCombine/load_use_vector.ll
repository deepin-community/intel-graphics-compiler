;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2017-2023 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================




target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-n8:16:32"
target triple = "spir64-unknown-unknown"

; Function Attrs: convergent nounwind
define spir_kernel void @test_usevector(i64 addrspace(1)* %d, i64 addrspace(1)* %ss, i16 %localIdX, i16 %localIdY, i16 %localIdZ) {
entry:
  %conv.i.i = zext i16 %localIdX to i64
;
; case 0:  load i32; load i64; load float; load <4xi32>
;          No struct, just a plain vector load
;
; CHECK-LABEL: define spir_kernel void @test_usevector
; CHECK: load <4 x i32>
;
  %c0.base = add i64 %conv.i.i, 8
  %c0.arrayidx = getelementptr inbounds i64, i64 addrspace(1)* %ss, i64 %c0.base
  %c0.addr = bitcast i64 addrspace(1)* %c0.arrayidx to i32 addrspace(1)*
  %c0.0 = load i32, i32 addrspace(1)* %c0.addr, align 4
  %c0.arrayidx.1 = getelementptr inbounds i32, i32 addrspace(1)* %c0.addr, i64 1
  %c0.addr.1 = bitcast i32 addrspace(1)* %c0.arrayidx.1 to i64 addrspace(1)*
  %c0.1 = load i64, i64 addrspace(1)* %c0.addr.1, align 4
  %c0.arrayidx.2 = getelementptr inbounds i32, i32 addrspace(1)* %c0.addr, i64 3
  %c0.addr.2 = bitcast i32 addrspace(1)* %c0.arrayidx.2 to float addrspace(1)*
  %c0.2 = load float, float addrspace(1)* %c0.addr.2, align 4
;
  %c0.arrayidx1.0 = getelementptr inbounds i64, i64 addrspace(1)* %d, i64 %c0.base
  %c0.0.0 = zext i32 %c0.0 to i64
  %c0.0.1 = shl i64 %c0.0.0, 32
  %c0.0.2 = bitcast float %c0.2 to i32
  %c0.0.3 = zext i32 %c0.0.2 to i64
  %c0.0.4 = or i64 %c0.0.1, %c0.0.3
  store i64 %c0.0.4, i64 addrspace(1)* %c0.arrayidx1.0, align 8
  %c0.add = add nuw nsw i64 %c0.base, 32
  %c0.arrayidx1.1 = getelementptr inbounds i64, i64 addrspace(1)* %d, i64 %c0.add
  store i64 %c0.1, i64 addrspace(1)* %c0.arrayidx1.1, align 8

;
; case 1:  load i64; load i64; load float; load <2xi64>
;
; CHECK-LABEL: c1.base
; CHECK: load <2 x i64>
; ret void
;
  %c1.base = add i64 %conv.i.i, 64
  %c1.arrayidx = getelementptr inbounds i64, i64 addrspace(1)* %ss, i64 %c1.base
  %c1.0 = load i64, i64 addrspace(1)* %c1.arrayidx, align 8
  %c1.arrayidx.1 = getelementptr inbounds i64, i64 addrspace(1)* %c1.arrayidx, i64 1
  %c1.1 = load i64, i64 addrspace(1)* %c1.arrayidx.1, align 4
;
  %c1.0.0 = insertelement <2 x i64> undef,   i64 %c1.0, i64 0
  %c1.0.1 = insertelement <2 x i64> %c1.0.0, i64 %c1.1, i64 1
  %c1.arrayidx1.0 = getelementptr inbounds i64, i64 addrspace(1)* %d, i64 %c1.base
  %c1.daddr = bitcast i64 addrspace(1)* %c1.arrayidx1.0 to <2 x i64> addrspace(1)*
  store <2 x i64> %c1.0.1, <2 x i64> addrspace(1)* %c1.daddr, align 8

  ret void
}
