//
//  EditSessionFormRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EditSessionFormRootView:ExtendedView {
    
    @IBOutlet var donationInfoLabel:UILabel?
    @IBOutlet var screenShotInfoLabel:UILabel?
    
    @IBOutlet var donationCustomSwitch:EditCustomSwitch?
    @IBOutlet var screenShotCustomSwitch:EditCustomSwitch?
    
    @IBOutlet var earningFormulaLbl:UILabel?
    @IBOutlet var totalEarningLabel:UILabel?
    
    @IBOutlet private var maxEarning:UIView?
    
    @IBOutlet private var maxEarningHeightConstraint:NSLayoutConstraint?
    
    //********
    
    @IBOutlet var chatCalculatorHeightConstrait:NSLayoutConstraint?
    
    @IBOutlet var priceAmountHieghtConstrait:NSLayoutConstraint?
    
    enum slotDurationMin:Int{
        
        case two = 0
        case three = 1
        case five = 2
        case ten = 3
        case fifteen = 4
        case thirty = 5
        case sixty = 6
        case none = 7
    }
    
    enum totalChatDuration:Int{
        
        case thirtyMinutes = 0
        case oneHour = 1
        case oneAndHalfHour = 2
        case twoHour = 3
        case none = 4
    }
    
    var slotSelected:slotDurationMin = .none
    @IBOutlet var slotDurationErrorLbl:UILabel?
    @IBOutlet var chatCalculatorLbl:UILabel?
    @IBOutlet var chatTotalNumberOfSlots:UILabel?
    @IBOutlet private var chatCalculatorView:UIView?

    var totalTimeOfChat:totalChatDuration = .none
    
    //***
    var scheduleInfo:ScheduleSessionInfo? = ScheduleSessionInfo()
    
    var planInfo:PlanInfo?
    
    enum pickerType:Int {
        
        case time = 0
        case date = 1
        case none = 10
    }
    
    var selectedPickerType:pickerType = .none
    
    @IBOutlet var titleField:SigninFieldView?
    @IBOutlet var dateField:SigninFieldView?
    
    @IBOutlet var timeField:SigninFieldView?
    @IBOutlet var sessionLength:SigninFieldView?
    
    @IBOutlet var chatLength:SigninFieldView?
    @IBOutlet var freeField:SigninFieldView?
    
    @IBOutlet var priceField:SigninFieldView?
    @IBOutlet var editSessionButton:UIButton?
    @IBOutlet var priceAmountField:SigninFieldView?

    @IBOutlet var scrollView:FieldManagingScrollView?
    
    private let datePickerContainer = DatePicker()
    fileprivate var isDatePickerIsShowing = false
    
    private let timePickerContainer = DatePicker()
    fileprivate var isTimePickerIsShowing = false
    
    var sessionArray = ["30 mins","1 hour","1.5 hours","2 hours"]
    //var chatLengthArray = ["2 mins","3 mins","5 mins","10 mins","15 mins","30 mins","60 mins"]
    var chatLengthArray = ["2 mins","3 mins","5 mins","10 mins","15 mins","30 mins"]
    
    let chatLengthPicker = CustomPicker()
    let sessionLengthPicker = CustomPicker()
    
    var isCustomPickerShowing = false
    
    @IBOutlet var donationSwitch:UISwitch?
    @IBOutlet var screenShotSwitch:UISwitch?
    @IBOutlet var donationLabel:UILabel?
    @IBOutlet var screenShotLabel:UILabel?
    
    var eventInfo:EventInfo?
    var isPricingEnable:Bool? = nil
    var controller:EditSessionFormController?
    
    var desiredDate:String {
    
        guard let date = self.eventInfo?.startDate else{
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let dateInStr = dateFormatter.string(from: date)
        dateField?.textField?.text = dateInStr
        return dateInStr
    }
    
    var desiredTime:String{
        
        guard let startDate = self.eventInfo?.startDate else{
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let dateInStr = dateFormatter.string(from: startDate)
        return dateInStr
    }
    
    //MARK:- Tracking checks
    
    var isTitleTracked = false
    var isDateTracked = false
    var isTimeTracked = false
    var isChatLengthTracked = false
    var isSessionLengthTracked = false
    var isPriceFieldTracked = false
    
    //MARK:- Segment.io Tracking Methods
    //To be overridden
    
    func titleTracking(){
    }
    
    func dateTracking(){
    }
    
    func timeTracking(){
    }
    
    func ChatLengthTracking(){
    }
    
    func SessionLengthTracking(){
    }
    
    func priceFieldTracking(){
    }
    
    //For cancel session
    
    @IBOutlet var cancelSessionView:UIView?
    var isCancelSessionVisible = false
    @IBOutlet var goBackButtonContainer:UIView?
    @IBOutlet var confirmButton:UIButton?
    
    @IBAction func cancelAction(sender:UIButton){
        
        if self.isCancelSessionVisible{
            
            self.layoutIfNeeded()
            self.isCancelSessionVisible = false
            UIView.animate(withDuration: 0.35) {
                self.cancelSessionView?.alpha = 0
            }
            return
        }
        
        self.isCancelSessionVisible = true
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.35) {
            self.cancelSessionView?.alpha = 1
        }
        return
    }
        
    @IBAction func keepITAction(sender:UIButton){
        
        self.layoutIfNeeded()
        self.isCancelSessionVisible = false
        UIView.animate(withDuration: 0.35) {
            self.cancelSessionView?.alpha = 0
        }
        return
    }
    
    @IBAction func cancelITAction(sender:UIButton){
        
        self.controller?.cancelSession()
        //service for cancel Session
    }
    
    @IBAction func donationSwitchAction(_ sender: Any) {
        
        if donationSwitch?.isOn ?? true {
            
            donationSwitch?.setOn(false, animated: true)
            donationLabel?.text = "OFF"
        }else{
            
            donationSwitch?.setOn(true, animated: true)
            donationLabel?.text = "ON"
        }
    }
    
    @IBAction func screenShotSwitch(_ sender: Any){
        
        if screenShotSwitch?.isOn ?? true {
            
            screenShotSwitch?.setOn(false, animated: true)
            screenShotLabel?.text = "OFF"
        }else{
            
            screenShotSwitch?.setOn(true, animated: true)
            screenShotLabel?.text = "ON"
        }
    }
    
    func paintInteface() {        
        
        goBackButtonContainer?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ?  32.5 : 22.5
        
        confirmButton?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ?  32.5 : 22.5
        
        goBackButtonContainer?.layer.masksToBounds = true
        confirmButton?.layer.masksToBounds = true
        
        self.chatCalculatorView?.layer.masksToBounds = true
        self.chatCalculatorView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.chatCalculatorView?.layer.borderWidth = 1
        self.chatCalculatorView?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
        self.titleField?.textField?.addDoneButtonOnKeyboard()
        
        self.maxEarning?.layer.masksToBounds = true
        self.maxEarning?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.maxEarning?.layer.borderWidth = 1
        self.maxEarning?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
        
        self.titleField?.isCompleteBorderAllow = true
        self.dateField?.isCompleteBorderAllow = true
        self.timeField?.isCompleteBorderAllow = true
        self.sessionLength?.isCompleteBorderAllow = true
        self.chatLength?.isCompleteBorderAllow = true
        self.freeField?.isCompleteBorderAllow = true
        self.priceField?.isCompleteBorderAllow = true
        self.roundToEditSessionButton()
        
        self.priceAmountField?.textField?.doneAccessory = true
        self.priceAmountField?.isCompleteBorderAllow = true
        
        priceAmountField?.textField?.keyboardType = UIKeyboardType.decimalPad        
    }
    
    func initializeCustomSwitch(){
        
        donationCustomSwitch?.toggleAction = {[weak self] in
            
            if self?.donationCustomSwitch?.isOn ?? false{
                
                self?.donationLabel?.text = "ON"
                self?.donationInfoLabel?.text = "People will have the option to give you a donation after their chats."
                self?.scheduleInfo?.tipEnabled = true

                UIView.animate(withDuration: 0.15, animations: {
                    
                    self?.donationInfoLabel?.alpha = 1
                    self?.layoutIfNeeded()
                })
                return
            }
            
            self?.scheduleInfo?.tipEnabled = false
            UIView.animate(withDuration: 0.15, animations: {
                
                self?.donationInfoLabel?.alpha = 0
                self?.layoutIfNeeded()
            })
            self?.donationInfoLabel?.text = ""
            self?.donationLabel?.text = "OFF"
            return
        }
        
        screenShotCustomSwitch?.toggleAction = {[weak self] in
            
            if self?.screenShotCustomSwitch?.isOn ?? false {
              
                self?.screenShotLabel?.text = "ON"
                self?.screenShotInfoLabel?.text = "A screenshot will automatically capture for each person you chat with."
                self?.scheduleInfo?.isScreenShotAllow = true
                UIView.animate(withDuration: 0.15, animations: {
                    self?.screenShotInfoLabel?.alpha = 1
                    self?.layoutIfNeeded()
                })
                return

            }else{
                
                self?.screenShotLabel?.text = "OFF"
                self?.scheduleInfo?.isScreenShotAllow = false
                UIView.animate(withDuration: 0.15, animations: {
                    self?.screenShotInfoLabel?.alpha = 0
                    self?.layoutIfNeeded()
                })
                self?.screenShotInfoLabel?.text = ""
                return
            }
        }
    }
    
    func initializeVariable(){
        
        initializeCustomSwitch()
        initializeDatePicker()
        initializeTimePicker()
        initializeChatLengthPicker()
        initializeSessionLengthPicker()
        
        self.titleField?.textField?.delegate = self
        self.dateField?.textField?.delegate = self
        self.timeField?.textField?.delegate = self
        self.sessionLength?.textField?.delegate = self
        self.chatLength?.textField?.delegate = self
        self.freeField?.textField?.delegate = self
        self.priceField?.textField?.delegate = self
        self.priceAmountField?.textField?.delegate = self
        priceAmountField?.textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func fillInfo(info:EventInfo?){
        
        guard let eventInfo = info else{
            return
        }
        
        //Printing whole Info
        
        Log.echo(key: "edit form", text: "Title is \(eventInfo.title) start date is \(desiredDate) desired time is \(desiredTime) duration is \(eventInfo.duration) duration of the chat is \(eventInfo.startDate?.timeIntervalSince(eventInfo.endDate ?? Date())) is event free \(eventInfo.isFree) screenshot info if \(eventInfo.isScreenShotAllowed) istipenabled \(eventInfo.tipEnabled) price of the event is \(eventInfo.price)")
        
        
        self.eventInfo = eventInfo
        
        self.titleField?.textField?.text = eventInfo.title
        self.dateField?.textField?.text = desiredDate
        self.timeField?.textField?.text = desiredTime
        
        if eventInfo.duration == 2{
            
            slotSelected = .two
            self.chatLength?.textField?.text =  chatLengthArray[0]
        }
        if eventInfo.duration == 3{
            
            slotSelected = .three
            self.chatLength?.textField?.text =  chatLengthArray[1]
        }
        if eventInfo.duration == 5{
           
            slotSelected = .five
            self.chatLength?.textField?.text =  chatLengthArray[2]
        }
        if eventInfo.duration == 10{
            
            slotSelected = .ten
            self.chatLength?.textField?.text =  chatLengthArray[3]
        }
        if eventInfo.duration == 15{
           
            slotSelected = .fifteen
            self.chatLength?.textField?.text =  chatLengthArray[4]
        }
        if eventInfo.duration == 30 {
           
            slotSelected = .thirty
            self.chatLength?.textField?.text =  chatLengthArray[5]
        }
        if eventInfo.duration == 60 {
            
            if chatLengthArray.count > 6 {
                
                slotSelected = .sixty
                self.chatLength?.textField?.text =  chatLengthArray[6]
            }
        }
        
        if let totalLengthOfChat = eventInfo.endDate?.timeIntervalSince(eventInfo.startDate ?? Date()){
            let minutes = Int(totalLengthOfChat/60)
           
            Log.echo(key: "yud", text: "minutes of the slot time is \(minutes)")
            if minutes == 30{
              
                totalTimeOfChat = .thirtyMinutes
                self.sessionLength?.textField?.text = sessionArray[0]
            }
            if minutes == 60{
               
                totalTimeOfChat = .oneHour
                self.sessionLength?.textField?.text = sessionArray[1]
            }
            if minutes == 90{
             
                totalTimeOfChat = .oneAndHalfHour
                self.sessionLength?.textField?.text = sessionArray[2]

            }
            if minutes == 120{
                
                totalTimeOfChat = .twoHour
                self.sessionLength?.textField?.text = sessionArray[3]
            }
        }
        
        if eventInfo.tipEnabled == true {
            
            donationCustomSwitch?.setOn()
            donationLabel?.text = "ON"
            donationInfoLabel?.text = "People will have the option to give you a donation after their chats."
            //donationSwitch?.setOn(true, animated: true)
        }else{
            
            donationCustomSwitch?.setOff()
            donationInfoLabel?.text = ""
            donationLabel?.text = "OFF"
            //donationSwitch?.setOn(false, animated: true)
        }
        
        if eventInfo.isScreenShotAllowed != "automatic"{
         
            //screenShotSwitch?.setOn(false, animated: true)
            screenShotCustomSwitch?.setOff()
            screenShotLabel?.text = "OFF"
            screenShotInfoLabel?.text = ""
        }else{

            //screenShotSwitch?.setOn(true, animated: true)
            screenShotCustomSwitch?.setOn()
            screenShotLabel?.text = "ON"
            screenShotInfoLabel?.text = "A screenshot will automatically capture for each person you chat with."
        }
        
        if eventInfo.isFree ?? false{
            
            hidePriceFillingField()
            
        }else{
            
            showHeightPriceFllingField()
            self.priceAmountField?.textField?.text = "\((eventInfo.price ?? 0.0))"
        }
        
        if self.eventInfo?.slotsInfoLists.count ?? 0 > 0{
            slotIdentifiedDisbaleView()
        }
        
        updatescheduleInfo()
    }
    
    
    func roundToEditSessionButton() {
        
        editSessionButton?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 32.5 : 22.5
        editSessionButton?.layer.masksToBounds = true
    }
    
    //MARK:- Button Actions
    @IBAction func sessionDateAction(sender:UIButton){
        
        if !isDateTracked{
            
            dateTracking()
            isDateTracked = true
        }
        if isDatePickerIsShowing{
            
            hidePicker()
            return
        }
        showDatePicker()
        selectedPickerType = .date
        return
    }
    
    @IBAction func timeAction(sender:UIButton){
        
        if !isTimeTracked{
            
            self.timeTracking()
            isTimeTracked = true
        }
        
        if isTimePickerIsShowing{
            hidePicker()
            return
        }
        showTimePicker()
        selectedPickerType = .time
        return
    }
    
    @IBAction func chatLengthAction(sender:UIButton){
        
        if !isChatLengthTracked{
            
            self.ChatLengthTracking()
            isChatLengthTracked = true
        }
        
        if isCustomPickerShowing{
            hidePicker()
            return
        }
        showChatLengthPicker()
        return
    }
    
    @IBAction func sessionLengthAction(sender:UIButton){
        
       
        if !isSessionLengthTracked{
          
            SessionLengthTracking()
            isSessionLengthTracked = true
        }
        if isCustomPickerShowing{
            hidePicker()
            return
        }
        showSessionLengthPicker()
        return
    }
    
    @IBAction func freeAction(sender:UIButton){
        
        hidePriceFillingField()
    }
    
    func hidePriceFillingField(){
   
        self.freeField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255, alpha: 1)
        self.priceField?.backgroundColor = UIColor.white
        self.isPricingEnable = false
        UIView.animate(withDuration: 0.25) {
            
            self.priceAmountHieghtConstrait?.constant = 0
            self.layoutIfNeeded()
        }
        self.priceAmountField?.textField?.text = ""
        self.priceAmountField?.resetErrorStatus()
        paintMaximumEarningCalculator()
    }
    
    @IBAction func paidActionAction(sender:UIButton){
        
        showHeightPriceFllingField()
        //Show Price Field existing price
    }
    
    func showHeightPriceFllingField(){
        
        self.isPricingEnable = true
        self.priceField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255, alpha: 1)
        self.freeField?.backgroundColor = UIColor.white
        UIView.animate(withDuration: 0.25) {
            
            self.priceAmountHieghtConstrait?.constant = UIDevice.current.userInterfaceIdiom == .pad ? 70:50
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func doneEditing(){
        
        if !validateFields(){
            return
        }
        save()
        Log.echo(key: "yud", text: "Final para are \(getParam())")
    }
    
    func save(){
        
        guard let eventId = self.controller?.eventInfo?.id else{
            return
        }
        
        guard let params = getParam() else{
            return
        }
        
        self.controller?.showLoader()
        EditMySessionProcessor().editInfo(eventId: eventId, param: params) { (success, response) in
            
            self.controller?.stopLoader()
            if success{
                
                self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Session details edited successfully.", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                    
                    self.controller?.navigationController?.popToRootViewController(animated: true)
                })
                return
            }
            self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Error occurred", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                
            })
            return
        }
    }
    
}

