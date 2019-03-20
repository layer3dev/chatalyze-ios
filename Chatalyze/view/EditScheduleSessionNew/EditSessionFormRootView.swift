//
//  EditSessionFormRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EditSessionFormRootView:ExtendedView{
    
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
        case none = 6
    }
    
    
    var slotSelected:slotDurationMin = .none
    @IBOutlet var slotDurationErrorLbl:UILabel?
    @IBOutlet var chatCalculatorLbl:UILabel?
    @IBOutlet var chatTotalNumberOfSlots:UILabel?
    
    @IBOutlet private var chatCalculatorView:UIView?
    
    
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
            return nil
        }
    }
    

    //***
    var scheduleInfo:ScheduleSessionInfo?
    
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
    var chatLengthArray = ["2 mins","5 mins","10 mins","15 mins","30 mins"]
    
    let chatLengthPicker = CustomPicker()
    let sessionLengthPicker = CustomPicker()
    
    var isCustomPickerShowing = false
    
    @IBOutlet var donationSwitch:UISwitch?
    @IBOutlet var screenShotSwitch:UISwitch?
    @IBOutlet var donationLabel:UILabel?
    @IBOutlet var screenShotLabel:UILabel?
    
    
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
        self.initializeVariable()
    }
    
    func initializeVariable(){
        
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
        self.roundToEditSessionButton()
        
        self.priceAmountField?.textField?.doneAccessory = true
        self.priceAmountField?.isCompleteBorderAllow = true
        
        priceAmountField?.textField?.keyboardType = UIKeyboardType.numberPad
        priceAmountField?.textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func roundToEditSessionButton() {
        
        editSessionButton?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 32.5 : 22.5
        editSessionButton?.layer.masksToBounds = true
    }
    
    //MARK:- Button Actions
    @IBAction func sessionDateAction(sender:UIButton){
        
        if isDatePickerIsShowing{
            hidePicker()
            return
        }
        showDatePicker()
        selectedPickerType = .date
        return
    }
    
    //MARK:- Button Actions
    @IBAction func timeAction(sender:UIButton){
        
        if isTimePickerIsShowing{
            hidePicker()
            return
        }
        showTimePicker()
        selectedPickerType = .time
        return
    }
    
    @IBAction func chatLengthAction(sender:UIButton){
        
        if isCustomPickerShowing{
            hidePicker()
            return
        }
        showChatLengthPicker()
        return
    }
    
    @IBAction func sessionLengthAction(sender:UIButton){
        
        if isCustomPickerShowing{
            hidePicker()
            return
        }
        showSessionLengthPicker()
        return
    }
    
    @IBAction func freeAction(sender:UIButton){
        
        self.freeField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255, alpha: 1)
        self.priceField?.backgroundColor = UIColor.white
        
        UIView.animate(withDuration: 0.25) {
           
            self.priceAmountHieghtConstrait?.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func paidActionAction(sender:UIButton){
        
        self.priceField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255, alpha: 1)
        self.freeField?.backgroundColor = UIColor.white
       
        UIView.animate(withDuration: 0.25) {
            
            self.priceAmountHieghtConstrait?.constant = UIDevice.current.userInterfaceIdiom == .pad ? 70:50
            self.layoutIfNeeded()
        }
        //Show Price Field existing price
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
        
        if textField == priceAmountField?.textField{
            
            if (((textField.text?.count) ?? 0)+(string.count)) > 4{
                return false
            }
            if string == ""{
                //Approving the backspace
                return true
            }
            if string.isNumeric{
                return true
            }
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        paintMaximumEarningCalculator()
        let _ = priceValidation()
    }
}

extension EditSessionFormRootView{
    
    func resetErrorStatus(){
        
        titleField?.resetErrorStatus()
    }
    
    func validateFields()->Bool{
        
        let titleValidated  = titleValidation()
        let dateValidated  = validateDate()
        let timeValidated = validateTime()
        let isFutureTimeValidation = isFutureTime()
        let durationValidated = validateSlotTime()
        let priceValidated  = priceValidation()
        return titleValidated && dateValidated && timeValidated && isFutureTimeValidation && durationValidated && priceValidated
    }
    
    fileprivate func titleValidation()->Bool{
        if(titleField?.textField?.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""){
            
            titleField?.showError(text: "Title is required.")
            return false
        }
        titleField?.resetErrorStatus()
        return true
    }
    
    func showError(message:String?){
        //errorLbl?.text =  message ?? ""
    }
}

extension EditSessionFormRootView{
    
    func validateDate()->Bool{
        
        if(dateField?.textField?.text == ""){
            
            dateField?.showError(text: "Date is required.")
            return false
        }
        dateField?.resetErrorStatus()
        return true
    }
}

extension EditSessionFormRootView:XibDatePickerDelegate{
    
    //MARK:- PICKER INITILIZATION
    func initializeDatePicker(){
        
        datePickerContainer.frame = self.frame
        datePickerContainer.timePicker?.datePickerMode = .date
        datePickerContainer.delegate = self
        datePickerContainer.timePicker?.minimumDate = Date()
        //TODO:- Implement the minimum date
        //datePicker.timePicker?.minimumDate
        datePickerContainer.isHidden = true
        self.addSubview(datePickerContainer)
    }
    
    func doneTapped(selectedDate:Date?){
        
        if selectedPickerType == .date{
            
            hidePicker()
            guard let pickerDate = selectedDate else{
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let dateInStr = dateFormatter.string(from: pickerDate)
            dateField?.textField?.text = dateInStr
            //birthDay = selectedDate
            return
        }
        
        if selectedPickerType == .time{
            
            hidePicker()
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
    }
    
    func pickerAction(selectedDate:Date?){
        
        if selectedPickerType == .date{
            
            guard let pickerDate = selectedDate else{
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM, yyyy"
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
    
    func getRequiredDateInStr()->String?{
        
        guard let date = dateField?.textField?.text else{
            return nil
        }
        
        if timeField?.textField?.text == ""{
            return nil
        }
        
        let requiredDate = date+" "+(timeField?.textField?.text ?? "")
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
            return
        }
        
        if pickerView == sessionLengthPicker.picker {
            
            //paintChatCalculator()
            sessionLength?.textField?.text = sessionArray[row]
            return
        }
    }
}

extension EditSessionFormRootView:CustomPickerDelegate{
    
    func pickerDoneTapped(type: CustomPicker.pickerType) {
        
        if type == .sessionLength{
            
            if sessionLengthPicker.picker?.selectedRow(inComponent: 0) == 0 {
                sessionLength?.textField?.text = sessionArray[0]
            }
        }
        
        if type == .chatLength{
            
            if chatLengthPicker.picker?.selectedRow(inComponent: 0) == 0 {
                chatLength?.textField?.text = chatLengthArray[0]
            }
        }
        
        hidePicker()
    }
}

extension EditSessionFormRootView {
    
    func paintChatCalculator(){
        
        guard let info = scheduleInfo else{
            return
        }
        guard let startDate = info.startDateTime else{
            return
        }
        guard let endDate = info.endDateTime else{
            return
        }
        
        let totalDurationInMinutes = Int(endDate.timeIntervalSince(startDate)/60.0)
        
        var totalSlots = 0
        
        guard let singleChatDuration = chatDuration else{
            return
        }
        
        totalSlots = totalDurationInMinutes/singleChatDuration
        
        var fontSizeTotalSlot = 30
        var normalFont = 20
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            
            fontSizeTotalSlot = 26
            normalFont = 18
        }
        
        if totalSlots > 0 && totalDurationInMinutes > 0 && singleChatDuration > 0{
            
            Log.echo(key: "yud", text: "Slot number fetch SuccessFully \(totalSlots) and the totalMinutesOfChat is \(totalDurationInMinutes) and the single Chat is \(singleChatDuration)")
            
            chatCalculatorLbl?.text = "\(totalDurationInMinutes) min session length / \(singleChatDuration) min chat length ="
            
            let mutableStr  = "\(totalSlots)".toMutableAttributedString(font: "Nunito-ExtraBold", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
            
            let nextStr = " available 1:1 chats"
            let nextAttrStr  = nextStr.toAttributedString(font: "Nunito-Regular", size: (normalFont-3), color: UIColor(hexString: "#808080"), isUnderLine: false)
            
            mutableStr.append(nextAttrStr)
            chatTotalNumberOfSlots?.attributedText = mutableStr
        }
        Log.echo(key: "yud", text: "total number of the slot is \(totalSlots)")
    }
    
    fileprivate func validateSlotTime()->Bool{
        
        if(slotSelected == .none){
            
            slotDurationErrorLbl?.text = "Chat duration is required."
            return false
        }
        slotDurationErrorLbl?.text = ""
        return true
    }
}


extension EditSessionFormRootView{
    
    func isPriceZero(text:String?)->Bool{
        
        if let requiredPrice = Int(text ?? "0"){
            if requiredPrice == 0 {
                return true
            }
        }
        return false
    }
    
    func isSatisFyingMinimumPlanAmount(text:String?)->Bool{
        
        if  self.scheduleInfo?.minimumPlanPriceToSchedule ?? 0.0 <= 0.0{
            return true
        }
        
        if let priceInt = Int(text ?? "0"){
            
            if Double(priceInt) < self.scheduleInfo?.minimumPlanPriceToSchedule ?? 0.0{
                return false
            }
        }
        return true
    }
    
    func isExceedsMaximumPrice(text:String?)->Bool{
        
        if let priceStr = text{
            if let price = Int64(priceStr){
                if price > 9999{
                    return true
                }
            }
        }
        return false
    }
}


extension EditSessionFormRootView{
    
    func paintMaximumEarningCalculator(){
        
        guard let price = Int(priceField?.textField?.text ?? "0") else{
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
        
        
        if price > 9999{
            return
        }
        
        if price == 0{
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
        let clientShares = (totalPriceOfChatwithoutTax/10)
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
        
        if let priceValue = Int(priceField?.textField?.text ?? "0"){
            if priceValue == 0 {
                maxEarningHeightConstraint?.priority = UILayoutPriority(rawValue: 999.0)
                return
            }
        }
        
        if priceField?.textField?.text ?? "" == ""{
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
        
        if(priceField?.textField?.text == ""){
            
            priceField?.showError(text: "Price is required.")
            return false
        }
        else if !isPriceZero(text: priceField?.textField?.text){
            
            if !isSatisFyingMinimumPlanAmount(text: priceField?.textField?.text){
                
                priceField?.showError(text: "Minimum price is $\(self.scheduleInfo?.minimumPlanPriceToSchedule ?? 0.0)")
                return false
            }
        }
        else if isExceedsMaximumPrice(text: priceField?.textField?.text){
            
            priceField?.showError(text: "Price can't be more than 9999.")
            return false
        }
        priceField?.resetErrorStatus()
        return true
    }
}




//
//extension EditSessionFormRootView{
//
//    func fillInfo(){
//
//
//
//    }
//
//
//    var endDateTime:Date?
//    var startDateTime:Date?
//    var startDate:String?
//    var startTime:String?
//    var price:Int?
//    var isFree:Bool = false
//    var title:String? = "Chat Session"
//    var eventDescription:String?
//    var duration:Int?
//    var isScreenShotAllow:Bool = false
//    var screenShotParam = "automatic"
//    var eventInfo:EventInfo?
//    var bannerImage:UIImage?
//    var tipEnabled:Bool = false
//    var minimumPlanPriceToSchedule:Double = 0.0
//
//}
//
//
//
//
////var endDateTime:Date?
////var startDateTime:Date?
////var startDate:String?
////var startTime:String?
////var price:Int?
////var isFree:Bool = false
////var title:String? = "Chat Session"
////var eventDescription:String?
////var duration:Int?
////var isScreenShotAllow:Bool = false
////var screenShotParam = "automatic"
////var eventInfo:EventInfo?
////var bannerImage:UIImage?
////var tipEnabled:Bool = false
////var minimumPlanPriceToSchedule:Double = 0.0
//
//
//
////[
////{
////    "room_id" : "ZUwe0T",
////    "paymentTransferred" : false,
////    "groupId" : "event_production_7789_1553064890487",
////    "isFree" : false,
////    "price" : 40,
////    "id" : 7789,
////    "eventBannerUrl" : null,
////    "forEnterprise" : false,
////    "eventFeedbackInfo" : null,
////    "youtubeURL" : null,
////    "duration" : "15",
////    "user" : {
////        "address" : "Sector 71",
////        "profilePic" : "https:\/\/s3-us-west-2.amazonaws.com\/chatalyze\/users\/avatars\/200X200\/YudiA__361547905223743_200X200",
////        "displayURL" : "YudiA",
////        "email" : "yudhisther@mansainfotech.com",
////        "phone" : "7888502101",
////        "lastLoginTime" : "2019-03-20T12:28:17.768Z",
////        "firstName" : "Yudi A",
////        "allowFreeSession" : true,
////        "id" : 36,
////        "eventMobReminder" : false,
////        "lastName" : " ",
////        "enterpriseId" : null,
////        "lastLogin" : null,
////        "stripe_id" : null,
////        "zipcode" : "10001",
////        "mobile" : null,
////        "urlName" : null,
////        "avatars" : {
////            "200X200" : "https:\/\/s3-us-west-2.amazonaws.com\/chatalyze\/users\/avatars\/200X200\/YudiA__361547905223743_200X200",
////            "50X50" : "https:\/\/s3-us-west-2.amazonaws.com\/chatalyze\/users\/avatars\/50X50\/YudiA__361547905223743_50X50",
////            "400X400" : "https:\/\/s3-us-west-2.amazonaws.com\/chatalyze\/users\/avatars\/400X400\/YudiA__361547905223743_400X400"
////        },
////        "middleName" : null,
////        "updatedAt" : "2019-03-20T12:37:52.802Z",
////        "roleId" : 2,
////        "passwordUpdatedOn" : "2018-10-05T07:34:08.000Z",
////        "isTestAccount" : false,
////        "blankReset" : false,
////        "isDeactivated" : false,
////        "href" : "\/users\/36",
////        "ememorabiliaEnabled" : false,
////        "dob" : null,
////        "yob" : null,
////        "createdAt" : "2017-12-21T10:45:57.976Z",
////        "gender" : "male",
////        "meta" : {
////            "askPlan" : false
////        },
////        "countryCode" : null,
////        "deletedAt" : null,
////        "patreonId" : null,
////        "description" : "Hello",
////        "twitterId" : null
////    },
////    "tipStatus" : "pending",
////    "start" : "2019-04-20T07:30:00.000Z",
////    "callbookings" : [
////
////    ],
////    "updatedAt" : "2019-03-20T06:54:50.488Z",
////    "bordercolor" : "#f0ff00",
////    "tag" : null,
////    "backgroundcolor" : "#dd002e",
////    "end" : "2019-04-20T09:00:00.000Z",
////    "screenshotAllow" : "automatic",
////    "paymentRuleId" : null,
////    "notified" : null,
////    "href" : "\/schedules\/calls\/7789",
////    "autographAllow" : null,
////    "createdAt" : "2019-03-20T06:54:50.474Z",
////    "meta" : {
////        "start" : "2019-04-20T07:30:00.000Z",
////        "end" : "2019-04-20T09:00:00.000Z"
////    },
////    "cancelled" : false,
////    "textcolor" : "#000000",
////    "started" : null,
////    "emptySlots" : null,
////    "title" : "iOS test",
////    "isPrivate" : false,
////    "tipEnabled" : true,
////    "deletedAt" : null,
////    "userId" : 36,
////    "leadPageUrl" : null,
////    "description" : ""
////}
