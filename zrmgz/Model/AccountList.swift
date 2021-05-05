//
//  AccountList.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/5/4.
//

import Foundation
import SQLite

class Accountlist {
    
    let today = Date()
    
    let accountTable = AccountTable.init()
    
    func getTheWeekRange() -> (Int, Int) {
        let weekStart = today.previous(.monday)
        let weekEnd = today.next(.sunday)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let intWeekStart = Int(formatter.string(from: weekStart)) ?? 0
        let intWeekEnd = Int(formatter.string(from: weekEnd)) ?? 0
        
        return (intWeekStart, intWeekEnd)
    }
    
    func getTheWeekRangeStr(_ formatStr: String = "yyyy-MM-dd") -> (String, String) {
        let weekStart = today.previous(.monday)
        let weekEnd = today.next(.sunday)
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr
        let intWeekStart = formatter.string(from: weekStart)
        let intWeekEnd = formatter.string(from: weekEnd)
        
        return (intWeekStart, intWeekEnd)
    }
    
    func getTheWeekDays() -> [Int] {
        var days = [Int]()
        let day1 = Int(today.previous(.monday).timeIntervalSince1970)
        for i in 0..<7 {
            let day = day1 + i * (24*60*60)
            days.append(day)
        }
        return days
    }
    
    func getTheWeekDaysStr(_ formatStr: String = "yyyy-MM-dd") -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr
        var daysStr = [String]()
        let days = getTheWeekDays()
        for d in days {
            let date = Date(timeIntervalSince1970: Double(d))
            let str = formatter.string(from: date)
            daysStr.append(str)
            print(" week day \(str)")
        }
        return daysStr
    }
    
    func getData(_ timeType: Int = 1, _ dataType: Int = 1) -> ([Double], [String: Double]) {
        let theYear = today.year()
        let theMonth = today.month()
        let days = Date.countOfDaysInCurrentMonth()
        
        let weekRange = getTheWeekRange()
        let weekDays = getTheWeekDaysStr("yyyyMMdd")
        
        let _year = Expression<Int>.init("year")
        let _month = Expression<Int>.init("month")
        let _type = Expression<Int>.init("type")
        let _recDate = Expression<Int>.init("date")
        
        var _filter: Expression<Bool>?
        
        var data = [Double]()
        var data2 = [String: Double]()
        var totals = 1
        
        if timeType == 1 {
            totals = 7
            _filter = _type == dataType && _recDate >= weekRange.0 && _recDate <= weekRange.1
        } else if timeType == 2 {
            totals = days
            _filter = _type == dataType && _year == theYear && _month == theMonth
        } else {
            totals = 12
            _filter = _type == dataType && _year == theYear
        }
        
        for _ in 0..<totals {
            data.append(0)
        }
        
        let res = accountTable.query(_filter: _filter)
        
        for account in res {
            print("\(account.id) | \(account.sortId) | \(account.sortName) | \(account.type) | \(account.num) | \(account.year) | \(account.month) | \(account.day) | \(account.date)")
            if timeType == 1 {
                for i in 0..<weekDays.count {
                    if Int(weekDays[i]) == account.date {
                        data[i] += account.num
                    }
                }
            } else if timeType == 2 {
                for i in 0..<days {
                    if (i + 1) == account.day {
                        data[i] += account.num
                    }
                }
            } else {
                for i in 0..<days {
                    if (i + 1) == account.month {
                        data[i] += account.num
                    }
                }
            }
            
            if data2[account.sortName] == nil {
                data2[account.sortName] = 0
            }
            data2[account.sortName]! += account.num
        }
        
        print("=== data for pie ===", data2.keys)
        for item in data2 {
            print("=== data for pie ===", item.key, item.value)
        }
        
        return (data, data2)
    }
    
}
