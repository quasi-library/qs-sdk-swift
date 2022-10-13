//
//  UIColor+Extension.swift
//  VivoSun
//
//  Created by Gwyneth Gan on 2021/10/29.
//

import Foundation
import UIKit

public extension UIColor {
    static let mobiBar = UIColor(hex: 0x25262F)
    static let finishBar = UIColor(hex: 0x2E364C)
    static let trackMid = UIColor(red: 36 / 255, green: 51 / 255, blue: 69 / 255, alpha: 1)
    static let trackText = UIColor(red: 108 / 255, green: 140 / 255, blue: 168 / 255, alpha: 1)
    static let trackDark = UIColor(red: 23 / 255, green: 35 / 255, blue: 49 / 255, alpha: 1)
    static let trackLight = UIColor(red: 67 / 255, green: 96 / 255, blue: 130 / 255, alpha: 1)
    static let trackGray = UIColor(red: 73 / 255, green: 87 / 255, blue: 104 / 255, alpha: 1)
    static let trackCyan = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1)
    static let trackRed = UIColor(red: 240 / 255, green: 61 / 255, blue: 107 / 255, alpha: 1)
    static let barBackground = UIColor(red: 32 / 255, green: 51 / 255, blue: 67 / 255, alpha: 1)
    static let barDisabled = UIColor(red: 54 / 255, green: 77 / 255, blue: 96 / 255, alpha: 1)
    static let hexLight = UIColor(red: 44 / 255, green: 57 / 255, blue: 75 / 255, alpha: 1)
    static let hexSelected = UIColor(red: 6 / 255, green: 77 / 255, blue: 95 / 255, alpha: 1)
    static let hexCyan = UIColor(red: 12 / 255, green: 204 / 255, blue: 213 / 255, alpha: 1)
    static let pins = [
        UIColor(red: 42 / 255, green: 182 / 255, blue: 101 / 255, alpha: 1),
        UIColor(red: 1, green: 70 / 255, blue: 137 / 255, alpha: 1),
        UIColor(red: 86 / 255, green: 84 / 255, blue: 1, alpha: 1),
        UIColor(red: 70 / 255, green: 173 / 255, blue: 1, alpha: 1),
        UIColor(red: 199 / 255, green: 70 / 255, blue: 1, alpha: 1)
    ]

    static var titleColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.hex(0x141B2D)
        }
    }

    static var commentBgColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { collection -> UIColor in
                if collection.userInterfaceStyle == .dark {
                    return UIColor.hex(0x252942)
                }
                return UIColor.hex(0xE6E7EC)
            }
        } else {
            return UIColor.hex(0xE6E7EC)
        }
    }

    var grayScaleColor: UIColor {
        var white: CGFloat = 0
        var alpha: CGFloat = 0
        getWhite(&white, alpha: &alpha)
        return UIColor(white: white, alpha: alpha)
    }
}

public extension UIColor {
    convenience init(_ r: Int, _ g: Int, _ b: Int) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }

    convenience init(hex: Int, alpha: CGFloat = 1) {
        func f(_ hex: Int) -> CGFloat { CGFloat(hex % 0x100) / CGFloat(0xFF) }
        let b = f(hex)
        let g = f(hex >> 8)
        let r = f(hex >> 16)
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    convenience init(string s: String) {
        self.init(hex: Int(s, radix: 16) ?? 0)
    }

    static func hex(_ hex: Int, alpha: CGFloat = 1) -> UIColor {
        UIColor(hex: hex, alpha: alpha)
    }

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
            red: CGFloat(arc4random() % 256) / 255.0,
            green: CGFloat(arc4random() % 256) / 255.0,
            blue: CGFloat(arc4random() % 256) / 255.0,
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
