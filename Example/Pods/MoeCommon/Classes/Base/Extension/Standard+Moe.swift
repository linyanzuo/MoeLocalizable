//
//  Standard.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/19.
//

// MARK: String

extension TypeWrapperProtocol where WrappedType == String {
    /// 获取指定位置的子字符串并返回
    /// - Parameter start: 开始截取位置(包含该位置的值)
    /// - Parameter length: 截取长度, 不指定则取到结束
    public func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = wrappedValue.count - start
        }
        let st = wrappedValue.index(wrappedValue.startIndex, offsetBy:start)
        let en = wrappedValue.index(st, offsetBy:len)
        return String(wrappedValue[st ..< en])
    }
}


// MARK: Operator

/// 将右侧数组的元素追加至左侧数组内
/// - Parameter left: 左侧数组，右侧数组值将追加至此
/// - Parameter right: 右侧数组，其元素将被追加到左侧数组内
public func += <Type> (left: inout Array<Type>, right: Array<Type>) {
    for value in right { left.append(value) }
}

/// 将右侧字典的元素追加至左侧字典内
/// - Parameter left: 左侧字典，右侧字典值将追加至此
/// - Parameter right: 右侧字典，其元素将被追加到左侧字典内
public func += <KeyType, ValueType> (
    left: inout Dictionary<KeyType, ValueType>,
    right: Dictionary<KeyType, ValueType>)
{
    for (key, value) in right { left.updateValue(value, forKey: key) }
}
<<<<<<< HEAD
=======


// MARK: UserDefaults

/// 增加多个键值对数据至`用户默认配置`数据库
/// - Parameter pairs: 保存所有要添加键值对的字典
public func userDefaultsSave(pairs: [String: Any?]) {
    let standard = UserDefaults.standard
    for (key, value) in pairs { standard.setValue(value, forKey: key) }
    standard.synchronize()
}

/// 向`用户默认配置`数据库获取指定键对应的值
/// - Parameter key: 指定的键值
public func userDefaultsValue(forKey key: String) -> Any? {
    return UserDefaults.standard.value(forKey: key)
}

/// 删除`用户默认配置`数据库中多个指定的键值对
/// - Parameter keys: 保存所有要删除键的数组
public func userDefaultsRemove(keys: [String]) {
    let standard = UserDefaults.standard
    for key in keys { standard.removeObject(forKey: key) }
    standard.synchronize()
}
>>>>>>> fa68b359b4f45c42990f1578c339de76f5f909b9
