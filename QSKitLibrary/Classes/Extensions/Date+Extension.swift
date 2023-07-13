//
//  Date+Extension.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2021/11/4.
//

import Foundation

public extension DateFormatter {
    static var shared = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")

    convenience init(dateFormat: String) {
        self.init()
//        self.locale = Locale(identifier: "zh-Hans-CN")
        self.dateFormat = dateFormat
    }
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }

    func secondBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.second], from: self, to: toDate)
        return components.second ?? 0
    }

    func timeStampDiff(toDateString: String) -> Double {
        let dateformatter = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
        dateformatter.locale = Locale.current
        let toDate = dateformatter.date(from: toDateString)
        let fromDateTimeStamp = timeIntervalSince1970
        let toDateTimeStamp = toDate?.timeIntervalSince1970 ?? fromDateTimeStamp
        let diff = fromDateTimeStamp - toDateTimeStamp
        return diff
    }

    /// 秒级
    func timeStampDiff(toTimeStamp: Double) -> Double {
        let fromDateTimeStamp = timeIntervalSince1970
        let toDateTimeStamp = toTimeStamp
        let diff = fromDateTimeStamp - toDateTimeStamp
        return diff
    }

    var localDate: Date {
        let zone = NSTimeZone.system
        let second = Int(zone.secondsFromGMT())
        return Date(timeInterval: TimeInterval(second), since: self)
    }

    var dataString: String {
        let dateformatter = DateFormatter(dateFormat: "HH:mm,yyyy.M.dd")
        dateformatter.locale = Locale.current
        return dateformatter.string(from: self)
    }

    var timeString: String {
        let dateformatter = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
        dateformatter.locale = Locale.current
        return dateformatter.string(from: self)
    }

    var zoonTimeStap: Int {
        let zone = NSTimeZone.system
        let second = Int(zone.secondsFromGMT())
        let timeInterval = timeIntervalSince1970
        return Int(timeInterval) + second
    }

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp: Int {
        let timeInterval: TimeInterval = timeIntervalSince1970
        return Int(timeInterval)
    }

    /// 获取当前 秒级 时间戳 - 10位
    var timeStampValue: String {
        let timeInterval: TimeInterval = timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStampValue: String {
        let timeInterval: TimeInterval = timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval * 1000))
        return "\(millisecond)"
    }

    var milliStamp: Int {
        let timeInterval: TimeInterval = timeIntervalSince1970
        return Int(round(timeInterval * 1000))
    }

    var week: String {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        let weekDay = (components.weekday ?? 1) - 1
        let array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return array[weekDay]
    }

    var year: Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year], from: self)
        return components.year ?? 0
    }

    var month: Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.month], from: self)
        return components.month ?? 0
    }

    var hour: Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.hour], from: self)
        return components.hour ?? 0
    }

    var minute: Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.minute], from: self)
        return components.minute ?? 0
    }

    var yearMonthDay: String {
        let dateformatter = DateFormatter(dateFormat: "yyyy.M.dd")
        dateformatter.locale = Locale.current
        return dateformatter.string(from: self)
    }

    var yearMonthDayForParam: String {
        let dateformatter = DateFormatter(dateFormat: "yyyy-MM-dd")
        dateformatter.locale = Locale.current
        return dateformatter.string(from: self)
    }

    var monthDayYear: String {
        let dateformatter = DateFormatter(dateFormat: "MMM dd,yyyy")
        dateformatter.locale = Locale.current
        return dateformatter.string(from: self)
    }

    var monthDayYearHourMin: String {
        let dateformatter = DateFormatter(dateFormat: "MMM dd, yyyy HH:mm")
        dateformatter.locale = Locale.current
        return dateformatter.string(from: self)
    }

    var hourMinuteSecond: String {
        let dateformatter = DateFormatter(dateFormat: "HH:mm")
        dateformatter.locale = Locale.current
        return dateformatter.string(from: self)
    }

    var hourMonthDay: String {
        let dateformatter = DateFormatter(dateFormat: "H:mm,MMM dd")
        dateformatter.locale = Locale.current
        return dateformatter.string(from: self)
    }

    var hourMonthDayYear: String {
        let dateformatter = DateFormatter(dateFormat: "H:mm,MMM dd, yyyy")
        dateformatter.locale = Locale.current
        return dateformatter.string(from: self)
    }
}
