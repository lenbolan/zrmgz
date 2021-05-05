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
    var dateRange = [Int]()
    var accountData = [Account]()
    
    var needRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultBackground()
        
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
        
        let _recDate = Expression<Int>.init("date")
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
    
    override func viewWillDisappear(_ animated: Bool) {
        needRefresh = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if needRefresh {
            needRefresh = false
            accountData.removeAll()
            setData()
            tableView.reloadData()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AddAcountViewController()
        vc.editAccount = accountData[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let rowData = accountData[indexPath.row]
            accountTable.delete(_id: rowData.id)
            accountData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.setData()
        }
    }
}
