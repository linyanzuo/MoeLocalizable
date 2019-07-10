//
//  LocalConst.swift
//  MoeLocalizable
//
//  Created by Zed on 2019/7/10.
//

struct RuntimeKey {
    static let localizable = UnsafeRawPointer(bitPattern: MKeyFor("localizable").hashValue)!
}
func MKeyFor(_ name: String, file: String = #file) -> NSString {
    let fileName = NSString(string: file).pathComponents.last!
    return NSString(string: "[\(fileName)]: \(name)")
}


public protocol LocalConst {
    var localconst: MoeLocalConst { get }
}
public extension LocalConst {
    /// the variable who has all const load form localizable strings
    var localconst: MoeLocalConst {
        get {
            var _localizable = objc_getAssociatedObject(self, RuntimeKey.localizable) as? MoeLocalConst
            if _localizable == nil {
                _localizable = MoeLocalConst.share
                objc_setAssociatedObject(self, RuntimeKey.localizable, _localizable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return _localizable!
        }
    }
    
    /// it's another simple express of `localconst`
    var moe: MoeLocalConst {
        get { return localconst }
    }
}
