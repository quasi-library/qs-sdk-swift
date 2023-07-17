//
//  UIColor+Extension.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2021/10/29.
//

import Foundation
import UIKit

public extension UIColor {
    convenience init(_ r: Int, _ g: Int, _ b: Int) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }

    /// 扩展16进制Int的实例构造方法
    convenience init(hex: Int, alpha: CGFloat = 1) {
        func f(_ hex: Int) -> CGFloat { CGFloat(hex % 0x100) / CGFloat(0xFF) }
        let b = f(hex)
        let g = f(hex >> 8)
        let r = f(hex >> 16)
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    /// 扩展入参为string的实例构造方法
    convenience init?(hexString: String) {
        let r, g, b: CGFloat

        // 移除字符串中的 # 符号
        var hexColor = hexString
        if hexColor.hasPrefix("#") {
            hexColor.remove(at: hexColor.startIndex)
        }

        // 将字符串转为十六进制整数
        guard let hexValue = Int(hexColor, radix: 16) else {
            return nil
        }

        // 分别计算 RGB 的值
        r = CGFloat((hexValue & 0xff0000) >> 16) / 255
        g = CGFloat((hexValue & 0x00ff00) >> 8) / 255
        b = CGFloat(hexValue & 0x0000ff) / 255

        // 初始化颜色
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    /// 推荐的工厂构造方法
    static func hex(_ hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let color = UIColor(hex: hex, alpha: alpha)
        return color
    }

    /// 推荐的工厂构造方法
    /// - NOTE: 建议使用入参为Int的构造方法
    static func hex(_ string: String, alpha: CGFloat = 1.0) -> UIColor {
        let scanner = Scanner(string: string)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0x00FF00) >> 8
        let b = (rgbValue & 0x0000FF)
        if #available(iOS 10.0, *) {
            return UIColor(
                displayP3Red: CGFloat(r) / 0xFF,
                green: CGFloat(g) / 0xFF,
                blue: CGFloat(b) / 0xFF,
                alpha: alpha
            )
        } else {
            return UIColor(
                red: CGFloat(r) / 0xFF,
                green: CGFloat(g) / 0xFF,
                blue: CGFloat(b) / 0xFF,
                alpha: alpha
            )
        }
    }

    /// 随机色
    static func randomCoror() -> UIColor {
        return UIColor(
            red: CGFloat(Int.random(in: 0...256)) / 255.0,
            green: CGFloat(Int.random(in: 0...256)) / 255.0,
            blue: CGFloat(Int.random(in: 0...256)) / 255.0,
            alpha: 1
        )
    }
}

public extension CGColor {
    static func hex(_ hex: Int) -> CGColor {
        UIColor(hex: hex).cgColor
    }

    static func hex(_ hex: Int, alpha: CGFloat) -> CGColor {
        UIColor(hex: hex).withAlphaComponent(alpha).cgColor
    }
}
