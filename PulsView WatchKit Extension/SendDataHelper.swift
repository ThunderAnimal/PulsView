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
    
    public func sendMeasureState(measureState: Bool){
        //SEND DATA
        if WCSession.isSupported()  {
            do{
                try WCSession.default().updateApplicationContext([Constants.Puls.isMeasure.key() : measureState])
            }catch{
                print("ERROR SEND DATA - MEASURESATE")
            }
        }
    }
    
    public func sendPulsData(puls: Int){
        if WCSession.isSupported(){
            do{
                try WCSession.default().updateApplicationContext([Constants.Puls.value.key(): puls])
            }catch{
                print("ERROR SEND DATA - PULSDATA")
            }
        }
    }
}
