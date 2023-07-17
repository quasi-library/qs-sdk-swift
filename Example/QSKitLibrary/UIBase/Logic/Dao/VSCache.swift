//
//  VSCache.swift
//  QuasiDemo
//
//  Created by Soul on 2022/1/27.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//
//  项目中所有缓存的“键”，避免不同业务产生同名缓存造成覆盖

import Foundation

public enum VSCache {
    // 本地缓存沙盒目录
    static let cachedPath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""

    // 枚举项目中所有缓存的“键”，避免硬编码造成覆盖
    public enum Keys: String {
        // MARK: 配置信息（与用户无关）
        /// 用户标记唯一设备的令牌(同一个手机同一个)
        case kAccessToken = "kAccessToken"
        /// 全局配置信息； e.g. 三方登录按钮展示等
        case kConfigGlobal = "kConfigGlobal"
        /// 消息中心的资源图配置
        case kConfigMessageCenter = "kConfigMessageCenter"

        /// 映射IoT设备内部型号&产品封面图
        case kDeviceConfigList = "kDeviceConfigList"
        /// 缓存IoT相关资源图片 IotAssetModel， e.g. 植物阶段图片url
        case kConfigIoTImages = "kConfigIoTImages"
        /// 缓存上一次请求资源图片的时间(24h内只请求一次)
        case kLastIoTAssetsTime = "kLastIoTAssetsTime"

        // MARK: 上次操作记录（登出后需重置）
        /// 用户当前登录的用户名称
        case kLastUserName = "kLastUserName"
        /// 用户上次登录的邮箱地址
        case kLastLoginEmail = "kLastLoginEmail"
        /// 用户上次登录的google账号
        case kLastGoogleAccount = "kLastGoogleAccount"
        /// 用户登录的之后的令牌
        case kLastLoginToken = "kLastLoginToken"
        /// 用户续期登录的令牌
        case kLastRefreshToken = "kLastRefreshToken"
        /// 用户上次弹出App Store弹窗日期
        case kLastPopReviewDate = "kLastPopReviewDate"

        /// 缓存连接AWS MQTT时客户端身份标识(手机首次建联时请求，登出时清掉)
        case kUserAwsMqttCerId = "kUserAwsMqttCerId"
        /// 用户设定的本地化选项-国家
        case kUserLocaleCountry = "kUserLocaleCountry"
        /// 用户设定的本地化选项-货币
        case kUserLocaleCurrency = "kUserLocaleCurrency"
        /// 用户设定的本地化选项-语言
        case kUserLocaleLanguage = "kUserLocaleLanguage"

        /// 用户首页优先展示的garden
        case kUserDefaultSceneId = "kUserDefaultSceneId"
        /// 用户设置的温湿度单位: 0 是摄氏度，1是华氏度
        case kUserTempUnit = "kUserTempUnit"
        /// 用户设置的长度单位: 0 是英寸，1是厘米
        case kUserHeightUnit = "kUserHeightUnit"
        /// 用户设置的体积单位: 0 是摄加仑，1是升
        case kUserVolumeUnit = "kUserVolumeUnit"

        // MARK: 公共缓存(不同用户共享的缓存)
        /// 缓存搜索记录
        case kSearchHistory = "kSearchHistory"
        /// 缓存推荐的搜索推荐词
        case kSearchPlaceholder = "kSearchPlaceholder"
        // MARK: 其他缓存
        case isShowDebugLogView = "isShowDebugLogView"
        /// debug包切换域名
        case kDebugHostDomain = "kDomainNameSetUnderDebugEnvironment"
    }

    /// 格式化轻量级“清空”缓存至UserDefault
    static func clean(forKey defaultName: VSCache.Keys) {
        UserDefaults.standard.removeObject(forKey: defaultName.rawValue)
    }

    /// 格式化轻量级“写”缓存至UserDefault
    static func write<T: UserDefaultable>(_ value: T?, forKey defaultName: VSCache.Keys) {
        T.writeToCache(value as? T.E, forKey: defaultName)
    }

    /// 格式化轻量级“取”缓存从UserDefault(非基本类型就当Data转出)
    static func read<T: UserDefaultable>(_ key: VSCache.Keys, for classType: T.Type = String.self) -> T? {
        return T.readFromCache(forKey: key) as? T
    }
}

// swiftlint:disable type_name
/// 声明一个泛型，并添加UserDefault的扩展，方便读缓存时共用一个方法
/// 如果自定义类也想实现共用读写缓存的方法，支持此协议即可
public protocol UserDefaultable {
    associatedtype E

    /// 实现此类型实例“保存”至本地缓存的方法
    /// - NOTE  默认实现示例
    ///    public static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
    ///        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    ///    }
    static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys)

    /// 实现此类型实例“读取”本地缓存的方法
    /// - NOTE  默认实现示例
    ///    public static func readFromCache(forKey key: String) -> Bool? {
    ///       return UserDefaults.standard.value(forKey: key) as? E
    ///    }
    static func readFromCache(forKey defaultName: VSCache.Keys) -> E?
}

extension Bool: UserDefaultable {
    public typealias E = Bool

    public static func writeToCache(_ value: Bool?, forKey defaultName: VSCache.Keys) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
        UserDefaults.standard.synchronize()
    }

    public static func readFromCache(forKey key: VSCache.Keys) -> Bool? {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
}

extension Int: UserDefaultable {
    public typealias E = Int

    public static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
        UserDefaults.standard.synchronize()
    }

    public static func readFromCache(forKey key: VSCache.Keys) -> Int? {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
}

extension String: UserDefaultable {
    public typealias E = String

    public static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
        UserDefaults.standard.synchronize()
    }

    public static func readFromCache(forKey key: VSCache.Keys) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
}

extension Double: UserDefaultable {
    public typealias E = Double

    public static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
        UserDefaults.standard.synchronize()
    }

    public static func readFromCache(forKey key: VSCache.Keys) -> Double? {
        return UserDefaults.standard.double(forKey: key.rawValue)
    }
}

extension Data: UserDefaultable {
    public typealias E = Data

    public static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }

    public static func readFromCache(forKey key: VSCache.Keys) -> Data? {
        return UserDefaults.standard.data(forKey: key.rawValue)
    }
}

extension Array: UserDefaultable {
    public typealias E = Array

    public static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }

    public static func readFromCache(forKey key: VSCache.Keys) -> Array? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? E
    }
}

extension Date: UserDefaultable {
    public typealias E = Date

    public static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }

    public static func readFromCache(forKey key: VSCache.Keys) -> Date? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? E
    }
}

extension Dictionary: UserDefaultable {
    public typealias E = [String: Any]
    public static func writeToCache(
        _ value: [String: Any]?,
        forKey defaultName: VSCache.Keys
    ) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }

    public static func readFromCache(
        forKey defaultName: VSCache.Keys
    ) -> [String: Any]? {
        return UserDefaults.standard.dictionary(forKey: defaultName.rawValue)
    }
}

// swiftlint:enable type_name
