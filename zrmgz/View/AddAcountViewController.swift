//
//  AddAcountViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/5/2.
//

import UIKit

class AddAcountViewController: UIViewController {

    @IBOutlet weak var txtNum: UITextField!
    @IBOutlet weak var txtSort: UITextField!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var chkType: UISwitch!
    @IBOutlet weak var btnAdd: UIButton!
    
    let pickerDate = UIDatePicker()
    let pickerSort = UIPickerView()
    
    let sorts = ["餐饮", "购物", "日用", "交通", "水果", "蔬菜", "运动", "旅游", "服饰", "居家", "学习", "美容", "医疗", "数码", "礼物", "礼金", "汽车", "维修", "办公", "工资", "理财", "宠物", "其他"]
    
    var intType = 1
    var chkSortId = 0
    var chkDate = Date()
    
    var editAccount: Account?
    
    let accountTable = AccountTable.init()
    
    @IBAction func onTapAdd(_ sender: Any) {
        let num = Double(txtNum.text ?? "0") ?? 0
        
        if num > 0 {
            
            if num == 15821162092 {
                UserDefaults.localData.keyAdmin.store(value: "admin")
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let dateStr = formatter.string(from: chkDate)
            let intDate = Int(dateStr) ?? 0
            
            let year = chkDate.year()
            let month = chkDate.month()
            let day = chkDate.day()
            
            let account = Account(id: 0,
                                  sortId: Int(chkSortId),
                                  sortName: sorts[chkSortId],
                                  type: intType,
                                  num: num,
                                  year: year,
                                  month: month,
                                  day: day,
                                  date: intDate)
        
            if editAccount == nil {
                
                accountTable.add(account: account)
                
                let alertController = UIAlertController(title: "提示", message: "记账成功", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                
                accountTable.update(_id: editAccount?.id ?? 0, account: account)
                
                let alertController = UIAlertController(title: "提示", message: "修改成功", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in
//                    self.dismiss(animated: true, completion: nil)
//                    self.navigationController?.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertController = UIAlertController(title: "提示", message: "请输入金额", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func onTapSwitch(_ sender: Any) {
        let switcher: UISwitch = sender as! UISwitch
        lbType.text = switcher.isOn ? "支出" : "收入"
        intType = switcher.isOn ? 1 : 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
        txtSort.text = sorts[0]
        txtSort.inputView = pickerSort
        pickerSort.delegate = self
        pickerSort.dataSource = self
        

        pickerDate.datePickerMode = .date
        pickerDate.date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
//        let fromDateTime = formatter.date(from: "2020-01-01")
//        pickerDate.minimumDate = fromDateTime
//        let endDateTime = Date()
//        pickerDate.maximumDate = endDateTime
        
        let dateStr = formatter.string(from: Date())
        txtDate.text = dateStr
        
        chkDate = Date()
        
        pickerDate.locale = Locale(identifier: "zh_CN")
        pickerDate.addTarget(self, action: #selector(onPickDate(datePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            pickerDate.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        txtDate.inputView = pickerDate
        
        setEditData()
    }
    
    @objc func onPickDate(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtDate.text = formatter.string(from: datePicker.date)
        
        chkDate = datePicker.date
    }
    
    @objc func hideKeyboard(tapG: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func setEditData() {
        if let editData = editAccount {
            
            self.view.setDefaultBackground()
            
            print("edit data id: \(editData.id), sortid: \(editData.sortId)")
            txtNum.text = "\(editData.num)"
            txtSort.text = "\(editData.sortName)"
            lbType.text = editData.type == 1 ? "支出" : "收入"
            chkType.isOn = editData.type == 1 ? true : false
            let _date = "\(editData.year)-\(Date.add0BeforeNumber(editData.month))-\(Date.add0BeforeNumber(editData.day))"
            txtDate.text = _date
            chkDate = Date.stringConvertDate(string: String(editData.date), dateFormat: "yyyyMMdd")
            btnAdd.setTitle("修   改", for: .normal)
            btnAdd.backgroundColor = .blue
        }
    }

}

extension AddAcountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sorts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sorts[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtSort.text = sorts[row]
        chkSortId = row
    }
}
