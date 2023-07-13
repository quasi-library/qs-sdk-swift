//
//  QSBaseViewModel.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/13.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import UIKit
import RxSwift

/**
 用于所有页面数据源基类，统一提供基础的rx信号
 */
open class QSBaseViewModel {
    // MARK: - Property
    let mBag = DisposeBag()

    // MARK: - Callback Signal
    /// 通用的报错信息，一般用于界面接受后展示toast
    public let errorDataSubject = PublishSubject<String?>()

    // MARK: - LifeCycle Method
    deinit {
        debugPrint("🦁️ \(self)", #function)
    }

    public init() {
        debugPrint("🦁️ \(self)", #function)
    }
}
