//
//  AddSalaryViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/4/30.
//

import UIKit
import SQLite

class AddSalaryViewController: UIViewController {
    
    let userTable = UserTable.init()
    let salaryTable = SalaryTable.init()
    
    var chkUid:Int64 = 0
    var employees = [Employee]()
    
    let pickerUserName = UIPickerView()
    let pickerDate = UIDatePicker()
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtMoney1: UITextField!
    @IBOutlet weak var txtMoney2: UITextField!
    @IBOutlet weak var txtMoney3: UITextField!
    @IBOutlet weak var txtMoney4: UITextField!
    @IBOutlet weak var txtMoney5: UITextField!
    @IBOutlet weak var txtMoney6: UITextField!
    @IBOutlet weak var txtMoney7: UITextField!
    @IBOutlet weak var txtMoney8: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    
    @IBAction func onTapOK(_ sender: Any) {
        let userName = (txtUserName.text!).trimmingCharacters(in: .whitespaces)
        
        if userName == "" {
            self.view.makeToast("请选择姓名")
        } else {
            let _userName = txtUserName.text ?? ""
            let _sDate = txtDate.text ?? ""
            let _money1 = Int(txtMoney1.text ?? "0") ?? 0
            let _money2 = Int(txtMoney2.text ?? "0") ?? 0
            let _money3 = Int(txtMoney3.text ?? "0") ?? 0
            let _money4 = Int(txtMoney4.text ?? "0") ?? 0
            let _money5 = Int(txtMoney5.text ?? "0") ?? 0
            let _money6 = Int(txtMoney6.text ?? "0") ?? 0
            let _money7 = Int(txtMoney7.text ?? "0") ?? 0
            let _money8 = _money1+_money2+_money3+_money4+_money5+_money6+_money7
            
            
            let salary = Salary(id: 0, uid: chkUid, userName: _userName, sDate: _sDate, sMoney1: _money1, sMoney2: _money2, sMoney3: _money3, sMoney4: _money4, sMoney5: _money5, sMoney6: _money6, sMoney7: _money7, sMoney8: _money8)
            
            
            let e_uid = Expression<Int64>.init("uid")
            let e_sDate = Expression<String>.init("sDate")
            
            let _query = salaryTable.query(_filter: e_uid == chkUid && e_sDate == _sDate)
            if _query.count > 0 {
                salaryTable.update(_id: chkUid, salary: salary)
            } else {
                salaryTable.add(salary: salary)
            }
            
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEmployees()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        pickerUserName.delegate = self
        pickerUserName.dataSource = self
        
        txtUserName.inputView = pickerUserName
        if employees.count > 0 {
            txtUserName.text = employees[0].userName
            chkUid = employees[0].id
        }
        
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
        
        onPickDate(datePicker: pickerDate)
    }
    
    func loadEmployees() {
        let _employees = userTable.query()
        employees.append(contentsOf: _employees)
        for item in employees {
            print("\(item.userName)")
        }
    }
    
    @objc func onPickDate(datePicker: UIDatePicker) {
        let _date = Int(datePicker.date.timeIntervalSince1970)
        let chkDate = Date.timeStampToString("\(_date)", useCN: false).prefix(6)
        print("chkDate: \(chkDate)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        txtDate.text = formatter.string(from: datePicker.date)
        
        
    }
    
    @objc func hideKeyboard(tapG: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTextValueChange(_ sender: Any) {
        print("... \(#function) ...")
        let _money1 = Int(txtMoney1.text ?? "0") ?? 0
        let _money2 = Int(txtMoney2.text ?? "0") ?? 0
        let _money3 = Int(txtMoney3.text ?? "0") ?? 0
        let _money4 = Int(txtMoney4.text ?? "0") ?? 0
        let _money5 = Int(txtMoney5.text ?? "0") ?? 0
        let _money6 = Int(txtMoney6.text ?? "0") ?? 0
        let _money7 = Int(txtMoney7.text ?? "0") ?? 0
        let _money8 = _money1+_money2+_money3+_money4+_money5+_money6+_money7
        txtMoney8.text = "\(_money8)"
    }
    
}

extension AddSalaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return employees.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return employees[row].userName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let emp = employees[row]
        txtUserName.text = emp.userName
        chkUid = emp.id
    }
    
}

extension AddSalaryViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtUserName {
            if employees.count > 0 {
//                textField.text = employees[0].userName
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("... \(#function) ...")
        if textField == txtMoney1
            || textField == txtMoney2
            || textField == txtMoney3
            || textField == txtMoney4
            || textField == txtMoney5
            || textField == txtMoney6
            || textField == txtMoney7 {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            // 只允许输入数字和两位小数
            let expression = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
            // let expression = "^[0-9]*([0-9])?$" //只允许输入纯数字
            // let expression = "^[A-Za-z0-9]+$" //允许输入数字和字母
            let regex = try! NSRegularExpression(pattern: expression,
                                                 options: .allowCommentsAndWhitespace)
            let numberOfMatches = regex.numberOfMatches(in: newString,
                                                        options: .reportProgress,
                                                        range: NSMakeRange(0, newString.count))
            if numberOfMatches == 0 {
                print("请输入数字")
                return false
            }
            return true
        }
        return true
    }
    
}
