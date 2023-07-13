//
//  Date+VSCalendarView.swift
//  QuasiDemo
//
//  Created by Geminy on 2022/5/17.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation

extension Date {
    func previousMonthDate() -> Date {
        /// 定位到上个月同一天，若无则上个月最后一天
        var components = DateComponents()
        components.month = -1
        let previousMonthDate = Calendar.current.date(byAdding: components, to: self)
        return previousMonthDate ?? Date()
    }

    func nextMonthDate() -> Date {
        /// 定位到下个月同一天，若无则下个月最后一天
        var components = DateComponents()
        components.month = 1
        let nextMonthDate = Calendar.current.date(byAdding: components, to: self)
        return nextMonthDate ?? Date()
    }

    func previousWeekDate() -> Date {
        let timeInterval = 7 * 24 * 60 * 60
        /// 定位到上一周同星期的日期
        return self.addingTimeInterval(-TimeInterval(timeInterval))
    }

    func nextWeekDate() -> Date {
        let timeInterval = 7 * 24 * 60 * 60
        /// 定位到下一周同星期的日期
        return self.addingTimeInterval(TimeInterval(timeInterval))
    }

    /// 当前日期的周日时间
    func sundayDate() -> Date {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        let weekday = components.weekday ?? 1
        /// 获取周日的date（系统里1、2、3、4、5、6、7 分别对应 周日、周一、周二、周三、周四、周五、周六）
        let timeInterval = (weekday - 1) * 24 * 60 * 60
        let sunDate = self.addingTimeInterval(-TimeInterval(timeInterval))
        return sunDate
    }

    func totalDaysInMonth() -> Int {
        let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)
        if let upperBound = range?.upperBound, let lowerBound = range?.lowerBound {
            return upperBound - lowerBound
        }
        return 0
    }

    func firstDayWeekDayInMonth() -> Int {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.day = 1
        let firstDate = Calendar.current.date(from: components)
        let firstComponents = Calendar.current.dateComponents([.weekday], from: firstDate ?? Date())
        let weekday = (firstComponents.weekday ?? 1) - 1
//       let weekday = Calendar.current.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDate ?? Date())
        return weekday
    }

    func firstDayDate() -> Date {
        let day = 1
        var component = Calendar.current.dateComponents([.year, .month], from: self)
        component.day = day
        let date = Calendar.current.date(from: component)
        return date ?? Date()
    }

    func lastDayDate() -> Date {
        let day = self.totalDaysInMonth()
        var component = Calendar.current.dateComponents([.year, .month], from: self)
        component.day = day
        let date = Calendar.current.date(from: component)
        return date ?? Date()
    }

    func dateDay() -> Int {
        let component = Calendar.current.dateComponents([.day], from: self)
        return component.day ?? 0
    }

    func dateMonth() -> Int {
        let component = Calendar.current.dateComponents([.month], from: self)
        return component.month ?? 0
    }

    func dateYear() -> Int {
        let component = Calendar.current.dateComponents([.year], from: self)
        return component.year ?? 0
    }

    /// 返回随系统，周日为1
    func dateWeek() -> Int {
        let component = Calendar.current.dateComponents([.weekday], from: self)
        return component.weekday ?? 1
    }

    func yearMonthDayString() -> String {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let desc = "\(component.year ?? 0)-\(component.month ?? 0)-\(component.day ?? 0)"
        return desc
    }

    /// 返回当前日期的一周中指定周几的日期
    func dateAttachWeek(_ week: Int) -> Date {
        if week < 1 || week > 7 {
            return self
        }
        let component = Calendar.current.dateComponents([.weekday], from: self)
        let currentWeek = component.weekday ?? 1
        let timeInterval = (week - currentWeek) * 24 * 60 * 60
        return self.addingTimeInterval(TimeInterval(timeInterval))
    }
}