extension EditSessionFormRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == titleField?.textField{
            if !isTitleTracked {
                
                self.titleTracking()
                isTitleTracked = true
            }
        }
        
        if textField == priceAmountField?.textField{
            if !isPriceFieldTracked {
                
                priceFieldTracking()
                isPriceFieldTracked = true
            }
        }
        
        
        if textField == priceAmountField?.textField {
            
//            if (((textField.text?.count) ?? 0)+(string.count)) > 4{
//                return false
//            }
            
            let str1 = textField.text ?? ""
            let str2 = string
            let concatenated = str1+str2
            Log.echo(key: "yud", text: "str1 \(str1) str2 \(str2) concatenated \(str1+str2)")
            
            if string == "" {
                
                //Approving the backspace
                return true
            }
            
            if isDecimalDigitsExceeds(text: concatenated) {
                return false
            }
            
            if isExceedsMaximumPrice(text: concatenated) {
                return false
            }
            
            if string.isDouble {
                return true
            }
            
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
       
        updatescheduleInfo()
        paintMaximumEarningCalculator()
        let _ = priceValidation()
    }
}

extension EditSessionFormRootView{
    
    func resetErrorStatus() {
        
        titleField?.resetErrorStatus()
    }
    
    func validateFields()->Bool {
        
        if self.eventInfo?.slotsInfoLists.count ?? 0 > 0{
            
            let titleValidated  = titleValidation()
            return titleValidated
        }
        
        let titleValidated  = titleValidation()
        let dateValidated  = validateDate()
        let timeValidated = validateTime()
        let isFutureTimeValidation = isFutureTime()
        let durationValidated = validateSlotTime()
        let priceValidated = priceValidation()
        let lengthBalanceValidate = validateBalanceBetweenSessionAndChatLength()
        let sessionLengthValidation = validateSessionLength()
        
        Log.echo(key: "yud", text: "titleValidated \(titleValidated) dateValidated\(dateValidated) timeValidated\(timeValidated) isFutureTimeValidation\(isFutureTimeValidation) durationValidated\(durationValidated) priceValidated \(priceValidated)")
        
        return titleValidated && dateValidated && timeValidated && isFutureTimeValidation && durationValidated && priceValidated && lengthBalanceValidate && sessionLengthValidation
    }
    
