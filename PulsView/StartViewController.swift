//
//  StartViewController.swift
//  HappyTrack
//
//  Created by Martin Weber on 02.08.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var vornameInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Load Data from Group Store
        if let shareDefaults = UserDefaults(suiteName: "group.de.mweber.uni"){
            if let name = shareDefaults.string(forKey: "name"){
                nameInput.text = name
            }
            if let vorname = shareDefaults.string(forKey: "vorname"){
                vornameInput.text = vorname
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUI(){
        
    }
    
    @IBAction func clickSaveButton(_ sender: Any) {
        self.dismissKeyboard()
        
        //SAVE Data in Group Store
        if let shareDefaults = UserDefaults(suiteName: "group.de.mweber.uni"){
            let name = nameInput.text
            let vorname = vornameInput.text
            
            shareDefaults.set(name, forKey: "name")
            shareDefaults.set(vorname, forKey: "vorname")
            
            shareDefaults.synchronize()
            
            self.showToast(message: "Saved Data!")
        }else {
            let alert = UIAlertController(title: "Error - Save", message: "Sorry somthing went went wrong... ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
}
