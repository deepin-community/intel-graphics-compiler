/*========================== begin_copyright_notice ============================

Copyright (C) 2022 Intel Corporation

SPDX-License-Identifier: MIT

============================= end_copyright_notice ===========================*/

#pragma once

#include <algorithm>
#include <string>
#include <vector>

#include "Probe/Assertion.h"

#include "llvm/IR/Module.h"

namespace IGC {

template <class ContainerType, class BinaryFunction,
          class Sorter = std::less<typename ContainerType::key_type>>
static void OrderedTraversal(const ContainerType &Data, BinaryFunction Visit,
                             Sorter SortProcedure = {}) {
  std::vector<typename ContainerType::key_type> Keys;
  std::transform(Data.begin(), Data.end(), std::back_inserter(Keys),
                 [](const auto &KV) { return KV.first; });
  std::sort(Keys.begin(), Keys.end(), SortProcedure);
  for (const auto &Key : Keys) {
    auto FoundIt = Data.find(Key);
    IGC_ASSERT(FoundIt != Data.end());
    const auto &Val = FoundIt->second;
    Visit(Key, Val);
  }
}

constexpr int32_t SOURCE_LANG_LITERAL_MD_IS_NOT_PRESENT = -1;

//
// Flag "Source Lang Literal" contains sourceLanguage.
//
// Example:
//   !llvm.module.flags = !{..., !3, ...}
//   ...
//   !3 = !{i32 2, !"Source Lang Literal", 33}
//   ...
//
inline int32_t getSourceLangLiteralMDValueLegacy(const llvm::Module *module) {
  auto sourceLangLiteral = module->getModuleFlag("Source Lang Literal");
  if (!sourceLangLiteral) {
    return SOURCE_LANG_LITERAL_MD_IS_NOT_PRESENT;
  }

  auto constant = llvm::cast<llvm::ConstantAsMetadata>(sourceLangLiteral);
  return int32_t(
      llvm::cast<llvm::ConstantInt>(constant->getValue())->getZExtValue());
}

//
// Flag "Source Lang Literal" contains a list (MDTuple) of pairs (MDTuple):
//   (compileUnit, sourceLanguage)
//
// Example:
//   !llvm.module.flags = !{..., !3, ...}
//   ...
//   !3 = !{i32 2, !"Source Lang Literal", !4}
//   !4 = !{!5, !1834, ...}
//   !5 = !{!6, i32 33}
//   !6 = !DICompileUnit(...
//   ...
//   !1834 = !{!1835, i32 33}
//   !1835 = !DICompileUnit(...
//   ...
//
inline int32_t
getSourceLangLiteralMDValue(const llvm::DICompileUnit *compileUnit,
                            const llvm::Module *module) {
  const auto flagName = "Source Lang Literal";

  if (!module->getModuleFlag(flagName)) {
    return SOURCE_LANG_LITERAL_MD_IS_NOT_PRESENT;
  }

  auto node = llvm::dyn_cast<llvm::MDTuple>(module->getModuleFlag(flagName));
  if (!node) {
    return getSourceLangLiteralMDValueLegacy(module);
  }

  for (auto &op : node->operands()) {
    auto entry = llvm::cast<llvm::MDTuple>(op);
    if (llvm::cast<llvm::DICompileUnit>(entry->getOperand(0)) == compileUnit) {
      auto constant =
          llvm::cast<llvm::ConstantAsMetadata>(entry->getOperand(1));
      return int32_t(
          llvm::cast<llvm::ConstantInt>(constant->getValue())->getZExtValue());
    }
  }

  return SOURCE_LANG_LITERAL_MD_IS_NOT_PRESENT;
}

inline uint16_t getSourceLanguage(const llvm::DICompileUnit *compileUnit,
                                  const llvm::Module *module) {
  int32_t sourceLanguage = getSourceLangLiteralMDValue(compileUnit, module);
  if (sourceLanguage == SOURCE_LANG_LITERAL_MD_IS_NOT_PRESENT) {
    sourceLanguage = compileUnit->getSourceLanguage();
  }
  return uint16_t(sourceLanguage);
}

} // namespace IGC
