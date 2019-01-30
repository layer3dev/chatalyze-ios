//
//  SessionTimeDateRootView.swift
//  Chatalyze
//
//  Created by Mansa on 09/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class SessionTimeDateRootView:ExtendedView{
 
    var activeControllerListner:((ScheduleSessionController.CurrentControllerFlag)->())?
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
    @IBOutlet var currentZoneShowingLbl:UILabel?
    
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
  
        paintFullBorder()
        showingCurrentTimeZone()
        acivateFlagForCurrentController()
    }
    
    func acivateFlagForCurrentController(){
        
        if let activate = activeControllerListner {
            activate(ScheduleSessionController.CurrentControllerFlag.DateTimeController)
        }
    }
    
    func showingCurrentTimeZone(){
        
        currentZoneShowingLbl?.text = TimeZone.current.abbreviation() ?? ""
    }
    
    func paintFullBorder(){
        
        dateField?.isCompleteBorderAllow = true
        startTimeField?.isCompleteBorderAllow = true
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
            validateDate()
        }
        
        if selectedPickerType == .time{
          
           //dateField?.textField?.text = selectedTime
            startTimeField?.textField?.text = startTime
            validateTime()
        }
    }
    
    @IBAction func dateAction(sender:UIButton?){
        
        selectedPickerType = .date
        timePicker?.datePickerMode = .date
        timePicker?.minuteInterval = 30
        timePicker?.minimumDate = Date()
        dateField?.textField?.text = selectedTime
        isPickerHidden = false
        pickerContainer?.isHidden = false
        validateDate()
        
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
        timePicker?.minuteInterval = 30
        timePicker?.minimumDate = nil
        startTimeField?.textField?.text = startTime
        isPickerHidden = false
        pickerContainer?.isHidden = false
        validateTime()
        
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
            //dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "dd MMM, yyyy"
            if let cd  = timePicker?.date{
               // setStartDate(date:timePicker?.date)
                
                Log.echo(key: "yud" ,text: "Selected time is \(dateFormatter.string(from: cd))")
                startDate = dateFormatter.string(from: cd).replacingOccurrences(of: ":", with: "")
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
            //dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "hh:mm a"
            if let cd  = timePicker?.date{
                Log.echo(key: "yud" ,text: "Selected date is \(dateFormatter.string(from: cd))")
                endDate = dateFormatter.string(from: cd)
                //setEndTime(date:timePicker?.date)
                return dateFormatter.string(from: cd)
            }
            return ""
        }
    }
    
    func getStartDateForParameter()->String {
        
        Log.echo(key: "yud", text: "Param start and the end Date is \(startDate) and the end date is \(endDate)")
        
        let date = startDate + " " + endDate
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        // dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a"
        
        if let newdate = dateFormatter.date(from: date){
            
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let requiredString = dateFormatter.string(from: newdate)
            
            Log.echo(key: "yud", text: "Final Start Date is  \(requiredString)")
            return requiredString
        }
        return ""
    }
    
    func getEndDateForParameter()->String {
        
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
        validateDuration()
    }
    @IBAction func oneHourAction(sender:UIButton){
 
        resetDurationSelection()
        selectedDurationType = .oneHour
        oneHourBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
        validateDuration()
    }
    @IBAction func oneAndHalfHourAction(sender:UIButton){
        
        resetDurationSelection()
        selectedDurationType = .oneAndhour
        oneAndHalfBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
        validateDuration()
    }
    @IBAction func twoHourAction(sender:UIButton){
        
        resetDurationSelection()
        selectedDurationType = .twohour
        twoHourBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
        validateDuration()
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
        
        let dateValidated  = validateDate()
        let timeValidated = validateTime()
        let durationValidation = validateDuration()
        let isFutureTimeValidation = isFutureTime()
        
        return dateValidated && timeValidated && durationValidation && isFutureTimeValidation
    }
    
     func validateDate()->Bool{
        
        if(dateField?.textField?.text == ""){
            
            dateField?.showError(text: "Date is required.")
            return false
        }
        dateField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validateTime()->Bool{
        
        if(startTimeField?.textField?.text == ""){
            
            startTimeField?.showError(text: "Time is required.")
            return false
        }
        startTimeField?.resetErrorStatus()
        return true
    }
    
    func isFutureTime()->Bool{
       
        if startDate != "" {
            
            let startDate = getStartDateForParameter()
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: startDate){
                
                Log.echo(key: "yud", text: "Diffrenece between the current time is \(date.timeIntervalSinceNow)")
               
                if date.timeIntervalSinceNow <=  0{
                    startTimeField?.showError(text: "Please select the future time")
                    return false
                }else{
                    startTimeField?.resetErrorStatus()
                    return true
                }
            }
            return true
        }
        return true
    }
    
    
    fileprivate func validateDuration()->Bool{
        
        if(selectedDurationType == .none){
            
            showError(message: "Session duration is required.")
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
        param["selectedHourSlot"] = selectedDurationType
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