    fileprivate func titleValidation()->Bool {
        
        if(titleField?.textField?.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""){
            
            titleField?.showError(text: "Title is required.")
            return false
        }
        titleField?.resetErrorStatus()
        return true
    }
    
    func showError(message:String?) {
        //errorLbl?.text =  message ?? ""
    }
}

extension EditSessionFormRootView {
    
    func validateDate()->Bool {
        
        if(dateField?.textField?.text == ""){
            dateField?.showError(text: "Date is required.")
            return false
        }
        dateField?.resetErrorStatus()
        return true
    }
    
    func validateBalanceBetweenSessionAndChatLength()->Bool{
        
        if slotSelected == .sixty && totalTimeOfChat == .thirtyMinutes{
            sessionLength?.showError(text: "Session length must be greater or equal to the chat length.")
            return false
        }
        sessionLength?.resetErrorStatus()
        return true
    }
    
    func validateSessionLength()->Bool{
        
        if totalTimeOfChat == .none{
            sessionLength?.showError(text: "Session length is required.")
            return false
        }
        sessionLength?.resetErrorStatus()
        return true
    }
}

extension EditSessionFormRootView:XibDatePickerDelegate {
    
    //MARK:- PICKER INITILIZATION
    func initializeDatePicker(){
        
        datePickerContainer.frame = self.frame
        datePickerContainer.frame.origin.y = datePickerContainer.frame.origin.y - CGFloat(64)
        datePickerContainer.timePicker?.datePickerMode = .date
        datePickerContainer.delegate = self
        datePickerContainer.timePicker?.minimumDate = Date()
        //TODO:- Implement the minimum date
        //datePicker.timePicker?.minimumDate
        datePickerContainer.isHidden = true
        self.addSubview(datePickerContainer)
    }
    
