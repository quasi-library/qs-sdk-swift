//
//  VSGoodsShowHandler.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/15.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//
//  Handler只提供类方法

import Foundation
import UIKit

/**
  处理电商展示相关的一些通用逻辑
 */
public enum VSGoodsShowHandler {
    /// 服务器返回的图片链接中一般带有宽度标记，根据业务可以替换链接用于请求较小的图片
    /// - Parameters imageUrl: 服务器返回链接 e.g. https://image.next.Quasi.com/asset/width-1000/picture/1875f0186029421db45bb5c563a5272b.jpg
    ///
    static func replaceImageWidth(_ imageUrl: String?, newWidth: Int) -> String? {
        // 需要替换的字符串
        guard let originalString = imageUrl else {
            return nil
        }

        // 匹配 /width-1000 或 /width-500 的正则表达式
        if let regex = try? NSRegularExpression(pattern: "/width-[0-9]+", options: []) {
            // 将 /width-1000 或 /width-500 替换成 /width-300
            let replaceStr = "/width-\(newWidth)"
            let range = NSRange(location: 0, length: originalString.count)
            let newStr = regex.stringByReplacingMatches(in: originalString, options: [], range: range, withTemplate: replaceStr)
            //        debugPrint(self, #function, newStr)
            return newStr
        } else {
            return originalString
        }
    }

    /// 将商品原价转化为划线价格富文本
    /// - Parameters fontSize: 展示划线价字体大小，传nil则沿用label自身属性
    static func strikethroughAttrText(
        originalPrice: String?,
        fontSize: CGFloat? = 12,
        lineColor: UIColor? = .textTipsGray
    ) -> NSAttributedString {
        guard let originalPrice, originalPrice.isBlank == false else {
            return NSAttributedString(string: "")
        }

        let attributedString = NSMutableAttributedString(string: originalPrice)
        let range = NSRange(location: 0, length: originalPrice.count)
        // 将删除线的粗细设置为2
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
        // 调整字体大小(全局默认ABCDRegular字体)
        if let fontSize {
            if let font = UIFont(style: .ABCDiatypeRegular, size: fontSize) {
                attributedString.addAttribute(.font, value: font, range: range)
            } else {
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: range)
            }
        }
        // 调整价格颜色
        if let lineColor {
            attributedString.addAttribute(.foregroundColor, value: lineColor, range: range)
        }

        return NSAttributedString(attributedString: attributedString)
    }
}
