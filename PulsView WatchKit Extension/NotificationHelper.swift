//
//  NotificationHelper.swift
//  PulsView
//
//  Created by Martin Weber on 05.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import WatchKit
import UserNotifications

class NotificationHelper: NSObject {
    
    public func initSetUpNotifications(){
        let generalCategory = UNNotificationCategory(identifier: Constants.NotificationCategory.general.indentifier(),actions: [],intentIdentifiers: [],options: .customDismissAction)
        
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([generalCategory])
        
    }
    
    
    public func pushLocalNotification(identifier: String, title:String, body:String){
        
        let dateNow = Date()
        let dateNowString = DateFormatter()
        dateNowString.dateFormat = "y-MM-dd H:m:ss.SSSS"
        
        let DateIdentifier = identifier + "_" + dateNowString.string(from: dateNow)
        
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = Constants.NotificationCategory.general.indentifier()
        
        content.sound = UNNotificationSound.default()
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: DateIdentifier, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if((error) != nil){
                print("Problems to push Notification")
            }
        }
    }
    
}
