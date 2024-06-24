/*========================== begin_copyright_notice ============================

Copyright (C) 2018-2021 Intel Corporation

SPDX-License-Identifier: MIT

============================= end_copyright_notice ===========================*/

//===- IBiF_dpas.cl - dpas extension functions                             -===//
//
//  This file defines extension functions for XeHP_SDV and PVC to use Dot Product
//  Accumulate Systolic pipe (DPAS). The pipe has dpas instruction and dpasw
//  (dpas wide) instructions. Both dpas and dpasw have a various flavors and
//  are all defined here in this file.
//
//===----------------------------------------------------------------------===//

// matrix multiply:  a x b + acc
//   FNAME:  base of external function name
//   RETTY: return type.
//   ACCTY: acc's type
//   ATY: type for argument a
//   BTY: type of argument b
//
//   INTERNAL_FNAME: base of internal function name
//   AT : type of a of the internal function
//   BT : type of b of the internal function
//      Note:  both AT and BT are opaque types, represented as signed int.
//

////  XeHP_SDV : simd8
#define  DEFN_INTEL_SG_IDPAS(FNAME, RETTY, ATY, BTY, INTERNAL_FNAME, AT, BT)             \
INLINE RETTY OVERLOADABLE intel_sub_group_##FNAME( ATY a,  BTY b, RETTY acc)             \
{                                                                                        \
    return __builtin_IB_sub_group_##INTERNAL_FNAME (acc, as_##AT (a), as_##BT (b));      \
}

#define  DEFN_INTEL_SG_FDPAS(FNAME, RETTY, ATY, BTY, INTERNAL_FNAME)                     \
INLINE RETTY OVERLOADABLE intel_sub_group_##FNAME( ATY a,  BTY b, RETTY acc)             \
{                                                                                        \
    return __builtin_IB_sub_group_##INTERNAL_FNAME (acc, a, b);                          \
}


////  PVC : simd16
#define  DEFN_INTEL_SG16_IDPAS(FNAME, RETTY, ATY, BTY, INTERNAL_FNAME, AT, BT)           \
INLINE RETTY OVERLOADABLE intel_sub_group_##FNAME( ATY a,  BTY b, RETTY acc)             \
{                                                                                        \
    return __builtin_IB_sub_group16_##INTERNAL_FNAME (acc, as_##AT (a), as_##BT (b));    \
}

#define  DEFN_INTEL_SG16_FDPAS(FNAME, RETTY, ACCTY, ATY, BTY, INTERNAL_FNAME)            \
INLINE RETTY OVERLOADABLE intel_sub_group_##FNAME( ATY a,  BTY b, ACCTY acc)             \
{                                                                                        \
    return __builtin_IB_sub_group16_##INTERNAL_FNAME (acc, a, b);                        \
}

//// conversion
#define DEFN_INTEL_CVT(FNAME, RETTY,  SRCTY,  INTERNAL_FNAME)                            \
INLINE RETTY OVERLOADABLE intel_convert_##FNAME (SRCTY a)                                \
{                                                                                        \
    return __builtin_IB_##INTERNAL_FNAME (a);                                            \
}

//// special conversion/rounding
#define DEFN_INTEL_CVT2(FNAME, RETTY,  SRC0TY,  SRC1TY,  INTERNAL_FNAME)                 \
INLINE RETTY OVERLOADABLE intel_convert_##FNAME (SRC0TY a, SRC1TY b)                     \
{                                                                                        \
    return __builtin_IB_##INTERNAL_FNAME (a, b);                                         \
}

#ifdef cl_intel_subgroup_matrix_multiply_accumulate

////  XeHP_SDV : simd8 ////

// a: 8 bit, b: 8 bit, repcount: 1,2,4,8
DEFN_INTEL_SG_IDPAS( i8_i8_matrix_mad_k32, int,  int,   int8,  idpas_s8_s8_8_1, int,  int8 )
DEFN_INTEL_SG_IDPAS( i8_i8_matrix_mad_k32, int2, int2,  int8,  idpas_s8_s8_8_2, int2, int8 )
DEFN_INTEL_SG_IDPAS( i8_i8_matrix_mad_k32, int4, int4,  int8,  idpas_s8_s8_8_4, int4, int8 )
DEFN_INTEL_SG_IDPAS( i8_i8_matrix_mad_k32, int8, int8,  int8,  idpas_s8_s8_8_8, int8, int8 )
DEFN_INTEL_SG_IDPAS( i8_u8_matrix_mad_k32, int,  int,   uint8, idpas_s8_u8_8_1, int,  int8 )
DEFN_INTEL_SG_IDPAS( i8_u8_matrix_mad_k32, int2, int2,  uint8, idpas_s8_u8_8_2, int2, int8 )
DEFN_INTEL_SG_IDPAS( i8_u8_matrix_mad_k32, int4, int4,  uint8, idpas_s8_u8_8_4, int4, int8 )
DEFN_INTEL_SG_IDPAS( i8_u8_matrix_mad_k32, int8, int8,  uint8, idpas_s8_u8_8_8, int8, int8 )
DEFN_INTEL_SG_IDPAS( u8_i8_matrix_mad_k32, int,  uint,  int8,  idpas_u8_s8_8_1, int,  int8 )
DEFN_INTEL_SG_IDPAS( u8_i8_matrix_mad_k32, int2, uint2, int8,  idpas_u8_s8_8_2, int2, int8 )
DEFN_INTEL_SG_IDPAS( u8_i8_matrix_mad_k32, int4, uint4, int8,  idpas_u8_s8_8_4, int4, int8 )
DEFN_INTEL_SG_IDPAS( u8_i8_matrix_mad_k32, int8, uint8, int8,  idpas_u8_s8_8_8, int8, int8 )
DEFN_INTEL_SG_IDPAS( u8_u8_matrix_mad_k32, int,  uint,  uint8, idpas_u8_u8_8_1, int,  int8 )
DEFN_INTEL_SG_IDPAS( u8_u8_matrix_mad_k32, int2, uint2, uint8, idpas_u8_u8_8_2, int2, int8 )
DEFN_INTEL_SG_IDPAS( u8_u8_matrix_mad_k32, int4, uint4, uint8, idpas_u8_u8_8_4, int4, int8 )
DEFN_INTEL_SG_IDPAS( u8_u8_matrix_mad_k32, int8, uint8, uint8, idpas_u8_u8_8_8, int8, int8 )

// a: 8 bit, b: 4 bit, repcount: 1,2,4,8
DEFN_INTEL_SG_IDPAS( i8_i4_matrix_mad_k32, int,  int,   int4,  idpas_s8_s4_8_1, int,  int4 )
DEFN_INTEL_SG_IDPAS( i8_i4_matrix_mad_k32, int2, int2,  int4,  idpas_s8_s4_8_2, int2, int4 )
DEFN_INTEL_SG_IDPAS( i8_i4_matrix_mad_k32, int4, int4,  int4,  idpas_s8_s4_8_4, int4, int4 )
DEFN_INTEL_SG_IDPAS( i8_i4_matrix_mad_k32, int8, int8,  int4,  idpas_s8_s4_8_8, int8, int4 )
DEFN_INTEL_SG_IDPAS( i8_u4_matrix_mad_k32, int,  int,   uint4, idpas_s8_u4_8_1, int,  int4 )
DEFN_INTEL_SG_IDPAS( i8_u4_matrix_mad_k32, int2, int2,  uint4, idpas_s8_u4_8_2, int2, int4 )
DEFN_INTEL_SG_IDPAS( i8_u4_matrix_mad_k32, int4, int4,  uint4, idpas_s8_u4_8_4, int4, int4 )
DEFN_INTEL_SG_IDPAS( i8_u4_matrix_mad_k32, int8, int8,  uint4, idpas_s8_u4_8_8, int8, int4 )
DEFN_INTEL_SG_IDPAS( u8_i4_matrix_mad_k32, int,  uint,  int4,  idpas_u8_s4_8_1, int,  int4 )
DEFN_INTEL_SG_IDPAS( u8_i4_matrix_mad_k32, int2, uint2, int4,  idpas_u8_s4_8_2, int2, int4 )
DEFN_INTEL_SG_IDPAS( u8_i4_matrix_mad_k32, int4, uint4, int4,  idpas_u8_s4_8_4, int4, int4 )
DEFN_INTEL_SG_IDPAS( u8_i4_matrix_mad_k32, int8, uint8, int4,  idpas_u8_s4_8_8, int8, int4 )
DEFN_INTEL_SG_IDPAS( u8_u4_matrix_mad_k32, int,  uint,  uint4, idpas_u8_u4_8_1, int,  int4 )
DEFN_INTEL_SG_IDPAS( u8_u4_matrix_mad_k32, int2, uint2, uint4, idpas_u8_u4_8_2, int2, int4 )
DEFN_INTEL_SG_IDPAS( u8_u4_matrix_mad_k32, int4, uint4, uint4, idpas_u8_u4_8_4, int4, int4 )
DEFN_INTEL_SG_IDPAS( u8_u4_matrix_mad_k32, int8, uint8, uint4, idpas_u8_u4_8_8, int8, int4 )

// a: 8 bit, b: 2 bit, repcount: 1,2,4,8
DEFN_INTEL_SG_IDPAS( i8_i2_matrix_mad_k32, int,  int,   int2,  idpas_s8_s2_8_1, int,  int2 )
DEFN_INTEL_SG_IDPAS( i8_i2_matrix_mad_k32, int2, int2,  int2,  idpas_s8_s2_8_2, int2, int2 )
DEFN_INTEL_SG_IDPAS( i8_i2_matrix_mad_k32, int4, int4,  int2,  idpas_s8_s2_8_4, int4, int2 )
DEFN_INTEL_SG_IDPAS( i8_i2_matrix_mad_k32, int8, int8,  int2,  idpas_s8_s2_8_8, int8, int2 )
DEFN_INTEL_SG_IDPAS( i8_u2_matrix_mad_k32, int,  int,   uint2, idpas_s8_u2_8_1, int,  int2 )
DEFN_INTEL_SG_IDPAS( i8_u2_matrix_mad_k32, int2, int2,  uint2, idpas_s8_u2_8_2, int2, int2 )
DEFN_INTEL_SG_IDPAS( i8_u2_matrix_mad_k32, int4, int4,  uint2, idpas_s8_u2_8_4, int4, int2 )
DEFN_INTEL_SG_IDPAS( i8_u2_matrix_mad_k32, int8, int8,  uint2, idpas_s8_u2_8_8, int8, int2 )
DEFN_INTEL_SG_IDPAS( u8_i2_matrix_mad_k32, int,  uint,  int2,  idpas_u8_s2_8_1, int,  int2 )
DEFN_INTEL_SG_IDPAS( u8_i2_matrix_mad_k32, int2, uint2, int2,  idpas_u8_s2_8_2, int2, int2 )
DEFN_INTEL_SG_IDPAS( u8_i2_matrix_mad_k32, int4, uint4, int2,  idpas_u8_s2_8_4, int4, int2 )
DEFN_INTEL_SG_IDPAS( u8_i2_matrix_mad_k32, int8, uint8, int2,  idpas_u8_s2_8_8, int8, int2 )
DEFN_INTEL_SG_IDPAS( u8_u2_matrix_mad_k32, int,  uint,  uint2, idpas_u8_u2_8_1, int,  int2 )
DEFN_INTEL_SG_IDPAS( u8_u2_matrix_mad_k32, int2, uint2, uint2, idpas_u8_u2_8_2, int2, int2 )
DEFN_INTEL_SG_IDPAS( u8_u2_matrix_mad_k32, int4, uint4, uint2, idpas_u8_u2_8_4, int4, int2 )
DEFN_INTEL_SG_IDPAS( u8_u2_matrix_mad_k32, int8, uint8, uint2, idpas_u8_u2_8_8, int8, int2 )

