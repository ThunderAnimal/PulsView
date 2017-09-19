//
//  SendDataHelper.swift
//  PulsView
//
//  Created by Martin Weber on 14.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import WatchConnectivity

class SendDataHelper{
    
    public func sendMeasureState(startMeasureTime: Date, measureState: Bool){
        let data = [
            Constants.Puls.measureStartTime.key(): startMeasureTime,
            Constants.Puls.isMeasure.key() : measureState] as [String : Any]
        if(WCSession.isSupported()){
            WCSession.default().transferUserInfo(data)
        }
    }
    
    public func sendPulsData(startMeasureTime: Date, measurePulsTime: Date, puls: Int){
        let data = [
            Constants.Puls.measureStartTime.key(): startMeasureTime,
            Constants.Puls.pulsTime.key(): measurePulsTime,
            Constants.Puls.value.key(): puls
        ] as [String : Any] 
        if(WCSession.isSupported()){
            WCSession.default().transferUserInfo(data)
        }
    }
}
