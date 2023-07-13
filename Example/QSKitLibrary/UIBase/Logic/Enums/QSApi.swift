//
//  QSApi.swift
//  QuasiDemo
//
//  Created by Soul on 2023/7/13.
//  Copyright © 2023 Quasi Team. All rights reserved.
//

import Foundation

public enum QSApi {
    /// 网站域名
    public enum Domain: String {
        case Test = "https://t.quasi.com"
        case PRelease = "https://pre.quasi.com"
        case Product = "https://www.quasi.com"
    }

    /// 服务器接口请求
    public enum Host: String {
        case ShopTest = "https://api-t.quasi.com"
        case ShopTestBackup = "https://api-t-2.quasi.com"
        case IotTest = "https://api-t-3.quasi.com"
        case IotTestBackup = "https://api-t-4.quasi.com"
        case PreRelease = "https://api-pre.next.quasi.com"
        case Product = "https://api-prod.next.quasi.com"
    }

    /// API 请求接口的枚举
    public enum Path: String {
        // MARK: - Init Config
        /// 获取初始化信息
        case FeatureInitInfo = "/init/info"
    }
}

/// 服务器根域名
var QS_API_HOST: String {
    get {
#if DEBUG
        if let cacheHost = VSCache.read(.kDebugHostDomain, for: String.self) {
            // 取手动设置的缓存host
            return cacheHost
        } else {
            // 默认t-3测试环境
            return QSApi.Host.IotTest.rawValue
        }
#else
        // 线上生产环境
        return QSApi.Host.Product.rawValue
#endif
    }
    set {
        // 缓存至本地,下次使用
        VSCache.write(newValue, forKey: .kDebugHostDomain)
    }
}
