//
//  VSTemperatureUnit.swift
//  QuasiDemo
//
//  Created by Soul on 2022/12/7.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation

/// 设备展示的温湿度单位，以及默认警戒线数值
enum VSTemperatureUnit: Int {
    case celsius = 0,
         fahrenheit = 1

    var unit: String {
        switch self {
        case .fahrenheit:
            return "°F"
        case .celsius:
            return "°C"
        }
    }
}
