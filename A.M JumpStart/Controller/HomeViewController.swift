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
import PopupDialog
import ChameleonFramework
import RealmSwift

class HomeViewController: UIViewController{
    
    let realm = try! Realm()
    
    //MARK: UIOutlet Controllers
    /////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var tableView: UITableView!
    /////////////////////////////////////////////////////////////////

    
    //MARK: Class Variables
    /////////////////////////////////////////////////////////////////

    var alarm : SystemAlarm?
    var noteSoundEffect : AVAudioPlayer?
    var createdClassicAlarms : Results<SystemAlarm>!
    var createdSmartAlarms : Results<SmartAlarm>!
    /////////////////////////////////////////////////////////////////

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        let nib = UINib(nibName: "AlarmCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "alarmCell")
        loadAlarms()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOldFashion"{
            let destinationVC = segue.destination as! OldFashionViewController
            destinationVC.homeViewController = self
            destinationVC.delegate = self
        }else{
            let destinationVC = segue.destination as! SmartAlarmIntro
            destinationVC.smartAlarm.delegate = self
        }
    }
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
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
            self.performSegue(withIdentifier: "goToSmartAlarm", sender: self)
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
    
    func loadAlarms() {
        
        createdClassicAlarms = realm.objects(SystemAlarm.self)
        createdSmartAlarms = realm.objects(SmartAlarm.self)
        
        
    }
    
    
    ///////////////////////////////////////////////////////////////////

}


extension HomeViewController: UNUserNotificationCenterDelegate, UITableViewDelegate, UITableViewDataSource,ClassicAlarmCreatedDelegate{
    
    
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
        
        switch indexPath.section {
        case 0:
            if let currentAlarm = createdClassicAlarms?[indexPath.row]{
                cell.alarmTitle.text = currentAlarm.alarmTitle
                cell.hourLabel.text = "\(currentAlarm.alarmHour)"
                cell.minuteLabel.text = String(format: "%02d", currentAlarm.alarmMin)
                
                
                for day in currentAlarm.weeklySchedule{
                    switch day{
                    case 1: cell.sundayLabel.textColor = UIColor.flatMint
                    case 2: cell.mondayLabel.textColor = UIColor.flatMint
                    case 3: cell.tuesdayLabel.textColor = UIColor.flatMint
                    case 4: cell.wednesdayLabel.textColor = UIColor.flatMint
                    case 5: cell.thursdayLabel.textColor = UIColor.flatMint
                    case 6: cell.fridayLabel.textColor = UIColor.flatMint
                    default: cell.saturdayLabel.textColor = UIColor.flatMint
                    }
                }
            }else{
                cell.alarmTitle.text = "No Alarms To Display"
                cell.hourLabel.text = ""
                cell.minuteLabel.text = ""
            }
        default:
            if let smartAlarm = createdSmartAlarms?[indexPath.row]{
                cell.alarmTitle.text = smartAlarm.alarmTitle
                cell.hourLabel.text = "\(smartAlarm.alarmHour)"
                cell.minuteLabel.text = String(format: "%02d", smartAlarm.alarmMin)
            }else{
                cell.alarmTitle.text = "No Alarms To Display"
                cell.hourLabel.text = ""
                cell.minuteLabel.text = ""
            }
        }
       


        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch section {
        case 0:
            return createdClassicAlarms?.count ?? 1
        default:
            return createdSmartAlarms?.count ?? 1
        }
    
//    return createdClassicAlarms?.count ?? 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(AlarmDetailViewController(), animated: true, completion: nil)
    }
    //////////////////////////////////////////////////////////////////
    
    //MARK: AlarmCreatedDelegate Method
    /////////////////////////////////////////////////////////////////
    
    
    func newAlarmCreated(createdAlarm: SystemAlarm) {
        
        //save with relm
        do{
            try realm.write {
                realm.add(createdAlarm)
                print("Saved alarm \(createdAlarm.alarmTitle)")
            }
        }catch{
            print("Realm error \(error)")
        }
        self.tableView.reloadData()
    }
    /////////////////////////////////////////////////////////////////
    
    
    
}

extension HomeViewController: SmartAlarmCreatedDelegate{
    func newSmartCreated(newSmartAlarm: SmartAlarm) {
        //save with relm
        do{
            try realm.write {
                realm.add(newSmartAlarm)
                print("Saved alarm \(newSmartAlarm.alarmTitle)")
            }
        }catch{
            print("Realm error \(error)")
        }
        self.tableView.reloadData()
    }
    
    
}