// a: 4 bit, b: 8 bit, repcount: 1,2,4,8
DEFN_INTEL_SG_IDPAS( i4_i8_matrix_mad_k32, int,  short,   int8,  idpas_s4_s8_8_1, short,  int8 )
DEFN_INTEL_SG_IDPAS( i4_i8_matrix_mad_k32, int2, short2,  int8,  idpas_s4_s8_8_2, short2, int8 )
DEFN_INTEL_SG_IDPAS( i4_i8_matrix_mad_k32, int4, short4,  int8,  idpas_s4_s8_8_4, short4, int8 )
DEFN_INTEL_SG_IDPAS( i4_i8_matrix_mad_k32, int8, short8,  int8,  idpas_s4_s8_8_8, short8, int8 )
DEFN_INTEL_SG_IDPAS( i4_u8_matrix_mad_k32, int,  short,   uint8, idpas_s4_u8_8_1, short,  int8 )
DEFN_INTEL_SG_IDPAS( i4_u8_matrix_mad_k32, int2, short2,  uint8, idpas_s4_u8_8_2, short2, int8 )
DEFN_INTEL_SG_IDPAS( i4_u8_matrix_mad_k32, int4, short4,  uint8, idpas_s4_u8_8_4, short4, int8 )
DEFN_INTEL_SG_IDPAS( i4_u8_matrix_mad_k32, int8, short8,  uint8, idpas_s4_u8_8_8, short8, int8 )
DEFN_INTEL_SG_IDPAS( u4_i8_matrix_mad_k32, int,  ushort,  int8,  idpas_u4_s8_8_1, short,  int8 )
DEFN_INTEL_SG_IDPAS( u4_i8_matrix_mad_k32, int2, ushort2, int8,  idpas_u4_s8_8_2, short2, int8 )
DEFN_INTEL_SG_IDPAS( u4_i8_matrix_mad_k32, int4, ushort4, int8,  idpas_u4_s8_8_4, short4, int8 )
DEFN_INTEL_SG_IDPAS( u4_i8_matrix_mad_k32, int8, ushort8, int8,  idpas_u4_s8_8_8, short8, int8 )
DEFN_INTEL_SG_IDPAS( u4_u8_matrix_mad_k32, int,  ushort,  uint8, idpas_u4_u8_8_1, short,  int8 )
DEFN_INTEL_SG_IDPAS( u4_u8_matrix_mad_k32, int2, ushort2, uint8, idpas_u4_u8_8_2, short2, int8 )
DEFN_INTEL_SG_IDPAS( u4_u8_matrix_mad_k32, int4, ushort4, uint8, idpas_u4_u8_8_4, short4, int8 )
DEFN_INTEL_SG_IDPAS( u4_u8_matrix_mad_k32, int8, ushort8, uint8, idpas_u4_u8_8_8, short8, int8 )

// a: 2 bit, b: 8 bit, repcount: 1,2,4,8
DEFN_INTEL_SG_IDPAS( i2_i8_matrix_mad_k32, int,  char,   int8,  idpas_s2_s8_8_1, char,  int8 )
DEFN_INTEL_SG_IDPAS( i2_i8_matrix_mad_k32, int2, char2,  int8,  idpas_s2_s8_8_2, char2, int8 )
DEFN_INTEL_SG_IDPAS( i2_i8_matrix_mad_k32, int4, char4,  int8,  idpas_s2_s8_8_4, char4, int8 )
DEFN_INTEL_SG_IDPAS( i2_i8_matrix_mad_k32, int8, char8,  int8,  idpas_s2_s8_8_8, char8, int8 )
DEFN_INTEL_SG_IDPAS( i2_u8_matrix_mad_k32, int,  char,   uint8, idpas_s2_u8_8_1, char,  int8 )
DEFN_INTEL_SG_IDPAS( i2_u8_matrix_mad_k32, int2, char2,  uint8, idpas_s2_u8_8_2, char2, int8 )
DEFN_INTEL_SG_IDPAS( i2_u8_matrix_mad_k32, int4, char4,  uint8, idpas_s2_u8_8_4, char4, int8 )
DEFN_INTEL_SG_IDPAS( i2_u8_matrix_mad_k32, int8, char8,  uint8, idpas_s2_u8_8_8, char8, int8 )
DEFN_INTEL_SG_IDPAS( u2_i8_matrix_mad_k32, int,  uchar,  int8,  idpas_u2_s8_8_1, char,  int8 )
DEFN_INTEL_SG_IDPAS( u2_i8_matrix_mad_k32, int2, uchar2, int8,  idpas_u2_s8_8_2, char2, int8 )
DEFN_INTEL_SG_IDPAS( u2_i8_matrix_mad_k32, int4, uchar4, int8,  idpas_u2_s8_8_4, char4, int8 )
DEFN_INTEL_SG_IDPAS( u2_i8_matrix_mad_k32, int8, uchar8, int8,  idpas_u2_s8_8_8, char8, int8 )
DEFN_INTEL_SG_IDPAS( u2_u8_matrix_mad_k32, int,  uchar,  uint8, idpas_u2_u8_8_1, char,  int8 )
DEFN_INTEL_SG_IDPAS( u2_u8_matrix_mad_k32, int2, uchar2, uint8, idpas_u2_u8_8_2, char2, int8 )
DEFN_INTEL_SG_IDPAS( u2_u8_matrix_mad_k32, int4, uchar4, uint8, idpas_u2_u8_8_4, char4, int8 )
DEFN_INTEL_SG_IDPAS( u2_u8_matrix_mad_k32, int8, uchar8, uint8, idpas_u2_u8_8_8, char8, int8 )

// Double througput (k64)
// a: 4 bit, b: 4 bit, repcount: 1,2,4,8
DEFN_INTEL_SG_IDPAS( i4_i4_matrix_mad_k64, int,  int,    int8,  idpas_s4_s4_8_1, int,   int8 )
DEFN_INTEL_SG_IDPAS( i4_i4_matrix_mad_k64, int2, int2,   int8,  idpas_s4_s4_8_2, int2,  int8 )
DEFN_INTEL_SG_IDPAS( i4_i4_matrix_mad_k64, int4, int4,   int8,  idpas_s4_s4_8_4, int4,  int8 )
DEFN_INTEL_SG_IDPAS( i4_i4_matrix_mad_k64, int8, int8,   int8,  idpas_s4_s4_8_8, int8,  int8 )
DEFN_INTEL_SG_IDPAS( i4_u4_matrix_mad_k64, int,  int,    uint8, idpas_s4_u4_8_1, int,   int8 )
DEFN_INTEL_SG_IDPAS( i4_u4_matrix_mad_k64, int2, int2,   uint8, idpas_s4_u4_8_2, int2,  int8 )
DEFN_INTEL_SG_IDPAS( i4_u4_matrix_mad_k64, int4, int4,   uint8, idpas_s4_u4_8_4, int4,  int8 )
DEFN_INTEL_SG_IDPAS( i4_u4_matrix_mad_k64, int8, int8,   uint8, idpas_s4_u4_8_8, int8,  int8 )
DEFN_INTEL_SG_IDPAS( u4_i4_matrix_mad_k64, int,  uint,   int8,  idpas_u4_s4_8_1, int,   int8 )
DEFN_INTEL_SG_IDPAS( u4_i4_matrix_mad_k64, int2, uint2,  int8,  idpas_u4_s4_8_2, int2,  int8 )
DEFN_INTEL_SG_IDPAS( u4_i4_matrix_mad_k64, int4, uint4,  int8,  idpas_u4_s4_8_4, int4,  int8 )
DEFN_INTEL_SG_IDPAS( u4_i4_matrix_mad_k64, int8, uint8,  int8,  idpas_u4_s4_8_8, int8,  int8 )
DEFN_INTEL_SG_IDPAS( u4_u4_matrix_mad_k64, int,  uint,   uint8, idpas_u4_u4_8_1, int,   int8 )
DEFN_INTEL_SG_IDPAS( u4_u4_matrix_mad_k64, int2, uint2,  uint8, idpas_u4_u4_8_2, int2,  int8 )
DEFN_INTEL_SG_IDPAS( u4_u4_matrix_mad_k64, int4, uint4,  uint8, idpas_u4_u4_8_4, int4,  int8 )
DEFN_INTEL_SG_IDPAS( u4_u4_matrix_mad_k64, int8, uint8,  uint8, idpas_u4_u4_8_8, int8,  int8 )

