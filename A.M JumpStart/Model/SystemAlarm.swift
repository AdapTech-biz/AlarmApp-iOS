//
//  Alarm.swift
//  AlarmTest
//
//  Created by Xavier Davis on 5/30/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import AVFoundation
import RealmSwift

class SystemAlarm: Object{
    
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var requests = [UNNotificationRequest]()
    var notificationActions = [UNNotificationAction]()
    @objc dynamic var alarmTitle : String = ""
    var weeklySchedule = Set<Int>()
    @objc dynamic var alarmTime = Date(){
        willSet{
            alarmHour = Calendar.current.component(.hour, from: newValue)
            alarmMin = Calendar.current.component(.minute, from: newValue)
        }
    }
    @objc dynamic var alarmHour : Int = 0
    @objc dynamic var alarmMin : Int = 0
    @objc dynamic var isRepeatable : Bool = false
    
    
   convenience init(title: String ) {
        self.init()
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
    
    func getNotificationAccess(){
        
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
    
    
    //Create Date from picker selected value.
    func createAlarm(from timePicker: UIDatePicker){
        
        let calendar = Calendar(identifier: .gregorian)
        var calendarUnitFlags = Set<Calendar.Component>()
        calendarUnitFlags.insert(.weekday)
        calendarUnitFlags.insert(.hour)
        calendarUnitFlags.insert(.minute)
        var dateComponents = NSCalendar.current.dateComponents(calendarUnitFlags, from: timePicker.date)
        
        
        let currentDate = Date()
        let year = Calendar.current.component(.year, from: currentDate)
        var components = DateComponents()
        components.hour = dateComponents.hour!
        components.minute = dateComponents.minute!
        components.year = year
        components.weekOfYear = Calendar.current.component(.weekOfYear, from: Date())
        components.month = Calendar.current.component(.month, from: Date())
        components.timeZone = .current
        
//        guard let weeklySechedule = weeklySchedule else { fatalError() }
        
        if (!weeklySchedule.isEmpty){
            for day in weeklySchedule{
                
                components.weekday = day // sunday = 1 ... saturday = 7
                
            let createdDate = calendar.date(from: components)!
            registerAlarm(for: createdDate, isrepeated: isRepeatable)
            }
        }else{
           
            var weekday = calendar.component(.weekday, from: currentDate)
            
            if(timePicker.date < currentDate){
                switch (weekday){
                case 1...6: weekday += 1
                default: weekday = 1
                }
            }
            components.weekday = weekday
            let createdDate = calendar.date(from: components)!
           registerAlarm(for: createdDate, isrepeated: isRepeatable)
        }
        
       
    }
    
   public func registerAlarm(for date:  Date, isrepeated: Bool)  {
        
        //get user access to user Notifcation center
        getNotificationAccess()
   
        let triggerDate = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
        alarmHour = triggerDate.hour!
        alarmMin = triggerDate.minute!
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: isrepeated)
        
        let request = UNNotificationRequest(identifier: alarmTitle, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
                fatalError()
            }else{
                self.requests.append(request)
                
            }
        }
        
    }
    
    func cancelAllPendingAlarms()  {
        center.removeAllPendingNotificationRequests()
    }

    
    
}

