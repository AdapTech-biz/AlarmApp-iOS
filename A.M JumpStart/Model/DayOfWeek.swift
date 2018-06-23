//
//  DayOfWeek.swift
//  AlarmTest
//
//  Created by Xavier Davis on 6/17/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation


class DayofWeek {
    
    let day : String
    var selected : Bool = false
    let dayEnum : DaysofWeek
    
    
    init(day: DaysofWeek) {
        self.day = day.description
        self.dayEnum = day
    }
    
   
    
}
