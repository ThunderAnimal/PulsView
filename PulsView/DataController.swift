//
//  DataController.swift
//  PulsView
//
//  Created by Martin Weber on 05.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
class DataController{
    
    public func getDataSendPerson() -> [String:Any]{
        if let shareDefaults = UserDefaults(suiteName: Constants.AppGroups.person_name.key()){
            let data = [
                Constants.Person.name.key(): shareDefaults.string(forKey: Constants.Person.name.key())!,
                Constants.Person.last_name.key(): shareDefaults.string(forKey: Constants.Person.last_name.key())!,
                ]
            return data
        }else{
            return [String:Any]()
        }
    }
}
