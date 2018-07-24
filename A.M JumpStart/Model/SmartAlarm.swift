//
//  SmartAlarm.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/17/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift


class SmartAlarm: BasicAlarm{
    
    var destination = Destination()
    var origin = Destination()
    var activites : Variable<[TravelTask]> = Variable([])
    @objc dynamic var departureTime: Date = Date()
    @objc dynamic var timeToDestination = 0
    @objc dynamic var totalTimeForPreTravel = 0{
        willSet{
            totalTimeNeededToTravel = newValue + timeToDestination
        }
    }
    @objc dynamic var totalTimeNeededToTravel = 0
    @objc dynamic var desiredArrivalTime: Date = Date()
//    var delegate : SmartAlarmCreatedDelegate?
    
    convenience init(title: String) {
        self.init()
        self.title = title
        
    }
    
    
    
}
