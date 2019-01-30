//
//  SessionNewTimeRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 30/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol SessionNewTimeRootViewDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
}

class SessionNewTimeRootView:ExtendedView  {
    
    private let timePickerContainer = DatePicker()
    fileprivate var isTimePickerIsShowing = false
    @IBOutlet private var timeFld:SigninFieldView?
    var delegate:SessionNewTimeRootViewDelegate?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeTimePicker()
    }
    
    //MARK:- updating parameter
    private func updateParameters(){
        
        delegate?.getSchduleSessionInfo()?.startTime = self.timeFld?.textField?.text
        updateStartDateParam()
    }
    
    //MARK:- Button Actions
    @IBAction func timeAction(sender:UIButton){
        
        if isTimePickerIsShowing{
            hidePicker()
            return
        }
        showTimePicker()
        return
    }
    
    @IBAction func nextAction(sender:UIButton){
        
        if !validateFields(){
            return
        }
        updateParameters()
        delegate?.goToNextScreen()
        Log.echo(key: "yud", text: "way is clear")
    }
    
    func updateStartDateParam(){
        
        guard let startDate = getRequiredDateInStr() else{
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: startDate){
            delegate?.getSchduleSessionInfo()?.startDateTime = date
        }
    }
}

extension SessionNewTimeRootView{
    
    //MARK:- Validations
    func validateFields()->Bool{
        
        let timeValidated = validateTime()
        let isFutureTimeValidation = isFutureTime()
        return  timeValidated && isFutureTimeValidation
    }
    
    
    fileprivate func validateTime()->Bool{
        
        if(timeFld?.textField?.text == ""){
            
            timeFld?.showError(text: "Time is required.")
            return false
        }
        timeFld?.resetErrorStatus()
        return true
    }
    
    func isFutureTime()->Bool{
        
        if timeFld?.textField?.text != "" {
            
            guard let startDate = getRequiredDateInStr() else{
                return false
            }
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: startDate){
                
                Log.echo(key: "yud", text: "Diffrenece between the current time is \(date.timeIntervalSinceNow)")
                
                if date.timeIntervalSinceNow <=  0{
                    timeFld?.showError(text: "Please select the future time")
                    return false
                }else{
                    timeFld?.resetErrorStatus()
                    return true
                }
            }
            return true
        }
        return true
    }
    
    func getRequiredDateInStr()->String?{
        
        guard let date = delegate?.getSchduleSessionInfo()?.startDate else{
            return nil
        }
        
        if timeFld?.textField?.text == ""{
            return nil
        }
        
        let requiredDate = date+" "+(timeFld?.textField?.text ?? "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        if  let newDate = dateFormatter.date(from: requiredDate){
            
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let requiredNewDate = dateFormatter.string(from: newDate )
            return requiredNewDate
        }
        return nil
    }
}

extension SessionNewTimeRootView:XibDatePickerDelegate{
    
    //MARK:- PICKER INITILIZATION
    
    func initializeTimePicker(){
        
        timePickerContainer.frame = self.frame
        timePickerContainer.timePicker?.datePickerMode = .time
        timePickerContainer.delegate = self
        timePickerContainer.timePicker?.minuteInterval = 30
        //TODO:- Implement the minimum date
        //datePicker.timePicker?.minimumDate
        timePickerContainer.isHidden = true
        self.addSubview(timePickerContainer)
    }
    
    func doneTapped(selectedDate:Date?){
        
        hidePicker()
        guard let pickerDate = selectedDate else{
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let dateInStr = dateFormatter.string(from: pickerDate)
        timeFld?.textField?.text = dateInStr
        //birthDay = selectedDate
    }
    
    func pickerAction(selectedDate:Date?){
        
        guard let pickerDate = selectedDate else{
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let dateInStr = dateFormatter.string(from: pickerDate)
        timeFld?.textField?.text = dateInStr
        //birthDay = selectedDate
    }
    
    private func showTimePicker(){
        
        handleBirthadyFieldScrolling()
        self.isTimePickerIsShowing = true
        self.timePickerContainer.isHidden = false
    }
    
    private func hidePicker(){
        
        handleBirthadyFieldScrolling()
        self.isTimePickerIsShowing = false
        self.timePickerContainer.isHidden = true
    }
    
    //    private func getBirthDayDateForParam()->String{
    //
    //        guard let date = birthDay else {
    //            return ""
    //        }
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "dd/MM/yyyy"
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        let dateInStr = dateFormatter.string(from: date)
    //        Log.echo(key: "yud", text: "Parameter dob is \(dateInStr)")
    //        return dateInStr
    //    }
    
    //TODO:- Yet to implement BirthadyFieldScrolling
    func handleBirthadyFieldScrolling(){
    }
}
