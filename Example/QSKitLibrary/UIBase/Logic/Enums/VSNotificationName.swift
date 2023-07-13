//
//  VSNotificationName.swift
//  QuasiDemo
//
//  Created by Soul on 2023/5/18.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//
//  全局“通知名称”常量

import Foundation

/// 全局货币单位变更时通知
/// - NOTE: 如刷新电商首页展示
public let kNoticeNameCountryChanged = Notification.Name(rawValue: "quasi.notification.name.locale.country")

/// 全局货币单位变更时通知
/// - NOTE: 如刷新电商首页展示
public let kNoticeNameCurrencyChanged = Notification.Name(rawValue: "quasi.notification.name.locale.currency")

/// 全局温度单位变更通知
/// - NOTE： 如在IoT首页刷新dashboard中的展示
public let kNoticeNameTempertureUnitUpdated = Notification.Name(rawValue: "quasi.notification.name.unit.temperture")
