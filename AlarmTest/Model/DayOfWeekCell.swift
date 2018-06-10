//
//  DayOfWeekCell.swift
//  AlarmTest
//
//  Created by Xavier Davis on 5/30/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit

class DayOfWeekCell: UITableViewCell {
    @IBOutlet weak var dayTitle: UILabel!
    var cellSelected : Bool = false
    var dayOfWeek : DaysofWeek?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
