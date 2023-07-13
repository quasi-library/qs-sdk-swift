//
//  VSUserInfoManager.swift
//  QuasiDemo
//
//  Created by Geminy on 2021/11/4.
//

import UIKit

/// 当登录成功后广播出去，业务层其余模块自行处理更新
let kLoginStatusNotification = Notification.Name("kLoginStatusNotification")

/// 全局关于用户信息和配置的单例，业务层随时可以取值
/// - Note: 由接口负责更新，管理缓存的事交给内部处理
class VSUserInfoManager: NSObject {
    // MARK: - Property
    // MARK: User
    /// 用私有属性减少缓存读写
    private var _accessToken: String? = VSCache.read(.kAccessToken, for: String.self)
    /// 记录用户当前唯一设备的AccessToken（只读），请求接口时必须
    var accessToken: String {
        get {
            return self._accessToken ?? ""
        }
        set {
            VSCache.write(newValue, forKey: .kAccessToken)
            _accessToken = newValue
        }
    }

    /// 用私有属性减少缓存读写
    private var _loginToken: String? = VSCache.read(.kLastLoginToken, for: String.self)
    /// 记录当前用户登录Session的LoginToken（只读），判断登录状态时必须
    var loginToken: String {
        get {
            return self._loginToken ?? ""
        }
        set {
            VSCache.write(newValue, forKey: .kLastLoginToken)
            _loginToken = newValue
        }
    }

    /// 判断当前登录状态(计算属性)
    var isLogin: Bool {
        if self.loginToken.isBlank == false && self.accessToken.isBlank == false {
            return true
        } else {
            return false
        }
    }

    /// 用户昵称，用于个人中心展示
    var userName = VSCache.read(.kLastUserName, for: String.self) {
        didSet {
            print(self, "username changed from", oldValue ?? "", "to", userName ?? "")
            if let userName = userName {
                VSCache.write(userName, forKey: .kLastUserName)
            }
        }
    }

    /// 用户邮箱，用于个人中心设置页展示
    var userEmail: String? = ""

    /// 购物车角标数量，用于页面展示
    var cartNum = 0

    /// IOT用户的唯一标识(暂未启用)
    var iotUserId: Int?

    /// 用户通过Firebase推送依赖的Token
    var fcmToken: String?

    // MARK: Setting
    /// 用私有属性减少缓存读写
    private var _country: LocaleCountryModel? = VSCache.read(.kUserLocaleCountry, for: LocaleCountryModel.self)
    /// 当前选中的语言
    var country: LocaleCountryModel {
        get {
            // 本地无缓存时默认en
            let defaultCountry = LocaleCountryModel(
                countryCode: "US",
                countryId: 3859,
                countryName: "United States",
                internationalAreaCode: "+1"
            )
            return self._country ?? defaultCountry
        }
        set {
            VSCache.write(newValue, forKey: .kUserLocaleCountry)
            _country = newValue
            NotificationCenter.default.post(name: kNoticeNameCountryChanged, object: newValue)
        }
    }

    /// 用私有属性减少缓存读写
    private var _currency: LocaleCurrencyModel? = VSCache.read(.kUserLocaleCurrency, for: LocaleCurrencyModel.self)
    /// 当前选中的语言
    var currency: LocaleCurrencyModel {
        get {
            // 本地无缓存时默认en
            return self._currency ?? LocaleCurrencyModel(currency: "USD", currencyId: 1, currencySymbol: "US$")
        }
        set {
            VSCache.write(newValue, forKey: .kUserLocaleCurrency)
            _currency = newValue
            NotificationCenter.default.post(name: kNoticeNameCurrencyChanged, object: newValue)
        }
    }

    /// 用私有属性减少缓存读写
    private var _language: LocaleLanguageModel? = VSCache.read(.kUserLocaleLanguage, for: LocaleLanguageModel.self)
    /// 当前选中的语言
    var language: LocaleLanguageModel {
        get {
            // 本地无缓存时默认en
            return self._language ?? LocaleLanguageModel(code: "en", languageId: 1, name: "English")
        }
        set {
            VSCache.write(newValue, forKey: .kUserLocaleLanguage)
            _language = newValue
        }
    }

