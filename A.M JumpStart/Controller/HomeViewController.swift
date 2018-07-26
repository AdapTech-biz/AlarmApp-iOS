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
import RxRealm
import SwipeCellKit
import RxSwift
import RxCocoa
import RxRealmDataSources


class HomeViewController: UIViewController{
    
    let realm = try! Realm()
    
    //MARK: UIOutlet Controllers
    /////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var tableView: UITableView!
    /////////////////////////////////////////////////////////////////

    
    //MARK: Class Variables
    /////////////////////////////////////////////////////////////////

    var alarm : SystemAlarmComponent?
    var noteSoundEffect : AVAudioPlayer?
    var createdClassicAlarms : Results<BasicAlarm>!
    var createdSmartAlarms : Results<SmartAlarm>!
    var disposeBag = DisposeBag()
    /////////////////////////////////////////////////////////////////

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
        case "goToSmartAlarm":
            let destinationVC = segue.destination as! SmartAlarmIntro
            destinationVC.homeViewController = self
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
        
        createdClassicAlarms = realm.objects(BasicAlarm.self)
        createdSmartAlarms = realm.objects(SmartAlarm.self)
        
    }
    
    func updateModel(at indexPath: IndexPath){
        //TODO: - Re-enable swipe to delete
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
                            alarm.systemAlarmComponent?.cancelFutureAlarms()
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


extension HomeViewController: UNUserNotificationCenterDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return createdClassicAlarms.count
        default:
            return createdSmartAlarms.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! AlarmCell
        
        switch indexPath.section {
        case 0:
            let alarm = createdClassicAlarms[indexPath.row]
            
            cell.alarmTitle.text = alarm.title
            cell.hourLabel.text = "\(alarm.alarmHour)"
            cell.minuteLabel.text = String(format: "%02d", alarm.alarmMin)
            cell.delegate = self
            
            for day in alarm.weeklySchedule{
                switch day.dayToInt{
                case 1: cell.sundayLabel.textColor = UIColor.flatMint
                case 2: cell.mondayLabel.textColor = UIColor.flatMint
                case 3: cell.tuesdayLabel.textColor = UIColor.flatMint
                case 4: cell.wednesdayLabel.textColor = UIColor.flatMint
                case 5: cell.thursdayLabel.textColor = UIColor.flatMint
                case 6: cell.fridayLabel.textColor = UIColor.flatMint
                default: cell.saturdayLabel.textColor = UIColor.flatMint
                }
            }
        default:
            let alarm = createdSmartAlarms[indexPath.row]
            cell.alarmTitle.text = alarm.title
            cell.hourLabel.text = "\(alarm.alarmHour)"
            cell.minuteLabel.text = String(format: "%02d", alarm.alarmMin)
            cell.delegate = self
            
            for day in alarm.weeklySchedule{
                switch day.dayToInt{
                case 1: cell.sundayLabel.textColor = UIColor.flatMint
                case 2: cell.mondayLabel.textColor = UIColor.flatMint
                case 3: cell.tuesdayLabel.textColor = UIColor.flatMint
                case 4: cell.wednesdayLabel.textColor = UIColor.flatMint
                case 5: cell.thursdayLabel.textColor = UIColor.flatMint
                case 6: cell.fridayLabel.textColor = UIColor.flatMint
                default: cell.saturdayLabel.textColor = UIColor.flatMint
                }
            }
        }
        
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! AlarmCell
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    //////////////////////////////////////////////////////////////////
    
    
    
}

extension HomeViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        return [deleteAction]
    }
    
//    func newSmartCreated(newSmartAlarm: SmartAlarm) {
//        //save with relm
//        do{
//            try realm.write {
//                realm.add(newSmartAlarm)
//                print("Saved alarm \(newSmartAlarm.title)")
//            }
//        }catch{
//            print("Realm error \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    
}



