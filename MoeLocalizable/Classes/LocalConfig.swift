//
//  LocalConfig.swift
//  MoeLocalizable
//
//  Created by Zed on 2019/7/11.
//

import UIKit
import MoeCommon


/// 本地化语言，项目添加本地化语言时，请勾选相应的类型，否则无法加载相应包的语言文件
public enum LocalLanguage: String {
    /// 简体中文，本地化勾选时请选择“zh-Hans”
    case chineseSimplified = "zh-Hans"
    /// 繁体中文，本地化勾选时请选择“zh-Hant”
    case chineseTraditional = "zh-Hant"
    /// 英文，本地化勾选时请选择“en”
    case english = "en"
    /// 韩文，本地化勾选时请选择“ko”
    case korean = "ko"
    /// 日文，本地化勾选时请选择“ja”
    case japanese = "ja"
}


extension Notification.Name {
    public struct Localizable {
        /// 本地化语言修改时，发出该通知。
        ///
        /// `userInfo`中携带键为`Language`的参数，其值为当前的本地化语言(`LocalLanguage`类型)
        public static let LanguageChange = Notification.Name(rawValue:
            "org.moe.localizable.notificatoin.name.localizable.languageChange")
    }
}


/// `本地化配置`，负责切换本地化语言，配置本地化默认表名、本地化默认值等。
public class LocalConfig {
    private enum LanguageKey: String {
        case user = "MoeUserLanguageKey"
        case apple = "AppleLanguages"
    }
    
    /// 获取本地化文件失败时，是否显示默认文本
    public var useLocalizedDefault = false
    /// 获取本地化文件失败时显示的默认文本
    public var localizedDefault = "localconst.localized.default"
    /// 本地化文件名称，默认为`Localizable`
    public var tableName = "Localizable"
    
    /// 本地化语言切换后触发的回调闭包，也可通过监听`Localizable.LanguageChange`通知处理
    private var languageDidChange: LanguageDidChangeClosure?
    public typealias LanguageDidChangeClosure = (_ language: LocalLanguage?) -> Void
        
    /// 获取共享实例
    static public let shared = LocalConfig()
    private init() {}
    
    /// 设置本地化语言
    /// - Parameter language: 本地化语言，如果为nil则使用系统默认语言
    public func setLocalLanguage(_ language: LocalLanguage?) {
        guard let language = language else { return resetAsSystemLanguage() }
        
        userDefaultsSave(pairs: [
            LanguageKey.user.rawValue : language.rawValue,
            LanguageKey.apple.rawValue : [language.rawValue]
        ])
        
        
        languageDidChange?(language)
        NotificationCenter.default.post(name: Notification.Name.Localizable.LanguageChange,
                                        object: self,
                                        userInfo: ["Language" : language])
    }
    
    /// 返回当前的本地化语言，若是未配置或不支持的语言则返回nil
    public func localLanguage() -> LocalLanguage? {
        let langDescription = userDefaultsValue(forKey: LanguageKey.user.rawValue)
        guard let rawValue = langDescription as? String else { return nil }
        
        guard let language = LocalLanguage(rawValue: rawValue) else { return nil }
        return language
    }
    
    /// 重置本地化语言为当前系统语言
    public func resetAsSystemLanguage() {
        userDefaultsRemove(keys: [LanguageKey.user.rawValue])
        userDefaultsSave(pairs: [LanguageKey.apple.rawValue: nil])
    }
    
    /// 返回本地化语言对应的包(`Bundle`)
    /// 若是未配置本地化语言、不支持的语言、或找不到匹配的包，则返回nil
    public func languageBundle() -> Bundle? {
        guard let language = localLanguage() else { return nil }
        
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj") else
        { return nil }
        
        guard let bundle = Bundle(path: path) else { return nil }
        return bundle
    }
    
    /// 本地化语言切换后执行回调闭包，也可通过监听`Localizable.LanguageChange`通知处理
    /// - Parameter closure: 语言切换后要执行的回调闭包
    public func languageDidChange(closure: LanguageDidChangeClosure?) {
        languageDidChange = closure
    }
}
