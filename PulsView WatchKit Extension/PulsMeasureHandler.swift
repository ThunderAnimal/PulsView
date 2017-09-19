//
//  PulsMeasureHandler.swift
//  PulsView
//
//  Created by Martin Weber on 17.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation

class PulsMeasureHandler {
    public static let shared = PulsMeasureHandler()
    
    private let sendDataHelper = SendDataHelper()
    
    private init(){}
    
    
    private var startMeasureTime: Date?
    
    public func startMeasure(){
        startMeasureTime = Date()
        sendDataHelper.sendMeasureState(startMeasureTime: self.startMeasureTime!, measureState: true)
        
    }
    
    public func stopMeasure(){
        sendDataHelper.sendMeasureState(startMeasureTime: self.startMeasureTime!, measureState: false)
        startMeasureTime = nil
    }
    
    public func newPulsData(puls: Int){
        
        NotificationCenter.default.post(name: NSNotification.Name(Constants.WatchNotification.newPulsData.key()), object: nil, userInfo: [Constants.Puls.value.key(): puls])
        sendDataHelper.sendPulsData(startMeasureTime: self.startMeasureTime!, measurePulsTime: Date(), puls: puls)
    }
    
}
