//
//  ActivityDurationViewController.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 6/23/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import FoldingCell
import TimeIntervals

fileprivate struct C {
    struct CellHeight {
        static let close: CGFloat = 125 // equal or greater foregroundView height
        static let open: CGFloat = 130 // equal or greater containerView height
    }
}

class ActivityDurationViewController: UIViewController {
    
    // MARK: - Variables
    ////////////////////////////////////////////////////
    
    @IBOutlet weak var tableView: UITableView!
    
    var activityDurationMap = [String: Int]()
    var activitiesToSetUp : Array<TravelTask>?{
        willSet{
            _ = newValue?.map({ (task) in
                activityDurationMap["\(task.title)"] = task.taskDuration
            })
        }
    }
    var cellHeights = (0..<2).map { _ in C.CellHeight.close }
    var openCells = Set<ActivityDurationCell>()
    var timeSum = 0
    var smartAlarm: SmartAlarm?
    ////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "Foldable", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "foldableCell")
        
        if let numCells = activitiesToSetUp{
            cellHeights = (0..<numCells.count).map { _ in C.CellHeight.close }
        }
        tableView.separatorStyle = .none
        
        print(activityDurationMap.count)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let smartAlarm = smartAlarm{
            smartAlarm.registerAlarm(for: smartAlarm.alarmTime, isrepeated: false)
            smartAlarm.delegate?.newSmartCreated(newSmartAlarm: smartAlarm)
        }
    }
    
    
    // MARK: - Navigation
    //////////////////////////////////////////////////
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        getValueFromAllOpenCells()
        var totalTimeNeededPreTravel = 0
        _ = activityDurationMap.mapValues { (mins) in
            print(mins)
            totalTimeNeededPreTravel += mins
        }
        guard let smartAlarm = smartAlarm else { fatalError() }
        let interval = totalTimeNeededPreTravel.minutes.inSeconds
         smartAlarm.totalTimeForPreTravel = Int(interval.value)
        smartAlarm.alarmTime = smartAlarm.desiredArrivalTime - smartAlarm.totalTimeNeededToTravel.seconds
//        print("Total time needed: \(smartAlarm.totalTimeNeededToTravel)")
//        print("Alarm Time is \(smartAlarm.alarmTime)")
//        print("Desired Arrival Time \(smartAlarm.desiredArrivalTime)")
        
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    ////////////////////////////////////////////////////
    
    
    // MARK: - Cell Clean Up
    ////////////////////////////////////////////////////
    func getValueFromAllOpenCells(){
        _ = openCells.map { (cell)  in
            self.activityDurationMap[(cell.task?.title)!] = Int(cell.durationTime.value)
        }
    }
    ////////////////////////////////////////////////////
    
    
}

extension ActivityDurationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let activities = activitiesToSetUp{
            return activities.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foldableCell", for: indexPath) as! ActivityDurationCell
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let durationCell = cell as! ActivityDurationCell
        durationCell.task = activitiesToSetUp?[indexPath.row]
        durationCell.task?.taskDuration = Int(durationCell.durationTime.value)
        
        _ = durationCell.durationLabels.map({$0.text = "\(durationCell.task?.taskDuration ?? 99)"})
        
        
        timeSum += Int(durationCell.durationTime.value)
        
        if case let cell as FoldingCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
                cell.unfold(false, animated: false, completion:nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ActivityDurationCell
        cell.task?.taskDuration = Int(cell.durationTime.value)
        _ = cell.durationLabels.map({$0.text = "\(cell.task?.taskDuration ?? 99)"})
        
        let duration = 0.5
        if cellHeights[indexPath.row] == C.CellHeight.close { // open cell
            cellHeights[indexPath.row] = C.CellHeight.open
            UIView.animate(withDuration: duration) {
                cell.foregroundView.alpha = 0.0
                cell.containerView.alpha = 1.0
            }
            
        } else {// close cell
            cellHeights[indexPath.row] = C.CellHeight.close
            UIView.animate(withDuration: duration) {
                cell.containerView.alpha = 0.0
                cell.foregroundView.alpha = 1.0
                
            }
            activityDurationMap.updateValue((cell.task?.taskDuration)!, forKey: (cell.task?.title)!)
            
        }
        
        if( cell.containerView.alpha == 1.0 ){
            openCells.insert(cell)
        }else{
            openCells.remove(cell)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }
    
    
    
}

