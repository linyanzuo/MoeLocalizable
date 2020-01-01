//
//  LocalRegister.swift
//  MoeLocalizable
//
//  Created by Zed on 2019/7/10.
//

import MoeCommon

/**
方案1： 先以简单中文开发，再提供本地化文本文件
1. 测试环境时，向“字符库文件”写入键值
2. 通过字符库导出本地化文本文件，进行翻译后重新导入内容至各个`.strings`文件
 
备注：
 只有调用了`localRegister`才会向“字符库文件”写入键值
 若项目在真机或模拟器中被删除，则“字符库文件”会被清除，此时需要重新展示相关字符的UI界面
 也可考虑使用`scan.py`脚本直接扫描整个项目，导出所有调用`localRegister`的键值对
*/


//struct LocalElement: Codable {
//    var key: String
//    var value: String
//    var fileName: String
//    var lineNumber: Int
//}


/// `本地化注册`，负责获取并注册本地化文本
public class LocalRegister {
    /// 获取共享实例
    static public let shared = LocalRegister()
    private init() {}
    
    /// 返回指定键对应的本地化文本，若加载失败则根据`useLocalizedDefault`值决定,
    /// `true`返回`localizedDefault`， `false`返回键值
    /// 此方法会向缓存库注册键值对，注册已使用的键名会抛出错误。可获取缓存库文件进行多语言翻译
    /// - Parameter key: 本地化文本对应的键名
    /// - Parameter value: 本地化文本对应的值
    /// - Parameter file: 代码所处的文件路径
    /// - Parameter line: 代码所处的行号
    public func localRegister(
        key: String,
        value: String,
        file: String = #file,
        line: Int = #line) -> String
    {
        #if DEBUG
        let element = stringLib.object(forKey: key) as? String
        if element == nil {
        // 键值都不一样，新值；正常写入
//            let newElement = LocalElement(
//                key: key,
//                value: value,
//                fileName: NSString(string: file).pathComponents.last ?? "UnknowFileName",
//                lineNumber: line
//            )
            stringLib.setValue(value, forKey: key)
            stringLib.write(to: stringLibURL, atomically: true)
        } else if element != value {
        // 键相同，值不同；冲突值，不写入，报错误。避免新词覆盖旧词
            /// Todo: 报错误
            MLog("该Key(`\(key)`)已匹配其它本地化字符，请修改")
        }
        #endif
        
        let config = LocalConfig.shared
        let localizedBundle = config.languageBundle() ?? Bundle.main
        let localizedDefault = config.localizedDefault
        let tableName = config.tableName
        
        // 1. 尝试使用key作为键获取本地化文本
        var localizedString = localizedBundle.localizedString(forKey: key,
                                                              value: localizedDefault,
                                                              table: tableName)
        // 2. 尝试使用value作为键获取本地化文本，获取失败则返回value本身
        if localizedString == localizedDefault {
            var failValue = value
            if config.useLocalizedDefault == true { failValue = localizedDefault }
            localizedString = localizedBundle.localizedString(forKey: value,
                                                              value: failValue,
                                                              table: tableName)
        }
        return localizedString
    }
    
    // MARK: Getter & Setter
    
    /// 字符库文件的URL路径
    public var stringLibURL: URL {
        get {
            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
            return URL(fileURLWithPath: cachePath).appendingPathComponent("caches.plist")
        }
    }
    
    /// 字符库，记录所有已注册的本地化字符
    internal var stringLib: NSMutableDictionary {
        get {
            if _stringLib == nil { _stringLib = NSMutableDictionary(contentsOf: self.stringLibURL) }
            if _stringLib == nil { _stringLib = NSMutableDictionary() }
            
            return _stringLib!
        }
    }
    internal var _stringLib: NSMutableDictionary?
}


extension String {
    /// 使用指定的键注册本地化文本，值为字符串本身。格式如`"key" = "string";`
    /// - Parameter key: 本地化字符的键
    public func localRegister(key: String) -> String {
        return LocalRegister.shared.localRegister(key: key, value: self)
    }
    
    /// 使用字符串本身作为键和值, 注册本地化文本, 格式如`"key" = "string";`
    public func local() -> String {
        return LocalRegister.shared.localRegister(key: self, value: self)
    }
}