// a: 4 bit, b: 2 bit, repcount: 1,2,4,8
DEFN_INTEL_SG_IDPAS( i4_i2_matrix_mad_k64, int,  int,    int4,  idpas_s4_s2_8_1, int,   int4 )
DEFN_INTEL_SG_IDPAS( i4_i2_matrix_mad_k64, int2, int2,   int4,  idpas_s4_s2_8_2, int2,  int4 )
DEFN_INTEL_SG_IDPAS( i4_i2_matrix_mad_k64, int4, int4,   int4,  idpas_s4_s2_8_4, int4,  int4 )
DEFN_INTEL_SG_IDPAS( i4_i2_matrix_mad_k64, int8, int8,   int4,  idpas_s4_s2_8_8, int8,  int4 )
DEFN_INTEL_SG_IDPAS( i4_u2_matrix_mad_k64, int,  int,    uint4, idpas_s4_u2_8_1, int,   int4 )
DEFN_INTEL_SG_IDPAS( i4_u2_matrix_mad_k64, int2, int2,   uint4, idpas_s4_u2_8_2, int2,  int4 )
DEFN_INTEL_SG_IDPAS( i4_u2_matrix_mad_k64, int4, int4,   uint4, idpas_s4_u2_8_4, int4,  int4 )
DEFN_INTEL_SG_IDPAS( i4_u2_matrix_mad_k64, int8, int8,   uint4, idpas_s4_u2_8_8, int8,  int4 )
DEFN_INTEL_SG_IDPAS( u4_i2_matrix_mad_k64, int,  uint,   int4,  idpas_u4_s2_8_1, int,   int4 )
DEFN_INTEL_SG_IDPAS( u4_i2_matrix_mad_k64, int2, uint2,  int4,  idpas_u4_s2_8_2, int2,  int4 )
DEFN_INTEL_SG_IDPAS( u4_i2_matrix_mad_k64, int4, uint4,  int4,  idpas_u4_s2_8_4, int4,  int4 )
DEFN_INTEL_SG_IDPAS( u4_i2_matrix_mad_k64, int8, uint8,  int4,  idpas_u4_s2_8_8, int8,  int4 )
DEFN_INTEL_SG_IDPAS( u4_u2_matrix_mad_k64, int,  uint,   uint4, idpas_u4_u2_8_1, int,   int4 )
DEFN_INTEL_SG_IDPAS( u4_u2_matrix_mad_k64, int2, uint2,  uint4, idpas_u4_u2_8_2, int2,  int4 )
DEFN_INTEL_SG_IDPAS( u4_u2_matrix_mad_k64, int4, uint4,  uint4, idpas_u4_u2_8_4, int4,  int4 )
DEFN_INTEL_SG_IDPAS( u4_u2_matrix_mad_k64, int8, uint8,  uint4, idpas_u4_u2_8_8, int8,  int4 )

// a: 2 bit, b: 4 bit, repcount: 1,2,4,8
DEFN_INTEL_SG_IDPAS( i2_i4_matrix_mad_k64, int,  short,   int8,  idpas_s2_s4_8_1, short,  int8 )
DEFN_INTEL_SG_IDPAS( i2_i4_matrix_mad_k64, int2, short2,  int8,  idpas_s2_s4_8_2, short2, int8 )
DEFN_INTEL_SG_IDPAS( i2_i4_matrix_mad_k64, int4, short4,  int8,  idpas_s2_s4_8_4, short4, int8 )
DEFN_INTEL_SG_IDPAS( i2_i4_matrix_mad_k64, int8, short8,  int8,  idpas_s2_s4_8_8, short8, int8 )
DEFN_INTEL_SG_IDPAS( i2_u4_matrix_mad_k64, int,  short,   uint8, idpas_s2_u4_8_1, short,  int8 )
DEFN_INTEL_SG_IDPAS( i2_u4_matrix_mad_k64, int2, short2,  uint8, idpas_s2_u4_8_2, short2, int8 )
DEFN_INTEL_SG_IDPAS( i2_u4_matrix_mad_k64, int4, short4,  uint8, idpas_s2_u4_8_4, short4, int8 )
DEFN_INTEL_SG_IDPAS( i2_u4_matrix_mad_k64, int8, short8,  uint8, idpas_s2_u4_8_8, short8, int8 )
DEFN_INTEL_SG_IDPAS( u2_i4_matrix_mad_k64, int,  ushort,  int8,  idpas_u2_s4_8_1, short,  int8 )
DEFN_INTEL_SG_IDPAS( u2_i4_matrix_mad_k64, int2, ushort2, int8,  idpas_u2_s4_8_2, short2, int8 )
DEFN_INTEL_SG_IDPAS( u2_i4_matrix_mad_k64, int4, ushort4, int8,  idpas_u2_s4_8_4, short4, int8 )
DEFN_INTEL_SG_IDPAS( u2_i4_matrix_mad_k64, int8, ushort8, int8,  idpas_u2_s4_8_8, short8, int8 )
DEFN_INTEL_SG_IDPAS( u2_u4_matrix_mad_k64, int,  ushort,  uint8, idpas_u2_u4_8_1, short,  int8 )
DEFN_INTEL_SG_IDPAS( u2_u4_matrix_mad_k64, int2, ushort2, uint8, idpas_u2_u4_8_2, short2, int8 )
DEFN_INTEL_SG_IDPAS( u2_u4_matrix_mad_k64, int4, ushort4, uint8, idpas_u2_u4_8_4, short4, int8 )
DEFN_INTEL_SG_IDPAS( u2_u4_matrix_mad_k64, int8, ushort8, uint8, idpas_u2_u4_8_8, short8, int8 )

// a: 2 bit, b: 2 bit, repcount: 1,2,4,8
DEFN_INTEL_SG_IDPAS( i2_i2_matrix_mad_k64, int,  short,   int4,  idpas_s2_s2_8_1, short,  int4 )
DEFN_INTEL_SG_IDPAS( i2_i2_matrix_mad_k64, int2, short2,  int4,  idpas_s2_s2_8_2, short2, int4 )
DEFN_INTEL_SG_IDPAS( i2_i2_matrix_mad_k64, int4, short4,  int4,  idpas_s2_s2_8_4, short4, int4 )
DEFN_INTEL_SG_IDPAS( i2_i2_matrix_mad_k64, int8, short8,  int4,  idpas_s2_s2_8_8, short8, int4 )
DEFN_INTEL_SG_IDPAS( i2_u2_matrix_mad_k64, int,  short,   uint4, idpas_s2_u2_8_1, short,  int4 )
DEFN_INTEL_SG_IDPAS( i2_u2_matrix_mad_k64, int2, short2,  uint4, idpas_s2_u2_8_2, short2, int4 )
DEFN_INTEL_SG_IDPAS( i2_u2_matrix_mad_k64, int4, short4,  uint4, idpas_s2_u2_8_4, short4, int4 )
DEFN_INTEL_SG_IDPAS( i2_u2_matrix_mad_k64, int8, short8,  uint4, idpas_s2_u2_8_8, short8, int4 )
DEFN_INTEL_SG_IDPAS( u2_i2_matrix_mad_k64, int,  ushort,  int4,  idpas_u2_s2_8_1, short,  int4 )
DEFN_INTEL_SG_IDPAS( u2_i2_matrix_mad_k64, int2, ushort2, int4,  idpas_u2_s2_8_2, short2, int4 )
DEFN_INTEL_SG_IDPAS( u2_i2_matrix_mad_k64, int4, ushort4, int4,  idpas_u2_s2_8_4, short4, int4 )
DEFN_INTEL_SG_IDPAS( u2_i2_matrix_mad_k64, int8, ushort8, int4,  idpas_u2_s2_8_8, short8, int4 )
DEFN_INTEL_SG_IDPAS( u2_u2_matrix_mad_k64, int,  ushort,  uint4, idpas_u2_u2_8_1, short,  int4 )
DEFN_INTEL_SG_IDPAS( u2_u2_matrix_mad_k64, int2, ushort2, uint4, idpas_u2_u2_8_2, short2, int4 )
DEFN_INTEL_SG_IDPAS( u2_u2_matrix_mad_k64, int4, ushort4, uint4, idpas_u2_u2_8_4, short4, int4 )
DEFN_INTEL_SG_IDPAS( u2_u2_matrix_mad_k64, int8, ushort8, uint4, idpas_u2_u2_8_8, short8, int4 )


// bfloat16: both a and b are 2 bfloat16.
DEFN_INTEL_SG_FDPAS( bf16_bf16_matrix_mad_k16, float,  int,   int8,  fdpas_bf_bf_8_1 )
DEFN_INTEL_SG_FDPAS( bf16_bf16_matrix_mad_k16, float2, int2,  int8,  fdpas_bf_bf_8_2 )
DEFN_INTEL_SG_FDPAS( bf16_bf16_matrix_mad_k16, float4, int4,  int8,  fdpas_bf_bf_8_4 )
DEFN_INTEL_SG_FDPAS( bf16_bf16_matrix_mad_k16, float8, int8,  int8,  fdpas_bf_bf_8_8 )

// half: both a and b are 2 half.
DEFN_INTEL_SG_FDPAS( f16_f16_matrix_mad_k16, float,  int,   int8,  fdpas_hf_hf_8_1 )
DEFN_INTEL_SG_FDPAS( f16_f16_matrix_mad_k16, float2, int2,  int8,  fdpas_hf_hf_8_2 )
DEFN_INTEL_SG_FDPAS( f16_f16_matrix_mad_k16, float4, int4,  int8,  fdpas_hf_hf_8_4 )
DEFN_INTEL_SG_FDPAS( f16_f16_matrix_mad_k16, float8, int8,  int8,  fdpas_hf_hf_8_8 )


//// PVC : simd16 ////

// a: 8 bit, b: 8 bit, repcount: 1,2,4,8
DEFN_INTEL_SG16_IDPAS( i8_i8_matrix_mad_k32, int,  short,   int8,  idpas_s8_s8_8_1, short,  int8 )
DEFN_INTEL_SG16_IDPAS( i8_i8_matrix_mad_k32, int2, short2,  int8,  idpas_s8_s8_8_2, short2, int8 )
DEFN_INTEL_SG16_IDPAS( i8_i8_matrix_mad_k32, int4, short4,  int8,  idpas_s8_s8_8_4, short4, int8 )
DEFN_INTEL_SG16_IDPAS( i8_i8_matrix_mad_k32, int8, short8,  int8,  idpas_s8_s8_8_8, short8, int8 )
DEFN_INTEL_SG16_IDPAS( i8_u8_matrix_mad_k32, int,  short,   uint8, idpas_s8_u8_8_1, short,  int8 )
DEFN_INTEL_SG16_IDPAS( i8_u8_matrix_mad_k32, int2, short2,  uint8, idpas_s8_u8_8_2, short2, int8 )
DEFN_INTEL_SG16_IDPAS( i8_u8_matrix_mad_k32, int4, short4,  uint8, idpas_s8_u8_8_4, short4, int8 )
DEFN_INTEL_SG16_IDPAS( i8_u8_matrix_mad_k32, int8, short8,  uint8, idpas_s8_u8_8_8, short8, int8 )
DEFN_INTEL_SG16_IDPAS( u8_i8_matrix_mad_k32, int,  ushort,  int8,  idpas_u8_s8_8_1, short,  int8 )
DEFN_INTEL_SG16_IDPAS( u8_i8_matrix_mad_k32, int2, ushort2, int8,  idpas_u8_s8_8_2, short2, int8 )
DEFN_INTEL_SG16_IDPAS( u8_i8_matrix_mad_k32, int4, ushort4, int8,  idpas_u8_s8_8_4, short4, int8 )
DEFN_INTEL_SG16_IDPAS( u8_i8_matrix_mad_k32, int8, ushort8, int8,  idpas_u8_s8_8_8, short8, int8 )
DEFN_INTEL_SG16_IDPAS( u8_u8_matrix_mad_k32, int,  ushort,  uint8, idpas_u8_u8_8_1, short,  int8 )
DEFN_INTEL_SG16_IDPAS( u8_u8_matrix_mad_k32, int2, ushort2, uint8, idpas_u8_u8_8_2, short2, int8 )
DEFN_INTEL_SG16_IDPAS( u8_u8_matrix_mad_k32, int4, ushort4, uint8, idpas_u8_u8_8_4, short4, int8 )
DEFN_INTEL_SG16_IDPAS( u8_u8_matrix_mad_k32, int8, ushort8, uint8, idpas_u8_u8_8_8, short8, int8 )

