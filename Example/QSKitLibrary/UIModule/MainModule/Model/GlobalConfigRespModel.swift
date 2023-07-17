//
//  GlobalConfigRespModel.swift
//  QuasiDemo
//
//  Created by Soul on 2023/3/20.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation

/// 首次启动app时请求的初始化接口，用于全局配置开关等
struct GlobalConfigRespModel: Codable {
    var apiVersion: String?
    var config: GlobalConfigModel?
}

/// 全局配置开关等
struct GlobalConfigModel: Codable {
    var commonImageWidth: Int? = 750
    /// 默认不显示FaceBook登录
    var isIosShowFBLogin: Int? = 0
    /// 默认不展示消息中心
    var isShowMessageEntry: Int? = 0
    /// 配网帮助页面链接
    var pairHelpLink: String?
}
