/*========================== begin_copyright_notice ============================

Copyright (C) 2017-2021 Intel Corporation

SPDX-License-Identifier: MIT

============================= end_copyright_notice ===========================*/

#pragma once

#ifdef _MSC_VER
#pragma warning(disable: 4005)
#endif

#include "common/LLVMWarningsPush.hpp"
#include <llvm/Support/ScaledNumber.h>
#include <llvm/Bitcode/BitcodeReader.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/Format.h>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/SourceMgr.h>
#include "common/LLVMWarningsPop.hpp"

#include <vector>
#include <stdint.h>

#include "usc.h"

#include "AdaptorOCL/OCL/LoadBuffer.h"
#include "Compiler/CISACodeGen/Platform.hpp"
#include "common/debug/Debug.hpp"
#include "Probe/Assertion.h"

namespace SIP
{
    enum SIP_ID {
        GEN9_SIP_DEBUG = 0,
        GEN9_SIP_CSR,
        GEN9_SIP_CSR_DEBUG,

        GEN10_SIP_DEBUG,
        GEN10_SIP_CSR,
        GEN10_SIP_CSR_DEBUG,

        GEN9_SIP_DEBUG_BINDLESS,
        GEN10_SIP_DEBUG_BINDLESS,

        GEN9_BXT_SIP_CSR,
        GEN9_SIP_CSR_DEBUG_LOCAL,
        GEN9_GLV_SIP_CSR,
        GEN11_SIP_CSR,
        GEN11_SIP_CSR_DEBUG,
        GEN11_SIP_CSR_DEBUG_BINDLESS,
        GEN11_LKF_SIP_CSR,
        GEN12_LP_CSR,
        GEN12_LP_CSR_DEBUG,
        GEN12_LP_CSR_DEBUG_BINDLESS,
        XE_HP_CSR,
        XE_HP_CSR_DEBUG,
        XE_HP_CSR_DEBUG_BINDLESS,
        XE_HPG_CSR_DEBUG,
        XE_HPG_CSR_DEBUG_BINDLESS,
        XE_HPC_CSR_DEBUG_BINDLESS,
        XE2_CSR_DEBUG_BINDLESS,
        XE2_CSR_DEBUG_BINDLESS_LNL_1x4_128,
        XE2_CSR_DEBUG_BINDLESS_LNL_1x4_160,
        XE2_CSR_DEBUG_BINDLESS_LNL_2x4_128,
        XE2_CSR_DEBUG_BINDLESS_LNL_2x4_160,
       GEN_SIP_MAX_INDEX
    };

    enum WMTP_DATA_SIZE
    {
        XE2_CSR_DEBUG_BINDLESS_LNL_1x4_128_WMTP_DATA_SIZE = 6296192,
        XE2_CSR_DEBUG_BINDLESS_LNL_1x4_160_WMTP_DATA_SIZE = 6428288,
        XE2_CSR_DEBUG_BINDLESS_LNL_2x4_128_WMTP_DATA_SIZE = 12588160,
        XE2_CSR_DEBUG_BINDLESS_LNL_2x4_160_WMTP_DATA_SIZE = 12852352,
    };

    enum SLM_SIZE_SUPPORTED
    {
        SLM_ANY,
        SLM_128,
        SLM_160
    };

    class CSystemThread
    {
    public:
        static bool   CreateSystemThreadKernel(
            const IGC::CPlatform &platform,
            const USC::SYSTEM_THREAD_MODE mode,
            USC::SSystemThreadKernelOutput* &pSystemThread,
            bool bindlessmode = false);

        static bool CreateSystemThreadKernel_v2(const PLATFORM &platform,
            const IGC::SCompilerHwCaps &Caps,
            const GT_SYSTEM_INFO &sysInfo,
            const USC::SYSTEM_THREAD_MODE mode,
            USC::SSystemThreadKernelOutput *&pSystemThread,
            SLM_SIZE_SUPPORTED slmSize);

        static void   DeleteSystemThreadKernel(
            USC::SSystemThreadKernelOutput* &pSystemThread );

    private:
        CSystemThread( void );
    };


    class CGenSystemInstructionKernelProgram
    {
    public:
        CGenSystemInstructionKernelProgram* Create(
            const IGC::CPlatform &platform,
            const USC::SYSTEM_THREAD_MODE mode,
            const bool bindlessMode,
            SLM_SIZE_SUPPORTED slmSize);

            void Delete(CGenSystemInstructionKernelProgram* &pKernelProgram );

            CGenSystemInstructionKernelProgram(const USC::SYSTEM_THREAD_MODE mode);
            const unsigned int  GetProgramSize() const { IGC_ASSERT(m_ProgramSize) ; return m_ProgramSize;}
            const void * GetLinearAddress() const { IGC_ASSERT(m_LinearAddress); return m_LinearAddress;}
            const unsigned int  GetStateSaveHeaderSize() const { return m_StateSaveHeaderSize; }
            const void * GetStateSaveHeaderAddress() const { return m_StateSaveHeaderAddress; }

    protected:

         unsigned int m_StateSaveHeaderSize;
         void* m_StateSaveHeaderAddress;
         unsigned int m_ProgramSize;
         void* m_LinearAddress;

    };

} // namespace IGC