// a: 8 bit, b: 4 bit, repcount: 1,2,4,8
DEFN_INTEL_SG16_IDPAS( i8_i4_matrix_mad_k32, int,  short,   int4,  idpas_s8_s4_8_1, short,  int4 )
DEFN_INTEL_SG16_IDPAS( i8_i4_matrix_mad_k32, int2, short2,  int4,  idpas_s8_s4_8_2, short2, int4 )
DEFN_INTEL_SG16_IDPAS( i8_i4_matrix_mad_k32, int4, short4,  int4,  idpas_s8_s4_8_4, short4, int4 )
DEFN_INTEL_SG16_IDPAS( i8_i4_matrix_mad_k32, int8, short8,  int4,  idpas_s8_s4_8_8, short8, int4 )
DEFN_INTEL_SG16_IDPAS( i8_u4_matrix_mad_k32, int,  short,   uint4, idpas_s8_u4_8_1, short,  int4 )
DEFN_INTEL_SG16_IDPAS( i8_u4_matrix_mad_k32, int2, short2,  uint4, idpas_s8_u4_8_2, short2, int4 )
DEFN_INTEL_SG16_IDPAS( i8_u4_matrix_mad_k32, int4, short4,  uint4, idpas_s8_u4_8_4, short4, int4 )
DEFN_INTEL_SG16_IDPAS( i8_u4_matrix_mad_k32, int8, short8,  uint4, idpas_s8_u4_8_8, short8, int4 )
DEFN_INTEL_SG16_IDPAS( u8_i4_matrix_mad_k32, int,  ushort,  int4,  idpas_u8_s4_8_1, short,  int4 )
DEFN_INTEL_SG16_IDPAS( u8_i4_matrix_mad_k32, int2, ushort2, int4,  idpas_u8_s4_8_2, short2, int4 )
DEFN_INTEL_SG16_IDPAS( u8_i4_matrix_mad_k32, int4, ushort4, int4,  idpas_u8_s4_8_4, short4, int4 )
DEFN_INTEL_SG16_IDPAS( u8_i4_matrix_mad_k32, int8, ushort8, int4,  idpas_u8_s4_8_8, short8, int4 )
DEFN_INTEL_SG16_IDPAS( u8_u4_matrix_mad_k32, int,  ushort,  uint4, idpas_u8_u4_8_1, short,  int4 )
DEFN_INTEL_SG16_IDPAS( u8_u4_matrix_mad_k32, int2, ushort2, uint4, idpas_u8_u4_8_2, short2, int4 )
DEFN_INTEL_SG16_IDPAS( u8_u4_matrix_mad_k32, int4, ushort4, uint4, idpas_u8_u4_8_4, short4, int4 )
DEFN_INTEL_SG16_IDPAS( u8_u4_matrix_mad_k32, int8, ushort8, uint4, idpas_u8_u4_8_8, short8, int4 )

// a: 8 bit, b: 2 bit, repcount: 1,2,4,8
DEFN_INTEL_SG16_IDPAS( i8_i2_matrix_mad_k32, int,  short,   int2,  idpas_s8_s2_8_1, short,  int2 )
DEFN_INTEL_SG16_IDPAS( i8_i2_matrix_mad_k32, int2, short2,  int2,  idpas_s8_s2_8_2, short2, int2 )
DEFN_INTEL_SG16_IDPAS( i8_i2_matrix_mad_k32, int4, short4,  int2,  idpas_s8_s2_8_4, short4, int2 )
DEFN_INTEL_SG16_IDPAS( i8_i2_matrix_mad_k32, int8, short8,  int2,  idpas_s8_s2_8_8, short8, int2 )
DEFN_INTEL_SG16_IDPAS( i8_u2_matrix_mad_k32, int,  short,   uint2, idpas_s8_u2_8_1, short,  int2 )
DEFN_INTEL_SG16_IDPAS( i8_u2_matrix_mad_k32, int2, short2,  uint2, idpas_s8_u2_8_2, short2, int2 )
DEFN_INTEL_SG16_IDPAS( i8_u2_matrix_mad_k32, int4, short4,  uint2, idpas_s8_u2_8_4, short4, int2 )
DEFN_INTEL_SG16_IDPAS( i8_u2_matrix_mad_k32, int8, short8,  uint2, idpas_s8_u2_8_8, short8, int2 )
DEFN_INTEL_SG16_IDPAS( u8_i2_matrix_mad_k32, int,  ushort,  int2,  idpas_u8_s2_8_1, short,  int2 )
DEFN_INTEL_SG16_IDPAS( u8_i2_matrix_mad_k32, int2, ushort2, int2,  idpas_u8_s2_8_2, short2, int2 )
DEFN_INTEL_SG16_IDPAS( u8_i2_matrix_mad_k32, int4, ushort4, int2,  idpas_u8_s2_8_4, short4, int2 )
DEFN_INTEL_SG16_IDPAS( u8_i2_matrix_mad_k32, int8, ushort8, int2,  idpas_u8_s2_8_8, short8, int2 )
DEFN_INTEL_SG16_IDPAS( u8_u2_matrix_mad_k32, int,  ushort,  uint2, idpas_u8_u2_8_1, short,  int2 )
DEFN_INTEL_SG16_IDPAS( u8_u2_matrix_mad_k32, int2, ushort2, uint2, idpas_u8_u2_8_2, short2, int2 )
DEFN_INTEL_SG16_IDPAS( u8_u2_matrix_mad_k32, int4, ushort4, uint2, idpas_u8_u2_8_4, short4, int2 )
DEFN_INTEL_SG16_IDPAS( u8_u2_matrix_mad_k32, int8, ushort8, uint2, idpas_u8_u2_8_8, short8, int2 )

// a: 4 bit, b: 8 bit, repcount: 1,2,4,8
DEFN_INTEL_SG16_IDPAS( i4_i8_matrix_mad_k32, int,  char,   int8,  idpas_s4_s8_8_1, char,  int8 )
DEFN_INTEL_SG16_IDPAS( i4_i8_matrix_mad_k32, int2, char2,  int8,  idpas_s4_s8_8_2, char2, int8 )
DEFN_INTEL_SG16_IDPAS( i4_i8_matrix_mad_k32, int4, char4,  int8,  idpas_s4_s8_8_4, char4, int8 )
DEFN_INTEL_SG16_IDPAS( i4_i8_matrix_mad_k32, int8, char8,  int8,  idpas_s4_s8_8_8, char8, int8 )
DEFN_INTEL_SG16_IDPAS( i4_u8_matrix_mad_k32, int,  char,   uint8, idpas_s4_u8_8_1, char,  int8 )
DEFN_INTEL_SG16_IDPAS( i4_u8_matrix_mad_k32, int2, char2,  uint8, idpas_s4_u8_8_2, char2, int8 )
DEFN_INTEL_SG16_IDPAS( i4_u8_matrix_mad_k32, int4, char4,  uint8, idpas_s4_u8_8_4, char4, int8 )
DEFN_INTEL_SG16_IDPAS( i4_u8_matrix_mad_k32, int8, char8,  uint8, idpas_s4_u8_8_8, char8, int8 )
DEFN_INTEL_SG16_IDPAS( u4_i8_matrix_mad_k32, int,  uchar,  int8,  idpas_u4_s8_8_1, char,  int8 )
DEFN_INTEL_SG16_IDPAS( u4_i8_matrix_mad_k32, int2, uchar2, int8,  idpas_u4_s8_8_2, char2, int8 )
DEFN_INTEL_SG16_IDPAS( u4_i8_matrix_mad_k32, int4, uchar4, int8,  idpas_u4_s8_8_4, char4, int8 )
DEFN_INTEL_SG16_IDPAS( u4_i8_matrix_mad_k32, int8, uchar8, int8,  idpas_u4_s8_8_8, char8, int8 )
DEFN_INTEL_SG16_IDPAS( u4_u8_matrix_mad_k32, int,  uchar,  uint8, idpas_u4_u8_8_1, char,  int8 )
DEFN_INTEL_SG16_IDPAS( u4_u8_matrix_mad_k32, int2, uchar2, uint8, idpas_u4_u8_8_2, char2, int8 )
DEFN_INTEL_SG16_IDPAS( u4_u8_matrix_mad_k32, int4, uchar4, uint8, idpas_u4_u8_8_4, char4, int8 )
DEFN_INTEL_SG16_IDPAS( u4_u8_matrix_mad_k32, int8, uchar8, uint8, idpas_u4_u8_8_8, char8, int8 )

