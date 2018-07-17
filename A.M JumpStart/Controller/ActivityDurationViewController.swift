//
//  ActivityDurationViewController.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 6/23/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import FoldingCell

fileprivate struct C {
    struct CellHeight {
        static let close: CGFloat = 125 // equal or greater foregroundView height
        static let open: CGFloat = 130 // equal or greater containerView height
    }
}

class ActivityDurationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var activitiesToSetUp : Array<TravelTask>?
    var cellHeights = (0..<2).map { _ in C.CellHeight.close }
    

    var timeSum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "Foldable", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "foldableCell")
        
        if let numCells = activitiesToSetUp{
            cellHeights = (0..<numCells.count).map { _ in C.CellHeight.close }
        }
            tableView.separatorStyle = .none

    }
    


    // MARK: - Navigation



    @IBAction func nextBtnPressed(_ sender: Any) {
        var sum = 0.0
        let cells = tableView.visibleCells as! [ActivityDurationCell]
        for cell in cells{
            sum += cell.durationTime.value
        }
        print("Total time needed: \(sum)")
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
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
//        _ = durationCell.activityLabels.map({$0.text = activitiesToSetUp?[indexPath.row].title})
        durationCell.task?.taskDuration = Int(durationCell.durationTime.value)
        
        _ = durationCell.durationLabels.map({$0.text = "\(durationCell.task?.taskDuration ?? 99)"})
        
//        durationCell.minutesLabel.text = "\(durationCell.task?.taskDuration ?? 99)"
        
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


        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)

    }
    
}

