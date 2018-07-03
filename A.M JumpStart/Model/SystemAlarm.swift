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

class SystemAlarm{
    
    let center : UNUserNotificationCenter
    let content : UNMutableNotificationContent
    var trigger : UNCalendarNotificationTrigger?
    var requests = [UNNotificationRequest]()
    var notificationActions = [UNNotificationAction]()
    var delegate : UNUserNotificationCenterDelegate?
    var alarmTitle : String
    var weeklySchedule : Set<DaysofWeek>?
    var alarmHour : Int = 0
    var alarmMin : Int = 0
    
    
    init(title: String ) {
        center = UNUserNotificationCenter.current()
        content = UNMutableNotificationContent()
        
        alarmTitle = title
        self.constructContent()
   
    }
    
    func constructContent(){
        
        let firstAction = makeAlertAction(withTitle: "Snooze", withIdentifier: "SNOOZE")
        notificationActions.append(firstAction)
        let secondAction = makeAlertAction(withTitle: "Decline", withIdentifier: "DECLINE")
        notificationActions.append(secondAction)
        
        let alarmCategory = createAlermCategory(withTitle: alarmTitle, actions: notificationActions)
        
        
        center.setNotificationCategories([alarmCategory])
        
        content.title = "Time to get up!"
        content.body = "The alarm you set is on!"
        content.sound = UNNotificationSound(named: "analog-watch-alarm_daniel-simion.wav")
        content.categoryIdentifier = "SleeperAlarm"
        
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

