//
//  VSStandardFont.swift
//  QuasiDemo
//
//  Created by Soul on 2021/7/20.
//

import UIKit

///  经UED设计标准化字体
public extension UIFont {
    /// 根据Lebbay设计扩展的字体文件
    enum QSDesignExtFont {
        case ABCDiatypeLight    /// < ABCDiatype字体 中细体
        case ABCDiatypeRegular  /// < ABCDiatype字体 常规
        case ABCDiatypeMedium   /// < ABCDiatype字体 中等
        case ABCDiatypeBold     /// < ABCDiatype字体 粗体
        case ABCDiatypeItalic   /// < ABCDiatype 斜体，即ABCDiatype-RegularItalic

        case ArialRegular       /// < Arial字体 常规 (价格 默认字体)
        case ArialBold          /// < Arial字体 粗体

        case CenturyGothicRegular   /// < CenturyGothic字体 常规
        case CenturyGothicBold      /// < CenturyGothic字体 粗体

        case DINRegular         /// < DIN字体 常规
        case DINMedium          /// < DIN字体 中等
        case DINAlternate       /// < DIN字体 中细体
        case DINBold            /// < DIN字体 粗体

        case HelveticaNeueRegular         /// < HelveticaNeue字体 常规
        case HelveticaNeueMedium          /// < HelveticaNeue字体 中等
        case HelveticaNeueBold            /// < HelveticaNeue字体 粗体
        case HelveticaNeueCondensedBold   /// < HelveticaNeue字体 瘦长体
        /// < 醒目标注的广告字体ITCAvantGardePro 中等
        case ITCAvantGardeProBold

        case MontserratRegular  /// < Montserrat字体 常规体 (App 默认字体)
        case MontserratSemi     /// < Montserrat字体 半粗体
        case MontserratBold     /// < Montserrat字体 粗体
    }

    /// 便利构造方法，获取项目标准设计自定义字体
    /// - NOTE: 建议直接调用VSStandardDesign设置字体,不要直接调用此分类
    /// - Parameters:
    ///   - style: 字体格式
    ///   - size: 字号
    /// - Returns: 字体对象
    convenience init!(style: QSDesignExtFont, size: CGFloat) {
        var fontName = UIFont.systemFont(ofSize: size).fontName
        switch style {
        case .ABCDiatypeBold:       fontName = "ABCDiatype-Bold"
        case .ABCDiatypeLight:      fontName = "ABCDiatype-Light"
        case .ABCDiatypeRegular:    fontName = "ABCDiatype-Regular"
        case .ABCDiatypeMedium:     fontName = "ABCDiatype-Medium"
        case .ABCDiatypeItalic:     fontName = "ABCDiatype-Italic"
        case .ArialRegular:         fontName = "ArialMT"
        case .ArialBold:            fontName = "Arial-BoldMT"
        case .CenturyGothicRegular: fontName = "CenturyGothic"
        case .CenturyGothicBold:    fontName = "CenturyGothic-Bold"
        case .DINRegular:           fontName = "DIN-Regular"
        case .DINMedium:            fontName = "DIN-Medium"
        case .DINAlternate:         fontName = "DIN-MediumAlternate"
        case .DINBold:              fontName = "DIN-Bold"
        case .HelveticaNeueRegular: fontName = "HelveticaNeue"
        case .HelveticaNeueMedium:  fontName = "HelveticaNeue-Medium"
        case .HelveticaNeueBold:    fontName = "HelveticaNeue-Bold"
        case .HelveticaNeueCondensedBold: fontName = "HelveticaNeue-CondensedBold"
        case .ITCAvantGardeProBold: fontName = "ITCAvantGardePro-Bold"
        case .MontserratRegular:    fontName = "Montserrat-Regular"
        case .MontserratSemi:       fontName = "Montserrat-SemiBold"
        case .MontserratBold:       fontName = "Montserrat-Bold"
        }

        if let styleFont = UIFont.init(name: fontName, size: size) {
            // 使用可失败构造器（failable initializer）来实现
            self.init(descriptor: styleFont.fontDescriptor, size: size)
        } else {
            let systemFont = UIFont.systemFont(ofSize: size)
            self.init(descriptor: systemFont.fontDescriptor, size: size)
        }
    }
}
