//
//  VSMineEmptyType.swift
//  QuasiDemo
//
//  Created by Soul on 2023/3/29.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation
import QSKitLibrary
import UIKit

/// 枚举列表空页面的图片和描述
public enum VSMineEmptyType {
    case common,
         address,
         cart,
         coupon,
         device,
         iotLogin,  // IoT首页提示登录
         log,
         network,   // 没网时的提示
         order,
         plantList,
         recipeList,
         sensor     // 蓝牙温湿度计

    var image: UIImage? {
        return UIImage(named: self.imageName)
    }

    var imageName: String {
        switch self {
        case .coupon:
            return "empty_icon_coupon"
        case .address:
            return "empty_icon_address"
        case .cart:
            return "empty_icon_cart"
        case .device:
            return "empty_icon_device"
        case .iotLogin:
            return "empty_icon_login"
        case .log:
            return "empty_icon_log"
        case .network:
            return "empty_icon_network"
        case .order:
            return "empty_icon_order"
        case .plantList:
            return "empty_icon_plant"
        case .recipeList:
            return "empty_icon_recipe"
        case .sensor:
            return "empty_icon_sensor"
        default:
            return "empty_icon_order"
        }
    }

    var desc: String {
        switch self {
        case.address:
            return "Your address is empty"
        case .cart:
            return "Your cart is empty"
        case .device:
            return "No device added"
        case .iotLogin:
            return "Sign in to view my garden"
        case .log:
            return "No log yet!"
        case .network:
            return "Please connect to a network"
        case .plantList:
            return "No plant"
        case .recipeList:
            return "No recipe, please create your recipe"
        default:
            return "It is empty here :-( "
        }
    }
}
