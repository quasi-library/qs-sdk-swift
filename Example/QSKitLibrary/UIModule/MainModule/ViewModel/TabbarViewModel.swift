//
//  TabbarViewModel.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/26.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import UIKit
import RxSwift
import QSKitLibrary

/// 根控制器的数据
class TabbarViewModel: QSBaseViewModel {
    // MARK: - Callback Method
    /// 回调当前未读消息数量
    let respUnreadMessageCountSubject = PublishSubject<Int>()

    // MARK: - Request Method
    /// 应用启动时请求初始化接口并更新User单例
    func requestInitInfo() {
    }

    /// 应用启动时请求服务端全局配置
    func requestGlobalConfig() {
    }

    /// 应用启动时获取消息中心相关资源图配置
    func requestMessageConfig() {
    }

    /// 请求换新的LoginToken续期
    func requestRefreshLoginToken() {
    }

    /// 请求未读取消息列表数量
    func requestMessageUnreadCount() {
    }
}
