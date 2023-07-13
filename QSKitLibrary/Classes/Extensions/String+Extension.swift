//
//  String+Extension.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2021/10/28.
//

import CommonCrypto
import Foundation

public extension String {
    /// 扩展: 判断是否为空字符串
    var isBlank: Bool {
        if self.isEmpty {
            return true
        } else if self == "null" {
            return true
        } else {
            return allSatisfy { $0.isWhitespace }
        }
    }

    var isPurnInt: Bool {
        if isBlank {
            return false
        }
        let scan = Scanner(string: self)
        var val = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }

    /// 自定义的下标方法，允许你通过整数范围来访问字符串的子串
    subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: min(r.lowerBound, count))
        let end = index(startIndex, offsetBy: min(r.upperBound, count))
        return String(self[start ..< end])
    }

    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }

    var intValue: Int {
        (self as NSString).integerValue
    }

    var longValue: Int64 {
        (self as NSString).longLongValue
    }

    var doubleValue: Double {
        (self as NSString).doubleValue
    }

    var priceValue: String {
        var number: String = ""
        for c in self {
            if c.isNumber {
                number += String(c)
            } else if c == "." {
                if number.isBlank == false {
                    number += String(c)
                }
            }
        }
        return number
    }

    var unitValue: String {
        var unit: String = ""
        for c in self {
            if !c.isNumber {
                unit += String(c)
            } else {
                break
            }
        }
        return unit
    }

    init(duration: Int) {
        let hour = Int(duration / 3600)
        let minute = Int(duration / 60) % 60
        let second = Int(duration % 60)
        if hour >= 1 {
            self.init(format: "%d:%02d:%02d", hour, minute, second)
        } else {
            self.init(format: "%d:%02d", minute, second)
        }
    }

    init(timeCount: Int) {
        let hour = Int(timeCount / 3600)
        let minute = Int(timeCount / 60) % 60
        let second = Int(timeCount % 60)
        self.init(format: "%02d:%02d:%02d", hour, minute, second)
    }

    init(millsecond: Int) {
        let duration = millsecond / 1000
        let hour = Int(duration / 3600)
        let minute = Int(duration / 60) % 60
        let second = Int(duration % 60)
        let mill = Int((millsecond % 1000) / 10)
        if hour >= 1 {
            self.init(format: "%d:%02d:%02d:%02d", hour, minute, second, mill)
        } else {
            self.init(format: "%d:%02d:%02d", minute, second, mill)
        }
    }

    public func formateForBankCard(joined: String = " ") -> String {
       guard self.isBlank == false else {
           return self
       }
       let length: Int = self.count
       let count: Int = length / 4
       var data: [String] = []
       for i in 0..<count {
           let start: Int = 4 * i
           let end: Int = 4 * (i + 1)
           data.append(self[start..<end])
       }
       if length % 4 > 0 {
           data.append(self[4 * count..<length])
       }
       let result = data.joined(separator: " ")
       return result
   }
}
