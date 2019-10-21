//
//  LocalConfig.swift
//  MoeLocalizable
//
//  Created by Zed on 2019/7/11.
//

import UIKit


enum LocalLanguage: String {
    /// 简体中文
    case chineseSimplified = "zh-Hans"
    /// 繁体中文
    case chineseTraditional = "zh-Hant"
    /// 英文
    case english = "en"
    /// 韩文
    case korean = "ko"
    /// 日文
    case japanese = "ja"
}


@objcMembers public class LocalConfig: NSObject {
    
    private static let UserLanguageKey = "MoeUserLanguageKey"
    
    /// Set user language
    ///
    /// - Parameter language: language name, use system language if nil
    public static func setUserLanguage(_ language: String?) {
        guard language?.count ?? 0 > 0 else {
            self.resetSystemLanguage()
            return
        }
        
        UserDefaults.standard.setValue(language, forKey: UserLanguageKey)
        UserDefaults.standard.setValue([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    /// get current user language
    ///
    /// - Returns: description of current user language
    public static func userLanguage() -> String? {
        return UserDefaults.standard.value(forKey: UserLanguageKey) as? String
    }
    
    /// Reset user language as System Language
    public static func resetSystemLanguage() {
        UserDefaults.standard.removeObject(forKey: UserLanguageKey)
        UserDefaults.standard.setValue(nil, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    public static func languageBundle() -> Bundle {
        guard userLanguage()?.count ?? 0 > 0 else { return Bundle.main }
        
        if let path = Bundle.main.path(forResource: userLanguage(), ofType: "lproj") {
            return Bundle(path: path)!
        }
        return Bundle.main
    }
}
