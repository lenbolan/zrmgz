//
//  SalaryViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/4/30.
//

import UIKit
import SQLite

class SalaryViewController: UIViewController {
    
    var salaries = [Salary]()
    
    let salaryTable = SalaryTable.init()

    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var list: UITableView!
    
    let pickerDate = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        let _data = salaryTable.query(_filter: nil)
        salaries.append(contentsOf: _data)
        
        list.register(UITableViewCell.self, forCellReuseIdentifier: "SalaryCell")
        
        list.delegate = self
        list.dataSource = self
        
        setDatePicker()
        
        onPickDate(datePicker: pickerDate)
    }
    
    func setDatePicker() {
        pickerDate.datePickerMode = .date
        pickerDate.date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let fromDateTime = formatter.date(from: "2020-01")
        pickerDate.minimumDate = fromDateTime
        let endDateTime = Date()
        pickerDate.maximumDate = endDateTime
        pickerDate.locale = Locale(identifier: "zh_CN")
        pickerDate.addTarget(self, action: #selector(onPickDate(datePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            pickerDate.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        txtDate.inputView = pickerDate
    }
    
    @objc func onPickDate(datePicker: UIDatePicker) {
        let _date = Int(datePicker.date.timeIntervalSince1970)
        let chkDate = Date.timeStampToString("\(_date)", useCN: false).prefix(6)
        print("chkDate: \(chkDate)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let _sDate = formatter.string(from: datePicker.date)
        txtDate.text = _sDate
        
        let e_sDate = Expression<String>.init("sDate")
        let _data = salaryTable.query(_filter: e_sDate == _sDate)
        salaries.removeAll()
        salaries.append(contentsOf: _data)
        
        list.reloadData()
    }
    
    @objc func hideKeyboard(tapG: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}

extension SalaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryCell", for: indexPath) as UITableViewCell
        
        let _data = salaries[indexPath.row]
        cell.textLabel?.text = "\(_data.userName)  |  \(_data.sDate)  |  \(_data.sMoney8)"
        
        return cell
    }
    
    
}
