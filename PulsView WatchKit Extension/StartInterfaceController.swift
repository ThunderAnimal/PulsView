//
//  StartInterfaceController.swift
//  PulsView
//
//  Created by Martin Weber on 02.08.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import WatchKit

class StartInterfaceController: WKInterfaceController {
    
    @IBOutlet var labelWelcome: WKInterfaceLabel!
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        setupNotificationCenter()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    
        self.updateGUI()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
  
    @IBAction func clickButtonNormal() {
        PulsGenerator.shared.startGeneratePulsWorkingOnPc()
        self.showPulsView()
    }
    
    @IBAction func clickButtonReleax() {
        PulsGenerator.shared.startGeneratePulsCalm()
        self.showPulsView()
    }
    @IBAction func clickButtonSport() {
        PulsGenerator.shared.startGeneratePulsSport()
        self.showPulsView()
    }
    @IBAction func clickButtonMeasurePuls() {
        HealthKitHelper.shared.startMeasurePuls()
        self.showPulsView()
    }
    
    private func showPulsView(){
        self.presentController(withName: "PulsView", context: nil)
    }
    
    
    private func setupNotificationCenter(){
        notificationCenter.addObserver(forName: NSNotification.Name(Constants.WatchNotification.contextReceived.key()), object: nil, queue: nil, using: { _ in
            self.updateGUI()
        })
    }
    
    private func updateGUI(){
        if let name = UserDefaults.standard.string(forKey: Constants.Person.name.key()){
            if(name != nil){
                labelWelcome.setText("Hey " + name + ",")
            }
            
        }
    }
    
}
