//
//  File.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/20/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation

protocol ClassicAlarmCreatedDelegate {
    func newAlarmCreated(createdAlarm: SystemAlarm)
}

protocol SmartAlarmCreatedDelegate {
    
    func newSmartCreated(newSmartAlarm: SmartAlarm)
}
