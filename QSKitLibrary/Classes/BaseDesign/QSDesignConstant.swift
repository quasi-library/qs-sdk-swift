//
//  QSDesignConstant.swift
//  QSKitLibrary
//
//  Created by Soul on 2023/7/13.
//

import Foundation
import UIKit

public let kScreenWidth = UIScreen.main.bounds.width
public let kScreenHeight = UIScreen.main.bounds.height
public let kScreenScale = UIScreen.main.scale
public let kScreenPixel = kScreenWidth * kScreenScale
public let kNavigationBarHeight = 44.0

public var kStatusBarHeight: Double = {
    if #available(iOS 13.0, *),
        let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
        return floor(statusBarManager.statusBarFrame.size.height)
    } else {
        return floor(UIApplication.shared.statusBarFrame.size.height)
    }
}()
