//
//  PostAlarmActivityCell.swift
//  AlarmTest
//
//  Created by Xavier Davis on 6/21/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit

class PostAlarmActivityCell: UICollectionViewCell {
    

    var task: TravelTask?{
        didSet {
            taskTitle.text = task?.title
        }
    }
    @IBOutlet weak var taskTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
