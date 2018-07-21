//
//  PointofOrginViewController.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/7/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import SCLAlertView
import TextFieldEffects
import Alamofire
import SwiftyJSON
import TimeIntervals

class PointofOrginViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: TextFieldEffects!
    @IBOutlet weak var cityTextField: TextFieldEffects!
    @IBOutlet weak var stateTextField: TextFieldEffects!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var smartAlarm: SmartAlarm?
    
    let states = UIPickerView()
    lazy var stateText = UITextField()
    private let API_KEY = "AIzaSyD5xKj3wd0xJ29AI4KI6a_wv8bbmsrqNOQ"


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStatePicker(for: stateTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       
        let destinationVC = segue.destination as! PostAlarmActivityViewController
        destinationVC.smartAlarm = self.smartAlarm
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    func setUpStatePicker(for textField: UITextField){
        
        states.dataSource = self
        states.delegate = self
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(doneStatePicker));
        
        toolbar.setItems([cancelButton,spaceButton, doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = states
    }

    
    @objc func doneStatePicker(){

        self.view.endEditing(true)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            if(self.cityTextField.isEditing || self.stateTextField.isEditing){
                self.bottomConstraint.constant = keyboardFrame.size.height + 20
            }
        })
    }
    

    @IBAction func continuePressed(_ sender: Any) {
        
       
        guard let smartAlarm = smartAlarm else {fatalError()}
        smartAlarm.origin.address = addressTextField.text!
        smartAlarm.origin.city = cityTextField.text!
        smartAlarm.origin.state = stateTextField.text!
        
        let origin = "\(smartAlarm.origin.address )+\(smartAlarm.origin.city)+\(smartAlarm.origin.state)"
        let destination = "\(smartAlarm.destination.address)+\(smartAlarm.destination.city)+\(smartAlarm.destination.state)"

        
        let parameters : Parameters = ["origins" : origin,
                                       "destinations" : destination,
                                       "key" : API_KEY]
        
        getTravelInfo(parameters: parameters)
    
    }
    
    func getTravelInfo(parameters: Parameters){
        
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json"
        guard let smartAlarm = smartAlarm else { fatalError() }
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                let travelTimeInSec = json["rows"][0]["elements"][0]["duration"]["value"].intValue
                smartAlarm.timeToDestination = travelTimeInSec
                let alarmTime = smartAlarm.desiredArrivalTime - travelTimeInSec.seconds
                
                print("Set you alarm for \(alarmTime) to arrive by \(smartAlarm.desiredArrivalTime )")
            case .failure(let error):
                print(error)
                
            }
            self.performSegue(withIdentifier: "goToRoutineSetup", sender: self)
        }
    }
    
    
}


extension PointofOrginViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return USStates.states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return USStates.states[row]
    }
    
}

extension PointofOrginViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = USStates.states[row]
    }
}
