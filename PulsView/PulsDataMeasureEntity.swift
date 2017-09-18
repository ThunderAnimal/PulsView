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
    dynamic var id = PulsDataMeasureEntity.generateId(date: Date())
    dynamic var date = Date()
    dynamic var dateStr = ""
    dynamic var timeStr = ""
    
    open let pulsData = List<PulsDataEntity>()
    
    convenience init(date:Date){
        self.init()
        
        self.id = PulsDataMeasureEntity.generateId(date: date)
        self.date = date
        self.dateStr = getFormatDate(date: date)
        self.timeStr = getFormatTime(date: date)
        
    }
    
    class func generateId(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd_H:m:ss.SSSS"
        return dateFormat.string(from: date)
    }
    
    override open class func primaryKey() -> String {
        return "id"
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
    
    func getMaxPuls()->Int{
        if let max = (pulsData.map{ $0.value }.max()){
            return max
        }else{
            return 0
        }
    }
    func getMinPuls()->Int{
        if let min = ( pulsData.map{ $0.value }.min()){
            return min
        }else{
            return 0
        }
    }
}
