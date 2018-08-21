//
//  SessionTimeDateRootView.swift
//  Chatalyze
//
//  Created by Mansa on 09/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class SessionTimeDateRootView:ExtendedView{
    
    
    var isPickerHidden = true
    @IBOutlet var pickerContainer:UIView?
    @IBOutlet var timePicker:UIDatePicker?
    @IBOutlet var dateField:SigninFieldView?
    @IBOutlet var startTimeField:SigninFieldView?
    @IBOutlet var thirtyMinsBtn:UIButton?
    @IBOutlet var oneHourBtn:UIButton?
    @IBOutlet var oneAndHalfBtn:UIButton?
    @IBOutlet var twoHourBtn:UIButton?
    @IBOutlet var errorLbl:UILabel?
    
    enum activePicker:Int{
        
        case date = 0
        case time = 1
        case none = 2
    }
    
    enum DurationLength:Int{
        
        case thirtyMin = 0
        case oneHour = 1
        case oneAndhour = 2
        case twohour = 3
        case none = 4
    }
    
    var selectedDurationType:DurationLength = .none
    var selectedPickerType:activePicker = .none
    var controller:SessionTimeDateController?
    
    override func viewDidLayout(){
        super.viewDidLayout()
    }
    
    @IBAction func pickerDoneAction(sender:UIButton?){
        
        if isPickerHidden == false {
            
            isPickerHidden = true
            pickerContainer?.isHidden = true
        }
    }
    
    @IBAction func datePickerAction(_ sender: Any){
        
        if selectedPickerType == .date{
            dateField?.textField?.text = selectedTime
        }
        if selectedPickerType == .time{
            startTimeField?.textField?.text = startTime
        }
    }
    
    @IBAction func dateAction(sender:UIButton?){
        
        selectedPickerType = .date
        timePicker?.datePickerMode = .date
        dateField?.textField?.text = selectedTime
        if isPickerHidden == true {
            
            isPickerHidden = false
            pickerContainer?.isHidden = false
        }else{
            
            isPickerHidden = true
            pickerContainer?.isHidden = true
        }
    }
    
    @IBAction func startTimeAction(sender:UIButton?){
        
        selectedPickerType = .time
        timePicker?.datePickerMode = .time
        startTimeField?.textField?.text = startTime
        if isPickerHidden == true {
            
            isPickerHidden = false
            pickerContainer?.isHidden = false
        }else{
            
            isPickerHidden = true
            pickerContainer?.isHidden = true
        }
    }
    
    
    var selectedTime:String{
        get{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "dd MMM, yyyy"
            if let cd  = timePicker?.date{
                return dateFormatter.string(from: cd).replacingOccurrences(of: ":", with: "")
            }
            return ""
        }
    }
    
    var startTime:String{
        get{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "hh:mm a"
            if let cd  = timePicker?.date{
                return dateFormatter.string(from: cd)
            }
            return ""
        }
    }
    
    func resetDurationSelection(){
        
        oneHourBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        thirtyMinsBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        oneAndHalfBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        twoHourBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
    }
    
    @IBAction func thirtyMinAction(sender:UIButton){
        
        resetDurationSelection()
        selectedDurationType = .thirtyMin
        thirtyMinsBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
    }
    @IBAction func oneHourAction(sender:UIButton){
 
        resetDurationSelection()
        selectedDurationType = .oneHour
        oneHourBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
    }
    @IBAction func oneAndHalfHourAction(sender:UIButton){
        
        resetDurationSelection()
        selectedDurationType = .oneAndhour
        oneAndHalfBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
    }
    @IBAction func twoHourAction(sender:UIButton){
        
        resetDurationSelection()
        selectedDurationType = .twohour
        twoHourBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
    }
    
    @IBAction func nextAction(){
        
        if(validateFields()){
            self.resetErrorStatus()
            next()
        }
    }
    
    func resetErrorStatus(){
        
        errorLbl?.text = ""
    }
    
    func validateFields()->Bool{
        
        
        let emailValidated  = validateDate()
        let passwordValidated = validateTime()
        let durationValidation = validateDuration()
        return emailValidated && passwordValidated && durationValidation
    }
    
    fileprivate func validateDate()->Bool{
        
        if(dateField?.textField?.text == ""){
            
            dateField?.showError(text: "Date field can't be left empty !")
            return false
        }
        dateField?.resetErrorStatus()
        return true
    }
    fileprivate func validateTime()->Bool{
        
        if(startTimeField?.textField?.text == ""){
            
            startTimeField?.showError(text: "Time field can't be left empty !")
            return false
        }
        startTimeField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validateDuration()->Bool{
        
        if(selectedDurationType == .none){
            
            showError(message: "Please select session duration !")
            return false
        }
        resetErrorStatus()
        return true
    }
    
    func showError(message:String?){
        
        errorLbl?.text =  message ?? ""
    }
    
    func next(){
        
        guard let controller = SessionChatInfoController.instance() else{
            return
        }
        self.controller?.navigationController?.pushViewController(controller, animated: true)
        Log.echo(key: "yud", text: "Eligible for navigation")
    }
    
}