    func doneTapped(selectedDate:Date?) {
        
        if selectedPickerType == .date{
            
            guard let pickerDate = selectedDate else{
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let dateInStr = dateFormatter.string(from: pickerDate)
            dateField?.textField?.text = dateInStr
            //birthDay = selectedDate
        }
        
        if selectedPickerType == .time {
            
            
            guard let pickerDate = selectedDate else{
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let dateInStr = dateFormatter.string(from: pickerDate)
            timeField?.textField?.text = dateInStr
            //birthDay = selectedDate
        }
        hidePicker()
        updatescheduleInfo()
        paintChatCalculator()
        paintMaximumEarningCalculator()
    }
    
    func pickerAction(selectedDate:Date?){
        
        if selectedPickerType == .date{
            
            guard let pickerDate = selectedDate else{
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let dateInStr = dateFormatter.string(from: pickerDate)
            dateField?.textField?.text = dateInStr
            //birthDay = selectedDate
            return
        }
        
        if selectedPickerType == .time {
            
            guard let pickerDate = selectedDate else{
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let dateInStr = dateFormatter.string(from: pickerDate)
            timeField?.textField?.text = dateInStr
            //birthDay = selectedDate
            return
        }
    }
    
    private func showDatePicker(){
        
        handleBirthadyFieldScrolling()
        self.isDatePickerIsShowing = true
        self.datePickerContainer.isHidden = false
    }
    
    //TODO:- Yet to implement BirthadyFieldScrolling
    func handleBirthadyFieldScrolling(){
    }
}

extension EditSessionFormRootView{
    
    //MARK:- PICKER INITILIZATION
    func initializeTimePicker(){
        
        timePickerContainer.frame = self.frame
        timePickerContainer.frame.origin.y = timePickerContainer.frame.origin.y - CGFloat(64)
        timePickerContainer.timePicker?.datePickerMode = .time
        timePickerContainer.delegate = self
        timePickerContainer.timePicker?.minuteInterval = 30
        //TODO:- Implement the minimum date
        //datePicker.timePicker?.minimumDate
        timePickerContainer.isHidden = true
        self.addSubview(timePickerContainer)
    }
    
    fileprivate func validateTime()->Bool{
        
        if(timeField?.textField?.text == ""){
            
            timeField?.showError(text: "Time is required.")
            return false
        }
        timeField?.resetErrorStatus()
        return true
    }
    
    func isFutureTime()->Bool{
        
        if timeField?.textField?.text != "" {
            
            guard let startDate = getRequiredDateInStr() else{
                return false
            }
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: startDate) {
                
                Log.echo(key: "yud", text: "Diffrenece between the current time is \(date.timeIntervalSinceNow)")
                
                if date.timeIntervalSinceNow <=  0{
                    
                    timeField?.showError(text: "Please select the future time")
                    return false
                }else{
                    timeField?.resetErrorStatus()
                    return true
                }
            }
            return true
        }
        return true
    }
    
}


extension EditSessionFormRootView{
    
    private func showChatLengthPicker(){
        
        handleBirthdayFieldScrolling()
        self.isCustomPickerShowing = true
        self.chatLengthPicker.isHidden = false
    }
    private func showSessionLengthPicker(){
        
        handleBirthdayFieldScrolling()
        self.isCustomPickerShowing = true
        self.sessionLengthPicker.isHidden = false
    }
    
    
    private func showTimePicker(){
        
        handleBirthdayFieldScrolling()
        self.isTimePickerIsShowing = true
        self.timePickerContainer.isHidden = false
    }
    
    private func hidePicker(){
        
        handleBirthdayFieldScrolling()
        self.isTimePickerIsShowing = false
        self.timePickerContainer.isHidden = true
        self.isDatePickerIsShowing = false
        self.datePickerContainer.isHidden = true
        self.isCustomPickerShowing = false
        self.sessionLengthPicker.isHidden = true
        self.chatLengthPicker.isHidden = true
    }
    
    //TODO:- Yet to implement BirthadyFieldScrolling.
    func handleBirthdayFieldScrolling(){
    }
}


extension EditSessionFormRootView:UIPickerViewDelegate, UIPickerViewDataSource{
    
    func initializeChatLengthPicker(){
        
        chatLengthPicker.frame = self.frame
        chatLengthPicker.frame.origin.y = chatLengthPicker.frame.origin.y - CGFloat(64)
        chatLengthPicker.delegate = self
        chatLengthPicker.currentType = .chatLength
        chatLengthPicker.picker?.delegate = self
        chatLengthPicker.picker?.dataSource = self
        chatLengthPicker.picker?.reloadAllComponents()
        //TODO:- Implement the minimum date
        //datePicker.timePicker?.minimumDate
        chatLengthPicker.isHidden = true
        self.addSubview(chatLengthPicker)
    }
    
    func initializeSessionLengthPicker(){
        
        sessionLengthPicker.frame = self.frame
        sessionLengthPicker.frame.origin.y = sessionLengthPicker.frame.origin.y - CGFloat(64)
        sessionLengthPicker.delegate = self
        sessionLengthPicker.currentType = .sessionLength
        sessionLengthPicker.picker?.delegate = self
        sessionLengthPicker.picker?.dataSource = self
        chatLengthPicker.picker?.reloadAllComponents()
        //TODO:- Implement the minimum date
        //datePicker.timePicker?.minimumDate
        sessionLengthPicker.isHidden = true
        self.addSubview(sessionLengthPicker)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == chatLengthPicker.picker {
            return chatLengthArray.count
        }
        
        if pickerView == sessionLengthPicker.picker {
            return sessionArray.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == chatLengthPicker.picker {
            return chatLengthArray[row] as String
        }
        
        if pickerView == sessionLengthPicker.picker {
            return sessionArray[row] as String
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == chatLengthPicker.picker {
            
            chatLength?.textField?.text = chatLengthArray[row]
            
            if row == 0{
                slotSelected = .two
            }
            if row == 1{
                slotSelected = .three
            }
            if row == 2{
                slotSelected = .five
            }
            if row == 3{
                slotSelected = .ten
            }
            if row == 4{
                slotSelected = .fifteen
            }
            if row == 5{
                slotSelected = .thirty
            }
            if row == 6{
                slotSelected = .sixty
            }
            return
        }
        
        if pickerView == sessionLengthPicker.picker {
            
            //paintChatCalculator()
            sessionLength?.textField?.text = sessionArray[row]
            
            if row == 0{
                totalTimeOfChat = .thirtyMinutes
            }
            if row == 1{
                totalTimeOfChat = .oneHour
            }
            if row == 2{
                totalTimeOfChat = .oneAndHalfHour
            }
            if row == 3{
                totalTimeOfChat = .twoHour
            }
            return
        }
    }
}

extension EditSessionFormRootView:CustomPickerDelegate{
    
    func pickerDoneTapped(type: CustomPicker.pickerType) {
        
        if type == .sessionLength{
            
            if sessionLengthPicker.picker?.selectedRow(inComponent: 0) == 0 {
                sessionLength?.textField?.text = sessionArray[0]
                totalTimeOfChat = .thirtyMinutes
            }
        }
        
        if type == .chatLength{
            
            if chatLengthPicker.picker?.selectedRow(inComponent: 0) == 0 {
                chatLength?.textField?.text = chatLengthArray[0]
                slotSelected = .two
            }
        }
        
        hidePicker()
        updatescheduleInfo()
        paintChatCalculator()
        paintMaximumEarningCalculator()
    }
}

extension EditSessionFormRootView {
    
    func hidePaintChatCalculator(){
        
        chatCalculatorHeightConstrait?.priority = UILayoutPriority(rawValue: 999.0)
    }
    
    func showPaintChatCalculator(){
        
        chatCalculatorHeightConstrait?.priority = UILayoutPriority(rawValue: 250.0)
    }
    
    func paintChatCalculator(){
        
        guard let info = scheduleInfo else{
            hidePaintChatCalculator()
            return
        }
        guard let startDate = info.startDateTime else{
            hidePaintChatCalculator()
            return
        }
        guard let endDate = info.endDateTime else{
            hidePaintChatCalculator()
            return
        }
        
        let totalDurationInMinutes = Int(endDate.timeIntervalSince(startDate)/60.0)
        
        var totalSlots = 0
        
        guard let singleChatDuration = self.scheduleInfo?.duration else{
            hidePaintChatCalculator()
            return
        }
        
        totalSlots = totalDurationInMinutes/singleChatDuration
        
        var fontSizeTotalSlot = 30
        var normalFont = 20
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            
            fontSizeTotalSlot = 26
            normalFont = 18
        }
        
        if totalSlots > 0 && totalDurationInMinutes > 0 && singleChatDuration > 0 {
            
            showPaintChatCalculator()

            Log.echo(key: "yud", text: "Slot number fetch SuccessFully \(totalSlots) and the totalMinutesOfChat is \(totalDurationInMinutes) and the single Chat is \(singleChatDuration)")
            
            chatCalculatorLbl?.text = "\(totalDurationInMinutes) min session length / \(singleChatDuration) min chat length ="
            
            let mutableStr  = "\(totalSlots)".toMutableAttributedString(font: "Nunito-ExtraBold", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
            
            let nextStr = " available 1:1 chats"
            let nextAttrStr  = nextStr.toAttributedString(font: "Nunito-Regular", size: (normalFont-3), color: UIColor(hexString: "#808080"), isUnderLine: false)
            
            mutableStr.append(nextAttrStr)
            chatTotalNumberOfSlots?.attributedText = mutableStr
            
            return
        }
        
        hidePaintChatCalculator()
        Log.echo(key: "yud", text: "Total number of the slot is \(totalSlots)")
    }
    
    fileprivate func validateSlotTime()->Bool{
        
        if(slotSelected == .none){
            
            chatLength?.showError(text:"Chat length is required.")
            return false
        }
        chatLength?.resetErrorStatus()
        return true
    }
}


extension EditSessionFormRootView{
    
    func isPriceZero(text:String?)->Bool{
        
        if let requiredPrice = Double(text ?? "0"){
            if requiredPrice == 0.0 {
                return true
            }
        }
        return false
    }
    
    func isSatisFyingMinimumPlanAmount(text:String?)->Bool{
        
        if  self.scheduleInfo?.minimumPlanPriceToSchedule ?? 0.0 <= 0.0{
            return true
        }
        
        if let priceInt = Double(text ?? "0"){
            
            if priceInt < self.scheduleInfo?.minimumPlanPriceToSchedule ?? 0.0{
                return false
            }
        }
        return true
    }
    
    func isExceedsMaximumPrice(text:String?)->Bool{
        
        if let priceStr = text{
            if let price = Double(priceStr){
                if price > 9999.0{
                    return true
                }
            }
        }
        return false
    }
    
    func isDecimalDigitsExceeds(text:String?)->Bool {
        
        if let digits = text{
            let digitsArray = digits.components(separatedBy: ".")
            Log.echo(key: "yud", text: "decimal digits count is \( digitsArray.count)")
            if digitsArray.count >= 3{
                
                //This is preventing user to insert multiple decimal digits in textfield.
                return true
            }
            if digitsArray.count > 1{
                
                Log.echo(key: "yud", text: "decimal digits are \( digitsArray[1])")
                if digitsArray[1].count > 2 {
                    return true
                }
                return false
            }
            return false
        }
        return false
    }
}

extension EditSessionFormRootView {
    
    func paintMaximumEarningCalculator(){
        
        guard let price = Double(priceAmountField?.textField?.text ?? "0.0") else{
            resetEarningCalculator()
            return
        }
        
        guard let info = self.scheduleInfo else{
            resetEarningCalculator()
            return
        }
        
        guard let totalSlots = info.totalSlots else{
            resetEarningCalculator()
            return
        }
        
        if price > 9999.0 {
            return
        }
        
        if price == 0.0 {
            resetEarningCalculator()
            return
        }
        
        maxEarningHeightConstraint?.priority = UILayoutPriority(rawValue: 250.0)
        
        let priceOfSingleChat = Double(price)
        let totalPriceOfChatwithoutTax = (priceOfSingleChat*Double(totalSlots))
        let paypalFeeofSingleChat = ((priceOfSingleChat*2.9)/100)+(0.30)
        let roundedPaypalFeeofSingleChatThreeDecimalPlace = paypalFeeofSingleChat.roundTo(places: 3)
        let roundedPaypalFeeofSingleChat = round(roundedPaypalFeeofSingleChatThreeDecimalPlace*100)/100
        Log.echo(key: "yud", text: "Paypal fee of the Single chat is \(roundedPaypalFeeofSingleChat) rounded exact i s\(roundedPaypalFeeofSingleChat.rounded())")
        let paypalFeeOfWholeChat = (roundedPaypalFeeofSingleChat*Double(totalSlots))
        Log.echo(key: "yud", text: "Paypal fee of the whole chat is \(paypalFeeOfWholeChat)")
        let partOfShare = ((Double(self.planInfo?.chatalyzeFee ?? 10))/100.0)
        Log.echo(key: "yud", text: "Part of the share is \(partOfShare)")
        var clientShares = 0.0
        if partOfShare == 0.0 {
            //Client share should remain to $ 0.0
        }else {
            clientShares = (totalPriceOfChatwithoutTax*(partOfShare))
        }
        Log.echo(key: "yud", text: "Client shares are \(clientShares)")
        let totalSeviceFee = clientShares + paypalFeeOfWholeChat + 0.25
        Log.echo(key: "yud", text: "Total Service fee is \(totalSeviceFee)")
        let totalEarning = (totalPriceOfChatwithoutTax-totalSeviceFee)
        //let serviceFee = totalSeviceFee
        let serviceFee = (round((totalSeviceFee*1000))/1000)
        let totalEarningRoundedPrice = (round((totalEarning*1000))/1000)
        
        //Log.echo(key: "yud", text: "Service fee is \(serviceFee) and the total earning is \(totalEarning) paypal fee is \(paypalFeeofSingleChat) and the cost of the single chat is \(price)")
        
        var fontSizeTotalSlot = 30
        var normalFont = 20
        if UIDevice.current.userInterfaceIdiom == .phone {
            fontSizeTotalSlot = 26
            normalFont = 18
        }
        let calculatorStr = "(\(totalSlots) chats * $\(price) per chat) - fees ($\(String(format: "%.2f", serviceFee))) ="
        
        let calculateAttrStr  = calculatorStr.toAttributedString(font: "Nunito-Regular", size: normalFont, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        let mutableStr  = "$\(String(format: "%.2f", totalEarningRoundedPrice))".toAttributedString(font: "Nunito-ExtraBold", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        
        earningFormulaLbl?.attributedText = calculateAttrStr
        totalEarningLabel?.attributedText = mutableStr
    }
    
    func resetEarningCalculator(){
        
        if let priceValue = Int(priceAmountField?.textField?.text ?? "0"){
            if priceValue == 0 {
                maxEarningHeightConstraint?.priority = UILayoutPriority(rawValue: 999.0)
                return
            }
        }
        
        if priceAmountField?.textField?.text ?? "" == ""{
            maxEarningHeightConstraint?.priority = UILayoutPriority(rawValue: 999.0)
            return
        }
        
        var fontSizeTotalSlot = 30
        var normalFont = 20
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            
            fontSizeTotalSlot = 26
            normalFont = 18
        }
        
        let calculatorStr = "(\(0) chats * $\(0) per chat) - fees ($\(0)) ="
        
        let calculateAttrStr  = calculatorStr.toAttributedString(font: "Nunito-Regular", size: normalFont, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        let mutableStr  = "$\(0)".toAttributedString(font: "Nunito-ExtraBold", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        
        earningFormulaLbl?.attributedText = calculateAttrStr
        totalEarningLabel?.attributedText = mutableStr
    }
    
    
    fileprivate func priceValidation()->Bool{
        
        if self.isPricingEnable == nil {
            
            priceAmountField?.showError(text: "Please select the pricing options.")
            return false
        }
        
        if !(self.isPricingEnable ?? false) {
            return true
        }
        
        if(priceAmountField?.textField?.text == ""){
            
            priceAmountField?.showError(text: "Price is required.")
            return false
        }
        
        else if isPriceZero(text: priceAmountField?.textField?.text){
            
            priceAmountField?.showError(text: "Please select free for free sessions.")
            return false
        }
        
        if !isSatisFyingMinimumPlanAmount(text: priceAmountField?.textField?.text){
            
            priceAmountField?.showError(text: "Minimum price is $\(self.scheduleInfo?.minimumPlanPriceToSchedule ?? 0.0)")
            return false
        }
            
        else if isExceedsMaximumPrice(text: priceAmountField?.textField?.text){
            
            priceAmountField?.showError(text: "Price can't be more than 9999.")
            return false
        }
        priceAmountField?.resetErrorStatus()
        return true
    }
}

extension EditSessionFormRootView{
    
    func updatescheduleInfo(){
        
        self.scheduleInfo?.title = titleField?.textField?.text
        self.scheduleInfo?.startDate = self.dateField?.textField?.text
        self.scheduleInfo?.startTime = self.timeField?.textField?.text
        updateStartDateParam()
    }
    
    func updateStartDateParam(){
        
        guard let startDate = getRequiredDateInStr() else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       
        if let date = dateFormatter.date(from: startDate){
            self.scheduleInfo?.startDateTime = date
        }
        
        if let newDate = self.scheduleInfo?.startDateTime{
            
            let calendar = Calendar.current
            var date:Date?
            if  totalTimeOfChat == .thirtyMinutes{
                
                date = calendar.date(byAdding: .minute, value: 30, to: newDate)
                self.scheduleInfo?.endDateTime = date
                
            }else if totalTimeOfChat == .oneHour{
                
                date = calendar.date(byAdding: .minute, value: 60, to: newDate)
                self.scheduleInfo?.endDateTime = date
                
            }else if totalTimeOfChat == .oneAndHalfHour{
                
                date = calendar.date(byAdding: .minute, value: 90, to: newDate)
                self.scheduleInfo?.endDateTime = date
                
            }else if totalTimeOfChat == .twoHour{
                
                date = calendar.date(byAdding: .minute, value: 120, to: newDate)
                self.scheduleInfo?.endDateTime = date
            }
            self.scheduleInfo?.duration = chatDuration
        }
        
        if donationCustomSwitch?.isOn == true{
            
            self.scheduleInfo?.tipEnabled = true
        }else{
        
            self.scheduleInfo?.tipEnabled = false
        }
        
        if screenShotCustomSwitch?.isOn == true{
            
            self.scheduleInfo?.isScreenShotAllow = true
        }else{
            
            self.scheduleInfo?.isScreenShotAllow = false
        }
        
        if self.priceAmountField?.textField?.text ?? "" != "" {
            
            self.scheduleInfo?.doublePrice = Double(self.priceAmountField?.textField?.text ??
                "0.0")
            self.scheduleInfo?.isFree = false
        }else{
            
            self.scheduleInfo?.isFree = true
            self.scheduleInfo?.doublePrice = 0.0
        }
        
        paintChatCalculator()
        paintMaximumEarningCalculator()
    }
    
    func getRequiredDateInStr()->String?{
        
        guard let date = self.scheduleInfo?.startDate else{
            return nil
        }
        
        if self.scheduleInfo?.startTime == ""{
            return nil
        }
        
        let requiredDate = date+" "+(self.scheduleInfo?.startTime ?? "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
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
    
    var chatDuration:Int?{
        
        get{
            
            if slotSelected == .none{
                return nil
            }
            if slotSelected == .two{
                return 2
            }
            if slotSelected == .three{
                return 3
            }
            if slotSelected == .five{
                return 5
            }
            if slotSelected == .ten{
                return 10
            }
            if slotSelected == .fifteen{
                return 15
            }
            if slotSelected == .thirty{
                return 30
            }
            if slotSelected == .sixty{
                return 60
            }
            return nil
        }
    }
    
    
    func getParam()->[String:Any]? {
        
        updatescheduleInfo()
        
        guard let info = self.scheduleInfo else{
            return nil
        }
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return nil
        }
        
        guard let startDate = info.startDateTime else{
            return nil
        }
        
        guard let endDate = info.endDateTime else{
            return nil
        }
        
        guard let durate = info.duration else{
            return nil
        }
        
        guard let priceHourly = caluclateHourlyPrice() else{
            return nil
        }
        
        var param = [String:Any]()
        
        if self.eventInfo?.slotsInfoLists.count ?? 0 > 0{
            
            param["title"] = info.title
            param["tipEnabled"] = info.tipEnabled
            return param
        }
        
        param["title"] = info.title
        param["start"] = "\(startDate)"
        param["end"] = "\(endDate)"
        param["userId"] = id
        param["duration"] = durate
        if info.isFree{
            //param["price"] = priceHourly
        }else{
            param["price"] = priceHourly
        }
        param["isFree"] = info.isFree
        param["screenshotAllow"] = info.isScreenShotAllow == true ? info.screenShotParam:NSNull()
        param["description"] = info.eventDescription
        param["eventBannerInfo"] = info.bannerImage == nil ? false:true
        param["tipEnabled"] = info.tipEnabled
        Log.echo(key: "yud", text: "Param are \(param)")
        return param
    }
    
    func caluclateHourlyPrice()->Int?{
        
        if let duration = self.scheduleInfo?.duration{
            let hourlySlots = (60/duration)
            if let singleChatPriceStr = self.scheduleInfo?.doublePrice{
                
                let hourlyPrice = (singleChatPriceStr*(Double(hourlySlots)))
                let truncate = hourlyPrice.roundTo(places: 3)
                let roundOffTwoDigits = (round(truncate*100)/100)
                return Int(roundOffTwoDigits)
            }
        }
        return nil
    }
}

extension EditSessionFormRootView{
    

}


extension EditSessionFormRootView{

    func slotIdentifiedDisbaleView(){
        
        dateField?.isUserInteractionEnabled = false
        timeField?.isUserInteractionEnabled = false
        sessionLength?.isUserInteractionEnabled = false
        chatLength?.isUserInteractionEnabled = false
        freeField?.isUserInteractionEnabled = false
        priceField?.isUserInteractionEnabled = false
        priceAmountField?.isUserInteractionEnabled = false
        screenShotCustomSwitch?.isUserInteractionEnabled = false

        dateField?.textFieldContainer?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        timeField?.textFieldContainer?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        sessionLength?.textFieldContainer?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        chatLength?.textFieldContainer?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)

        if self.eventInfo?.isFree ?? false {
            
            freeField?.backgroundColor = UIColor(red: 254.0/255.0, green: 203.0/255.0, blue: 170.0/255.0, alpha: 1)
            priceAmountField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
            priceField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
            
        }else{
            
            priceField?.backgroundColor = UIColor(red: 254.0/255.0, green: 203.0/255.0, blue: 170.0/255.0, alpha: 1)
            priceAmountField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
            freeField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
            
        }
    }
}
