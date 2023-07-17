//
//  VSRealm.swift
//  QuasiDemo
//
//  Created by Soul on 2023/2/15.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation
import RealmSwift

enum VSRealm {
    // MARK: - Config Method
#if DEBUG
    private static let realmName = "localDB.realm"
#else
    private static let realmName = "defaultDB.realm"
#endif

    /// 初始化并打开本地数据库
    static func initDefaultConfig() {
        guard let documentsURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return
        }

        let dbPath = documentsURL.appendingPathComponent(realmName)
        print(self, "🛖 创建并打开本地数据库 dbPath", dbPath)
        let config = Realm.Configuration(
            fileURL: dbPath,
            schemaVersion: 2
        ) { migration, oldSchemaVersion in
            if oldSchemaVersion < 2 {
                // 迁移版本 兼容本地数据库1->2
                migration.enumerateObjects(ofType: VSTempHumiRecord.className()) { oldObject, newObject in
                    newObject?.inTemp = oldObject?.inTemp
                    newObject?.outTemp = oldObject?.outTemp
                    newObject?.inHumi = oldObject?.inHumi
                    newObject?.outHumi = oldObject?.outHumi
                    if oldObject?.isSynced == nil {
                        newObject?.isSynced = false
                    }
                }
            }
        }
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { result in
            switch result {
            case .success(let realm):
                print(self, "🛖 启动本地数据库成功", realm)
            case .failure(let error):
                print(self, "❌ 启动本地数据库失败", error)
            }
        }
    }

    static let realmQueue = DispatchQueue(label: "com.quasi.realm", qos: .utility, attributes: [.concurrent])

    // MARK: - Device Log Method
    /// 将从服务器请求回来的温湿度数据保存至本地数据库中
//    static func writeDeviceLog(
//        deviceId: String,
//        list: [DeviceDataLogModel],
//        fromServer: Bool = true,
//        resultBlock: ((Bool) -> Void)?
//    ) {
//        let recordList: [VSTempHumiRecord] = list.map { dataLog in
//            let recordModel = VSTempHumiRecord()
//            recordModel.deviceId = deviceId
//            recordModel.time = dataLog.time
//
//            recordModel.inHumi = dataLog.inHumi
//            recordModel.inTemp = dataLog.inTemp
//            recordModel.outHumi = dataLog.outHumi
//            recordModel.outTemp = dataLog.outTemp
//
//            recordModel.lightlv = dataLog.lightLv
//            recordModel.cFanlv = dataLog.cFanLv
//            recordModel.dFanlv = dataLog.dFanLv
//
//            recordModel.unionPrimaryKey = String(format: "%@-%d", deviceId, dataLog.time)
//            recordModel.isSynced = fromServer
//
//            let timeInterval = TimeInterval(dataLog.time)
//            recordModel.showDate = Date(timeIntervalSince1970: timeInterval)
//
//            return recordModel
//        }
//
//        realmQueue.async {
//            do {
//                let realm = try Realm()
//                debugPrint(self, "🛖 准备写入温湿度Log数据...", realm.configuration.fileURL ?? "")
//                try realm.write {
//                    realm.add(recordList, update: .modified)
//                }
//                // 调用refresh()方法来确保写入完成
//                realm.refresh()
//                debugPrint(self, "🛖 写入温湿度Log数据完成", recordList.count)
//                resultBlock?(true)
//            } catch let error {
//                debugPrint(self, "🛖 写入温湿度Log数据报错", error)
//                resultBlock?(false)
//            }
//        }
//    }

    /// 读取本地数据库中最后一条已经从服务端同步的数据（提取时间戳确定后续请求返回）
    static func readLatestSyncedLog(deviceId: String) -> VSTempHumiRecord? {
        do {
            let realm = try Realm()
            debugPrint(self, "🛖 准备查找已同步的最后一条温湿度Log数据...", realm.configuration.fileURL ?? "")
            let results = realm.objects(VSTempHumiRecord.self).filter("deviceId == '\(deviceId)' AND isSynced == true")
            if let maxTimeObject = results.max(by: { $0.time < $1.time }) {
                // maxTimeObject 即为 time 最大的对象
                return maxTimeObject
            } else {
                debugPrint(self, "🛖 读取已同步的最新一条温湿度Log数据时数组为空")
                return nil
            }
        } catch let error {
            debugPrint(self, "🛖 读取已同步的最新一条温湿度Log数据报错", error)
            return nil
        }
    }

    /// 将请求到的历史日志压缩包记录在本地数据库中，并更新解压状态
    static func writeLogZipData(
        deviceId: String,
        month: String,
        path: String,
        afterUnzip: Bool,
        resultBlock: ((Bool) -> Void)?
    ) {
        let task = VSLogZipRecord()
        task.deviceId = deviceId
        task.month = month
        task.zipPath = path
        task.isUnziped = afterUnzip
        task.unionPrimaryKey = deviceId + "-" + month

        realmQueue.async {
            do {
                let realm = try Realm()
                debugPrint(self, "🛖 准备写入温湿度S3数据...", realm.configuration.fileURL ?? "")
                try realm.write {
                    realm.add(task, update: .modified)
                }
                // 调用refresh()方法来确保写入完成
                realm.refresh()
                debugPrint(self, "🛖 写入温湿度S3数据完成", task.unionPrimaryKey)
                resultBlock?(true)
            } catch let error {
                debugPrint(self, "🛖 写入温湿度S3数据报错", error)
                resultBlock?(false)
            }
        }
    }

    /// 读取本地数据库中关于历史日志数据的S3地址及解压状态
    static func readLogZipData(deviceId: String, month: String) -> VSLogZipRecord? {
        do {
            let realm = try Realm()
            debugPrint(self, "🛖 准备查询已保存S3Zip地址的数据...", realm.configuration.fileURL ?? "")
            let results = realm.objects(VSLogZipRecord.self).filter("deviceId == '\(deviceId)' AND month == '\(month)'")
            if let existZip = results.first {
                debugPrint(self, "🛖 读取已保存S3Zip地址时找到了", existZip)
                return existZip
            } else {
                debugPrint(self, "🛖 读取已保存S3Zip地址时为空")
                return nil
            }
        } catch let error {
            debugPrint(self, "🛖 读取已保存S3Zip地址时报错", error)
            return nil
        }
    }

    /// 读取本地数据库中关于历史日志数据的S3地址及解压状态
    static func updateLogZipData(zipPath: String, isUnziped: Bool) -> Bool {
        do {
            let realm = try Realm()
            debugPrint(self, "🛖 准备更新已保存S3Zip地址的状态...")
            let results = realm.objects(VSLogZipRecord.self).filter("zipPath == '\(zipPath)'")
            if let existZip = results.first {
                debugPrint(self, "🛖 更新已保存S3Zip地址时找到了", existZip)
                try realm.write {
                    existZip.isUnziped = true
                }
                debugPrint(self, "🛖 更新已保存S3Zip地址时未找到", zipPath)
                return true
            } else {
                return false
            }
        } catch let error {
            debugPrint(self, "🛖 更新已保存S3Zip地址时报错", error)
            return false
        }
    }
}
