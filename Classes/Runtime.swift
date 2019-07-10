//
//  Runtime.swift
//  MoeLocalizable
//
//  Created by Zed on 2019/7/10.
//

import UIKit


let valueTypesMap: Dictionary<String, Any> = [
    "c" : Int8.self,
    "s" : Int16.self,
    "i" : Int32.self,
    "q" : Int.self,         //也是 Int64, NSInteger, 64位平台时有效
    "S" : UInt16.self,
    "I" : UInt32.self,
    "Q" : UInt.self,        //也是 UInt64, 64位平台时有效
    "B" : Bool.self,
    "d" : Double.self,
    "f" : Float.self,
    "{" : Decimal.self
]


protocol Runtime {
    func getTypesOfProperties(in clazz: AnyClass?) -> Dictionary<String, Any>?
    func getNameOf(property: objc_property_t) -> String?
    func getTypeOf(property: objc_property_t) -> Any
    func valueType(withAttributes attributes: String) -> Any
}
extension Runtime {
    func getTypesOfProperties(in clazz: AnyClass?) -> Dictionary<String, Any>? {
        var count = UInt32()
        guard let properties = class_copyPropertyList(clazz, &count)
            else { return nil }
        var types: Dictionary<String, Any> = [:]
        for i in 0..<Int(count) {
            let property: objc_property_t = properties[i]
            
            guard let name = getNameOf(property: property)
                else { continue }
            let type = getTypeOf(property: property)
            types[name] = type
        }
        free(properties)
        return types
    }
    
    func checkProperty(name: String, availableIn clazz: AnyClass?) -> Bool {
        
        guard let properties = getTypesOfProperties(in: clazz)
            else { return false }
        
        for key in properties.keys {
            if key == name { return true }
        }
        return false
    }
    
    func getNameOf(property: objc_property_t) -> String? {
        guard let name: NSString = NSString(utf8String: property_getName(property))
            else { return nil }
        
        return name as String
    }
    
    func getTypeOf(property: objc_property_t) -> Any {
        guard
            let attributes = property_getAttributes(property),
            let attrAsString: NSString = NSString(utf8String: attributes)
            else { return Any.self }
        
        // Tq,N,Vcount                  : Int类型的, 属性名为count
        // T@"NSString",N,R,Vtitle      : NSString类型, 属性名为title
        let attrString = attrAsString as String
        // [Tq,N,Vcount]
        // ["T@", "NSString", ",N,R,Vtitle"]
        let slices = attrString.components(separatedBy: "\"")
        
        guard slices.count > 1
            else { return valueType(withAttributes: attrString) }
        let objectClassName = slices[1]
        let objectClass = NSClassFromString(objectClassName) as! NSObject.Type
        
        return objectClass
    }
    
    func valueType(withAttributes attributes: String) -> Any {
        // "Tq,N,Vcount"         : Int类型的, 属性名为count
        let letter = attributes.subString(start: 1, length: 1)
        guard let type = valueTypesMap[letter]
            else { return Any.self }
        
        return type
    }
}

