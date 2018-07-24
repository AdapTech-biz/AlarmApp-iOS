//
//  DayOfWeek.swift
//  AlarmTest
//
//  Created by Xavier Davis on 6/17/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation
import RealmSwift


class DayofWeek: Object {
    
   @objc dynamic var day : String = ""
    @objc dynamic var selected : Bool = false
    @objc dynamic var dayToInt : Int = -1

    var parentAlarm = LinkingObjects(fromType: BasicAlarm.self, property: "weeklySchedule") //retro relationship to Category -- looks up items variable
   
    convenience init (day: DaysofWeek){
        self.init()
        self.day = day.description
        self.dayToInt = day.dateComponentValue
    }
}
