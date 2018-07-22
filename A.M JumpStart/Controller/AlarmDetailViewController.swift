//
//  AlarmDetailViewController.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/20/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import SnapKit

class AlarmDetailViewController: UIViewController {
    
   lazy var alarmDetailView = AlarmDetailView()
    var alarmToDisplay : SystemAlarm?
    var isSmartAlarm = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        alarmDetailView.tripButton.addTarget(self, action: #selector(displayTravelDetails), for: .touchUpInside)
//        alarmDetailView.backArrow.addTarget(self, action: #selector(backHomePressed), for: .touchUpInside)

        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        view.addSubview(alarmDetailView)
        alarmDetailView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        alarmDetailView.alarmTitleLabel.text = alarmToDisplay?.alarmTitle
        alarmDetailView.alarmTimeLabel.text = "\(alarmToDisplay?.alarmHour ?? 99):\(alarmToDisplay?.alarmMin ?? 99)"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @objc func displayTravelDetails(sender: UIButton){
//        alarmDetailView.moveInfoElementsToHeader(buttonPressed: sender)
//    }
//
//    @objc func backHomePressed(sender: UIButton){
//        print("Pressed")
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