    /// 用户设置的温度单位: 0是摄氏度 1是华氏度
    var tempUnit = VSTemperatureUnit(rawValue: VSCache.read(.kUserTempUnit, for: Int.self) ?? 0) ?? .celsius {
        didSet {
            print(self, "tempUnit changed from", oldValue, "to", tempUnit)
            VSCache.write(tempUnit.rawValue, forKey: .kUserTempUnit)
            // 通知全局刷新
            NotificationCenter.default.post(name: kNoticeNameTempertureUnitUpdated, object: tempUnit)
        }
    }

    /// 用户设置的长度单位
    var heightUnit = VSHeightUnit(rawValue: VSCache.read(.kUserHeightUnit, for: Int.self) ?? 0) ?? .inch {
        didSet {
            print(self, "heightUnit changed from", oldValue, "to", heightUnit)
            VSCache.write(heightUnit.rawValue, forKey: .kUserHeightUnit)
        }
    }

    /// 用户设置的体积单位
    var volumeUnit = VSVolumeUnit(rawValue: VSCache.read(.kUserVolumeUnit, for: Int.self) ?? 0) ?? .gallon {
        didSet {
            print(self, "volumeUnit changed from", oldValue, "to", volumeUnit)
            VSCache.write(volumeUnit.rawValue, forKey: .kUserVolumeUnit)
        }
    }

    // MARK: Switch
    /// 服务端配置的全局开关
    var globalSwitch: GlobalConfigRespModel? {
        get {
            // 将本地缓存转化成配置返回
            if let jsonData = VSCache.read(.kConfigGlobal, for: Data.self) {
                let decoder = JSONDecoder()
                let model = try? decoder.decode(GlobalConfigRespModel.self, from: jsonData)
                return model
            }
            return nil
        }
        set {
            // 将接口数据缓存至本地
            if let newModel = newValue {
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(newModel)
                VSCache.write(jsonData, forKey: .kConfigGlobal)
            }
        }
    }

    // MARK: - Shared Instance
    static let shared = VSUserInfoManager()
    override func copy() -> Any { self }
    override func mutableCopy() -> Any { self }

    // MARK: - Public Method
    /// 登录注册成功之后更新单例缓存至本地，并广播至业务层
    func loginSuccess(
        email: String,
        userName: String?,
        refreshToken: String?,
        loginToken: String?,
        accessToken: String?
    ) {
        // 缓存
        self.userEmail = email
        VSCache.write(email, forKey: .kLastLoginEmail)
        if let refreshToken, refreshToken.isBlank == false {
            VSCache.write(refreshToken, forKey: .kLastRefreshToken)
        }
        if let accessToken = accessToken, accessToken.isBlank == false {
            self.accessToken = accessToken
        }
        if let loginToken = loginToken, loginToken.isBlank == false {
            self.loginToken = loginToken
        }

        self.userName = userName

        // 发送登录状态变化通知
        NotificationCenter.default.post(name: kLoginStatusNotification, object: nil)
    }

    /// 用户登出后清楚本地缓存，并广播至业务层
    func logOutSuccess() {
        // 清除用户信息缓存
        VSCache.clean(forKey: .kLastRefreshToken)
        VSCache.clean(forKey: .kLastLoginToken)
        VSCache.clean(forKey: .kLastUserName)
        VSCache.clean(forKey: .kUserDefaultSceneId)
        VSCache.clean(forKey: .kLastPopReviewDate)

        /// 清除aws相关缓存
        VSCache.clean(forKey: .kUserAwsMqttCerId)

        // 更新变量
        self.loginToken = ""
        self.userName = ""
        self.userEmail = ""

        // 发送登录状态变化通知
        NotificationCenter.default.post(name: kLoginStatusNotification, object: nil)
    }
}
