//
//  NotificationController.swift
//  PulsView
//
//  Created by Martin Weber on 05.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationController {
    
    public func initNotificationSetupCheck(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if(success){
                print("Permission Granted")
            }else{
                print("There was a problem!")
            }
        }
    }
    
}
