//
//  SettingViewController.swift
//  PulsView
//
//  Created by Martin Weber on 05.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0

class SettingViewController: UITableViewController{
    
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputLastname: UITextField!
    @IBOutlet weak var labelBirthday: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = (indexPath as NSIndexPath)
        
        if(index.section == 0){ //Secetion Genereal
            if(index.row == 0){ //Name
                inputName.becomeFirstResponder()
            }else if(index.row == 1){ //Lastname
                inputLastname.becomeFirstResponder()
            }else if(index.row == 2){ //Birthday
                self.dismissKeyboard()
                self.showDatePicker(sender: tableView, indexPath: indexPath)
                
            }
        }
    }
    
    @IBAction func changeName(_ sender: UITextField) {
        if let shareDefaults = UserDefaults(suiteName: Constants.AppGroups.person_name.key()){
            shareDefaults.set(sender.text, forKey: Constants.Person.name.key())
        }
        sendNameToWatch()
    }
    @IBAction func changeLastname(_ sender: UITextField) {
        if let shareDefaults = UserDefaults(suiteName: Constants.AppGroups.person_name.key()){
            shareDefaults.set(sender.text, forKey: Constants.Person.last_name.key())
        }
        sendNameToWatch()
    }
    
    private func showDatePicker(sender: UITableView, indexPath: IndexPath){
        let shareDefault = UserDefaults(suiteName: Constants.AppGroups.person_name.key())
        
        let date = shareDefault?.value(forKey: Constants.Person.birthday.key()) as? Date ?? Date()
        
        
        let datePicker = ActionSheetDatePicker(title: "Birthday", datePickerMode: UIDatePickerMode.date, selectedDate:  date, doneBlock: {
            picker, value, index in
            
            shareDefault?.set(value as? Date, forKey: Constants.Person.birthday.key())
            self.updateUI()
            sender.deselectRow(at: indexPath, animated: true)
            return
        }, cancel: { ActionStringCancelBlock in
            sender.deselectRow(at: indexPath, animated: true)
            return
        }, origin: sender.superview!.superview)
        
        datePicker?.maximumDate = Date()
        datePicker?.toolbarButtonsColor = AppColor().primaryColor
        datePicker?.show()
    }
    
    private func updateUI(){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.yyyy"
        
        let shareDefaults = UserDefaults(suiteName: Constants.AppGroups.person_name.key())
        
        inputName.text = shareDefaults?.string(forKey: Constants.Person.name.key())
        inputLastname.text = shareDefaults?.string(forKey: Constants.Person.last_name.key())
        
        if let date = shareDefaults?.value(forKey: Constants.Person.birthday.key()) as? Date {
            labelBirthday.text = dateFormat.string(from: date)
        }else{
            labelBirthday.text = "--.--.----"
        }
    }
    
    
    private func sendNameToWatch(){
        let data = AppComponent.instance.getDataController().getDataSendPerson()
        
        AppComponent.instance.getWatchConnectivityController().sendData(data: data, callback:
            {(success, errMsg) -> Void in
                if(!success){
                    print(errMsg)
                }
        })
    }
}
