//
//  ExtensionDelegate.swift
//  PulsView WatchKit Extension
//
//  Created by Martin Weber on 31.07.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import WatchKit
import WatchConnectivity
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, UNUserNotificationCenterDelegate {

    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        setupWatchConnectivity()
        setUpNotifications()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }
    
    fileprivate func setupWatchConnectivity(){
        guard WCSession.isSupported() else{
            return
        }
        
        let session = WCSession.default()
        session.delegate = self
        session.activate()
    }
    
    fileprivate func setUpNotifications(){
        let center = UNUserNotificationCenter.current()
        let notificationHelper = NotificationHelper()
        
        //Handel delgeation when App is in forground
        center.delegate = self
        
        //Authorized for local Notifications
        center.requestAuthorization(options: [.alert, .sound, .badge,.carPlay,UNAuthorizationOptions.init(rawValue: 0)]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        ///Create Categories with actions
        notificationHelper.initSetUpNotifications()
        
        notificationCenter.addObserver(forName: NSNotification.Name(Constants.WatchNotification.newPulsData.key()), object: nil, queue: nil) { (notification) in
            if let puls = notification.userInfo?[Constants.Puls.value.key()] as? Int{
                print(puls)
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        //Receive UserName
        if let name = userInfo[Constants.Person.name.key()] as? String,
            let lastname = userInfo[Constants.Person.last_name.key()] as? String {
            
            let userDefaults = UserDefaults.standard
            
            userDefaults.set(lastname, forKey: Constants.Person.last_name.key())
            userDefaults.set(name, forKey: Constants.Person.name.key())
            
            NotificationCenter.default.post(name: NSNotification.Name(Constants.WatchNotification.contextReceived.key()), object: nil)
        }
        
        //Receive PushNotification
        if let identifier = userInfo[Constants.PushLocalNotification.identifier.key()] as? String,
            let title = userInfo[Constants.PushLocalNotification.title.key()] as? String,
            let body = userInfo[Constants.PushLocalNotification.body.key()] as? String{
            
            let notificationHelper = NotificationHelper()
            notificationHelper.pushLocalNotification(identifier: identifier, title: title, body: body)
        }
    }
    
    //Will triggerd by Notification an App is in Forground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //Also show Notification
        completionHandler(UNNotificationPresentationOptions.alert)
    }

}
