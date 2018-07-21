//
//  AlarmDetailView.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/20/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ChameleonFramework

class AlarmDetailView: UIView{
    let screenSize = UIScreen.main.bounds
    
    let gradientView = UIImageView()
    let imageViewHolder = UIView()
    let alarmImage = UIImageView()
    let bottomView = UIView()
    let alarmTitleLabel = UILabel()
    let alarmTimeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(gradientView)
        gradientView.addSubview(imageViewHolder)
        imageViewHolder.addSubview(alarmImage)
        self.addSubview(bottomView)
        
        gradientView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(screenSize.height / 4)
            make.top.left.right.equalToSuperview()
            
        }
        gradientView.image = UIImage(named: "Gradient-Background")
        
        imageViewHolder.snp.makeConstraints { (make) in
            make.height.equalTo(110)
            make.width.equalTo(136)
            make.bottom.equalTo(gradientView.snp.bottom).offset(50)
            make.centerX.equalTo(gradientView.snp.centerX)
        }
      
        
        imageViewHolder.backgroundColor = UIColor.white
        imageViewHolder.layer.cornerRadius = 55
        imageViewHolder.layer.borderColor = UIColor.flatWhite.cgColor
        imageViewHolder.layer.borderWidth = 5
        
        alarmImage.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.width.equalTo(110)
            make.top.equalTo(imageViewHolder).offset(15)
            make.centerX.equalTo(imageViewHolder.snp.centerX)
        }
        alarmImage.image = UIImage(named: "alarm-clock")
        alarmImage.clipsToBounds = true
        alarmImage.contentMode = .scaleAspectFit
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(gradientView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        
        }
        bottomView.backgroundColor = UIColor.white
        self.bringSubview(toFront: gradientView)
        
        bottomView.addSubview(alarmTitleLabel)
        
        alarmTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageViewHolder.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            
        }
        alarmTitleLabel.text = "Test Alarm"
        
        bottomView.addSubview(alarmTimeLabel)
        alarmTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        alarmTimeLabel.text = "12:00 pm"
        alarmTimeLabel.font.withSize(14.0)
        alarmTimeLabel.alpha = 0.75
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
