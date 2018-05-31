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
import HGPlaceholders
import PopupDialog

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: TableView!
    
    var alarm : Alarm?
    var noteSoundEffect : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "customCell")

        
        alarm = Alarm()

        //assign Nofication Center delegate to self
        if let alarm = alarm{
            //get Notification Center object
            let center = alarm.center
            center.removeAllPendingNotificationRequests()
            
            center.delegate = self
            
            //get user access to user Notifcation center
            alarm.getNotificationAccess(to: center)
            
            let firstAction = alarm.makeAlertAction(withTitle: "Snooze", withIdentifier: "SNOOZE")
                alarm.notificationActions.append(firstAction)
            let secondAction = alarm.makeAlertAction(withTitle: "Decline", withIdentifier: "DECLINE")
                alarm.notificationActions.append(secondAction)
            
            let alarmCategory = alarm.createAlermCategory(withTitle: "SleeperAlarm", actions: alarm.notificationActions)
    
    
            center.setNotificationCategories([alarmCategory])
            
//          call Alarm class to get content var
            let content = alarm.content
            content.title = "Time to get up!"
            content.body = "The alarm you set is on!"
            //        content.sound = UNNotificationSound.
            content.sound = UNNotificationSound(named: "analog-watch-alarm_daniel-simion.wav")
            content.categoryIdentifier = "ALARM"
            
            var date = DateComponents()
            date.hour = 20
            date.minute = 00
            
            var trigger = alarm.trigger
            trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
    
            let request = UNNotificationRequest.init(identifier: "Test", content: content, trigger: trigger)
    
            center.add(request) { (error) in
                if let error = error {
                    print(error)
                }else{
                    print("request Successful...")
    
                }
            }

        }
        
    }
    
    //MARK: Button Press Action
       ///////////////////////////////////////////////////////////////////
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        // Prepare the popup assets
        let title = "Type of Alarm"
        let message = "You have options: "
        let image = UIImage(named: "popUpImage")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        popup.transitionStyle = .fadeIn
        popup.shake()
        
        // Create buttons
        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        
        // This button will not the dismiss the dialog
        let buttonTwo = DefaultButton(title: "Smart Alarm") {
            print("Smart alarm picked")
        }
        buttonTwo.buttonHeight = 100
        
        let buttonThree = DestructiveButton(title: "Old-Fashion", height: 60) {
            print("Still old fashion")
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonTwo, buttonThree, buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    
    
       ///////////////////////////////////////////////////////////////////
 
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}


extension ViewController: UNUserNotificationCenterDelegate, UITableViewDelegate, UITableViewDataSource, PlaceholderDelegate{
    
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        tableView.showDefault()
    }
    

    //TODO: UserNotificationCenter Delegate Methods
    ///////////////////////////////////////////////////////////////////
    
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
    
    //////////////////////////////////////////////////////////////////
    
   
    
    //TODO: UITableView Delegate Methods
    ///////////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    //////////////////////////////////////////////////////////////////
    
}



