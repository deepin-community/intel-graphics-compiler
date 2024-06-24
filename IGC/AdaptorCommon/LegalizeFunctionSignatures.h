/*========================== begin_copyright_notice ============================

Copyright (C) 2020-2021 Intel Corporation

SPDX-License-Identifier: MIT

============================= end_copyright_notice ===========================*/

#pragma once

#include "Compiler/MetaDataUtilsWrapper.h"
#include "Compiler/CodeGenContextWrapper.hpp"

#include "common/LLVMWarningsPush.hpp"
#include <llvm/Pass.h>
#include <llvm/IR/InstVisitor.h>
#include <llvmWrapper/IR/IRBuilder.h>
#include "common/LLVMWarningsPop.hpp"

#include <map>

class LegalizeFunctionSignatures : public llvm::ModulePass
{
public:
    static char ID;

    LegalizeFunctionSignatures();

    virtual void getAnalysisUsage(llvm::AnalysisUsage& AU) const
    {
        AU.addRequired<IGC::CodeGenContextWrapper>();
        AU.addRequired<IGC::MetaDataUtilsWrapper>();
    }

    virtual bool runOnModule(llvm::Module& M);

    void FixFunctionSignatures(llvm::Module& M);
    void FixFunctionBody(llvm::Module& M);
    void FixFunctionUsers(llvm::Module& M);
    void FixCallInstruction(llvm::Module& M, llvm::CallInst* callInst);

    virtual llvm::StringRef getPassName() const
    {
        return "LegalizeFunctionSignatures";
    }

private:
    std::map<llvm::Function*, llvm::Function*> oldToNewFuncMap;
};
