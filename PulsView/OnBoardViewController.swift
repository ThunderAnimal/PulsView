//
//  OnBoardViewController.swift
//  PulsView
//
//  Created by Martin Weber on 05.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import UIKit

class OnBoardViewController: UIViewController{
    @IBOutlet weak var nameBorder: UIView!
    @IBOutlet weak var lastnameBorder: UIView!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputLastname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUI(){
        let shareDefaults = UserDefaults(suiteName: Constants.AppGroups.person_name.key())
        
        inputName.text = shareDefaults?.string(forKey: Constants.Person.name.key())
        inputLastname.text = shareDefaults?.string(forKey: Constants.Person.last_name.key())
    }
    
    private func finishOnBoarding(){
        UserDefaults().set(true, forKey: Constants.General.onboardingApp.key())
        
        self.sendUserDataToWatch()
        self.sendWelcomeMessageToWatch()
    }
    
    @IBAction func startEditName(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.nameBorder.backgroundColor = AppColor().primaryColor
        }
        
        
    }
    @IBAction func entEdirName(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.nameBorder.backgroundColor = UIColor.lightGray
        }
        
        if let shareDefaults = UserDefaults(suiteName: Constants.AppGroups.person_name.key()){
            shareDefaults.set(inputName.text, forKey: Constants.Person.name.key())
        }
    }
    
    @IBAction func startEditLastname(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.lastnameBorder.backgroundColor = AppColor().primaryColor        }
        
    }
    @IBAction func endEditLastname(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.lastnameBorder.backgroundColor = UIColor.lightGray
        }
        
        if let shareDefaults = UserDefaults(suiteName: Constants.AppGroups.person_name.key()){
            shareDefaults.set(inputLastname.text, forKey: Constants.Person.last_name.key())
        }
        
    }
    
    @IBAction func clickReady(_ sender: Any) {
        self.finishOnBoarding()
    }
    
    private func sendUserDataToWatch (){
        let data = AppComponent.instance.getDataController().getDataSendPerson()
        
        AppComponent.instance.getWatchConnectivityController().sendData(data: data, callback:
            {(success, errMsg) -> Void in
                if(!success){
                    print(errMsg)
                }
        })
    }
    
    private func sendWelcomeMessageToWatch(){
        let shareDefaults = UserDefaults(suiteName: Constants.AppGroups.person_name.key())
        
        let data = [
            Constants.PushLocalNotification.identifier.key(): "WELCOME",
            Constants.PushLocalNotification.title.key(): "Hey " + shareDefaults!.string(forKey: Constants.Person.name.key())!,
            Constants.PushLocalNotification.body.key(): "Welcome to Pulsview. You are AWESOME!"]
        
        
        AppComponent.instance.getWatchConnectivityController().sendData(data: data, callback:
            {(success, errMsg) -> Void in
                if(!success){
                    print(errMsg)
                }
        })
    }
    
}
