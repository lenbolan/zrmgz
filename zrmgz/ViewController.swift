//
//  ViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/4/26.
//

import UIKit
import SQLite

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbMonth: UILabel!
    @IBOutlet weak var lbExpend: UILabel!
    @IBOutlet weak var lbIncome: UILabel!
    @IBOutlet weak var lbBalance: UILabel!
    
    var options = [HomeCellData]()
    
    let today = Date()
    
    var needRefresh = false
    
    // --- base ---
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        
        cell.setup(data: options[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemData = options[indexPath.row]
        print(itemData)
        if indexPath.section == 0 {
            print("... ... \(itemData.info) ... ...")
            self.navigationItem.backButtonTitle = itemData.info
            let vc = AccountListViewController()
            vc.dateInfo = itemData.info
            vc.dateRange = itemData.range
            vc.modalPresentationStyle = .fullScreen
            
//                self.present(vc, animated: true, completion: nil)
//                self.navigationController?.present(vc, animated: true, completion: nil)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // -------
    
    // --- Header ---
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // =======
    
    let accountTable = AccountTable.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nibBundle?.loadNibNamed("ViewController", owner: self, options: nil)
        
        let homeCellNib = UINib(nibName: "HomeTableViewCell", bundle: Bundle(for: HomeTableViewCell.self))
        tableView.register(homeCellNib, forCellReuseIdentifier: "HomeCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setData()
        
//        view.backgroundColor = .blue
//        let topColor = UIColor(red: 79/255, green: 48/255, blue: 123/255, alpha: 1)
//        let bottomColor = UIColor.white
//        view.setBackgroundGradientColor(topColor: topColor, buttomColor: bottomColor, topPos: 0, bottomPos: 0.3)
        
//        banner.contentMode = .scaleAspectFill
        
//        if UserDefaults.localData.keyAdmin.storedString != nil {
//            print("admin...")
//            options[0].append("签到")
//        }
        
        
        
    }
    
    func setData() {
        let theYear = today.year()
        let theMonth = today.month()
        let theDay = today.day()
        let days = Date.countOfDaysInCurrentMonth()
        lbMonth.text = "\(theMonth)"
        
        
        var expend: Double = 0
        var income: Double = 0
        var balance: Double = 0
        
        var weekExpend: Double = 0
        var weekIncome: Double = 0
        
        var dayExpend: Double = 0
        var dayIncome: Double = 0
        
        var todayRec: Account?
        
        let weekStart = today.previous(.monday)
        let weekEnd = today.next(.sunday)
        
        let formatter0 = DateFormatter()
        formatter0.dateFormat = "yyyyMMdd"
        let intToday = Int64(formatter0.string(from: today)) ?? 0
        let intWeekStart = Int64(formatter0.string(from: weekStart)) ?? 0
        let intWeekEnd = Int64(formatter0.string(from: weekEnd)) ?? 0
        let strTheMonth = Date.add0BeforeNumber(theMonth)
        let intMonthStart = Int64("\(theYear)\(strTheMonth)01") ?? 0
        let intMonthEnd = Int64("\(theYear)\(strTheMonth)\(days)") ?? 0
        
        let _year = Expression<Int>.init("year")
        let _month = Expression<Int>.init("month")
        let _recDate = Expression<Int64>.init("date")
        let _data = accountTable.query(_filter: _year == today.year() && _month == today.month())
//        let _data = accountTable.query(_filter: nil)
        for account in _data {
            print("\(account.id) | \(account.sortId) | \(account.sortName) | \(account.type) | \(account.num) | \(account.year) | \(account.month) | \(account.day) | \(account.date)")
            if account.type == 1 {
                expend += account.num
                if account.day == theDay {
                    dayExpend += account.num
                    todayRec = account
                }
            } else {
                income += account.num
                if account.day == theDay {
                    dayIncome += account.num
                    todayRec = account
                }
            }
        }
        balance = income - expend
        let douExpend = String(format: "%.2f", expend)
        lbExpend.text = "\(douExpend)"
        let douIncome = String(format: "%.2f", income)
        lbIncome.text = "\(douIncome)"
        let douBalance = String(format: "%.2f", balance)
        lbBalance.text = "\(douBalance)"
        
        let _weekData = accountTable.query(_filter: _recDate >= intWeekStart && _recDate <= intWeekEnd)
        for account in _weekData {
            print("\(account.id) | \(account.sortId) | \(account.sortName) | \(account.type) | \(account.num) | \(account.year) | \(account.month) | \(account.day) | \(account.date)")
            if account.type == 1 {
                weekExpend += account.num
            } else {
                weekIncome += account.num
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        
        var subTitle = "今天还没有记账"
        if todayRec != nil {
            if let _num = todayRec?.num {
                subTitle = "最近一笔 \(todayRec?.sortName ?? "") \(String(format: "%.2f", _num))"
            }
        }
        let douDayExpend = String(format: "%.2f", dayExpend)
        let douDayIncome = String(format: "%.2f", dayIncome)
        var vmData = HomeCellData(icon: "clock",
                                  title: "今天",
                                  subTitle: subTitle,
                                  info: "今天 " + formatter.string(from: today),
                                  range: [intToday, intToday],
                                  income: douDayIncome,
                                  expend: douDayExpend)
        options.append(vmData)
        
        
        print(" =====")
        print("\(weekStart)")
        print("\(weekEnd)")
        print(" =====")
        
        
        let weekStartFor = formatter.string(from: weekStart)
        let weekEndFor = formatter.string(from: weekEnd)
        
        subTitle = "\(weekStartFor) - \(weekEndFor)"
        let douWeekExpend = String(format: "%.2f", weekExpend)
        let douWeekIncome = String(format: "%.2f", weekIncome)
        vmData = HomeCellData(icon: "timer",
                              title: "本周",
                              subTitle: subTitle,
                              info: "本周 " + subTitle,
                              range: [intWeekStart, intWeekEnd],
                              income: douWeekIncome,
                              expend: douWeekExpend)
        options.append(vmData)
        
        
        
        subTitle = "\(theMonth)月1日 - \(theMonth)月\(days)日"
        vmData = HomeCellData(icon: "calendar.circle.fill",
                              title: "\(theMonth)月",
                              subTitle: subTitle,
                              info: subTitle,
                              range: [intMonthStart, intMonthEnd],
                              income: douIncome,
                              expend: douExpend)
        options.append(vmData)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        needRefresh = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        needRefresh = false
        options.removeAll()
        setData()
        tableView.reloadData()
    }

}

