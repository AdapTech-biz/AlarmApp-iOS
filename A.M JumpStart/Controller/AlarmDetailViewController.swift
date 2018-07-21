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
    let alarmDetailView = AlarmDetailView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(alarmDetailView)
        alarmDetailView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // Do any additional setup after loading the view.
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
