//
//  SmartAlarm.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/17/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation


class SmartAlarm: SystemAlarm{
    
    var alarmName: String?
    var destination: [String: String]?
    var origin: [String: String]?
    var activites = [TravelTask]()
    var departureTime: Date?
    var desiredArrivalTime: Date?
    
    override init(title: String) {
        self.alarmName  = title
        super.init(title: title)
    }
    
    
}
