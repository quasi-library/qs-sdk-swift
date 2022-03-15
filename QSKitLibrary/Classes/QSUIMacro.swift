//
//  QSUIMacro.swift
//  QSKitLibrary
//
//  Created by GengJian on 2022/3/15.
//
//  方便布局使用的全局变量(OC中Layout宏)

import Foundation

//MARK: - 屏幕尺寸参数
/// 屏幕宽度
public let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高度
public let kScreenHeigth = UIScreen.main.bounds.size.height
/// 屏幕是否刘海儿屏(含底部操纵线)
public let kIsBangScreen: Bool = {
    var isPhoneX = false
    if #available(iOS 11.0, *) {
        isPhoneX = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0.0
    }
    return isPhoneX
}()
/// 屏幕状态栏高度
public var kStatusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
}
/// 屏幕导航栏高度(含状态栏)
public var kNavigationBarHeight: CGFloat {
    return kStatusBarHeight + 44
}
/// 屏幕底部安全区高度
public let kSafeBottomHeight = kIsBangScreen ? 34 : 0
/// 悬浮框左右边距
public let kScreenMargin = kIsBangScreen ? 15 : 0
/// 是否是反向布局
public let kIsReverseLayout = UIApplication.shared.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.rightToLeft

//MARK: - 屏幕缩放比
public let kScreenScaleValue = kScreenWidth / 375.0
public let kScreenHeightScaleValue = kScreenHeigth / 667.0
