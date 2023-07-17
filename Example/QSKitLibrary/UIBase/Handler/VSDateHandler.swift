//
//  VSDateHandler.swift
//  QuasiDemo
//
//  Created by Soul on 2023/5/6.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation

class VSDateFormatter: DateFormatter {
    override func string(from date: Date) -> String {
        let now = Date()
        let calendar = Calendar.current

        if calendar.isDateInToday(date) || calendar.isDateInYesterday(date) {
            // 当日期为当天时只展示小时和分钟
            self.dateFormat = "hh:mm a"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            // 当日期为本周内时展示星期和时分
            self.dateFormat = "EEEE hh:mm a"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .year) {
            // 当在本年度时再多展示月份
            self.dateFormat = "MMM dd, hh:mm a"
        } else {
            // 不在本年度时多展示年份
            self.dateFormat = "MMM dd, yyyy hh:mm a"
        }
//        self.locale = Locale(identifier: "en_US_POSIX") // 设置为使用 12 小时制的区域设置
        return super.string(from: date)
    }
}

/// 根据业务需求格式化日期展示
enum VSDateHandler {
    static private var mFormatter = VSDateFormatter()
    /// 根据日期是否属于本日/本月/本年，展示不同长度的格式化字符串
    static func autoFormat(date: Date) -> String {
        var showStr = self.mFormatter.string(from: date)

        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            showStr = "Today " + showStr
        } else if calendar.isDateInYesterday(date) {
            showStr = "Yesterday " + showStr
        }

        return showStr
    }

    /// 根据日期是否属于本日/本月/本年，展示不同长度的格式化字符串
    static func autoFormat(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return self.autoFormat(date: date)
    }

    /// 将秒数转化成 x 小时 y 分钟
    static func formatSecondsToHourMinuteString(_ seconds: Int?) -> String {
        guard let seconds, seconds > 0 else {
            return "0 minute"
        }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full

        // 将时间间隔转换为日期
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(seconds))
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        return String(
            format: "%2d %@ %02d %@",
            arguments: [
                hour,
                hour > 1 ? "hours" : "hour",
                minute,
                minute > 1 ? "minutes" : "minute"
            ]
        )
    }

    /// 将距离0点的秒数转化成12小时时刻展示
    static func formatSecondsTo12TimeString(_ seconds: Int) -> String {
        guard seconds > 0 else {
            return "12:00 AM"
        }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full

        // 将时间间隔转换为日期
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(seconds))
        let dateFormat = DateFormatter(dateFormat: "hh:mm a")
        dateFormat.timeZone = TimeZone(identifier: "UTC") ?? .current // 格林尼治时间
        dateFormat.locale = Locale(identifier: "en_US_POSIX") // 设置为使用 12 小时制的区域设置

        return dateFormat.string(from: date)
    }
}
