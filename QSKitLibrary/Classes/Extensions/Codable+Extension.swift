//
//  Codable+Extension.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2021/11/4.
//

import Foundation

// TODO: 待删除
public extension Encodable {
    var toDictionary: [String: Any] {
        if let data = try? JSONEncoder().encode(self),
           let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return dict
        }
        return [:]
    }
}

// TODO: 待删除
public extension Decodable {
    init?(data: [String: Any]) {
        let decoder = JSONDecoder()
        let dateFormattter = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
        decoder.dateDecodingStrategy = .formatted(dateFormattter)

        if JSONSerialization.isValidJSONObject(data),
           let json = try? JSONSerialization.data(withJSONObject: data, options: []),
           let obj = try? decoder.decode(Self.self, from: json) {
            self = obj
        } else {
            #if DEBUG
                do {
                    let json = try JSONSerialization.data(withJSONObject: data, options: [])
                    _ = try decoder.decode(Self.self, from: json)
                } catch {
                    debugPrint(Self.self, "❌❌ 低能转JSON报错", error)
                }
            #endif
            return nil
        }
    }
}
