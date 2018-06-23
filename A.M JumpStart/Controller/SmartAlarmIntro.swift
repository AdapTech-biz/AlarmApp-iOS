//
//  SmartAlarmIntro.swift
//  AlarmTest
//
//  Created by Xavier Davis on 6/16/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import PopupDialog
import CoreLocation
import SwiftyJSON
import Alamofire

class SmartAlarmIntro: UIViewController {
    
  
    let locationManager = CLLocationManager()
     let states = UIPickerView()
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        states.dataSource = self
        states.delegate = self
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelStatePicker));
        
        toolbar.setItems([cancelButton,spaceButton, doneButton], animated: false)
        
        stateTextField.inputAccessoryView = toolbar
        stateTextField.inputView = states
        
        
        // Do any additional setup after loading the view.
        //TODO:Set up the location manager here.
        getLocation()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        let API_KEY = "&key=AIzaSyD5xKj3wd0xJ29AI4KI6a_wv8bbmsrqNOQ"
//        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=Dover+DE&destinations=509+NW+Backwoods+Rd+Moyock".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
//
//        Alamofire.request(url!+API_KEY, method: .get).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//                print(json["rows"][0]["elements"])
//            case .failure(let error):
//                print(error)
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        
        displayPopUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    func getLocation() {
        print("Getting location")
        // 1
        let status  = CLLocationManager.authorizationStatus()
        
        // 2
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // 3
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        // 4
        locationManager.delegate = self //define who the delegate is -- current class
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters  //defines the accuracy for the GPS location
//        locationManager.requestWhenInUseAuthorization() //request user approve to use GPS location -- make updates to plist file as well
        locationManager.startUpdatingLocation() //starts searching for GPS location
    }
    
    func displayPopUp() {
        // Prepare the popup assets
        let title = "Next-Gen Alarm"
        let message = "Bacon ipsum dolor amet ham turducken ball tip, tri-tip bresaola pork salami frankfurter beef ribs bacon. Alcatra salami flank ball tip meatball, kielbasa pancetta bresaola boudin tail pig pastrami jerky spare ribs. Spare ribs venison corned beef brisket flank ribeye. Leberkas salami cow sirloin shoulder turkey pork belly picanha drumstick. Ground round cow ball tip bacon ribeye. Tongue pastrami pork chop doner turducken chuck."
        
        let image = UIImage(named: "popUpImage")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        popup.transitionStyle = .bounceUp
        popup.shake()
        
        // Create buttons
        // This button will not the dismiss the dialog
        let buttonOne = DefaultButton(title: "") {
            self.view.becomeFirstResponder()
//            self.resignFirstResponder()
        }
        

        buttonOne.setImage(UIImage(named: "checkmark"), for: .normal)
        buttonOne.imageView?.contentMode = .scaleAspectFit
        buttonOne.backgroundColor = UIColor.clear
        buttonOne.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor

        

        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
   @objc func keyboardWillHide(sender: NSNotification) {
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    @objc func doneStatePicker(){
        print("Tapped")

        
        self.view.endEditing(true)
    }
    
    @objc func cancelStatePicker(){
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}

extension SmartAlarmIntro: UIPickerViewDataSource{
    
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

extension SmartAlarmIntro: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = USStates.states[row]
    }
}

extension SmartAlarmIntro: CLLocationManagerDelegate{
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {    //GPS gathering adds to the end of the array w/ each update
        let location = locations[locations.count - 1]   //fetches the last item in array -- most up to date location
        if location.horizontalAccuracy > 0 {    //checks the location radius to ensure it is valid--  video (sec. 13 lecture 143 @ 7:50)
            self.locationManager.stopUpdatingLocation()  //stops the GPS gathering
            //            print ("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            print("Lat \(latitude), Long \(longitude)")
//            let params : [String: String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
//            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
//        cityLabel.text = "Location Unavailable"
    }
    
}


