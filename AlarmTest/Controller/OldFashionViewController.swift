//
//  OldFashionViewController.swift
//  AlarmTest
//
//  Created by Xavier Davis on 5/30/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import ChameleonFramework
import SCLAlertView

protocol AlarmCreatedDelegate {
    func newAlarmCreated(createdAlarm: Alarm)
}


class OldFashionViewController: UIViewController {
    
    //MARK: UIColor Scheme
    /////////////////////////////////////////////////////////////////

    let colors:[UIColor] = [
        UIColor.flatPurpleDark,
        UIColor.flatWhite
    ]
    /////////////////////////////////////////////////////////////////

    //MARK: UIOutlet Controllers
    /////////////////////////////////////////////////////////////////

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var reoccurringSwitch: UISwitch!
    /////////////////////////////////////////////////////////////////


    //MARK: Class Variables
    /////////////////////////////////////////////////////////////////

    var delegate : AlarmCreatedDelegate?
    var selectedDays = Set<DaysofWeek>()
    var colorArray = ColorSchemeOf(ColorScheme.complementary, color: FlatBlue(), isFlatScheme: true)
    var homeViewController : HomeViewController?
    /////////////////////////////////////////////////////////////////

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "DayOfWeekCell", bundle: nil), forCellReuseIdentifier: "dayCell")

        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: colors)
    }
    
    //MARK: IBAction Button Press
    //////////////////////////////////////////////////////////////
    
    @IBAction func setAlarmPressed(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: true
        )
        let alertViewIcon = UIImage(named: "alarmClockIcon")
        let alert = SCLAlertView(appearance: appearance)
        let text = alert.addTextField("Label for Alarm...")
        alert.addButton("Create") {
            var calendarUnitFlags = Set<Calendar.Component>()
            calendarUnitFlags.insert(.weekday)
            calendarUnitFlags.insert(.hour)
            calendarUnitFlags.insert(.minute)
            
            let dateComponents = NSCalendar.current.dateComponents(calendarUnitFlags, from: self.timePicker.date)
            
            print(self.selectedDays)
            if self.reoccurringSwitch.isOn
            {
                self.createAlarm(title: text.text!, for: dateComponents, weekdays: self.selectedDays)
                
            }else{
                self.createAlarm(title: text.text!, for: dateComponents, weekdays: nil)
            }
            
        }
        alert.showEdit("Name new alarm", subTitle: "Make it yours", circleIconImage: alertViewIcon)
        
  
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func repeatableSwitchClicked(_ sender: UISwitch) {
        
        self.tableView.isHidden = !sender.isOn
        
        
    }
    
    /////////////////////////////////////////////////////////////////
    
    //MARK: Functionality to create alarms
    /////////////////////////////////////////////////////////////////
    
    func createAlarm(title: String = "Alarm", for date:  DateComponents, weekdays: Set<DaysofWeek>?) {
        
        let alarm = Alarm(title: title)
        
        
        //assign Nofication Center delegate to self
        //get Notification Center object
        let center = alarm.center
        center.removeAllPendingNotificationRequests()
        
        center.delegate = homeViewController
        
        //get user access to user Notifcation center
        alarm.getNotificationAccess(to: center)
        
        let firstAction = alarm.makeAlertAction(withTitle: "Snooze", withIdentifier: "SNOOZE")
        alarm.notificationActions.append(firstAction)
        let secondAction = alarm.makeAlertAction(withTitle: "Decline", withIdentifier: "DECLINE")
        alarm.notificationActions.append(secondAction)
        
        let alarmCategory = alarm.createAlermCategory(withTitle: "SleeperAlarm", actions: alarm.notificationActions)
        
        
        center.setNotificationCategories([alarmCategory])
        
        let content = alarm.content
        content.title = "Time to get up!"
        content.body = "The alarm you set is on!"
        content.sound = UNNotificationSound(named: "analog-watch-alarm_daniel-simion.wav")
        content.categoryIdentifier = "SleeperAlarm"
        
        
        
        alarm.alarmHour = date.hour!
        alarm.alarmMin = date.minute!
        
        if let weekdays = weekdays{
            alarm.weeklySchedule = weekdays
            for day in weekdays{
                var newDate = date
                newDate.day = day.dateComponentValue
                let trigger = UNCalendarNotificationTrigger.init(dateMatching: newDate, repeats: false)
                
                let request = UNNotificationRequest.init(identifier: "Alarm \(day)", content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    if let error = error {
                        print(error)
                    }else{
                        print("Alarm created for \(newDate.day!)")
                       
                        
                        
                    }
                }
            }
        }else{
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
            
            let request = UNNotificationRequest.init(identifier: "Alarm 1", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                if let error = error {
                    print(error)
                }else{
                    print("Alarm created for today!")
                    
                    
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
        self.delegate?.newAlarmCreated(createdAlarm: alarm)
        
    }
    /////////////////////////////////////////////////////////////////

    
    
}

extension OldFashionViewController: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: TableView Delegate Methods
    /////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DayOfWeekCell
        
        switch indexPath.row {
        case 0:
            cell.dayOfWeek = DaysofWeek.Monday
        case 1:
            cell.dayOfWeek = DaysofWeek.Tuesday
        case 2:
            cell.dayOfWeek = DaysofWeek.Wednesday
        case 3:
            cell.dayOfWeek = DaysofWeek.Thursday
        case 4:
            cell.dayOfWeek = DaysofWeek.Friday
        case 5:
            cell.dayOfWeek = DaysofWeek.Saturday
        default:
            cell.dayOfWeek = DaysofWeek.Sunday
            
        }
        
        cell.dayTitle.text = cell.dayOfWeek?.description
        
        if cell.cellSelected{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DayOfWeekCell
        
        cell.cellSelected = true
        selectedDays.insert((cell.dayOfWeek)!)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DayOfWeekCell
        
        cell.cellSelected = false
        selectedDays.remove((cell.dayOfWeek)!)
        tableView.reloadData()
    }
    
    /////////////////////////////////////////////////////////////////
    
    
    
}
