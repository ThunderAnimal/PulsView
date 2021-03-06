//
//  AppDelegate.swift
//  HappyTrack
//
//  Created by Martin Weber on 31.07.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import UIKit
import WatchKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    
    var window: UIWindow?
    let watchConnectivityController = AppComponent.instance.getWatchConnectivityController()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //----- Set Up UI -------
        self.setUpAppearance()
        
        //----- INIT WCSession
        watchConnectivityController.iniSession(delegate: self)
        
        //GET Permission Notifications
        AppComponent.instance.getNotificationController().initNotificationSetupCheck()
        
        //GET Permission HealthStore
        AppComponent.instance.getHealthController().enableHealthKit(completion: nil)
        
        //----- CHECK IF first Start
        let userDefaults = UserDefaults()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(!userDefaults.bool(forKey: Constants.General.onboardingApp.key())){
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "OnBoardingScreen")
        }else{
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "StartAppScreen")
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        NotificationCenter.default.post(name: NSNotification.Name(Constants.General.appDidEnterBackground.key()), object: nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //WCSession Delegate
    
    /**
     Receive Data
     */
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let measureStartTime = userInfo[Constants.Puls.measureStartTime.key()] as? Date,
            let pulsTime = userInfo[Constants.Puls.pulsTime.key()] as? Date,
            let pulsVvalue = userInfo[Constants.Puls.value.key()] as? Int{
            
            AppComponent.instance.getPulsDataHandle().addPuls(dateMeasure: measureStartTime, datePuls: pulsTime, value: pulsVvalue)
            
            let userDefaults = UserDefaults()
            userDefaults.set(pulsVvalue, forKey: Constants.Puls.value.key())
            userDefaults.set(pulsTime, forKey: Constants.Puls.pulsTime.key())
            userDefaults.synchronize()
            
            NotificationCenter.default.post(name: NSNotification.Name(Constants.WatchNotification.newPulsData.key()), object: nil)
        }
        if let isMeasure = userInfo[Constants.Puls.isMeasure.key()] as? Bool,
            let measureStartTime = userInfo[Constants.Puls.measureStartTime.key()] as? Date{
            let userDefaults  = UserDefaults()
            userDefaults.set(measureStartTime, forKey: Constants.Puls.measureStartTime.key())
            userDefaults.set(isMeasure, forKey: Constants.Puls.isMeasure.key())
            userDefaults.synchronize()
            
            NotificationCenter.default.post(name: NSNotification.Name(Constants.WatchNotification.changeMeasureState.key()), object: nil)
        }
    }
    
    /**
     Receive Message
     */
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    }
    
    /**
     Receive Context
     */
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?){
        
    }
    func sessionDidBecomeInactive(_ session: WCSession){
        
    }
    func sessionDidDeactivate(_ session: WCSession){
        
    }
    
    
    //OWN FUNCTIONS
    
    /**
     Sets the main appearance of the App
     */
    private func setUpAppearance(){
        let myAppColor = AppColor()
        
        //Button and Link Color
        self.window?.tintColor = myAppColor.primaryColor
        
        //Navigation Bar
        UINavigationBar.appearance().tintColor = myAppColor.textColorLight
        UINavigationBar.appearance().barTintColor = myAppColor.primaryColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: myAppColor.textColorLight]
        
        //Naviagtion Bar Shadow
        UINavigationBar.appearance().castShadow = ""
        
        //Text Color
        //UILabel.appearance().textColor = myAppColor.textColorDark
        
        //Status Bar
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Show Statusbar
        UIApplication.shared.setStatusBarHidden(false, with: .slide)
    }
    
}

