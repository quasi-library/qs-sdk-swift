//
//  VSAppstoreReviewAlert.swift
//  QuasiDemo
//
//  Created by Soul on 2023/4/13.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit
import StoreKit

/// 调用Appstore评论页面
enum VSAppstoreReviewAlert {
    /// 展示评分页面
    static func show(appstoreId: String = "12345678") {

#if DEBUG
        let limitDays = 0.0
#else
        let limitDays = 15.0
#endif
        if let lastPopDate = VSCache.read(.kLastPopReviewDate, for: Date.self),
           lastPopDate.timeIntervalSinceNow > -limitDays * 24 * 3600 {
            debugPrint(VSAppstoreReviewAlert.self, "限制\(limitDays)天内只弹出一次")
            return
        }

        /**
         如果弹窗中的提交按钮(SUBMIT)不能被点击，有以下几种可能的原因和解决方案：

         1.未满足调用SKStoreReviewController.requestReview()的条件：调用该方法的次数是有限制的，一般情况下一个应用程序的一个版本只会调用3次。因此，如果在应用程序中多次调用此方法，可能会导致应用程序打开App Store时没有机会显示评分弹窗。

         2.未在应用程序的发布版本中调用此方法：调用SKStoreReviewController.requestReview()方法只能在发布到App Store的应用程序中使用。如果在测试应用程序中使用此方法，则不会显示弹出窗口，而且不会出现错误消息。请确保您已将应用程序提交到App Store并且已发布它的版本，然后再次测试此方法。

         3.未登录App Store账户或未完成评分弹窗中的评分操作：评分弹窗的提交按钮(SUBMIT)只有在用户登录App Store账户并完成评分操作之后才会变成可用状态，如果用户未登录App Store账户或未完成评分操作，则此按钮将保持不可用状态。

         如果以上解决方案都不能解决问题，请检查您的代码是否有其他错误或问题，并且您的设备或模拟器是否连接到正确的App Store账户。
         */

        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            // 记录弹出评论弹窗事件
        } else {
            // 如果设备系统版本低于 iOS 10.3，则只能打开 App Store 首页
            if let reviewURL = URL(string: "https://itunes.apple.com/app/id\(appstoreId)?action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
                UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
            }
        }

        VSCache.write(Date(), forKey: .kLastPopReviewDate)
    }
}
