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
import ChameleonFramework

class HomeViewController: UIViewController{
    
    //MARK: UIOutlet Controllers
    /////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var tableView: TableView!
    /////////////////////////////////////////////////////////////////

    
    //MARK: Class Variables
    /////////////////////////////////////////////////////////////////

    var alarm : Alarm?
    var noteSoundEffect : AVAudioPlayer?
    var createdAlarms = [Alarm]()
    /////////////////////////////////////////////////////////////////

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        let nib = UINib(nibName: "AlarmCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "alarmCell")

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
        popup.transitionStyle = .bounceUp
        popup.shake()
        
        // Create buttons
        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        
        // This button will not the dismiss the dialog
        let buttonTwo = DefaultButton(title: "Smart Alarm") {
            print("Smart alarm picked")
        }
        
        
        let buttonThree = DefaultButton(title: "Old-Fashion") {
            self.performSegue(withIdentifier: "goToOldFashion", sender: self)
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonTwo, buttonThree, buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    
    
    ///////////////////////////////////////////////////////////////////
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOldFashion"{
            let destinationVC = segue.destination as! OldFashionViewController
            destinationVC.homeViewController = self
            destinationVC.delegate = self
        }
    }
    
    
    
}


extension HomeViewController: UNUserNotificationCenterDelegate, UITableViewDelegate, UITableViewDataSource, PlaceholderDelegate, AlarmCreatedDelegate{
    
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        tableView.showDefault()
    }
    
    
    //MARK: UserNotificationCenter Delegate Methods
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
    
    
    
    //MARK: UITableView Delegate Methods
    ///////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! AlarmCell
        cell.accessoryType = .disclosureIndicator
        let currentAlarm = createdAlarms[indexPath.row]
        cell.alarmTitle.text = currentAlarm.alarmTitle
        cell.hourLabel.text = "\(currentAlarm.alarmHour)"
        cell.minuteLabel.text = String(format: "%02d", currentAlarm.alarmMin)
        
        if let weeklySchedule = currentAlarm.weeklySchedule{
            for day in weeklySchedule{
                switch day{
                case .Sunday: cell.sundayLabel.textColor = UIColor.flatMint
                case .Monday: cell.mondayLabel.textColor = UIColor.flatMint
                case .Tuesday: cell.tuesdayLabel.textColor = UIColor.flatMint
                case .Wednesday: cell.wednesdayLabel.textColor = UIColor.flatMint
                case .Thursday: cell.thursdayLabel.textColor = UIColor.flatMint
                case .Friday: cell.fridayLabel.textColor = UIColor.flatMint
                case .Saturday: cell.saturdayLabel.textColor = UIColor.flatMint
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createdAlarms.count
    }
    
    
    
    //////////////////////////////////////////////////////////////////
    
    //MARK: AlarmCreatedDelegate Method
    /////////////////////////////////////////////////////////////////
    
    
    func newAlarmCreated(createdAlarm: Alarm) {
        
        createdAlarms.append(createdAlarm)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    /////////////////////////////////////////////////////////////////
    
    
    
}



