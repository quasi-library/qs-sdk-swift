//
//  VSFile.swift
//  QuasiDemo
//
//  Created by Soul on 2023/2/10.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation

/// 封装文件管理器，提供读写沙盒方法
enum VSFile {
    /// 创建文件夹
    /// - Parameters :folderPath 文件夹目录, e.g "/localData/2023-01"
    static func createFolder(folderName: String) -> URL? {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }

        let path = documentPath.appending(folderName)
        if FileManager.default.fileExists(atPath: path) {
            // 已存在
            return URL(string: path)
        } else {
            // 创建文件夹
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                return URL(string: path)
            } catch let e {
                print("❌❌ 创建文件夹失败", e)
            }
        }

        return nil
    }

    /// 将字符串写入txt文件中
    /// - NOTE: 若文件已存在，则换行追加
    static func writeText(folderPath: URL, fileName: String, text: String) {
        let wholePath = folderPath.appendingPathComponent(fileName).appendingPathExtension("txt")
        debugPrint(self, "写入文件 fileURL", wholePath)
        do {
            if FileManager.default.fileExists(atPath: wholePath.path) {
                // 追加记录
                if let fileHandle = FileHandle(forUpdatingAtPath: wholePath.path),
                   let textData = ("\n" + text).data(using: .utf8) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write( textData)
                    fileHandle.closeFile()
                }
            } else {
                // 新写记录
                try text.write(toFile: wholePath.path, atomically: false, encoding: .utf8)
            }
        } catch let e {
            print("❌❌ 写入文件失败", e)
        }
    }

    /// 创建指定文件
    static func createFile(_ fileURL: URL) {
        let fileManager = FileManager.default
        let content = "This is the content of the file."
        if fileManager.fileExists(atPath: fileURL.path) {
            print(self, "文件已存在，无需重复创建")
            return
        } else {
            let res = fileManager.createFile(atPath: fileURL.path, contents: content.data(using: .utf8))
            print(self, "新文件创建结果", fileURL, res)
        }
    }

    /// 删除指定文件
    static func deleteFile(_ fileURL: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: fileURL)
            print(self, "The file has been deleted.")
        } catch {
            print(self, "Failed to delete the file: \(error.localizedDescription)")
        }
    }
}
