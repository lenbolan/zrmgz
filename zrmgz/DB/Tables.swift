//
//  Tables.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/4/26.
//

import Foundation
import SQLite

class UserTable{
    
    var sql: SqLiteManger
    let id = Expression<Int64>.init("uid")
    let name = Expression<String>.init("userName")
    let gender = Expression<String>.init("gender")
    let duties = Expression<String>.init("duties")
    
    var table: Table?
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask,
                                                       true)[0]
        print(path)
        sql = SqLiteManger.init(sqlPath: path + "/zrmgz.sqlite")
        
        table = sql.createTable(tableName: "User") { bulider in
            bulider.column(id, primaryKey: .autoincrement)
            bulider.column(name, unique: true)
            bulider.column(gender)
            bulider.column(duties)
        }
    }
    
//    胡小红 江小雨 张小珏 王小萌
    func add(userName: String, _gender: String, _duties: String) {
        if sql.insert(table: table, setters: [name <- userName, gender <- _gender, duties <- _duties]) {
            print("add success.")
        }
    }
    
    func query() -> [Employee] {
        let rows = sql.select(table: table, select: [id, name, gender, duties], filter: id >= 0)
        var employees = [Employee]()
        for item in rows ?? [] {
            print(item[id], item[name], item[gender], item[duties])
            let employee = Employee(id: item[id], userName: item[name], gender: item[gender], duties: item[duties])
            employees.append(employee)
        }
        return employees
    }
    
    func update(_id: Int64, userName: String, _gender: String, _duties: String) {
        if sql.update(table: table, setters: [name <- userName, gender <- _gender, duties <- _duties], filter: id == _id) {
            print("update success.")
        }
    }
    
    func delete(_id: Int64) {
        if sql.delete(table: table, filter: id == _id) {
            print("delete success.")
        }
    }
    
}


class SalaryTable{
    
    var sql: SqLiteManger
    let id = Expression<Int64>.init("sid")
    let uid = Expression<Int64>.init("uid")
    let name = Expression<String>.init("userName")
    let sDate = Expression<String>.init("sDate")
    let sMoney1 = Expression<Int>.init("sMoney1")
    let sMoney2 = Expression<Int>.init("sMoney2")
    let sMoney3 = Expression<Int>.init("sMoney3")
    let sMoney4 = Expression<Int>.init("sMoney4")
    let sMoney5 = Expression<Int>.init("sMoney5")
    let sMoney6 = Expression<Int>.init("sMoney6")
    let sMoney7 = Expression<Int>.init("sMoney7")
    let sMoney8 = Expression<Int>.init("sMoney8")
    
    var table: Table?
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask,
                                                       true)[0]
        print(path)
        sql = SqLiteManger.init(sqlPath: path + "/zrmgz.sqlite")
        
        table = sql.createTable(tableName: "Salary") { bulider in
            bulider.column(id, primaryKey: .autoincrement)
            bulider.column(uid)
            bulider.column(name)
            bulider.column(sDate)
            bulider.column(sMoney1)
            bulider.column(sMoney2)
            bulider.column(sMoney3)
            bulider.column(sMoney4)
            bulider.column(sMoney5)
            bulider.column(sMoney6)
            bulider.column(sMoney7)
            bulider.column(sMoney8)
        }
    }
    
    
    func add(salary: Salary) {
        if sql.insert(table: table, setters: [uid <- salary.uid,
                                              name <- salary.userName,
                                              sDate <- salary.sDate,
                                              sMoney1 <- salary.sMoney1,
                                              sMoney2 <- salary.sMoney2,
                                              sMoney3 <- salary.sMoney3,
                                              sMoney4 <- salary.sMoney4,
                                              sMoney5 <- salary.sMoney5,
                                              sMoney6 <- salary.sMoney6,
                                              sMoney7 <- salary.sMoney7,
                                              sMoney8 <- salary.sMoney8]) {
            print("add success.")
        }
    }
    
    func query(_filter:Expression<Bool>?) -> [Salary] {
        var filter_: Expression<Bool> = id >= 0
        if let _fil = _filter {
            filter_ = _fil
        }
        let rows = sql.select(table: table, select: [id, uid, name, sDate, sMoney1, sMoney2, sMoney3, sMoney4, sMoney5, sMoney6, sMoney7, sMoney8], filter: filter_)
        var salaries = [Salary]()
        for item in rows ?? [] {
            print(item[id], item[uid], item[name], item[sDate], item[sMoney8])
            let salary = Salary(id: item[id], uid: item[uid], userName: item[name], sDate: item[sDate], sMoney1: item[sMoney1], sMoney2: item[sMoney2], sMoney3: item[sMoney3], sMoney4: item[sMoney4], sMoney5: item[sMoney5], sMoney6: item[sMoney6], sMoney7: item[sMoney7], sMoney8: item[sMoney8])
            salaries.append(salary)
        }
        return salaries
    }
    
    func update(_id: Int64, salary: Salary) {
        if sql.update(table: table, setters: [sMoney1 <- salary.sMoney1,
                                              sMoney2 <- salary.sMoney2,
                                              sMoney3 <- salary.sMoney3,
                                              sMoney4 <- salary.sMoney4,
                                              sMoney5 <- salary.sMoney5,
                                              sMoney6 <- salary.sMoney6,
                                              sMoney7 <- salary.sMoney7,
                                              sMoney8 <- salary.sMoney8], filter: id == _id) {
            print("update success.")
        }
    }
    
    func delete(_id: Int64) {
        if sql.delete(table: table, filter: id == _id) {
            print("delete success.")
        }
    }
    
}

