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
    func newAlarmCreated(createdAlarm: SystemAlarm)
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
    let days:[DayofWeek] = [
        DayofWeek(day: DaysofWeek.Sunday),
        DayofWeek(day: DaysofWeek.Monday),
        DayofWeek(day: DaysofWeek.Tuesday),
        DayofWeek(day: DaysofWeek.Wednesday),
        DayofWeek(day: DaysofWeek.Thursday),
        DayofWeek(day: DaysofWeek.Friday),
        DayofWeek(day: DaysofWeek.Saturday)
    ]
    var alarm : SystemAlarm?
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
    
    override func viewWillDisappear(_ animated: Bool) {
        if let alarm = alarm{
            self.delegate?.newAlarmCreated(createdAlarm: alarm)
        }
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
            
            self.alarm = SystemAlarm(title: text.text!)
            guard let alarm = self.alarm else {fatalError()}
            alarm.center.delegate = self.homeViewController
            alarm.isRepeatable = self.reoccurringSwitch.isOn

//            print(self.selectedDays)
            alarm.weeklySchedule = self.selectedDays
            alarm.createAlarm(from: self.timePicker)
            self.dismiss(animated: true, completion: nil)
            
        }
        
        alert.showEdit("Name new alarm", subTitle: "Make it yours", circleIconImage: alertViewIcon)
        
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /////////////////////////////////////////////////////////////////
  
}

extension OldFashionViewController: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: TableView Delegate Methods
    /////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DayOfWeekCell
        let thisDay = days[indexPath.row]
        cell.dayTitle.text = thisDay.day
        
        if thisDay.selected{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return days.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDay = days[indexPath.row]
        selectedDay.selected = !selectedDay.selected
       
        if (selectedDay.selected){
            selectedDays.insert(selectedDay.dayEnum)
        }else{
           selectedDays.remove(selectedDay.dayEnum)
        }
        tableView.reloadData()
    }

    
    /////////////////////////////////////////////////////////////////

}
