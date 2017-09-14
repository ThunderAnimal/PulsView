//
//  PulsDataEntity.swift
//  PulsView
//
//  Created by Martin Weber on 14.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class PulsDataEntity: Object{
    dynamic var date = Date()
    dynamic var value = 0
    
    convenience init(date:Date, value:Int){
        self.init()
        
        self.date = date
        self.value = value
    }
}
