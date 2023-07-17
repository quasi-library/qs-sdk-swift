//
//  VSVolumeUnit.swift
//  QuasiDemo
//
//  Created by Soul on 2022/12/7.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation

/// 展示用的体积单位（默认是加仑）
enum VSVolumeUnit: Int {
    case gallon = 0,    // 加仑
         litre = 1      // 升

    var unit: String {
        switch self {
        case .gallon:
            return "gal"
        case .litre:
            return "L"
        }
    }

    var showUnit: String {
        switch self {
        case .gallon:
            return "gallon"
        case .litre:
            return "L"
        }
    }
}
