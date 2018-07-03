//
//  ActivityDurationCell.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 6/23/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import GMStepper
import FoldingCell


protocol ActivityDurationDelegate {
    func timeTotalUpdated(time: Double)
}

class ActivityDurationCell: FoldingCell {
    var delegate : ActivityDurationDelegate?
    

    @IBOutlet weak var durationTime: GMStepper!
    @IBOutlet var activityLabels: [UILabel]!
    @IBOutlet weak var minutesLabel: UILabel!{
        
        didSet{
            delegate?.timeTotalUpdated(time: durationTime.value)
        }
    }
    
    @IBOutlet weak var foldedBackground: RotatedView!
    
    @IBOutlet weak var unfoldedBackground: RotatedView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
    
}
