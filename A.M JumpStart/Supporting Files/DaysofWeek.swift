//
//  DaysofWeek.swift
//  AlarmTest
//
//  Created by Xavier Davis on 5/30/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation


enum DaysofWeek: CustomStringConvertible{
    var description: String{
        switch self {
        // Use Internationalization, as appropriate.
        case .Monday: return "Monday"
        case .Tuesday: return "Tuesday"
        case .Wednesday: return "Wednesday"
        case .Thursday: return "Thursday"
        case .Friday: return "Friday"
        case .Saturday: return "Saturday"
        case .Sunday: return "Sunday"
        }
    }
    
    var dateComponentValue : Int{
        switch self {
        case .Sunday: return 1
        case .Monday: return 2
        case .Tuesday: return 3
        case .Wednesday: return 4
        case .Thursday: return 5
        case .Friday: return 6
        case .Saturday: return 7
        }
    }
    
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    static let allDays = [DaysofWeek.Sunday, DaysofWeek.Monday, DaysofWeek.Tuesday, DaysofWeek.Wednesday, DaysofWeek.Thursday,
                          DaysofWeek.Friday, DaysofWeek.Saturday]
}




