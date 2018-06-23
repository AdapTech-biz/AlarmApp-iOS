//
//  ActivityDurationViewController.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 6/23/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit

class ActivityDurationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var activitiesToSetUp : Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ActivityDurationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "activityDurationCell")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityDurationCell", for: indexPath) as! ActivityDurationCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let durationCell = cell as! ActivityDurationCell
        
        durationCell.activity.text = activitiesToSetUp?[indexPath.row]
    }
    
}
