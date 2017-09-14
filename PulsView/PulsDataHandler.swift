//
//  PulsDataEntityHandler.swift
//  PulsView
//
//  Created by Martin Weber on 14.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


class PulsDataHandler: NSObject{

    private func getPulsMeasureForDate(date:Date) -> PulsDataMeasureEntity{
        let realm = try! Realm()
        let predicate = NSPredicate(format: "date = %@", date as CVarArg)
        let results = realm.objects(PulsDataMeasureEntity.self).filter(predicate)
        
        if let entry = results.first{
            return entry
        }else{
            let entry =  PulsDataMeasureEntity(date: date)
            try! realm.write {
                realm.add(entry, update: true)
            }
            return entry
        }
    }
    
    public func addPuls(dateMeasure:Date, datePuls:Date, value:Int){
        let realm = try! Realm()
        let entry = self.getPulsMeasureForDate(date: dateMeasure)
        
        try! realm.write {
            entry.addPulsData(date: datePuls, value: value)
        }
    }
}
