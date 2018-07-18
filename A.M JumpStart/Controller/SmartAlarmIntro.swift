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
import TimeIntervals

class SmartAlarmIntro: UIViewController {
    
    private let API_KEY = "AIzaSyD5xKj3wd0xJ29AI4KI6a_wv8bbmsrqNOQ"

    
    var locationManager: CLLocationManager?{
        didSet{
            print("manger set!")
            setupLocationManager()
        }
    }
    
    private var smartAlarm: SmartAlarm = SmartAlarm(title: "Alarm")
    
     let states = UIPickerView()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var formStackView: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var desiredTimePicker: UIDatePicker!
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayPopUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
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


    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        switch segue.identifier {
        case "goToManualDepart":
            let destinationVC = segue.destination as! PointofOrginViewController
            destinationVC.smartAlarm = self.smartAlarm
            
        default:
            let destinationVC = segue.destination as! PostAlarmActivityViewController
            destinationVC.smartAlarm = self.smartAlarm
        }
        
    }
    
    func getTravelInfo(parameters: Parameters){
        
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json"
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                let travelTimeInSec = json["rows"][0]["elements"][0]["duration"]["value"].intValue
                let alarmTime = self.smartAlarm.desiredArrivalTime - travelTimeInSec.seconds
                
                print("Set you alarm for \(alarmTime) to arrive by \(self.smartAlarm.desiredArrivalTime )")
            case .failure(let error):
                print(error)
                
            }
            
        self.performSegue(withIdentifier: "goToRoutineSetup", sender: self)
            
        }
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        
        smartAlarm.alarmTitle = titleTextField.text!
        smartAlarm.destination?.address = addressTextField.text!
        smartAlarm.destination?.city = cityTextField.text!
        smartAlarm.destination?.state = stateTextField.text!
        smartAlarm.desiredArrivalTime = desiredTimePicker.date
        
        // Prepare the popup assets
        let title = "Travel From"
        let message = "Set point of orgin: "
        let image = UIImage(named: "popUpImage")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        popup.transitionStyle = .bounceUp
        popup.shake()
        
        // Create buttons
        let buttonOne = CancelButton(title: "Back") {
            print("Closing pop up")
        }
        
        let buttonTwo = DefaultButton(title: "Use Current Location") {
            print("using current location...")
            self.locationManager = CLLocationManager()
            
            
        }
        
        // This button will not the dismiss the dialog
        let buttonThree = DefaultButton(title: "Enter Depart Location") {
            self.performSegue(withIdentifier: "goToManualDepart", sender: self)
        }
       

        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonTwo, buttonThree, buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    

    
    @objc func doneStatePicker(){
        print("Tapped")

        self.view.becomeFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func cancelStatePicker(){
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupLocationManager(){
        guard  let location = locationManager else {
            fatalError()
        }
        location.delegate = self
        getLocation(with: location)
    }
    
    func getLocation(with locationManager: CLLocationManager) {

        // 1
        let status  = CLLocationManager.authorizationStatus()   //get current authorization status
        
        // 2
        if status == .notDetermined {   //checks current state of status
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // 3
        if status == .denied || status == .restricted { //condition for denied auth
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        // 4
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters  //defines the accuracy for the GPS location
        locationManager.startUpdatingLocation() //starts searching for GPS location
        
    }
    
    

}

extension SmartAlarmIntro: CLLocationManagerDelegate{
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {    //GPS gathering adds to the end of the array w/ each update
        let location = locations[locations.count - 1]   //fetches the last item in array -- most up to date location
        if location.horizontalAccuracy > 0 {    //checks the location radius to ensure it is valid--  video (sec. 13 lecture 143 @ 7:50)
            manager.stopUpdatingLocation()  //stops the GPS gathering
            //            print ("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            print("Lat \(latitude), Long \(longitude)")
            //            let params : [String: String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            //            getWeatherData(url: WEATHER_URL, parameters: params)
            smartAlarm.origin?.lat = latitude
            smartAlarm.origin?.lon = longitude
            
            
            
            let destination = "\(smartAlarm.destination?.address ?? "")+\(smartAlarm.destination?.city ?? "")+\(smartAlarm.destination?.state ?? "")"
            let origin = "\(smartAlarm.origin?.lat ?? ""),\(smartAlarm.origin?.lon ?? "")"
            
            let parameters : Parameters = ["origins" : origin,
                                           "destinations" : destination,
                                           "key" : API_KEY]
            
            getTravelInfo(parameters: parameters)

            
//            performSegue(withIdentifier: "goToRoutineSetup", sender: self)
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        //        cityLabel.text = "Location Unavailable"
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