// a: 2 bit, b: 8 bit, repcount: 1,2,4,8
// no type for 4-bit integer, unsupported
//DEFN_INTEL_SG16_IDPAS( i2_i8_matrix_mad_k32, int,  char,   int8,  idpas_s2_s8_8_1, char,  int8 )
//DEFN_INTEL_SG16_IDPAS( i2_i8_matrix_mad_k32, int2, char2,  int8,  idpas_s2_s8_8_2, char2, int8 )
//DEFN_INTEL_SG16_IDPAS( i2_i8_matrix_mad_k32, int4, char4,  int8,  idpas_s2_s8_8_4, char4, int8 )
//DEFN_INTEL_SG16_IDPAS( i2_i8_matrix_mad_k32, int8, char8,  int8,  idpas_s2_s8_8_8, char8, int8 )
//DEFN_INTEL_SG16_IDPAS( i2_u8_matrix_mad_k32, int,  char,   uint8, idpas_s2_u8_8_1, char,  int8 )
//DEFN_INTEL_SG16_IDPAS( i2_u8_matrix_mad_k32, int2, char2,  uint8, idpas_s2_u8_8_2, char2, int8 )
//DEFN_INTEL_SG16_IDPAS( i2_u8_matrix_mad_k32, int4, char4,  uint8, idpas_s2_u8_8_4, char4, int8 )
//DEFN_INTEL_SG16_IDPAS( i2_u8_matrix_mad_k32, int8, char8,  uint8, idpas_s2_u8_8_8, char8, int8 )
//DEFN_INTEL_SG16_IDPAS( u2_i8_matrix_mad_k32, int,  uchar,  int8,  idpas_u2_s8_8_1, char,  int8 )
//DEFN_INTEL_SG16_IDPAS( u2_i8_matrix_mad_k32, int2, uchar2, int8,  idpas_u2_s8_8_2, char2, int8 )
//DEFN_INTEL_SG16_IDPAS( u2_i8_matrix_mad_k32, int4, uchar4, int8,  idpas_u2_s8_8_4, char4, int8 )
//DEFN_INTEL_SG16_IDPAS( u2_i8_matrix_mad_k32, int8, uchar8, int8,  idpas_u2_s8_8_8, char8, int8 )
//DEFN_INTEL_SG16_IDPAS( u2_u8_matrix_mad_k32, int,  uchar,  uint8, idpas_u2_u8_8_1, char,  int8 )
//DEFN_INTEL_SG16_IDPAS( u2_u8_matrix_mad_k32, int2, uchar2, uint8, idpas_u2_u8_8_2, char2, int8 )
//DEFN_INTEL_SG16_IDPAS( u2_u8_matrix_mad_k32, int4, uchar4, uint8, idpas_u2_u8_8_4, char4, int8 )
//DEFN_INTEL_SG16_IDPAS( u2_u8_matrix_mad_k32, int8, uchar8, uint8, idpas_u2_u8_8_8, char8, int8 )

// Double througput (k64)
// a: 4 bit, b: 4 bit, repcount: 1,2,4,8
DEFN_INTEL_SG16_IDPAS( i4_i4_matrix_mad_k64, int,  short,    int8,  idpas_s4_s4_8_1, short,   int8 )
DEFN_INTEL_SG16_IDPAS( i4_i4_matrix_mad_k64, int2, short2,   int8,  idpas_s4_s4_8_2, short2,  int8 )
DEFN_INTEL_SG16_IDPAS( i4_i4_matrix_mad_k64, int4, short4,   int8,  idpas_s4_s4_8_4, short4,  int8 )
DEFN_INTEL_SG16_IDPAS( i4_i4_matrix_mad_k64, int8, short8,   int8,  idpas_s4_s4_8_8, short8,  int8 )
DEFN_INTEL_SG16_IDPAS( i4_u4_matrix_mad_k64, int,  short,    uint8, idpas_s4_u4_8_1, short,   int8 )
DEFN_INTEL_SG16_IDPAS( i4_u4_matrix_mad_k64, int2, short2,   uint8, idpas_s4_u4_8_2, short2,  int8 )
DEFN_INTEL_SG16_IDPAS( i4_u4_matrix_mad_k64, int4, short4,   uint8, idpas_s4_u4_8_4, short4,  int8 )
DEFN_INTEL_SG16_IDPAS( i4_u4_matrix_mad_k64, int8, short8,   uint8, idpas_s4_u4_8_8, short8,  int8 )
DEFN_INTEL_SG16_IDPAS( u4_i4_matrix_mad_k64, int,  ushort,   int8,  idpas_u4_s4_8_1, short,   int8 )
DEFN_INTEL_SG16_IDPAS( u4_i4_matrix_mad_k64, int2, ushort2,  int8,  idpas_u4_s4_8_2, short2,  int8 )
DEFN_INTEL_SG16_IDPAS( u4_i4_matrix_mad_k64, int4, ushort4,  int8,  idpas_u4_s4_8_4, short4,  int8 )
DEFN_INTEL_SG16_IDPAS( u4_i4_matrix_mad_k64, int8, ushort8,  int8,  idpas_u4_s4_8_8, short8,  int8 )
DEFN_INTEL_SG16_IDPAS( u4_u4_matrix_mad_k64, int,  ushort,   uint8, idpas_u4_u4_8_1, short,   int8 )
DEFN_INTEL_SG16_IDPAS( u4_u4_matrix_mad_k64, int2, ushort2,  uint8, idpas_u4_u4_8_2, short2,  int8 )
DEFN_INTEL_SG16_IDPAS( u4_u4_matrix_mad_k64, int4, ushort4,  uint8, idpas_u4_u4_8_4, short4,  int8 )
DEFN_INTEL_SG16_IDPAS( u4_u4_matrix_mad_k64, int8, ushort8,  uint8, idpas_u4_u4_8_8, short8,  int8 )

// a: 4 bit, b: 2 bit, repcount: 1,2,4,8
DEFN_INTEL_SG16_IDPAS( i4_i2_matrix_mad_k64, int,  short,    int4,  idpas_s4_s2_8_1, short,   int4 )
DEFN_INTEL_SG16_IDPAS( i4_i2_matrix_mad_k64, int2, short2,   int4,  idpas_s4_s2_8_2, short2,  int4 )
DEFN_INTEL_SG16_IDPAS( i4_i2_matrix_mad_k64, int4, short4,   int4,  idpas_s4_s2_8_4, short4,  int4 )
DEFN_INTEL_SG16_IDPAS( i4_i2_matrix_mad_k64, int8, short8,   int4,  idpas_s4_s2_8_8, short8,  int4 )
DEFN_INTEL_SG16_IDPAS( i4_u2_matrix_mad_k64, int,  short,    uint4, idpas_s4_u2_8_1, short,   int4 )
DEFN_INTEL_SG16_IDPAS( i4_u2_matrix_mad_k64, int2, short2,   uint4, idpas_s4_u2_8_2, short2,  int4 )
DEFN_INTEL_SG16_IDPAS( i4_u2_matrix_mad_k64, int4, short4,   uint4, idpas_s4_u2_8_4, short4,  int4 )
DEFN_INTEL_SG16_IDPAS( i4_u2_matrix_mad_k64, int8, short8,   uint4, idpas_s4_u2_8_8, short8,  int4 )
DEFN_INTEL_SG16_IDPAS( u4_i2_matrix_mad_k64, int,  ushort,   int4,  idpas_u4_s2_8_1, short,   int4 )
DEFN_INTEL_SG16_IDPAS( u4_i2_matrix_mad_k64, int2, ushort2,  int4,  idpas_u4_s2_8_2, short2,  int4 )
DEFN_INTEL_SG16_IDPAS( u4_i2_matrix_mad_k64, int4, ushort4,  int4,  idpas_u4_s2_8_4, short4,  int4 )
DEFN_INTEL_SG16_IDPAS( u4_i2_matrix_mad_k64, int8, ushort8,  int4,  idpas_u4_s2_8_8, short8,  int4 )
DEFN_INTEL_SG16_IDPAS( u4_u2_matrix_mad_k64, int,  ushort,   uint4, idpas_u4_u2_8_1, short,   int4 )
DEFN_INTEL_SG16_IDPAS( u4_u2_matrix_mad_k64, int2, ushort2,  uint4, idpas_u4_u2_8_2, short2,  int4 )
DEFN_INTEL_SG16_IDPAS( u4_u2_matrix_mad_k64, int4, ushort4,  uint4, idpas_u4_u2_8_4, short4,  int4 )
DEFN_INTEL_SG16_IDPAS( u4_u2_matrix_mad_k64, int8, ushort8,  uint4, idpas_u4_u2_8_8, short8,  int4 )

// a: 2 bit, b: 4 bit, repcount: 1,2,4,8
DEFN_INTEL_SG16_IDPAS( i2_i4_matrix_mad_k64, int,  char,   int8,  idpas_s2_s4_8_1, char,  int8 )
DEFN_INTEL_SG16_IDPAS( i2_i4_matrix_mad_k64, int2, char2,  int8,  idpas_s2_s4_8_2, char2, int8 )
DEFN_INTEL_SG16_IDPAS( i2_i4_matrix_mad_k64, int4, char4,  int8,  idpas_s2_s4_8_4, char4, int8 )
DEFN_INTEL_SG16_IDPAS( i2_i4_matrix_mad_k64, int8, char8,  int8,  idpas_s2_s4_8_8, char8, int8 )
DEFN_INTEL_SG16_IDPAS( i2_u4_matrix_mad_k64, int,  char,   uint8, idpas_s2_u4_8_1, char,  int8 )
DEFN_INTEL_SG16_IDPAS( i2_u4_matrix_mad_k64, int2, char2,  uint8, idpas_s2_u4_8_2, char2, int8 )
DEFN_INTEL_SG16_IDPAS( i2_u4_matrix_mad_k64, int4, char4,  uint8, idpas_s2_u4_8_4, char4, int8 )
DEFN_INTEL_SG16_IDPAS( i2_u4_matrix_mad_k64, int8, char8,  uint8, idpas_s2_u4_8_8, char8, int8 )
DEFN_INTEL_SG16_IDPAS( u2_i4_matrix_mad_k64, int,  uchar,  int8,  idpas_u2_s4_8_1, char,  int8 )
DEFN_INTEL_SG16_IDPAS( u2_i4_matrix_mad_k64, int2, uchar2, int8,  idpas_u2_s4_8_2, char2, int8 )
DEFN_INTEL_SG16_IDPAS( u2_i4_matrix_mad_k64, int4, uchar4, int8,  idpas_u2_s4_8_4, char4, int8 )
DEFN_INTEL_SG16_IDPAS( u2_i4_matrix_mad_k64, int8, uchar8, int8,  idpas_u2_s4_8_8, char8, int8 )
DEFN_INTEL_SG16_IDPAS( u2_u4_matrix_mad_k64, int,  uchar,  uint8, idpas_u2_u4_8_1, char,  int8 )
DEFN_INTEL_SG16_IDPAS( u2_u4_matrix_mad_k64, int2, uchar2, uint8, idpas_u2_u4_8_2, char2, int8 )
DEFN_INTEL_SG16_IDPAS( u2_u4_matrix_mad_k64, int4, uchar4, uint8, idpas_u2_u4_8_4, char4, int8 )
DEFN_INTEL_SG16_IDPAS( u2_u4_matrix_mad_k64, int8, uchar8, uint8, idpas_u2_u4_8_8, char8, int8 )

