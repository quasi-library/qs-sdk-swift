//
//  VSLogZipRecord.swift
//  QuasiDemo
//
//  Created by Soul on 2023/2/16.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation
import RealmSwift

/// 记录在Realm中已获取的设备在S3上压缩的日志路径及解压状态
class VSLogZipRecord: Object {
    /// 设置联合主键(deviceId+month)
    @Persisted(primaryKey: true) var unionPrimaryKey: String = ""
    /// 当前设备Id，用于筛选
    @Persisted var deviceId = ""
    /// 单条zip数据标识，"yyyy-MM"
    @Persisted var month: String
    /// 服务端返回的已经压缩好的地址
    @Persisted var zipPath: String?
    /// 是否已经解压过并保存在本地(避免重复请求和IO)
    @Persisted var isUnziped = false
}
