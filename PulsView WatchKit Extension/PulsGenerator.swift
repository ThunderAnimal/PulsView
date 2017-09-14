//
//  PulsGenerator.swift
//  PulsView
//
//  Created by Martin Weber on 06.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import UserNotifications

class PulsGenerator{
    public static let shared = PulsGenerator()
    
    private var tickNewPulsData:DispatchSourceTimer!
    private var currentPulsItem: Int = 0
    
    private let tickNewPulsTimeSecoends = 10
    
    private let pulsSport = [61, 88,73,69,69,106,104,99,99,100,104,47,164,162,161,160,160,153,157,159,139,138,135,135,139,122,122,121,120,114,112,109,109,109,109,112,112,111,109,133,131,130,120,116,115,114,113,112,111,112,147,147,146,146,123,122,122,124,125,126,151,151,149,147,138,135,125,125,128,129,125,133,131,131,131,130,130,130,129,130,129,130,132,150,149,149,144,126,120,118]
    
    private let pulsWorkingOnPC = [56,56,55,62,59,55,54,54,53,54,54,53,51,51,54,52,52,51,52,54,55,55,55,63,62,61,59,59,52,51,51,52,57,58,58,57,54,54,54,54,56,60,62,65,68,68,68,69,57,57,59,62,60,58,58,57,57,57,57,57,58,59,59,60,61,63,60,59,59,60,58,59,59]
    
    private let pulsAfterWakeUp = [49,49,53,50,50,51,58,47,46,47,50,50,47,48,49,49,49,49,49,46,47,47,48,48,49,48,48,48,48,48,47,48,48,47,47,47,47,47,47,49,49,59,46,48]
    
    
    private init(){}
    
    public func startGeneratePulsSport(){
        self.startGeneratePulsData(pulsList: self.pulsSport)
    }
    
    public func startGeneratePulsWorkingOnPc(){
        self.startGeneratePulsData(pulsList: self.pulsWorkingOnPC)
    }
    
    public func startGeneratePulsCalm(){
        self.startGeneratePulsData(pulsList: self.pulsAfterWakeUp)
    }
    
    public func stopGenratePulsData(){
        tickNewPulsData?.cancel()
    }
    
    
    private func startGeneratePulsData(pulsList: [Int]){
        self.stopGenratePulsData() // Sicher gehen das vorherige Timer gestoppt sind
        self.currentPulsItem = 0
        
        let handletick = DispatchWorkItem {
            if(self.currentPulsItem >= pulsList.count){
                self.currentPulsItem = 0
            }
            NotificationCenter.default.post(name: NSNotification.Name(Constants.WatchNotification.newPulsData.key()), object: nil, userInfo: [Constants.Puls.value.key(): pulsList[self.currentPulsItem]])
            SendDataHelper.init().sendPulsData(puls: pulsList[self.currentPulsItem])
            
            self.currentPulsItem = self.currentPulsItem + 1
        }
        
        tickNewPulsData = DispatchSource.makeTimerSource()
        tickNewPulsData.scheduleRepeating(deadline: .now(), interval: .seconds(self.tickNewPulsTimeSecoends))
        tickNewPulsData.setEventHandler(handler: handletick)
        tickNewPulsData.resume()
        
    }
}
