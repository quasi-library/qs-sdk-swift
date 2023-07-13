//
//  QSStandardDesign.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/27.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import UIKit

/// 定义好的设计规范（字体 + 字号）枚举
public enum QSStandardDesignStyle {
    /// 醒目大标题 / 积分数字 / Bold 32pt
    case outstand32Bold
    /// 醒目数字（如优惠券标题，轮盘中的标题）
    case outstand20Medium
    /// 醒目数字 (如横幅中的折扣提示)
    case outstand14Bold

    /// < 提示大标题 / 优惠券力度 / Bold 20pt
    case heading20Bold
    /// < 页面大标题(导航栏标题) / 订单详情状态 / Bold 18pt
    case heading18Bold
    /// <  弹窗标题, 底部操作按钮 16 + Bold
    case heading16Bold

    /// 区域标题（加粗） / 详情页模块标题等 / ABCD-Bold 16pt
    case sectionTitleBold
    /// 选项卡分段标题（加粗）/ SemiBold 12pt
    case segmentTitleBold
    /// 选项卡分段标题（常规） / Regular 12pt
    case segmentTitleRegular

    /// 按钮标题1 / 详情页支付页地址页等&弹窗按钮 / Bold 16pt
    case buttonTitle16Bold
    /// 按钮标题2 / 签到等 / Semi 14pt
    case buttonTitle14Bold
    /// 按钮标题3 / 订单列表页退换货按钮 / Regular 14pt
    case buttonTitle14Regular
    /// 按钮标题4 / 任务按钮等 / Semi 12pt
    case body12Bold

    /// 正文1 / 详情页首选列表页闪购列表页价格等 / Semi 16pt
    case body16Medium
    /// 正文2 / 卡支付页面输入信息 / Regular 16pt
    case body16Regular
    /// 正文 6 / 说明信息 / Regular 15pt
    case body15Regular
    /// 正文 8 / 首页闪购商品价格 / ABCD-Bold 14pt
    case body14Bold
    /// 正文 4 / 列表页购物车闪购商品价格 / Semi 14pt
    case body14Medium
    /// 正文 5 / 通用信息 / Regular 14pt
    case body14Regular
    /// 正文3 / 订单号地址等重要信息，商品列表页购物车价格 / Semi 14pt
    case body13Bold
    /// 正文 7 / 首页商品推荐商品价格 / SemiBold 12pt
    case body13Regular
    /// 正文15 / Bold 10pt
    case body12Medium
    /// 正文9 / 说明文本，提示 / Regular 12pt
    case body12Regular
    /// 正文11 / 说明文本，提示 / Regular 10pt
    case body10Regular
    /// 正文14 / 折扣标签 / Bold 8pt
    case body8Bold
}

 struct VSStandardDesignPara {
     var standardFont = UIFont.systemFont(ofSize: 14)
     var standardColor = UIColor.appMainBlack

     init(font: UIFont, color: UIColor) {
         self.standardColor = color
         self.standardFont = font
     }
}

/// UI设计标准化管理类,统一字体及颜色
public enum VSStandardDesign {
    /// UI设计标准化对应的颜色
    /// - Parameter styleType: 预配置的设计标准
    /// - Returns: 单条标准对应的颜色
static func colorForStyle(_ styleType: QSStandardDesignStyle) -> UIColor {
    var standardColor = UIColor.appMainBlack
        switch styleType {
        case .outstand32Bold,
             .heading20Bold,
             .heading18Bold,
             .heading16Bold,
             .buttonTitle16Bold,
             .buttonTitle14Regular,
             .sectionTitleBold,
             .segmentTitleBold,
             .body16Medium,
             .body16Regular,
             .body15Regular,
             .body13Bold,
             .body14Bold,
             .body14Medium,
             .body14Regular,
             .body13Regular,
             .body12Bold,
             .body12Regular,
             .body10Regular,
             .body12Medium,
             .body8Bold,
             .outstand20Medium:
            // #111111
            standardColor = UIColor.textMainBlack
        case .segmentTitleRegular:
            // #666666
            standardColor = UIColor.textDescGray
        case .buttonTitle14Bold, .outstand14Bold:
            standardColor = .appMainWhite
        default:
            #if DEBUG
            assert(false, "缺少case,快快补充")
            #else
            standardColor = UIColor.textMainBlack
            #endif
        }

        return standardColor
    }

    /// UI设计标准化对应的字体
    /// - Parameter styleType: 预配置的设计标准
    /// - Returns: 单条标准对应的字体
    static func fontForStyle(_ styleType: QSStandardDesignStyle) -> UIFont {
        var standardFont = UIFont.systemFont(ofSize: 18)
        switch styleType {
        case .outstand32Bold:
            standardFont = UIFont(style: .ITCAvantGardeProBold, size: 32)
        case .heading20Bold:
            standardFont = UIFont(style: .ABCDiatypeBold, size: 20)
        case .outstand20Medium:
            standardFont = UIFont(style: .ITCAvantGardeProBold, size: 20)
        case .heading18Bold:
            standardFont = UIFont(style: .ABCDiatypeBold, size: 18)
        case .heading16Bold:
            standardFont = UIFont(style: .ABCDiatypeBold, size: 16)
        case .segmentTitleBold:
            standardFont = UIFont(style: .MontserratBold, size: 12)
        case .segmentTitleRegular:
            standardFont = UIFont(style: .MontserratRegular, size: 12)
        case .sectionTitleBold:
            standardFont = UIFont(style: .ABCDiatypeBold, size: 16)
        case .buttonTitle16Bold:
            standardFont = UIFont(style: .ABCDiatypeBold, size: 16)
        case .buttonTitle14Bold:
            standardFont = UIFont(style: .ABCDiatypeBold, size: 14)
        case .buttonTitle14Regular:
            standardFont = UIFont(style: .MontserratRegular, size: 14)
        case .body16Medium:
            standardFont = UIFont(style: .ABCDiatypeMedium, size: 16)
        case .body16Regular:
            standardFont = UIFont(style: .ABCDiatypeRegular, size: 16)
        case .body15Regular: // 28px + Semi
            standardFont = UIFont(style: .ABCDiatypeRegular, size: 15)
        case .outstand14Bold:
            standardFont = UIFont(style: .ITCAvantGardeProBold, size: 14)
        case .body14Medium:
            standardFont = UIFont(style: .ABCDiatypeMedium, size: 14)
        case .body14Bold:
            standardFont = UIFont(style: .ABCDiatypeBold, size: 14)
        case .body14Regular:
            standardFont = UIFont(style: .ABCDiatypeRegular, size: 14)
        case .body13Bold:
            standardFont = UIFont(style: .ABCDiatypeBold, size: 13)
        case .body13Regular:
            standardFont = UIFont(style: .ABCDiatypeRegular, size: 13)
        case .body12Bold:
            standardFont = UIFont(style: .ABCDiatypeBold, size: 12)
        case .body12Medium:
            standardFont = UIFont(style: .ABCDiatypeMedium, size: 12)
        case .body12Regular: // 12px + Regular
            standardFont = UIFont(style: .ABCDiatypeRegular, size: 12)
        case .body10Regular:
            standardFont = UIFont(style: .MontserratRegular, size: 10)
        case .body8Bold:
            standardFont = UIFont(style: .MontserratBold, size: 8)
        }

        return standardFont
    }

 static func standardStyleModel(_ styleType: QSStandardDesignStyle) -> VSStandardDesignPara {
        let font = self.fontForStyle(styleType)
        let color = self.colorForStyle(styleType)

        let res = VSStandardDesignPara(font: font, color: color)

        return res
    }
}