class AccountTable{
    
    var sql: SqLiteManger
    
    let id = Expression<Int64>.init("id")
    let sortId = Expression<Int>.init("sid")
    let sortName = Expression<String>.init("sName")
    let type = Expression<Int>.init("type")
    let num = Expression<Double>.init("num")
    let year = Expression<Int>.init("year")
    let month = Expression<Int>.init("month")
    let day = Expression<Int>.init("day")
    let date = Expression<Int>.init("date")
    
    var table: Table?
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask,
                                                       true)[0]
        print(path)
        sql = SqLiteManger.init(sqlPath: path + "/zrmgz.sqlite")
        
        table = sql.createTable(tableName: "Account") { bulider in
            bulider.column(id, primaryKey: .autoincrement)
            bulider.column(sortId)
            bulider.column(sortName)
            bulider.column(type)
            bulider.column(num)
            bulider.column(year)
            bulider.column(month)
            bulider.column(day)
            bulider.column(date)
        }
    }
    
    
    func add(account: Account) {
        if sql.insert(table: table, setters: [sortId <- account.sortId,
                                              sortName <- account.sortName,
                                              type <- account.type,
                                              num <- account.num,
                                              year <- account.year,
                                              month <- account.month,
                                              day <- account.day,
                                              date <- account.date]) {
            print("add success.")
        }
    }
    
    func query(_filter:Expression<Bool>?) -> [Account] {
        var filter_: Expression<Bool> = id >= 0
        if let _fil = _filter {
            filter_ = _fil
        }
        let rows = sql.select(table: table, select: [id, sortId, sortName, type, num, year, month, day, date], filter: filter_)
        var accounts = [Account]()
        for item in rows ?? [] {
            print(item[id], item[sortId], item[sortName], item[type], item[date])
            let _account = Account(id: item[id],
                                   sortId: item[sortId],
                                   sortName: item[sortName],
                                   type: item[type],
                                   num: item[num],
                                   year: item[year],
                                   month: item[month],
                                   day: item[day],
                                   date: item[date])
            accounts.append(_account)
        }
        return accounts
    }
    
    func update(_id: Int64, account: Account) {
        if sql.update(table: table, setters: [sortId <- account.sortId,
                                              sortName <- account.sortName,
                                              type <- account.type,
                                              num <- account.num,
                                              year <- account.year,
                                              month <- account.month,
                                              day <- account.day,
                                              date <- account.date], filter: id == _id) {
            print("update success.")
        }
    }
    
    func delete(_id: Int64) {
        if sql.delete(table: table, filter: id == _id) {
            print("delete success.")
        }
    }
    
}