// a: 2 bit, b: 2 bit, repcount: 1,2,4,8
DEFN_INTEL_SG16_IDPAS( i2_i2_matrix_mad_k64, int,  char,   int4,  idpas_s2_s2_8_1, char,  int4 )
DEFN_INTEL_SG16_IDPAS( i2_i2_matrix_mad_k64, int2, char2,  int4,  idpas_s2_s2_8_2, char2, int4 )
DEFN_INTEL_SG16_IDPAS( i2_i2_matrix_mad_k64, int4, char4,  int4,  idpas_s2_s2_8_4, char4, int4 )
DEFN_INTEL_SG16_IDPAS( i2_i2_matrix_mad_k64, int8, char8,  int4,  idpas_s2_s2_8_8, char8, int4 )
DEFN_INTEL_SG16_IDPAS( i2_u2_matrix_mad_k64, int,  char,   uint4, idpas_s2_u2_8_1, char,  int4 )
DEFN_INTEL_SG16_IDPAS( i2_u2_matrix_mad_k64, int2, char2,  uint4, idpas_s2_u2_8_2, char2, int4 )
DEFN_INTEL_SG16_IDPAS( i2_u2_matrix_mad_k64, int4, char4,  uint4, idpas_s2_u2_8_4, char4, int4 )
DEFN_INTEL_SG16_IDPAS( i2_u2_matrix_mad_k64, int8, char8,  uint4, idpas_s2_u2_8_8, char8, int4 )
DEFN_INTEL_SG16_IDPAS( u2_i2_matrix_mad_k64, int,  uchar,  int4,  idpas_u2_s2_8_1, char,  int4 )
DEFN_INTEL_SG16_IDPAS( u2_i2_matrix_mad_k64, int2, uchar2, int4,  idpas_u2_s2_8_2, char2, int4 )
DEFN_INTEL_SG16_IDPAS( u2_i2_matrix_mad_k64, int4, uchar4, int4,  idpas_u2_s2_8_4, char4, int4 )
DEFN_INTEL_SG16_IDPAS( u2_i2_matrix_mad_k64, int8, uchar8, int4,  idpas_u2_s2_8_8, char8, int4 )
DEFN_INTEL_SG16_IDPAS( u2_u2_matrix_mad_k64, int,  uchar,  uint4, idpas_u2_u2_8_1, char,  int4 )
DEFN_INTEL_SG16_IDPAS( u2_u2_matrix_mad_k64, int2, uchar2, uint4, idpas_u2_u2_8_2, char2, int4 )
DEFN_INTEL_SG16_IDPAS( u2_u2_matrix_mad_k64, int4, uchar4, uint4, idpas_u2_u2_8_4, char4, int4 )
DEFN_INTEL_SG16_IDPAS( u2_u2_matrix_mad_k64, int8, uchar8, uint4, idpas_u2_u2_8_8, char8, int4 )


// bfloat16: both a and b are 2 bfloat16.
DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, float,  float,  short,   int8,  fdpas_f_f_bf_bf_8_1 )
DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, float2, float2, short2,  int8,  fdpas_f_f_bf_bf_8_2 )
DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, float4, float4, short4,  int8,  fdpas_f_f_bf_bf_8_4 )
DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, float8, float8, short8,  int8,  fdpas_f_f_bf_bf_8_8 )
//DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, short,  float,  short,   int8,  fdpas_bf_f_bf_bf_8_1 )
//DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, short2, float2, short2,  int8,  fdpas_bf_f_bf_bf_8_2 )
//DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, short4, float4, short4,  int8,  fdpas_bf_f_bf_bf_8_4 )
//DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, short8, float8, short8,  int8,  fdpas_bf_f_bf_bf_8_8 )
//DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, float,  short,  short,   int8,  fdpas_f_bf_bf_bf_8_1 )
//DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, float2, short2, short2,  int8,  fdpas_f_bf_bf_bf_8_2 )
//DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, float4, short4, short4,  int8,  fdpas_f_bf_bf_bf_8_4 )
//DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, float8, short8, short8,  int8,  fdpas_f_bf_bf_bf_8_8 )
DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, short,  short,  short,   int8,  fdpas_bf_bf_bf_bf_8_1 )
DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, short2, short2, short2,  int8,  fdpas_bf_bf_bf_bf_8_2 )
DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, short4, short4, short4,  int8,  fdpas_bf_bf_bf_bf_8_4 )
DEFN_INTEL_SG16_FDPAS( bf16_bf16_matrix_mad_k16, short8, short8, short8,  int8,  fdpas_bf_bf_bf_bf_8_8 )

// half: both a and b are 2 half.
DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, float,  float,  short,   int8,  fdpas_f_f_hf_hf_8_1 )
DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, float2, float2, short2,  int8,  fdpas_f_f_hf_hf_8_2 )
DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, float4, float4, short4,  int8,  fdpas_f_f_hf_hf_8_4 )
DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, float8, float8, short8,  int8,  fdpas_f_f_hf_hf_8_8 )

#ifdef cl_khr_fp16

//DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, half,   float,  short,   int8,  fdpas_hf_f_hf_hf_8_1 )
//DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, half2,  float2, short2,  int8,  fdpas_hf_f_hf_hf_8_2 )
//DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, half4,  float4, short4,  int8,  fdpas_hf_f_hf_hf_8_4 )
//DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, half8,  float8, short8,  int8,  fdpas_hf_f_hf_hf_8_8 )
//DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, float,  half,   short,   int8,  fdpas_f_hf_hf_hf_8_1 )
//DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, float2, half2,  short2,  int8,  fdpas_f_hf_hf_hf_8_2 )
//DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, float4, half4,  short4,  int8,  fdpas_f_hf_hf_hf_8_4 )
//DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, float8, half8,  short8,  int8,  fdpas_f_hf_hf_hf_8_8 )
DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, half,   half,   short,   int8,  fdpas_hf_hf_hf_hf_8_1 )
DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, half2,  half2,  short2,  int8,  fdpas_hf_hf_hf_hf_8_2 )
DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, half4,  half4,  short4,  int8,  fdpas_hf_hf_hf_hf_8_4 )
DEFN_INTEL_SG16_FDPAS( f16_f16_matrix_mad_k16, half8,  half8,  short8,  int8,  fdpas_hf_hf_hf_hf_8_8 )

#endif  // cl_khr_fp16

// conversion bf <-> f
DEFN_INTEL_CVT( f32_to_bf16,  short,   float,   ftobf_1  )
DEFN_INTEL_CVT( f32_to_bf16,  short2,  float2,  ftobf_2  )
DEFN_INTEL_CVT( f32_to_bf16,  short3,  float3,  ftobf_3  )
DEFN_INTEL_CVT( f32_to_bf16,  short4,  float4,  ftobf_4  )
DEFN_INTEL_CVT( f32_to_bf16,  short8,  float8,  ftobf_8  )
DEFN_INTEL_CVT( f32_to_bf16,  short16, float16, ftobf_16 )

DEFN_INTEL_CVT( bf16_to_f32,  float,   short,   bftof_1  )
DEFN_INTEL_CVT( bf16_to_f32,  float2,  short2,  bftof_2  )
DEFN_INTEL_CVT( bf16_to_f32,  float3,  short3,  bftof_3  )
DEFN_INTEL_CVT( bf16_to_f32,  float4,  short4,  bftof_4  )
DEFN_INTEL_CVT( bf16_to_f32,  float8,  short8,  bftof_8  )
DEFN_INTEL_CVT( bf16_to_f32,  float16, short16, bftof_16 )

DEFN_INTEL_CVT2( f32_to_bf16_packed,  int,   float,   float,   2fto2bf_1  )
DEFN_INTEL_CVT2( f32_to_bf16_packed,  int2,  float2,  float2,  2fto2bf_2  )
DEFN_INTEL_CVT2( f32_to_bf16_packed,  int3,  float3,  float3,  2fto2bf_3  )
DEFN_INTEL_CVT2( f32_to_bf16_packed,  int4,  float4,  float4,  2fto2bf_4  )
DEFN_INTEL_CVT2( f32_to_bf16_packed,  int8,  float8,  float8,  2fto2bf_8  )
DEFN_INTEL_CVT2( f32_to_bf16_packed,  int16, float16, float16, 2fto2bf_16 )

#ifdef cl_intel_subgroup_matrix_multiply_accumulate_tf32
// PVC_B

DEFN_INTEL_SG16_FDPAS( tf32_tf32_matrix_mad_k8_f32, float,   float,   float,   float8,  fdpas_f_f_tf32_tf32_8_1 )
DEFN_INTEL_SG16_FDPAS( tf32_tf32_matrix_mad_k8_f32, float2,  float2,  float,   float8,  fdpas_f_f_tf32_tf32_8_2 )
DEFN_INTEL_SG16_FDPAS( tf32_tf32_matrix_mad_k8_f32, float4,  float4,  float2,  float8,  fdpas_f_f_tf32_tf32_8_4 )
DEFN_INTEL_SG16_FDPAS( tf32_tf32_matrix_mad_k8_f32, float8,  float8,  float4,  float8,  fdpas_f_f_tf32_tf32_8_8 )

DEFN_INTEL_CVT( f32_to_tf32,  int,   float,   ftotf32_1  )
DEFN_INTEL_CVT( f32_to_tf32,  int2,  float2,  ftotf32_2  )
DEFN_INTEL_CVT( f32_to_tf32,  int3,  float3,  ftotf32_3  )
DEFN_INTEL_CVT( f32_to_tf32,  int4,  float4,  ftotf32_4  )
DEFN_INTEL_CVT( f32_to_tf32,  int8,  float8,  ftotf32_8  )
DEFN_INTEL_CVT( f32_to_tf32,  int16, float16, ftotf32_16 )

DEFN_INTEL_CVT( tf32_to_f32,  float,   int,   tf32tof_1  )
DEFN_INTEL_CVT( tf32_to_f32,  float2,  int2,  tf32tof_2  )
DEFN_INTEL_CVT( tf32_to_f32,  float3,  int3,  tf32tof_3  )
DEFN_INTEL_CVT( tf32_to_f32,  float4,  int4,  tf32tof_4  )
DEFN_INTEL_CVT( tf32_to_f32,  float8,  int8,  tf32tof_8  )
DEFN_INTEL_CVT( tf32_to_f32,  float16, int16, tf32tof_16 )

