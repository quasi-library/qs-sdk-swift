//
//  VSHeightUnit.swift
//  QuasiDemo
//
//  Created by Soul on 2022/12/7.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation

/// 展示用的长度单位(默认是英寸)
enum VSHeightUnit: Int {
    case inch = 0,      // 英寸
         centimeter = 1 // 厘米

    var unit: String {
        switch self {
        case .inch:
            return "inch"
        case .centimeter:
            return "cm"
        }
    }
}
