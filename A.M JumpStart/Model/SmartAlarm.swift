//
//  SmartAlarm.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/17/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation
import RealmSwift


class SmartAlarm: SystemAlarm{
    
    @objc dynamic var alarmName : String = ""
    @objc dynamic var destination : Destination?
    @objc dynamic var origin : Destination?
    var activites = List<TravelTask>()
    @objc dynamic var departureTime: Date = Date()
    @objc dynamic var desiredArrivalTime: Date = Date()
    
    convenience init(title: String) {
        self.init(title: title)
        self.alarmName  = title
        
    }
    
    
    
}
