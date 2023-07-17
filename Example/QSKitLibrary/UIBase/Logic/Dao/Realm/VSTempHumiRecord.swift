//
//  VSTempHumiRecord.swift
//  QuasiDemo
//
//  Created by Soul on 2023/2/15.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation
import RealmSwift

/// 记录在Realm中单条温湿度记录
public class VSTempHumiRecord: Object {
    /// 设置联合主键
    @Persisted(primaryKey: true) var unionPrimaryKey: String = ""
    /// 方便在数据库中查看
    @Persisted var showDate: Date?
    @Persisted var cFanlv: Int?
    @Persisted var dFanlv: Int?
    @Persisted var lightlv: Int?
    /// 从云端拉取的外部湿度历史记录,为百分数x100之后的值
    @Persisted var outHumi: Int? = 0
    /// 从云端拉取的外部温度历史记录,为摄氏度x100之后的值
    @Persisted var outTemp: Int? = 0
    /// 从云端拉取的内部湿度历史记录,为百分数x100之后的值
    @Persisted var inHumi: Int? = 0
    /// 从云端拉取的内部温度历史记录,为摄氏度x100之后的值
    @Persisted var inTemp: Int? = 0
    /// 时间戳
    @Persisted var time = 0
    /// 当前设备Id，用于筛选
    @Persisted var deviceId = ""
    /// 是否已经同步过(来自云端)，用于筛选比对待上传的数据
    /// - NOTE: 当蓝牙温湿度从本地取日志直接用于展示时此字段保持false
    @Persisted var isSynced = false
}