#endif // cl_intel_subgroup_matrix_multiply_accumulate_tf32

#ifdef cl_intel_subgroup_matrix_multiply_accumulate_bf8

#ifdef cl_khr_fp16

// conversion bf8 <-> half
DEFN_INTEL_CVT( f16_to_bf8,  char,   half,   hftobf8_1  )
DEFN_INTEL_CVT( f16_to_bf8,  char2,  half2,  hftobf8_2  )
DEFN_INTEL_CVT( f16_to_bf8,  char3,  half3,  hftobf8_3  )
DEFN_INTEL_CVT( f16_to_bf8,  char4,  half4,  hftobf8_4  )
DEFN_INTEL_CVT( f16_to_bf8,  char8,  half8,  hftobf8_8  )
DEFN_INTEL_CVT( f16_to_bf8,  char16, half16, hftobf8_16 )

DEFN_INTEL_CVT( bf8_to_f16,  half,   char,   bf8tohf_1  )
DEFN_INTEL_CVT( bf8_to_f16,  half2,  char2,  bf8tohf_2  )
DEFN_INTEL_CVT( bf8_to_f16,  half3,  char3,  bf8tohf_3  )
DEFN_INTEL_CVT( bf8_to_f16,  half4,  char4,  bf8tohf_4  )
DEFN_INTEL_CVT( bf8_to_f16,  half8,  char8,  bf8tohf_8  )
DEFN_INTEL_CVT( bf8_to_f16,  half16, char16, bf8tohf_16 )

#ifdef cl_intel_stochastic_rounding
// stochastic rounding
DEFN_INTEL_CVT2( f16_to_bf8_srnd,  char,   half,   char,   srnd_hftobf8_1_char  )
DEFN_INTEL_CVT2( f16_to_bf8_srnd,  char2,  half2,  char2,  srnd_hftobf8_2_char  )
DEFN_INTEL_CVT2( f16_to_bf8_srnd,  char3,  half3,  char3,  srnd_hftobf8_3_char  )
DEFN_INTEL_CVT2( f16_to_bf8_srnd,  char4,  half4,  char4,  srnd_hftobf8_4_char  )
DEFN_INTEL_CVT2( f16_to_bf8_srnd,  char8,  half8,  char8,  srnd_hftobf8_8_char  )
DEFN_INTEL_CVT2( f16_to_bf8_srnd,  char16, half16, char16, srnd_hftobf8_16_char )

DEFN_INTEL_CVT2( f32_to_f16_srnd,  half,   float,   short,   srnd_ftohf_1_short  )
DEFN_INTEL_CVT2( f32_to_f16_srnd,  half2,  float2,  short2,  srnd_ftohf_2_short  )
DEFN_INTEL_CVT2( f32_to_f16_srnd,  half3,  float3,  short3,  srnd_ftohf_3_short  )
DEFN_INTEL_CVT2( f32_to_f16_srnd,  half4,  float4,  short4,  srnd_ftohf_4_short  )
DEFN_INTEL_CVT2( f32_to_f16_srnd,  half8,  float8,  short8,  srnd_ftohf_8_short  )
DEFN_INTEL_CVT2( f32_to_f16_srnd,  half16, float16, short16, srnd_ftohf_16_short )
#endif // cl_intel_stochastic_rounding

#endif  // cl_khr_fp16

#endif // cl_intel_subgroup_matrix_multiply_accumulate_bf8

#endif


#ifdef cl_intel_subgroup_split_matrix_multiply_accumulate

////  XeHP_SDV : simd8, split matrix mad (dpasw) ////

// a: 8 bit, b: 8 bit, repcount: 2,4,8
DEFN_INTEL_SG_IDPAS( i8_i8_split_matrix_mad_k32, int2, int,   int8,  idpasw_s8_s8_8_2, int,  int8 )
DEFN_INTEL_SG_IDPAS( i8_i8_split_matrix_mad_k32, int4, int2,  int8,  idpasw_s8_s8_8_4, int2, int8 )
DEFN_INTEL_SG_IDPAS( i8_i8_split_matrix_mad_k32, int8, int4,  int8,  idpasw_s8_s8_8_8, int4, int8 )
DEFN_INTEL_SG_IDPAS( i8_u8_split_matrix_mad_k32, int2, int,   uint8, idpasw_s8_u8_8_2, int,  int8 )
DEFN_INTEL_SG_IDPAS( i8_u8_split_matrix_mad_k32, int4, int2,  uint8, idpasw_s8_u8_8_4, int2, int8 )
DEFN_INTEL_SG_IDPAS( i8_u8_split_matrix_mad_k32, int8, int4,  uint8, idpasw_s8_u8_8_8, int4, int8 )
DEFN_INTEL_SG_IDPAS( u8_i8_split_matrix_mad_k32, int2, uint,  int8,  idpasw_u8_s8_8_2, int,  int8 )
DEFN_INTEL_SG_IDPAS( u8_i8_split_matrix_mad_k32, int4, uint2, int8,  idpasw_u8_s8_8_4, int2, int8 )
DEFN_INTEL_SG_IDPAS( u8_i8_split_matrix_mad_k32, int8, uint4, int8,  idpasw_u8_s8_8_8, int4, int8 )
DEFN_INTEL_SG_IDPAS( u8_u8_split_matrix_mad_k32, int2, uint,  uint8, idpasw_u8_u8_8_2, int,  int8 )
DEFN_INTEL_SG_IDPAS( u8_u8_split_matrix_mad_k32, int4, uint2, uint8, idpasw_u8_u8_8_4, int2, int8 )
DEFN_INTEL_SG_IDPAS( u8_u8_split_matrix_mad_k32, int8, uint4, uint8, idpasw_u8_u8_8_8, int4, int8 )

// a: 8 bit, b: 4 bit, repcount: 2,4,8
DEFN_INTEL_SG_IDPAS( i8_i4_split_matrix_mad_k32, int2, int,   int4,  idpasw_s8_s4_8_2, int,  int4 )
DEFN_INTEL_SG_IDPAS( i8_i4_split_matrix_mad_k32, int4, int2,  int4,  idpasw_s8_s4_8_4, int2, int4 )
DEFN_INTEL_SG_IDPAS( i8_i4_split_matrix_mad_k32, int8, int4,  int4,  idpasw_s8_s4_8_8, int4, int4 )
DEFN_INTEL_SG_IDPAS( i8_u4_split_matrix_mad_k32, int2, int,   uint4, idpasw_s8_u4_8_2, int,  int4 )
DEFN_INTEL_SG_IDPAS( i8_u4_split_matrix_mad_k32, int4, int2,  uint4, idpasw_s8_u4_8_4, int2, int4 )
DEFN_INTEL_SG_IDPAS( i8_u4_split_matrix_mad_k32, int8, int4,  uint4, idpasw_s8_u4_8_8, int4, int4 )
DEFN_INTEL_SG_IDPAS( u8_i4_split_matrix_mad_k32, int2, uint,  int4,  idpasw_u8_s4_8_2, int,  int4 )
DEFN_INTEL_SG_IDPAS( u8_i4_split_matrix_mad_k32, int4, uint2, int4,  idpasw_u8_s4_8_4, int2, int4 )
DEFN_INTEL_SG_IDPAS( u8_i4_split_matrix_mad_k32, int8, uint4, int4,  idpasw_u8_s4_8_8, int4, int4 )
DEFN_INTEL_SG_IDPAS( u8_u4_split_matrix_mad_k32, int2, uint,  uint4, idpasw_u8_u4_8_2, int,  int4 )
DEFN_INTEL_SG_IDPAS( u8_u4_split_matrix_mad_k32, int4, uint2, uint4, idpasw_u8_u4_8_4, int2, int4 )
DEFN_INTEL_SG_IDPAS( u8_u4_split_matrix_mad_k32, int8, uint4, uint4, idpasw_u8_u4_8_8, int4, int4 )

// a: 8 bit, b: 2 bit, repcount: 2,4,8
DEFN_INTEL_SG_IDPAS( i8_i2_split_matrix_mad_k32, int2, int,   int2,  idpasw_s8_s2_8_2, int,  int2 )
DEFN_INTEL_SG_IDPAS( i8_i2_split_matrix_mad_k32, int4, int2,  int2,  idpasw_s8_s2_8_4, int2, int2 )
DEFN_INTEL_SG_IDPAS( i8_i2_split_matrix_mad_k32, int8, int4,  int2,  idpasw_s8_s2_8_8, int4, int2 )
DEFN_INTEL_SG_IDPAS( i8_u2_split_matrix_mad_k32, int2, int,   uint2, idpasw_s8_u2_8_2, int,  int2 )
DEFN_INTEL_SG_IDPAS( i8_u2_split_matrix_mad_k32, int4, int2,  uint2, idpasw_s8_u2_8_4, int2, int2 )
DEFN_INTEL_SG_IDPAS( i8_u2_split_matrix_mad_k32, int8, int4,  uint2, idpasw_s8_u2_8_8, int4, int2 )
DEFN_INTEL_SG_IDPAS( u8_i2_split_matrix_mad_k32, int2, uint,  int2,  idpasw_u8_s2_8_2, int,  int2 )
DEFN_INTEL_SG_IDPAS( u8_i2_split_matrix_mad_k32, int4, uint2, int2,  idpasw_u8_s2_8_4, int2, int2 )
DEFN_INTEL_SG_IDPAS( u8_i2_split_matrix_mad_k32, int8, uint4, int2,  idpasw_u8_s2_8_8, int4, int2 )
DEFN_INTEL_SG_IDPAS( u8_u2_split_matrix_mad_k32, int2, uint,  uint2, idpasw_u8_u2_8_2, int,  int2 )
DEFN_INTEL_SG_IDPAS( u8_u2_split_matrix_mad_k32, int4, uint2, uint2, idpasw_u8_u2_8_4, int2, int2 )
DEFN_INTEL_SG_IDPAS( u8_u2_split_matrix_mad_k32, int8, uint4, uint2, idpasw_u8_u2_8_8, int4, int2 )

