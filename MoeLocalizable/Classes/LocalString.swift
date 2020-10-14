//
//  LocalConst.swift
//  MoeLocalizable
//
//  Created by Zed on 2019/7/10.
//

/**
方案2： 先提供本地化文本文件，再进行开发
1.  在项目的`Target > Build phases`添加`Run Script`，并引入`LocalConst.sh`脚本
    在每次Build项目时脚本自动根据简单中文的`.strings`文件生成`LocalConst+Var`文件
    该文件位于项目的`Support`目录下，第一次Build后需要手动将该文件导入项目中
2.  `LocalConst+Var`文件中为`LocalConst`单例对象扩展了大量的计算属性，每个属性都对应一个本地化文本
    本地化文本的键名即为属性名，简单中文的值作为默认值。每个属性的代码也匹配了简单中文的注释
    项目中可直接通过`LocalConst`的属性获取所有国际化文本，避免输错键名
3.  每次项目Build时都会重新根据简单中文的`.strings`文件生成`LocalConst`扩展代码
    因此`.strings`文件的修改可能导致代码错误，如删除了已经使用的文本，可能导致Build之后找不到对应的属性
 */


// `本地化文本`，负责获取本地化文本
public class LocalString {
    public static let share = LocalString()
    private init() {}
    
    /// 返回指定键对应的本地化文本，若加载失败则返回默认值。
    /// 若无默认值则根据`useLocalizedDefault`值决定,
    /// `true`返回`localizedDefault`， `false`返回键值
    /// - Parameter key: 本地化文本对应的键名
    /// - Parameter defaultValue: 本地化文本加载失败时显示的默认值
    public func localized(_ key: String, _ defaultValue: String? = nil) -> String {
        let config = LocalConfig.shared
        let bundle = config.languageBundle() ?? Bundle.main
        let failValue = config.useLocalizedDefault ? config.localizedDefault : key
        
        return bundle.localizedString(forKey: key,
                                      value: defaultValue ?? failValue,
                                      table: config.tableName)
    }
}


/// `LocalConst`的共享实例
public var local: LocalString {
    get { return LocalString.share }
}
