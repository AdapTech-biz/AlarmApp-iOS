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
import SwipeCellKit

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
        switch segue.identifier {
        case "goToOldFashion":
            let destinationVC = segue.destination as! OldFashionViewController
            destinationVC.homeViewController = self
            destinationVC.delegate = self
        case "goToSmartAlarm":
            let destinationVC = segue.destination as! SmartAlarmIntro
            destinationVC.smartAlarm.delegate = self
        default:
            print("Nothing to display")
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
    
    func updateModel(at indexPath: IndexPath){
        var isSmart = false
        switch indexPath.section {
        case 0:
            isSmart = false
        default:
            isSmart = true
        }
                do{
                    let alarm = isSmart ? createdSmartAlarms[indexPath.row] : createdClassicAlarms[indexPath.row]
                        try realm.write {
                            alarm.cancelFutureAlarms()
                            realm.delete(alarm)
                        }

                }catch {
                    print("Error deleting alarm \(error)")
                }
        
        tableView.performBatchUpdates({
            var paths = Array<IndexPath>()
            paths.append(indexPath)
            tableView.deleteRows(at: paths, with: UITableViewRowAnimation.fade)
        }, completion: nil)
    
    ///////////////////////////////////////////////////////////////////

    }
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
        cell.delegate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let alarmCell = cell as! AlarmCell
        
        
        switch indexPath.section {
        case 0:
            if let currentAlarm = createdClassicAlarms?[indexPath.row]{
                alarmCell.alarmModel = currentAlarm
                alarmCell.alarmTitle.text = currentAlarm.alarmTitle
                alarmCell.hourLabel.text = "\(currentAlarm.alarmHour)"
                alarmCell.minuteLabel.text = String(format: "%02d", currentAlarm.alarmMin)
                
                
                for day in currentAlarm.weeklySchedule{
                    switch day{
                    case 1: alarmCell.sundayLabel.textColor = UIColor.flatMint
                    case 2: alarmCell.mondayLabel.textColor = UIColor.flatMint
                    case 3: alarmCell.tuesdayLabel.textColor = UIColor.flatMint
                    case 4: alarmCell.wednesdayLabel.textColor = UIColor.flatMint
                    case 5: alarmCell.thursdayLabel.textColor = UIColor.flatMint
                    case 6: alarmCell.fridayLabel.textColor = UIColor.flatMint
                    default: alarmCell.saturdayLabel.textColor = UIColor.flatMint
                    }
                }
            }else{
                alarmCell.alarmTitle.text = "No Alarms To Display"
                alarmCell.hourLabel.text = ""
                alarmCell.minuteLabel.text = ""
            }
        default:
            if let smartAlarm = createdSmartAlarms?[indexPath.row]{
                alarmCell.alarmModel = smartAlarm
                alarmCell.alarmTitle.text = smartAlarm.alarmTitle
                alarmCell.hourLabel.text = "\(smartAlarm.alarmHour)"
                alarmCell.minuteLabel.text = String(format: "%02d", smartAlarm.alarmMin)
            }else{
                alarmCell.alarmTitle.text = "No Alarms To Display"
                alarmCell.hourLabel.text = ""
                alarmCell.minuteLabel.text = ""
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch section {
        case 0:
            return createdClassicAlarms?.count ?? 1
        default:
            return createdSmartAlarms?.count ?? 1
        }

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alarmDetailVC = AlarmDetailViewController()
        switch indexPath.section {
        case 0:
          alarmDetailVC.alarmToDisplay =  createdClassicAlarms[indexPath.row]
        default:
             alarmDetailVC.alarmToDisplay =  createdSmartAlarms[indexPath.row]
        }
        present(alarmDetailVC, animated: true, completion: nil)
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

extension HomeViewController: SmartAlarmCreatedDelegate, SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        return [deleteAction]
    }
    
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