// a: 4 bit, b: 8 bit, repcount: 4,8
DEFN_INTEL_SG_IDPAS( i4_i8_split_matrix_mad_k32, int4, short2,  int8,  idpasw_s4_s8_8_4, short2, int8 )
DEFN_INTEL_SG_IDPAS( i4_i8_split_matrix_mad_k32, int8, short4,  int8,  idpasw_s4_s8_8_8, short4, int8 )
DEFN_INTEL_SG_IDPAS( i4_u8_split_matrix_mad_k32, int4, short2,  uint8, idpasw_s4_u8_8_4, short2, int8 )
DEFN_INTEL_SG_IDPAS( i4_u8_split_matrix_mad_k32, int8, short4,  uint8, idpasw_s4_u8_8_8, short4, int8 )
DEFN_INTEL_SG_IDPAS( u4_i8_split_matrix_mad_k32, int4, ushort2, int8,  idpasw_u4_s8_8_4, short2, int8 )
DEFN_INTEL_SG_IDPAS( u4_i8_split_matrix_mad_k32, int8, ushort4, int8,  idpasw_u4_s8_8_8, short4, int8 )
DEFN_INTEL_SG_IDPAS( u4_u8_split_matrix_mad_k32, int4, ushort2, uint8, idpasw_u4_u8_8_4, short2, int8 )
DEFN_INTEL_SG_IDPAS( u4_u8_split_matrix_mad_k32, int8, ushort4, uint8, idpasw_u4_u8_8_8, short4, int8 )

// a: 2 bit, b: 8 bit, repcount: 8
DEFN_INTEL_SG_IDPAS( i2_i8_split_matrix_mad_k32, int8, char4,  int8,  idpasw_s2_s8_8_8, char4, int8 )
DEFN_INTEL_SG_IDPAS( i2_u8_split_matrix_mad_k32, int8, char4,  uint8, idpasw_s2_u8_8_8, char4, int8 )
DEFN_INTEL_SG_IDPAS( u2_i8_split_matrix_mad_k32, int8, uchar4, int8,  idpasw_u2_s8_8_8, char4, int8 )
DEFN_INTEL_SG_IDPAS( u2_u8_split_matrix_mad_k32, int8, uchar4, uint8, idpasw_u2_u8_8_8, char4, int8 )

// Double througput (k64)
// a: 4 bit, b: 4 bit, repcount: 2,4,8
DEFN_INTEL_SG_IDPAS( i4_i4_split_matrix_mad_k64, int2, int,    int8,  idpasw_s4_s4_8_2, int,   int8 )
DEFN_INTEL_SG_IDPAS( i4_i4_split_matrix_mad_k64, int4, int2,   int8,  idpasw_s4_s4_8_4, int2,  int8 )
DEFN_INTEL_SG_IDPAS( i4_i4_split_matrix_mad_k64, int8, int4,   int8,  idpasw_s4_s4_8_8, int4,  int8 )
DEFN_INTEL_SG_IDPAS( i4_u4_split_matrix_mad_k64, int2, int,    uint8, idpasw_s4_u4_8_2, int,   int8 )
DEFN_INTEL_SG_IDPAS( i4_u4_split_matrix_mad_k64, int4, int2,   uint8, idpasw_s4_u4_8_4, int2,  int8 )
DEFN_INTEL_SG_IDPAS( i4_u4_split_matrix_mad_k64, int8, int4,   uint8, idpasw_s4_u4_8_8, int4,  int8 )
DEFN_INTEL_SG_IDPAS( u4_i4_split_matrix_mad_k64, int2, uint,   int8,  idpasw_u4_s4_8_2, int,   int8 )
DEFN_INTEL_SG_IDPAS( u4_i4_split_matrix_mad_k64, int4, uint2,  int8,  idpasw_u4_s4_8_4, int2,  int8 )
DEFN_INTEL_SG_IDPAS( u4_i4_split_matrix_mad_k64, int8, uint4,  int8,  idpasw_u4_s4_8_8, int4,  int8 )
DEFN_INTEL_SG_IDPAS( u4_u4_split_matrix_mad_k64, int2, uint,   uint8, idpasw_u4_u4_8_2, int,   int8 )
DEFN_INTEL_SG_IDPAS( u4_u4_split_matrix_mad_k64, int4, uint2,  uint8, idpasw_u4_u4_8_4, int2,  int8 )
DEFN_INTEL_SG_IDPAS( u4_u4_split_matrix_mad_k64, int8, uint4,  uint8, idpasw_u4_u4_8_8, int4,  int8 )

// a: 4 bit, b: 2 bit, repcount: 2,4,8
DEFN_INTEL_SG_IDPAS( i4_i2_split_matrix_mad_k64, int2, int,    int4,  idpasw_s4_s2_8_2, int,   int4 )
DEFN_INTEL_SG_IDPAS( i4_i2_split_matrix_mad_k64, int4, int2,   int4,  idpasw_s4_s2_8_4, int2,  int4 )
DEFN_INTEL_SG_IDPAS( i4_i2_split_matrix_mad_k64, int8, int4,   int4,  idpasw_s4_s2_8_8, int4,  int4 )
DEFN_INTEL_SG_IDPAS( i4_u2_split_matrix_mad_k64, int2, int,    uint4, idpasw_s4_u2_8_2, int,   int4 )
DEFN_INTEL_SG_IDPAS( i4_u2_split_matrix_mad_k64, int4, int2,   uint4, idpasw_s4_u2_8_4, int2,  int4 )
DEFN_INTEL_SG_IDPAS( i4_u2_split_matrix_mad_k64, int8, int4,   uint4, idpasw_s4_u2_8_8, int4,  int4 )
DEFN_INTEL_SG_IDPAS( u4_i2_split_matrix_mad_k64, int2, uint,   int4,  idpasw_u4_s2_8_2, int,   int4 )
DEFN_INTEL_SG_IDPAS( u4_i2_split_matrix_mad_k64, int4, uint2,  int4,  idpasw_u4_s2_8_4, int2,  int4 )
DEFN_INTEL_SG_IDPAS( u4_i2_split_matrix_mad_k64, int8, uint4,  int4,  idpasw_u4_s2_8_8, int4,  int4 )
DEFN_INTEL_SG_IDPAS( u4_u2_split_matrix_mad_k64, int2, uint,   uint4, idpasw_u4_u2_8_2, int,   int4 )
DEFN_INTEL_SG_IDPAS( u4_u2_split_matrix_mad_k64, int4, uint2,  uint4, idpasw_u4_u2_8_4, int2,  int4 )
DEFN_INTEL_SG_IDPAS( u4_u2_split_matrix_mad_k64, int8, uint4,  uint4, idpasw_u4_u2_8_8, int4,  int4 )

// a: 2 bit, b: 4 bit, repcount: 4,8
DEFN_INTEL_SG_IDPAS( i2_i4_split_matrix_mad_k64, int4, short2,  int8,  idpasw_s2_s4_8_4, short2, int8 )
DEFN_INTEL_SG_IDPAS( i2_i4_split_matrix_mad_k64, int8, short4,  int8,  idpasw_s2_s4_8_8, short4, int8 )
DEFN_INTEL_SG_IDPAS( i2_u4_split_matrix_mad_k64, int4, short2,  uint8, idpasw_s2_u4_8_4, short2, int8 )
DEFN_INTEL_SG_IDPAS( i2_u4_split_matrix_mad_k64, int8, short4,  uint8, idpasw_s2_u4_8_8, short4, int8 )
DEFN_INTEL_SG_IDPAS( u2_i4_split_matrix_mad_k64, int4, ushort2, int8,  idpasw_u2_s4_8_4, short2, int8 )
DEFN_INTEL_SG_IDPAS( u2_i4_split_matrix_mad_k64, int8, ushort4, int8,  idpasw_u2_s4_8_8, short4, int8 )
DEFN_INTEL_SG_IDPAS( u2_u4_split_matrix_mad_k64, int4, ushort2, uint8, idpasw_u2_u4_8_4, short2, int8 )
DEFN_INTEL_SG_IDPAS( u2_u4_split_matrix_mad_k64, int8, ushort4, uint8, idpasw_u2_u4_8_8, short4, int8 )

// a: 2 bit, b: 2 bit, repcount: 4,8
DEFN_INTEL_SG_IDPAS( i2_i2_split_matrix_mad_k64, int4, short2,  int4,  idpasw_s2_s2_8_4, short2, int4 )
DEFN_INTEL_SG_IDPAS( i2_i2_split_matrix_mad_k64, int8, short4,  int4,  idpasw_s2_s2_8_8, short4, int4 )
DEFN_INTEL_SG_IDPAS( i2_u2_split_matrix_mad_k64, int4, short2,  uint4, idpasw_s2_u2_8_4, short2, int4 )
DEFN_INTEL_SG_IDPAS( i2_u2_split_matrix_mad_k64, int8, short4,  uint4, idpasw_s2_u2_8_8, short4, int4 )
DEFN_INTEL_SG_IDPAS( u2_i2_split_matrix_mad_k64, int4, ushort2, int4,  idpasw_u2_s2_8_4, short2, int4 )
DEFN_INTEL_SG_IDPAS( u2_i2_split_matrix_mad_k64, int8, ushort4, int4,  idpasw_u2_s2_8_8, short4, int4 )
DEFN_INTEL_SG_IDPAS( u2_u2_split_matrix_mad_k64, int4, ushort2, uint4, idpasw_u2_u2_8_4, short2, int4 )
DEFN_INTEL_SG_IDPAS( u2_u2_split_matrix_mad_k64, int8, ushort4, uint4, idpasw_u2_u2_8_8, short4, int4 )


// bfloat16: both a and b are 2 bfloat16.
DEFN_INTEL_SG_FDPAS( bf16_bf16_split_matrix_mad_k16, float2, int,   int8,  fdpasw_bf_bf_8_2 )
DEFN_INTEL_SG_FDPAS( bf16_bf16_split_matrix_mad_k16, float4, int2,  int8,  fdpasw_bf_bf_8_4 )
DEFN_INTEL_SG_FDPAS( bf16_bf16_split_matrix_mad_k16, float8, int4,  int8,  fdpasw_bf_bf_8_8 )

// half: both a and b are 2 half.
DEFN_INTEL_SG_FDPAS( f16_f16_split_matrix_mad_k16, float2, int,   int8,  fdpasw_hf_hf_8_2 )
DEFN_INTEL_SG_FDPAS( f16_f16_split_matrix_mad_k16, float4, int2,  int8,  fdpasw_hf_hf_8_4 )
DEFN_INTEL_SG_FDPAS( f16_f16_split_matrix_mad_k16, float8, int4,  int8,  fdpasw_hf_hf_8_8 )

#endif // cl_intel_subgroup_split_matrix_multiply_accumulate
