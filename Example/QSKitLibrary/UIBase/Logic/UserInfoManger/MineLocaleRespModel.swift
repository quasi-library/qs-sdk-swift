//
//  MineLocaleRespModel.swift
//  QuasiDemo
//
//  Created by Soul on 2023/4/12.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation

/// 支持的本地化选项列表
struct MineLocaleRespModel: Codable {
    var countryList: [LocaleCountryModel]?
    var currencyList: [LocaleCurrencyModel]?
    var languageList: [LocaleLanguageModel]?
}

// swiftlint:disable type_name
/// 本地化国家选项
struct LocaleCountryModel: Codable, UserDefaultable {
    /// e.g. "US"
    var countryCode: String?
    /// e.g. "3859"
    var countryId: Int? = 0
    /// e.g. "United States"
    var countryName: String?
    /// e.g. "+86"
    var internationalAreaCode: String?

    typealias E = LocaleCountryModel
    static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
        // 将自定义对象归档成Data缓存本地
        if let newModel = value {
            let encoder = JSONEncoder()
            let jsonData = try? encoder.encode(newModel)
            UserDefaults.standard.set(jsonData, forKey: defaultName.rawValue)
        } else {
            UserDefaults.standard.set(nil, forKey: defaultName.rawValue)
        }
    }

    static func readFromCache(forKey defaultName: VSCache.Keys) -> E? {
        // 将本地缓存Data解档成自定义对象返回
        if let jsonData = UserDefaults.standard.data(forKey: defaultName.rawValue) {
            let decoder = JSONDecoder()
            let model = try? decoder.decode(LocaleCountryModel.self, from: jsonData)
            return model
        }
        return nil
    }
}

/// 本地化货币选项
struct LocaleCurrencyModel: Codable, UserDefaultable {
    /// e.g. "USD"
    var currency: String?
//    var currencyIcon: String?
    /// e.g. "1"
    var currencyId: Int? = 0
//    var currencyLocalSymbol: String?
    /// e.g. "US$"
    var currencySymbol: String?

    typealias E = LocaleCurrencyModel
    static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
        // 将自定义对象归档成Data缓存本地
        if let newModel = value {
            let encoder = JSONEncoder()
            let jsonData = try? encoder.encode(newModel)
            UserDefaults.standard.set(jsonData, forKey: defaultName.rawValue)
        } else {
            UserDefaults.standard.set(nil, forKey: defaultName.rawValue)
        }
    }

    static func readFromCache(forKey defaultName: VSCache.Keys) -> E? {
        // 将本地缓存Data解档成自定义对象返回
        if let jsonData = UserDefaults.standard.data(forKey: defaultName.rawValue) {
            let decoder = JSONDecoder()
            let model = try? decoder.decode(LocaleCurrencyModel.self, from: jsonData)
            return model
        }
        return nil
    }
}

/// 本地化语言选项
struct LocaleLanguageModel: Codable, UserDefaultable {
    /// e.g "en"
    var code: String?
    /// e.g "1"
    var languageId: Int? = 0
    /// e.g "English"
    var name: String?

    typealias E = LocaleLanguageModel
    static func writeToCache(_ value: E?, forKey defaultName: VSCache.Keys) {
        // 将自定义对象归档成Data缓存本地
        if let newModel = value {
            let encoder = JSONEncoder()
            let jsonData = try? encoder.encode(newModel)
            UserDefaults.standard.set(jsonData, forKey: defaultName.rawValue)
        } else {
            UserDefaults.standard.set(nil, forKey: defaultName.rawValue)
        }
    }

    static func readFromCache(forKey defaultName: VSCache.Keys) -> E? {
        // 将本地缓存Data解档成自定义对象返回
        if let jsonData = UserDefaults.standard.data(forKey: defaultName.rawValue) {
            let decoder = JSONDecoder()
            let model = try? decoder.decode(LocaleLanguageModel.self, from: jsonData)
            return model
        }
        return nil
    }
}

// swiftlint:enable type_name
