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
    var startDate = ""
    var endDate = ""
    var actualStartDate:Date?
    var successHandler:(()->())?
    
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
        isPickerHidden = false
        pickerContainer?.isHidden = false
        
//        if isPickerHidden == true {
//
//            isPickerHidden = false
//            pickerContainer?.isHidden = false
//        }else{
//
//            isPickerHidden = true
//            pickerContainer?.isHidden = true
//        }
    }
    
    @IBAction func startTimeAction(sender:UIButton?){
        
        selectedPickerType = .time
        timePicker?.datePickerMode = .time
        startTimeField?.textField?.text = startTime
        isPickerHidden = false
        pickerContainer?.isHidden = false
        
//        if isPickerHidden == true {
//
//            isPickerHidden = false
//            pickerContainer?.isHidden = false
//        }else{
//
//            isPickerHidden = true
//            pickerContainer?.isHidden = true
//        }
    }
    
    func setStartDate(date:Date?){
        
        guard let date = date else{
            return
        }
       
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startDate = dateFormatter.string(from: date)
        Log.echo(key: "yud", text: "Start Date is \(startDate)")
    }
    
    func setEndTime(date:Date?){
      
        guard let date = date else{
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm:ss"
        endDate = dateFormatter.string(from: date)
        Log.echo(key: "yud", text: "End Date is \(startDate)")
    }
    
    var selectedTime:String{
       
        get{
            
            Log.echo(key: "yud", text: "Provided date is \(String(describing: timePicker?.date))")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "dd MMM, yyyy"
            if let cd  = timePicker?.date{
                setStartDate(date:timePicker?.date)
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
                
                setEndTime(date:timePicker?.date)
                return dateFormatter.string(from: cd)
            }
            return ""
        }
    }
    
    func getStartDateForParameter()->String{
        
        let date = startDate + " " + endDate
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let newdate = dateFormatter.date(from: date){
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let requiredString = dateFormatter.string(from: newdate)
            return requiredString
        }
        return ""
    }
    
    func getEndDateForParameter()->String{
        
        let startDate = getStartDateForParameter()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let newDate = dateFormatter.date(from: startDate){
            
            let calendar = Calendar.current
            var date:Date?
            if selectedDurationType == .thirtyMin{
              
                 date = calendar.date(byAdding: .minute, value: 30, to: newDate)
            }else if selectedDurationType == .oneHour{
                
                 date = calendar.date(byAdding: .minute, value: 60, to: newDate)
            }else if selectedDurationType == .oneAndhour{
                
                date = calendar.date(byAdding: .minute, value: 90, to: newDate)
                
            }else if selectedDurationType == .twohour{
                
                date = calendar.date(byAdding: .minute, value: 120, to: newDate)
            }else if selectedDurationType == .none{
              
                return ""
            }
            if let date = date{
                return dateFormatter.string(from: date)
            }
            return ""
        }
        return ""
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
            if let handler = successHandler{
                handler()
            }
            next()
        }
    }
    
    func switchTab(){
        
        if(validateFields()){
            self.resetErrorStatus()
            if let handler = successHandler{
                handler()
            }
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
    
    func getParam()->[String:Any]{

        guard let id = SignedUserInfo.sharedInstance?.id else {
            return ["":""]
        }
        
        var param = [String:Any]()
        param["title"] = "Chat Session"
        param["start"] = getStartDateForParameter()
        param["end"] = getEndDateForParameter()
        param["userId"] = id
        param["isFree"] = false
        return param
    }
    
    func next(){
        
        Log.echo(key: "yud", text: "Required Date is \(getStartDateForParameter())")
        Log.echo(key: "yud", text: "End Date is \(getEndDateForParameter())")
        
        guard let controller = SessionChatInfoController.instance() else{
            return
        }
        controller.param  = getParam()
        controller.selectedDurationType = self.selectedDurationType
        //getParam()
        //self.controller?.navigationController?.pushViewController(controller, animated: true)
        Log.echo(key: "yud", text: "Eligible for navigation")
    }
    
    func fillInfo(controller:SessionChatInfoController?){
        
        guard let controller = controller else{
            return
        }
        controller.param  = getParam()
        controller.selectedDurationType = self.selectedDurationType
    }
    
}
