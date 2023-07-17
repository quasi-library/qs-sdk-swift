//
//  VSMobileInfo.swift
//  QuasiDemo
//
//  Created by Soul on 2023/3/6.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation
import AdSupport
import SwiftKeychainWrapper

enum VSMobileInfo {
    static func uuidString() -> String {
        let  bundleIdString = Bundle.main.bundleIdentifier ?? ""
        var deviceId = KeychainWrapper.standard.string(forKey: bundleIdString.appending(".uuid.key")) ?? ""

        if deviceId.isBlank == false {
            return deviceId
        } else {
            let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString
            deviceId = identifierForVendor?.replacingOccurrences(of: "-", with: "") ?? ""
            let isSaved: Bool = KeychainWrapper.standard.set(deviceId, forKey: bundleIdString.appending(".uuid.key"))
            debugPrint("\(isSaved)")
        }

        return deviceId
    }

    /// IDFV（Identifier for Vendor）
    /// - NOTE: IDFA是由苹果提供的广告跟踪标识符，用户可以在设置中关闭该功能，因此需要在使用时进行检查和获取用户的授权。
    static func getDeviceIDFA() -> String? {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return nil
    }

    /// IDFA（Identifier for Advertising）
    /// - NOTE: IDFV是一个UUID字符串，仅适用于相同开发者的应用程序之间，如果用户卸载了所有这些应用程序，再重新安装时，该值会更改
    static func getDeviceIDFV() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }

    /// 获取手机别名 e.g. "xx 's iPhone"
    static func mobileName() -> String {
        let name = UIDevice.current.name
        return name
    }

    /// 获取手机内部型号
    static func mobileModelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPhone1,1": return "iPhone 2G"
        case "iPhone1,2": return "iPhone 3G"
        case "iPhone2,1": return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4S"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE (1st generation)"
        case "iPhone9,1", "iPhone9,3": return "iPhone 7"
        case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone11,2": return "iPhone Xs"
        case "iPhone11,4", "iPhone11,6": return "iPhone Xs Max"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone12,8": return "iPhone SE (2nd generation)"
        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone14,6": return "iPhone SE 3"
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"
        default: return identifier
        }
    }

    /// 获取手机系统版本 e.g. "iOS 14.5"
    static func mobileSystemName() -> String {
        let device = UIDevice.current
        let systemName = device.systemName
        let systemVersion = device.systemVersion
        return systemName + " " + systemVersion
    }

    /// 获取当前app应用版本号
    static var bundleVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0.0"
    }
}
