//
//  VSDeviceModelType.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/16.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation

/// 映射同一个“设备型号”在不同场景不同的叫法
enum VSDeviceModelType: String {
    case Unknown,
         E42 = "VSCTL001",
         E25 = "VSCTL002",
         E42A = "VSCTLE42A",
         BT001 = "VSBT001"

    /// 当前设备是否属于控制设备（如E42 / E25等），用于启动影子文档相关逻辑
    var isSGSHub: Bool {
        switch self {
        case .E42, .E42A, .E25:
            return true
        default:
            return false
        }
    }

    /// 在服务端数据库对应的产品代码
    var serverModelName: String {
        switch self {
        case .Unknown:
            return "Unknown"
        case .E42:
            return "VSCTL001"
        case .E42A:
            return "VSCTLE42A"
        case .E25:
            return "VSCTL002"
        case .BT001:
            return "VSBT001"
        }
    }

    /// 在扫描蓝牙时不同设备的名称前缀
    var hardwareBleName: String {
        switch self {
        case .Unknown:
            return "Unknown"
        case .E42:
            return "VSCTL001"
        case .E42A:
            return "VSCTLE42A"
        case .E25:
            return "VSCTL002"
        case .BT001:
            return "ThermoBeacon"
        }
    }

    /// 在扫描蓝牙阶段不同设备标识的图片
    var hardwareBleImage: String {
        switch self {
        case .Unknown:
            return ""
        case .E42, .E42A:
            return "iot_default_e42"
        case .E25:
            return "iot_default_e25"
        case .BT001:
            return ""
        }
    }

    /// 在客户端展示时外露的代号名称
    var clientDeviceName: String {
        switch self {
        case .Unknown:
            return "Unknown"
        case .E42, .E42A:
            return "E42"
        case .E25:
            return "E25"
        case .BT001:
            return "Smart Thermometer"
        }
    }
}
