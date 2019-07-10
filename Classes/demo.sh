# change localizable.strings path as dictated by your program requirements
localizableFile="${SRCROOT}/${PROJECT_NAME}/Support/zh-Hans.lproj/Localizable.strings"
# change const filepath as dictated by your program requirements
localizedFile="${SRCROOT}/${PROJECT_NAME}/Support/MoeLocalConst+Localizable.swift"

sed '/^\"/!d' "${localizableFile}" | sed -E 's%^\"([^\"]*)\" = \"([^\"]*)\";$%/// \2;=>var \1: String { get { return localized(\"\1\", \"\2\") } }%g' | sed 's%;=>%\'$'\n%g' | sed 's/^/    /' > "${localizedFile}.moe"
echo '''//
//  MoeLocalConst+Var.swift
//  Copyright © 2019 MoeLocalizable. All rights reserved.
//
//  Automatically generate By MoeLocalizable

import MoeLocalizable


extension MoeLocalConst {
    // MARK: Automatically generated const from `zh-Hans.lproj/Localizable.strings`
''' > "${localizedFile}"
cat "${localizedFile}.moe" >> "${localizedFile}"
echo "\n}" >> "${localizedFile}"
rm "${localizedFile}.moe"
