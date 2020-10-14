//
//  String+Moe.swift
//  MoeCommon
//
//  Created by Zed on 2020/9/10.
//
/**
 【字符串】相关扩展
 */

import UIKit


// MARK: - String

public extension TypeWrapperProtocol where WrappedType == String {
    /// 获取指定索引值所包含的区间值
    /// - Parameters:
    ///   - start:  开始索引值，包含开始索引
    ///   - end:    结束索引值，不包含结束索引
    /// - Returns:  从开始索引至结束索引的范围值
    func range(from start: Int, to end: Int) -> Range<String.Index>? {
        guard start <= end, end < wrappedValue.count else { return nil }
        let startIndex = wrappedValue.index(wrappedValue.startIndex, offsetBy: start)
        let endIndex = wrappedValue.index(wrappedValue.startIndex, offsetBy: end)
        return startIndex..<endIndex
    }
    
    /// 获取指定位置的子字符串并返回
    /// - Parameter start: 开始截取位置(包含该位置的值)
    /// - Parameter length: 截取长度, 不指定则取到结束
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = wrappedValue.count - start
        }
        let st = wrappedValue.index(wrappedValue.startIndex, offsetBy:start)
        let en = wrappedValue.index(st, offsetBy:len)
        return String(wrappedValue[st ..< en])
    }
    
    /// 替换指定范围的内容为`*`号，并适当添加空格
    /// - Parameters:
    ///   - left:   起始位置保留的原字符个数
    ///   - right:  结束位置保留的原字符个数
    ///   - per:    每间隔多少个字符添加空格
    /// - Returns:  返回替换的字符
    func replaceAsterisk(leftKeep left: Int, rightKeep right: Int, insertWhitespace per: Int? = nil) -> String? {
        guard wrappedValue.count > left + right else { return nil }
        var asterisks = ""
        for i in left..<(wrappedValue.count - right) {
            if per != nil && i % per! == 0 { asterisks += " " }
            asterisks += "*"
        }
        if per != nil { asterisks += " " }
        let rightIndex = wrappedValue.count - right
        guard let rangeExp = wrappedValue.moe.range(from: left, to: rightIndex) else { return nil }
        return wrappedValue.replacingCharacters(in: rangeExp, with: asterisks)
    }
    
    /// 计算文本内容在有限空间内，展示时所占据的尺寸
    /// - Parameters:
    ///   - limitSize:  有限空间的尺寸
    ///   - font:       文本字体
    /// - Returns:      文本内容占据的尺寸
    func boundingSize(limitSize: CGSize, font: UIFont) -> CGSize {
        return NSString(string: self.wrappedValue).boundingRect(
            with: limitSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        ).size
    }
}

// MARK: - AttributedString

public extension NSAttributedString {
    /// 根据指定参数，创建富文本实例
    /// - Parameters:
    ///   - text:   富文本内容
    ///   - size:   字体大小
    ///   - weight: 字体粗细，默认为普通
    ///   - color:  字体颜色
    ///   - lineSpacing: 行间距
    @available(iOS 8.2, *)
    convenience init(text: String, withFont size: CGFloat, weight: UIFont.Weight = .regular, color: UIColor = .black, lineSpacing: CGFloat? = nil) {
        var attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: weight),
            NSAttributedString.Key.foregroundColor: color,
        ]
        if let lineSpacing = lineSpacing {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = lineSpacing
            attributes[NSAttributedString.Key.paragraphStyle] = paraStyle
        }
        self.init(string: text, attributes: attributes)
    }
}
