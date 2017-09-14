//
//  PulsDataMeasureEntity.swift
//  PulsView
//
//  Created by Martin Weber on 14.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class PulsDataMeasureEntity:Object {
    dynamic var date = Date()
    dynamic var dateStr = ""
    dynamic var timeStr = ""
    
    open let pulsData = List<PulsDataEntity>()
    
    convenience init(date:Date){
        self.init()
        
        self.date = date
        self.dateStr = getFormatDate(date: date)
        self.timeStr = getFormatTime(date: date)
        
    }
    
    private func getFormatTime(date:Date)-> String{
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        var stringMinutes = String(minutes)
        if(minutes < 10){
            stringMinutes = "0" + stringMinutes
        }
        var stringHours = String(hour)
        if(hour < 10){
            stringHours = "0" + stringHours
        }
        
        return stringHours + ":" + stringMinutes
    }
    
    private func getFormatDate(date:Date)-> String{
        let dateFormatDay = DateFormatter()
        dateFormatDay.dateFormat = "dd.MM.yyyy"
        
        return dateFormatDay.string(from: date)
    }
    
    func addPulsData(date:Date, value:Int){
        let puls = PulsDataEntity(date: date, value: value)
        self.pulsData.append(puls)
    }
}
