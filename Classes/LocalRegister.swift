//
//  LocalRegister.swift
//  MoeLocalizable
//
//  Created by Zed on 2019/7/10.
//

public protocol LocalRegister {
    func localRegister(key: String) -> String
}


extension String: LocalRegister, LocalConst, Runtime {
    /// Todo: developing ...
    /// register the Key-Value pair to localizable string.
    /// `localconst` will generate the relatvie const when build project
    ///
    /// - Parameter key: key of localizable string
    /// - Returns: localizable string, or the caller self if not exists
    public func localRegister(key: String) -> String {
        #if DEBUG
        let caches = localconst.caches
        if caches.object(forKey: key) == nil {
            caches.setObject(self, forKey: key as NSString)
            caches.write(to: localconst.cachesUrl, atomically: true)
        }
        #endif
        
        if checkProperty(name: key, availableIn: MoeLocalConst.classForCoder()),
            let value = localconst.value(forKey: key) as? String {
            return value
        }
        
        let localizedDefault = "localconst.localized.default"
        var localizedString = LocalConfig.languageBundle().localizedString(forKey: key, value: localizedDefault, table: MoeLocalConst.table)
        if localizedString == localizedDefault {
            localizedString = LocalConfig.languageBundle().localizedString(forKey: self, value: localizedDefault, table: MoeLocalConst.table)
        }
        return localizedString
    }
    
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}
