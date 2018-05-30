//
//  Alarm.swift
//  AlarmTest
//
//  Created by Xavier Davis on 5/30/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation
import UserNotifications
import AVFoundation

class Alarm{
    
    let center : UNUserNotificationCenter
    let content : UNMutableNotificationContent
    var trigger : UNCalendarNotificationTrigger?
    var request : UNNotificationRequest?
    var notificationActions = [UNNotificationAction]()
    var delegate : UNUserNotificationCenterDelegate?
    
    
    init() {
        center = UNUserNotificationCenter.current()
        content = UNMutableNotificationContent()
        
    }

    
    
    //MARK: Request Access Notification Center
    //////////////////////////////////////////////////////////////////
    
    func getNotificationAccess(to center: UNUserNotificationCenter){
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
            if let error = error {
                print(error)
            }else {
                print("Access granted!")
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////
    
    //MARK: Construct Alarm Components
    //////////////////////////////////////////////////////////////////
    
    func createAlermCategory(withTitle title: String, actions: [UNNotificationAction]) -> UNNotificationCategory{
        
        
        let alarmCategory =
            UNNotificationCategory(identifier: title,
                                   actions: actions,
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .hiddenPreviewsShowSubtitle)
        
        return alarmCategory
        
    }
    
    func makeAlertAction(withTitle title: String, withIdentifier id: String) -> UNNotificationAction{
        
        let notificationAction = UNNotificationAction(identifier: id,
                                                      title: title,
                                                      options: UNNotificationActionOptions(rawValue: 0))
        
        return notificationAction
        
    }
    
    ///////////////////////////////////////////////////////////////////
    
    
    

    
    
}

