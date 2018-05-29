//
//  ViewController.swift
//  AlarmTest
//
//  Created by Xavier Davis on 5/28/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var noteSoundEffect : AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let center = UNUserNotificationCenter.current()
      
        center.delegate = self
        center.removeAllPendingNotificationRequests()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        
            if let error = error {
                print(error)
            }else {
                print("Access granted!")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                                title: "Leave me alone!",
                                                options: UNNotificationActionOptions(rawValue: 0))
        
        let awakeAction = UNNotificationAction(identifier: "Cancel",
                                                 title: "I'm Up already!",
                                                 options: UNNotificationActionOptions(rawValue: 0))
        
        
        
        
        // Define the notification type
        let alarmCategory =
            UNNotificationCategory(identifier: "ALARM",
                                   actions: [snoozeAction, awakeAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .hiddenPreviewsShowSubtitle)
        
        
        center.setNotificationCategories([alarmCategory])
        
       let content = UNMutableNotificationContent()
        content.title = "Time to get up!"
        content.body = "The alarm you set is on!"
//        content.sound = UNNotificationSound.
        content.sound = UNNotificationSound(named: "analog-watch-alarm_daniel-simion.wav")
        content.categoryIdentifier = "ALARM"
        
        
        
        
        var date = DateComponents()
        date.hour = 18
        date.minute = 17
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
    
        let request = UNNotificationRequest.init(identifier: "Test", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if (error != nil){
                print(error)
            }else{
                print("request Successful...")
             
            }
        }
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
        
        let url = Bundle.main.url(forResource: "analog-watch-alarm_daniel-simion", withExtension:"wav")!
        
        do {
           noteSoundEffect = try AVAudioPlayer(contentsOf: url)
            noteSoundEffect?.play()
            noteSoundEffect?.numberOfLoops = -1

        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "Snooze":
            print("Snooze button selected...")
            noteSoundEffect?.stop()
        default:
            print("Stop action seleceted...")
            noteSoundEffect?.stop()
        }
        
        completionHandler()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

