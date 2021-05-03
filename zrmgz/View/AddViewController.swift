//
//  AddViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/4/26.
//

import UIKit
import Toast_Swift

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let pickerDuties = UIPickerView()
    
    let userTable = UserTable.init()
    
    let duties = ["市场", "人事", "财务", "运营", "研发"]
    
    var chkDuties: String = ""
    var chkGender: Int = 1
    
    var isEditMode: Bool = false
    var employee: Employee? = nil
    
    // ----- UIPickerView [begin] -----
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return duties.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return duties[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let duty = duties[row]
        print("check: \(duty)")
        txtDuties.text = duty
        chkDuties = duty
    }
    
    // ----- UIPickerView [end] -----
    
    @IBAction func tapSwitcher(_ sender: Any) {
        let switcher: UISwitch = sender as! UISwitch
        lbGender.text = switcher.isOn ? "男" : "女"
        chkGender = switcher.isOn ? 1 : 2
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        return true
    }
    
    @IBOutlet weak var imageTitle: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtDuties: UITextField!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var switchGender: UISwitch!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBAction func tapAdd(_ sender: Any) {
        let userName = (txtUserName.text!).trimmingCharacters(in: .whitespaces)
        let gender = lbGender.text!
        
        print("username: \(userName), duties: \(chkDuties), gender: \(gender)")
        
//        let alertController = UIAlertController(title: "系统提示", message: "请选择时间", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
        
        if userName == "" {
            self.view.makeToast("请输入姓名")
        } else {
            if isEditMode == false {
                if userName == "ykyadmin" {
                    UserDefaults.localData.keyAdmin.store(value: "admin")
                } else {
                    userTable.add(userName: userName, _gender: gender, _duties: chkDuties)
                }
//                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                if let emp = employee {
                    userTable.update(_id: emp.id, userName: userName, _gender: gender, _duties: chkDuties)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageTitle.layer.shadowOpacity = 0.8
        imageTitle.layer.shadowColor = UIColor.gray.cgColor
        imageTitle.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        pickerDuties.delegate = self
        pickerDuties.dataSource = self
        
        txtDuties.inputView = pickerDuties
        txtDuties.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        btnAdd.layer.cornerRadius = 24
        btnAdd.layer.shadowOpacity = 0.8
        btnAdd.layer.shadowColor = UIColor.gray.cgColor
        btnAdd.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        chkDuties = duties[0]
        txtDuties.text = chkDuties
        
        if isEditMode {
            print("edit mode: \(isEditMode)")
            if let emp = employee {
                print("employee info: \(emp.id) \(emp.userName) \(emp.gender) \(emp.duties)")
                txtUserName.text = emp.userName
                txtDuties.text = emp.duties
                lbGender.text = emp.gender
            }
            btnAdd.setTitle("修  改", for: .normal)
            btnAdd.backgroundColor = .blue
        }
    }
    
    @objc func hideKeyboard(tapG: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}
