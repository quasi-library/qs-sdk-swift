//
//  VSStandardColor.swift
//  QuasiDemo
//
//  Created by Soul on 2020/7/6.
//
//  所有项目通用的颜色

import UIKit

public extension UIColor {
    // MARK: - 主题色
    /// App主题色
    static let appMainGreen = UIColor.hex(0x14C355)
    /// App默认白色，纯白
    static let appMainWhite = UIColor.hex(0xFFFFFF)
    /// App默认黑色，纯黑
    static let appMainBlack = UIColor.hex(0x111111)
    /// App默认警告红色
    static let appMainRed = UIColor.hex(0xFF593C)
    /// App默认橘色（常用语Scheduled）
    static let appMainOrange = UIColor.hex(0xFFA318)
    /// App默认黄色（常用语数量）
    static let appMainYellow = UIColor.hex(0xFFC838)
    /// App默认透明色
    static let appMainClear = UIColor.clear
    /// APP常用灰色(提示不可用/不可点击)
    static let appMainGray = UIColor.hex(0xBBBBBB)
    /// APP常用粉色(提示横幅背景色)
    static let appMainPink = UIColor.hex(0xFFEEEB)
    /// APP常用淡棕色(用于指示器圆点)
    static let appMainLightBrown = UIColor.hex(0xE4E1DC)

    // MARK: - 背景色
    /// App 页面背景色(米白 #FBFBFB)
    static let appBackgroundPage = UIColor.hex(0xFBFBFB)
    /// APP列表背景色(灰白 #F1F0ED)，原F6F6F6
    static let appBackgroundList = UIColor.hex(0xF1F0ED)
    /// APP弹框遮罩层背景色(半透明黑色)
    static let appBackgroundAlert = UIColor.hex(0x000000, alpha: 0.3)
    /// APP卡片式Cell背景色(灰棕 #F1F0ED)
    static let appBackgroundCard = UIColor.hex(0xF1F0ED)
    /// APP一些强调区域的背景色(EBEBEB)
    static let appBackgroundContent = UIColor.hex(0xEBEBEB)

    // MARK: - 文本颜色
    /// 常规黑色文本#141414(原 #111111)
    static let textMainBlack = UIColor.hex(0x141414)
    /// 占位符及描述文本 #70675E(原#666666)
    static let textDescGray = UIColor.hex(0x70675E)
    /// 常见区域副标题 #8C847D
    static let textSubBrown = UIColor.hex(0x8C847D)
    /// 提示文本 #999999
    static let textTipsGray = UIColor.hex(0x999999)
    /// 报错警告文本 #ff593c
    static let textWarnRed = UIColor.hex(0xff593c)

    // MARK: - 分割线颜色
    static let line8B = UIColor.hex(0x8b8b8b)
    static let lineCC = UIColor.hex(0xcccccc)
    static let lineD8 = UIColor.hex(0xd8d8d8)
    static let lineDD = UIColor.hex(0xdddddd)
    static let lineE1 = UIColor.hex(0xe1e1e1)
    static let lineE8 = UIColor.hex(0xe8e8e8)
    static let lineEE = UIColor.hex(0xeeeeee)
    static let lineF4 = UIColor.hex(0xf4f4f4)
    static let lineF9 = UIColor.hex(0xf9f9f9)

    // MARK: - 自定义业务颜色
    /// iot-温湿度
    static let iotMeterColor = UIColor.hex(0x49BAFF)
    /// iot-light
    static let iotLightColor = UIColor.hex(0xFFC718)
    /// iot-cFan
    static let iotCFanColor = UIColor.hex(0x7ED5F1)
    /// iot-dFan
    static let iotDFanColor = UIColor.hex(0xA39EF1)
}
