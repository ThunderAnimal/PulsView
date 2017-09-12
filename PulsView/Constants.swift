//
//  File.swift
//  PulsView
//
//  Created by Martin Weber on 05.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation

public enum Constants{
    public static func bundle () -> String{
        return "de.mweber.uni.PulsView"
    }
    
    public enum General: Int {
        case onboardingApp, appDidEnterBackground
        
        public func key() -> String{
            switch self {
            case .onboardingApp:
                return "FIRST_START"
            case .appDidEnterBackground:
                return "APP_DID_ENTER_BACKGOUND"
            }
        }
    }
    
    public enum AppGroups: Int {
        case person_name
        
        public func key() -> String{
            switch self {
            case .person_name:
                return "group.de.mweber.uni"
            }
        }
    }
    
    public enum Person: Int {
        case name, last_name
        
        public func key() -> String{
            switch self {
            case .name:
                return "NAME"
            case .last_name:
                return "LAST_NAME"
            }
        }
    }
    
    public enum PushLocalNotification: Int {
        case identifier, title, body
        public func key() -> String {
            switch self {
            case .identifier:
                return "IDENTIFIER"
            case .title:
                return "TITLE"
            case .body:
                return "BODY"
            }
        }
    }
    
    public enum Puls: Int {
        case value
        public func key() -> String{
            switch self {
            case .value:
                return "PULS_DATA"
            }
        }
    }
    
    public enum NotificationCategory: Int{
        case happytrack_needed, general
        public func indentifier() -> String{
            switch self {
            case .general:
                return "GENERAL"
            default: return ""
            }
        }
    }
    
    public enum WatchNotification: Int {
        case contextReceived, newPulsData,  dataAdded
        
        public func key() -> String{
            switch self {
            case .contextReceived:
                return "NotificationContextReceived"
            case .newPulsData:
                return "NotificationNewPulsData"
            default: return ""
            }
        }
    }
    
}
