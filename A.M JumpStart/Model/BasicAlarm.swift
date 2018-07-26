//
//  BasicAlarm.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/23/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation
import RealmSwift

class BasicAlarm: Object {
    
   @objc dynamic var title = ""{
        didSet{
            systemAlarmComponent = SystemAlarmComponent(alarmModel: self)
        }
    }
     @objc dynamic var alarmHour : Int = 0
     @objc dynamic var alarmMin : Int = 0
     @objc dynamic var isRepeatable : Bool = false
     @objc dynamic var isSmart : Bool = false
     var weeklySchedule = List<DayofWeek>()
     @objc dynamic var alarmTime = Date(){
        willSet{
            alarmHour = Calendar.current.component(.hour, from: newValue)
            alarmMin = Calendar.current.component(.minute, from: newValue)
        }
    }
    
    var systemAlarmComponent: SystemAlarmComponent?
    
}
