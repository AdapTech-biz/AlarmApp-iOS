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
    let bottomView = UIScrollView()
    let alarmTitleLabel = UILabel()
    let alarmTimeLabel = UILabel()
    let tripButton = UIButton()
    let routineButton = UIButton()
    let backArrow = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // TODO: - Add subviews to parent views
        //////////////////////////////////////////

        self.addSubview(gradientView)
        self.addSubview(imageViewHolder)
        self.addSubview(bottomView)
        
        gradientView.addSubview(backArrow)
        imageViewHolder.addSubview(alarmImage)
        bottomView.addSubview(alarmTitleLabel)
        bottomView.addSubview(alarmTimeLabel)
        bottomView.addSubview(tripButton)
        bottomView.addSubview(routineButton)
        //////////////////////////////////////////
        
        //TODO: - Construct gradientView
        //////////////////////////////////////////
        createGradientView()
        ///////////////////////////////////////////
        
        //TODO: - Construct backArrow Button View
        //////////////////////////////////////////
        createBackArrow()
        //////////////////////////////////////////////
        
        //TODO: - Construct imageHolder View
        //////////////////////////////////////////
        createImageViewHolder()
        //////////////////////////////////////////

        //TODO: - Construct alarmImage View
        //////////////////////////////////////////
        createAlarmImage()
        //////////////////////////////////////////

        //TODO: - Construct bottomScrollView
        //////////////////////////////////////////
        createBottomScrollView()
        //////////////////////////////////////////

        //TODO: - Construct alarmTitleLabel
        //////////////////////////////////////////
        createAlarmTitleLabel()
        //////////////////////////////////////////

        //TODO: - Construct tripButton
        //////////////////////////////////////////
        createTripInfoBtn()
        //////////////////////////////////////////

        //TODO: - Construct routineButton
        //////////////////////////////////////////
        createRoutineInfoBtn()
        //////////////////////////////////////////
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createGradientView(){
        gradientView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(screenSize.height / 4)
            make.top.left.right.equalToSuperview()
            
        }
        gradientView.layer.borderWidth = 0.0
        gradientView.image = UIImage(named: "Gradient-Background")
    }
    
    private func createBackArrow(){
        backArrow.snp.makeConstraints { (make) in
            make.top.equalTo(gradientView).offset(50)
            make.left.equalTo(gradientView).offset(15)
            make.width.height.equalTo(30)
        }
        backArrow.setBackgroundImage(UIImage(named: "Back Arrow"), for: .normal)
        backArrow.addTarget(self, action: #selector(backHomePressed), for: .touchUpInside)
    }
    
    private func createImageViewHolder(){
        imageViewHolder.snp.makeConstraints { (make) in
            make.height.equalTo(110)
            make.width.equalTo(136)
            make.bottom.equalTo(gradientView.snp.bottom).offset(50)
            make.centerX.equalTo(gradientView.snp.centerX)
        }
        
        
        imageViewHolder.backgroundColor = UIColor(hexString: "EBEEF2")
        imageViewHolder.layer.cornerRadius = 55
        imageViewHolder.layer.borderColor = UIColor.flatWhite.cgColor
        imageViewHolder.layer.borderWidth = 5
    }
    
    private func createAlarmImage(){
        alarmImage.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.width.equalTo(110)
            make.top.equalTo(imageViewHolder).offset(15)
            make.centerX.equalTo(imageViewHolder.snp.centerX)
        }
        alarmImage.image = UIImage(named: "alarm-clock")
        alarmImage.clipsToBounds = true
        alarmImage.contentMode = .scaleAspectFit
    }
    
    private func createBottomScrollView(){
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(gradientView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            
        }
        bottomView.backgroundColor = UIColor.white
        self.bringSubview(toFront: imageViewHolder)
    }
    
    private func createAlarmTitleLabel(){
        alarmTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageViewHolder.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            
        }
        alarmTitleLabel.text = "Test Alarm"
        alarmTitleLabel.tag = 100
        
        
        alarmTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(5)
            make.centerX.equalTo(alarmTitleLabel)
        }
        alarmTimeLabel.text = "12:00 pm"
        alarmTimeLabel.font.withSize(14.0)
        alarmTimeLabel.alpha = 0.75
    }
    
    private func createTripInfoBtn(){
        tripButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
            make.height.equalTo(66)
            make.width.equalTo(234)
        }
        tripButton.setTitle("Trip Info", for: .normal)
        tripButton.setTitleColor(UIColor.flatPowderBlue, for: .normal)
        tripButton.titleLabel?.font = UIFont(name: (tripButton.titleLabel?.font.fontName)!, size: 25.0)
        tripButton.layer.cornerRadius = 20
        tripButton.layer.borderColor = UIColor.flatSkyBlue.cgColor
        tripButton.layer.borderWidth = 2
        tripButton.layer.shadowRadius = 3
        tripButton.layer.shadowColor = UIColor.flatBlue.cgColor
        tripButton.layer.shadowOffset = CGSize(width: 2, height: -1)
        tripButton.layer.shadowOpacity = 0.30
        tripButton.addTarget(self, action: #selector(displayTravelDetails), for: .touchUpInside)
    }
    
    private func createRoutineInfoBtn(){
        routineButton.snp.makeConstraints { (make) in
            make.top.equalTo(tripButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(66)
            make.width.equalTo(234)
        }
        routineButton.setTitle("Routines", for: .normal)
        routineButton.setTitleColor(UIColor.flatPowderBlue, for: .normal)
        routineButton.titleLabel?.font = UIFont(name: (routineButton.titleLabel?.font.fontName)!, size: 25.0)
        routineButton.layer.cornerRadius = 20
        routineButton.layer.borderColor = UIColor.flatSkyBlue.cgColor
        routineButton.layer.borderWidth = 2
        routineButton.layer.shadowRadius = 3
        routineButton.layer.shadowColor = UIColor.flatBlue.cgColor
        routineButton.layer.shadowOffset = CGSize(width: 2, height: -1)
        routineButton.layer.shadowOpacity = 0.30
    }
    
    func moveInfoElementsToHeader(buttonPressed button: UIButton){
        
        UIView.animate(withDuration: 1.5) {
           self.alarmTitleLabel.alpha = 0.1
            self.alarmTimeLabel.alpha = 0.1
            
            UIView.animate(withDuration: 0.5, animations: {
                self.gradientView.addSubview(self.alarmTitleLabel)
                self.gradientView.addSubview(self.alarmTimeLabel)
                self.alarmTimeLabel.alpha = 1.0
                self.alarmTitleLabel.alpha = 1.0
                self.alarmTitleLabel.textColor = UIColor(hexString: "4652EC")
                self.alarmTimeLabel.textColor = UIColor(hexString: "4A90E2")
                
                self.alarmTitleLabel.snp.remakeConstraints { (make) in
                    make.centerX.equalTo(self.gradientView)
                    make.centerY.equalTo(self.gradientView).offset(-20)
                }
                
               self.alarmTimeLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(self.alarmTitleLabel.snp.bottom).offset(5)
                    make.centerX.equalTo(self.alarmTitleLabel)
                })
            })
        }
        addGradientView(labelForHeader: (button.titleLabel?.text)!)
    }
    
    private func addGradientView(labelForHeader: String){
        let lowerGradientView = UIImageView()
        let headerLabel = UILabel()
        headerLabel.alpha = 0.0
        headerLabel.text = labelForHeader
        headerLabel.textColor = UIColor(hexString: "4652EC")
        headerLabel.font = UIFont(name: headerLabel.font.fontName, size: 25.0)
        lowerGradientView.image = UIImage(named: "Gradient-Background")
        lowerGradientView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
       
        UIView.animate(withDuration: 1.0) {
            self.gradientView.addSubview(lowerGradientView)
            self.bottomView.snp.remakeConstraints { (make) in
                make.top.equalTo(lowerGradientView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
            self.bringSubview(toFront: self.imageViewHolder)
            lowerGradientView.snp.makeConstraints { (make) in
                make.top.equalTo(self.gradientView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(self.gradientView.snp.height).dividedBy(2)
            }
            
            self.gradientView.addSubview(headerLabel)
            headerLabel.alpha = 1.0
            headerLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.imageViewHolder.snp.bottom).offset(5)
                make.centerX.equalTo(self.imageViewHolder)
            }
        }
       
    }
    
    @objc func backHomePressed(sender: UIButton){
        print("Pressed")
    }
    
    @objc func displayTravelDetails(sender: UIButton){
        moveInfoElementsToHeader(buttonPressed: sender)
    }
}
