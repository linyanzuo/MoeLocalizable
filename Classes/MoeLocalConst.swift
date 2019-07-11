//
//  MoeLocalConst.swift
//  MoeLocalizable
//
//  Created by Zed on 2019/7/10.
//

@objcMembers public class MoeLocalConst: NSObject {
    static let share = MoeLocalConst()
    private override init() {}
    
    /// default localizable table name
    public static let table = "Localizable"
    
    private(set) lazy var cachesUrl: URL = {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let cachesPath = docPath.appendingPathComponent("caches.plist")
        return URL(fileURLWithPath: cachesPath)
    }()
    
    private(set) lazy var caches: NSMutableDictionary = {
        if let caches = NSMutableDictionary(contentsOf: self.cachesUrl) {
            return caches
        }
        return NSMutableDictionary()
    }()
    
    public func localized(_ key: String, _ comment: String) -> String {
        let bundle = LocalConfig.languageBundle()
        return NSLocalizedString(key, tableName: MoeLocalConst.table, bundle: bundle, value: "", comment: comment)
    }
}

