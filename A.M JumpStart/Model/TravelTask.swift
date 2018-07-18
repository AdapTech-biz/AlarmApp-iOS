//
//  TravelTask.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/17/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation
import RealmSwift


class TravelTask: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var taskDuration: Int = 0
    var parentAlarm = LinkingObjects(fromType: SmartAlarm.self, property: "activites")
    
    
    convenience init(title: String) {
        self.init(title: title)
        self.title = title
    }
}
