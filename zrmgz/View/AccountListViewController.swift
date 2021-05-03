//
//  AccountListViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/5/3.
//

import UIKit
import SQLite

class AccountListViewController: UIViewController {
    
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbIncome: UILabel!
    @IBOutlet weak var lbExpend: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let accountTable = AccountTable.init()
    
    var dateInfo = ""
    var dateRange = [Int64]()
    var accountData = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topColor = UIColor(red: 68/255, green: 25/255, blue: 123/255, alpha: 1)
        let bottomColor = UIColor.white
        view.setBackgroundGradientColor(topColor: topColor, buttomColor: bottomColor, topPos: 0, bottomPos: 0.3)
        
        print("... \(dateInfo) ...")
        
//        navigationItem.leftBarButtonItem?.title = dateInfo
        
        let cellNib = UINib(nibName: "DailyCell", bundle: Bundle(for: DailyCell.self))
        tableView.register(cellNib, forCellReuseIdentifier: "DailyCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setData()
    }
    
    func setData() {
        var expend:Double = 0
        var income:Double = 0
        var balance:Double = 0
        
        let _recDate = Expression<Int64>.init("date")
        let intDateStart = dateRange[0]
        let intDateEnd = dateRange[1]
        var _accountData: [Account]
        if intDateEnd == intDateStart {
            _accountData = accountTable.query(_filter: _recDate == intDateStart)
        } else {
            _accountData = accountTable.query(_filter: _recDate >= intDateStart && _recDate <= intDateEnd)
        }
        accountData.removeAll()
        accountData = _accountData
        for account in _accountData {
            print("\(account.id) | \(account.sortId) | \(account.sortName) | \(account.type) | \(account.num) | \(account.year) | \(account.month) | \(account.day) | \(account.date)")
            if account.type == 1 {
                expend += account.num
            } else {
                income += account.num
            }
        }
        
        balance = income - expend
        let douExpend = String(format: "%.2f", expend)
        lbExpend.text = "\(douExpend)"
        let douIncome = String(format: "%.2f", income)
        lbIncome.text = "\(douIncome)"
        let douBalance = String(format: "%.2f", balance)
        lbBalance.text = "\(douBalance)"
    }

}

extension AccountListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyCell
        
        cell.setup(data: accountData[indexPath.row])
        
        return cell
    }
    
    
}
