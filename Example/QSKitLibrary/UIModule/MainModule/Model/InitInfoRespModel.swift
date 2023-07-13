//
//  InitInfoRespModel.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/26.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation

/// 首次启动app时请求的初始化接口，用于初始化accessToken等
struct InitInfoRespModel: Codable {
    var accessToken: String?
    var cartId: String?
    var cartNum: Int? = 0
    var couponNum: Int? = 0
//    var currentTime: String?
    var email: String?
    var isGuestUser: Int? = 0
    var isLogin: Int? = 0
    /// 当前登录Token的有效期，用于判断自动续期
    var loginTokenExpireData: String?
//    var payVerifyEmail: String?
//    var sha1Email: String?
    var track = false
    var userId: String?
    var userName: String?
    var userTags: [String]?

    /// (计算属性) 当前LoginToken的有效期转化为天
    var loginTokenLifespan: Int {
        guard let timeString = loginTokenExpireData,
              timeString.isEmpty == false else {
            return 777 // 旧接口无返回时直接认为不过期
        }

        if let timeInterval = Int.init((timeString), radix: 10) {
            let spanDays = timeInterval / 3600 / 24
            // 向下取整
            return spanDays
        } else {
            // 异常数据认为需要续期
            return 0
        }
    }
}
