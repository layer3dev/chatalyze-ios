//
//  EditSessionFormRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EditSessionFormRootView:ExtendedView {
    
    enum BookingStyle{
    
        case standard
        case flex
        case none
    }
    
    @IBOutlet var standardLabel:UILabel?
    @IBOutlet var flexLabel:UILabel?
    
    @IBOutlet var standardField:SigninFieldView?
    @IBOutlet var flexField:SigninFieldView?
    
    var currentBookingStyle = BookingStyle.flex
    
    @IBOutlet var customCalenadarSupportView:UIView?
    let appDelegate:AppDelegate? = UIApplication.shared.delegate as? AppDelegate
     
    var emptySlotList = [EmptySlotInfo]()
    @IBOutlet var breakAdapter:BreakAdapter?
    
    @IBOutlet var donationInfoLabel:UILabel?
    @IBOutlet var screenShotInfoLabel:UILabel?
    
    @IBOutlet var donationCustomSwitch:EditCustomSwitch?
    @IBOutlet var screenShotCustomSwitch:EditCustomSwitch?
    
    @IBOutlet var earningFormulaLbl:UILabel?
    @IBOutlet var totalEarningLabel:UILabel?
    
    @IBOutlet private var maxEarning:UIView?
   
    var isBreakShowing = false
    
    @IBOutlet var breakHeightConstraintPriority:NSLayoutConstraint?
    @IBOutlet private var maxEarningHeightConstraint:NSLayoutConstraint?
    @IBOutlet var chatCalculatorHeightConstrait:NSLayoutConstraint?
    @IBOutlet var priceAmountHieghtConstrait:NSLayoutConstraint?
    @IBOutlet var customCalendar:FSWrapper?
    
    enum totalChatDuration:Int{
        
        case thirtyMinutes = 0
        case oneHour = 1
        case oneAndHalfHour = 2
        case twoHour = 3
        case twoAndHalf = 4
        case three = 5
        case threeAndHalf = 6
        case four = 7
        case fourAndHalf = 8
        case five = 9
        case fiveAndHalf = 10
        case six = 11
        case none = 12
    }
    
    var slotSelected:Int?
    @IBOutlet var slotDurationErrorLbl:UILabel?
    @IBOutlet var chatCalculatorLbl:UILabel?
    @IBOutlet var chatTotalNumberOfSlots:UILabel?
    @IBOutlet private var chatCalculatorView:UIView?

    var totalTimeOfChat:totalChatDuration = .none
    var scheduleInfo:ScheduleSessionInfo? = ScheduleSessionInfo()
    var planInfo:PlanInfo?
    
    enum pickerType:Int {
        
        case time = 0
        case date = 1
        case none = 10
    }
    
    var selectedPickerType:pickerType = .none
    
    @IBOutlet var breakField:SigninFieldView?
    
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
    
    var sessionArray = ["30 mins","1 hour","1.5 hours","2 hours","2.5 hours","3 hours","3.5 hours","4 hours","4.5 hours","5 hours","5.5 hours","6 hours"]
    
    var chatLengthArray = [String]()
    
    let chatLengthPicker = CustomPicker()
    let sessionLengthPicker = CustomPicker()
    
    var isCustomPickerShowing = false
    
    @IBOutlet var donationSwitch:UISwitch?
    @IBOutlet var screenShotSwitch:UISwitch?
    @IBOutlet var donationLabel:UILabel?
    @IBOutlet var screenShotLabel:UILabel?
    @IBOutlet var sponsorshipViewHeightConstraintForFreeSession:NSLayoutConstraint?
    @IBOutlet var sponsorShipLabel:UILabel?
    
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
    
    var desiredTime:String {
        
        guard let startDate = self.eventInfo?.startDate else{
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let dateInStr = dateFormatter.string(from: startDate)
        return dateInStr
    }
    
    //MARK:- Segment.io Tracking Methods
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
    var isCalendarVisible = false

    @IBOutlet var goBackButtonContainer:UIView?
    @IBOutlet var confirmButton:UIButton?
    
    @IBOutlet var sponsorShipToggle:EditCustomSwitch?
    @IBOutlet var heightOfSponserConstraint:NSLayoutConstraint?

    @IBOutlet var sponsorShipStatusLabel:UILabel?
    @IBOutlet var sponsorShipInfoLabel:UILabel?
    var isSponsorEnable = true
    
    
    func implementSponsorShip(){
        
        DispatchQueue.main.async {
            
            let textOne = "The no-show rate is much higher for free sessions."
            
            let textOneMutable = textOne.toMutableAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1), isUnderLine: false)
            
            self.sponsorShipLabel?.attributedText = textOneMutable
        }
    }
    
    
    func calenderAction(){
        
        if self.isCalendarVisible {
            
            self.layoutIfNeeded()
            self.isCalendarVisible = false
            UIView.animate(withDuration: 0.25) {
                
                self.customCalendar?.alpha = 0
                self.customCalenadarSupportView?.alpha = 0
            }
            return
        }
        
        self.isCalendarVisible = true
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            
            self.customCalendar?.alpha = 1
            self.customCalenadarSupportView?.alpha = 1
        }
        return
    }
    
    @IBAction func hideCalendar(sender:UIButton?){
        
        self.isCalendarVisible = false
        UIView.animate(withDuration: 0.25) {
            
            self.customCalendar?.alpha = 0
            self.customCalenadarSupportView?.alpha = 0
        }
    }
    
    
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
        
        self.breakAdapter?.layer.masksToBounds = true
        self.breakAdapter?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.breakAdapter?.layer.borderWidth = 1
        self.breakAdapter?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
        
        self.titleField?.textField?.autocapitalizationType = .sentences
        self.titleField?.isCompleteBorderAllow = true
        self.dateField?.isCompleteBorderAllow = true
        self.timeField?.isCompleteBorderAllow = true
        self.sessionLength?.isCompleteBorderAllow = true
        self.chatLength?.isCompleteBorderAllow = true
        self.freeField?.isCompleteBorderAllow = true
        self.priceField?.isCompleteBorderAllow = true
        self.breakField?.isCompleteBorderAllow = true
        self.standardField?.isCompleteBorderAllow = true
        self.flexField?.isCompleteBorderAllow = true
        
        self.roundToEditSessionButton()
        
        self.priceAmountField?.textField?.doneAccessory = true
        self.priceAmountField?.isCompleteBorderAllow = true
        
        priceAmountField?.textField?.keyboardType = UIKeyboardType.decimalPad
        self.switchONSponsor()
        
        self.initializeCustomCalendar()
    }
    
    func initializeCustomSwitch(){
        
        sponsorShipToggle?.toggleAction = {[weak self] in
            
            if self?.sponsorShipToggle?.isOn ?? false {
                
                self?.sponsorShipStatusLabel?.text = "ON"
                self?.sponsorShipInfoLabel?.text = "People can pay $3 to become a session sponsor and receive special perks."
                self?.scheduleInfo?.isSponsorEnable = true
                self?.isSponsorEnable = true
                
                UIView.animate(withDuration: 0.15, animations: {
                    
                    self?.sponsorShipInfoLabel?.alpha = 1
                    self?.layoutIfNeeded()
                })
                return
            }
            
            self?.scheduleInfo?.isSponsorEnable = false
            UIView.animate(withDuration: 0.15, animations: {
                
                self?.sponsorShipInfoLabel?.alpha = 0
                self?.layoutIfNeeded()
            })
            self?.sponsorShipInfoLabel?.text = ""
            self?.sponsorShipStatusLabel?.text = "OFF"
            self?.isSponsorEnable = false
            return
        }
        
        //************
        donationCustomSwitch?.toggleAction = {[weak self] in
            
            if self?.donationCustomSwitch?.isOn ?? false {
                
                self?.donationLabel?.text = "ON"
                self?.donationInfoLabel?.text = "People will have the option to give you a tip after their chats."
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
    
    func initializeCustomCalendar(){
        
        customCalendar?.tappedDate = { (date,dateinStr) in
            
            guard let pickerDate = date else{
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.locale = NSLocale.current
            let dateInStr = dateFormatter.string(from: pickerDate)
            self.dateField?.textField?.text = dateInStr
           let _ =  self.validateDate()
        }
    }
    
    func paintBookingStyle(){
        
        if self.currentBookingStyle == .standard{
            self.paintStandardBookingStyle()
            return
        }
        
        if self.currentBookingStyle == .flex{
            
            self.paintFlexBookingStyle()
            return
        }
        
        
    }
    
    
    func paintBookingStyleLabels(){
        
        DispatchQueue.main.async {
            
            let size = UIDevice.current.userInterfaceIdiom == .pad ? 19:16
            
            let text1 = "Standard: "
            let text2 = "Guarantee efficiency by only allowing participants to book the next available time slot"
            
            let text3 = "Flex: "
            let text4 = "Give participants flexibility by allowing them to select any available time slot to book"
            
            let text1Mutate = text1.toMutableAttributedString(font: "Nunito-SemiBold", size: size, color: UIColor(hexString: "#4a4a4a"), isUnderLine: false)
            
            let text1Attribute = text2.toMutableAttributedString(font: "Nunito-Regular", size: size, color: UIColor(hexString: "#4a4a4a"), isUnderLine: false)
            
            let text2Mutate = text3.toMutableAttributedString(font: "Nunito-SemiBold", size: size, color: UIColor(hexString: "#4a4a4a"), isUnderLine: false)
            
            let text2Attribute = text4.toMutableAttributedString(font: "Nunito-Regular", size: size, color: UIColor(hexString: "#4a4a4a"), isUnderLine: false)
            
            text1Mutate.append(text1Attribute)
            text2Mutate.append(text2Attribute)
            
            self.standardLabel?.attributedText = text1Mutate
            self.flexLabel?.attributedText = text2Mutate
        }
    }

    
    
    func initializeVariable(){
       
        breakAdapter?.customDelegate = self
        initializeCustomSwitch()
        initializeDatePicker()
        initializeTimePicker()
        initializeChatLengthPicker()
        initializeSessionLengthPicker()
        implementSponsorShip()
        paintBookingStyleLabels()
        paintBookingStyle()
        
        self.breakAdapter?.root = self
        self.titleField?.textField?.delegate = self
        self.dateField?.textField?.delegate = self
        self.timeField?.textField?.delegate = self
        self.sessionLength?.textField?.delegate = self
        self.chatLength?.textField?.delegate = self
        self.freeField?.textField?.delegate = self
        self.priceField?.textField?.delegate = self
        self.priceAmountField?.textField?.delegate = self
        priceAmountField?.textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        titleField?.textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
        
    func fillInfo(info:EventInfo?){
        
        guard let eventInfo = info else{
            return
        }

        self.eventInfo = eventInfo
        
        self.titleField?.textField?.text = eventInfo.title
        self.dateField?.textField?.text = desiredDate
        customCalendar?.setSelectionDate(date: self.eventInfo?.startDate)
        self.timeField?.textField?.text = desiredTime
        
        slotSelected = Int(eventInfo.duration ?? 0.0)
        
        Log.echo(key: "yud", text: "is flex really enabled \(info?.isFlexEnabled)")
        
        if !(info?.isFlexEnabled ?? false){
            
            self.paintStandardBookingStyle()
        }else{
            
            self.paintFlexBookingStyle()

        }
     
        if slotSelected ?? 0 <= 1 {
            self.chatLength?.textField?.text = "\(slotSelected ?? 0) min"
        }else{
            self.chatLength?.textField?.text = "\(slotSelected ?? 0) mins"
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
            if minutes == 150{
                
                totalTimeOfChat = .twoAndHalf
                self.sessionLength?.textField?.text = sessionArray[4]
            }
            if minutes == 180{
                
                totalTimeOfChat = .three
                self.sessionLength?.textField?.text = sessionArray[5]
            }
            if minutes == 210{
                
                totalTimeOfChat = .threeAndHalf
                self.sessionLength?.textField?.text = sessionArray[6]
            }
            if minutes == 240{
                
                totalTimeOfChat = .four
                self.sessionLength?.textField?.text = sessionArray[7]
            }
            if minutes == 270{
                
                totalTimeOfChat = .fourAndHalf
                self.sessionLength?.textField?.text = sessionArray[8]
            }
            if minutes == 300{
                
                totalTimeOfChat = .five
                self.sessionLength?.textField?.text = sessionArray[9]
            }
            if minutes == 330{
                
                totalTimeOfChat = .fiveAndHalf
                self.sessionLength?.textField?.text = sessionArray[10]
            }
            if minutes == 360{
                
                totalTimeOfChat = .six
                self.sessionLength?.textField?.text = sessionArray[11]
            }
        }
        
        if eventInfo.tipEnabled == true {
            
            donationCustomSwitch?.setOn()
            donationLabel?.text = "ON"
            donationInfoLabel?.text = "People will have the option to give you a tip after their chats."
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
        
        handleSponsorToggle()

        if eventInfo.isFree ?? false{
            
            hidePriceFillingField()
        }else{
            
            showHeightPriceFllingField()
            self.priceAmountField?.textField?.text = "\((eventInfo.price ?? 0.0))"
        }
        
        
        Log.echo(key: "yud", text: "Time Differences is ttt \(Date().timeIntervalSince(self.eventInfo?.startDate ?? Date()))")
        
        
        if Date().timeIntervalSince(self.eventInfo?.startDate ?? Date()) >= 0.0 || self.eventInfo?.slotsInfoLists.count ?? 0 > 0 {
            slotIdentifiedDisbaleView()
        }
        
        updatescheduleInfo()
    }
    
    func handleSponsorToggle(){
        
        if self.eventInfo?.isFree ?? false {
            
            heightOfSponserConstraint?.priority = UILayoutPriority(250.0)
            
        }else{
            
            heightOfSponserConstraint?.priority = UILayoutPriority(999.0)
        }
        
        if self.eventInfo?.isSponsorEnable ?? false {
            
            self.sponsorShipStatusLabel?.text = "ON"
            self.sponsorShipInfoLabel?.text = "People can pay $3 to become a session sponsor and receive special perks."
            self.sponsorShipToggle?.setOn()
            self.scheduleInfo?.isSponsorEnable = true
            self.isSponsorEnable = true
            
            UIView.animate(withDuration: 0.15, animations: {
                
                self.sponsorShipInfoLabel?.alpha = 1
                self.layoutIfNeeded()
            })
        }else{
           
            self.sponsorShipToggle?.setOff()
            self.scheduleInfo?.isSponsorEnable = false
            UIView.animate(withDuration: 0.15, animations: {
                
                self.sponsorShipInfoLabel?.alpha = 0
                self.layoutIfNeeded()
            })
            self.isSponsorEnable = false
            self.sponsorShipInfoLabel?.text = ""
            self.sponsorShipStatusLabel?.text = "OFF"
        }
    }
    
    
    func roundToEditSessionButton() {
        
        editSessionButton?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 32.5 : 22.5
        editSessionButton?.layer.masksToBounds = true
    }
    
    func showBreak(){
        
        //Must be used only in PaintChat calculator
        breakHeightConstraintPriority?.priority = UILayoutPriority(rawValue: 250)
        isBreakShowing = true
    }
    
    func hideBreak(){
        
        //Must be used only in PaintChat calculator
        breakHeightConstraintPriority?.priority = UILayoutPriority(rawValue: 999.0)
        self.breakAdapter?.update(emptySlots: [EmptySlotInfo]())
        self.breakField?.textField?.text = ""
        isBreakShowing = false
    }
    
    
    func showSelectedIndex(){
        
        if let selectedBreakArray = breakAdapter?.emptySlots {
            
            var str = ""
            for index in 0..<selectedBreakArray.count {
                
                if str == "" && selectedBreakArray[index].isSelected{
                    str.append("\(index+1)")
                    continue
                }
                if str != "" && selectedBreakArray[index].isSelected{
                   str.append(",\(index+1)")
                    continue
                }
            }
            breakField?.textField?.text = str
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        datePickerContainer.frame = self.frame
        timePickerContainer.frame = self.frame
        chatLengthPicker.frame = self.frame
        sessionLengthPicker.frame = self.frame
        datePickerContainer.frame.origin.y = datePickerContainer.frame.origin.y - CGFloat(64)
        timePickerContainer.frame.origin.y = timePickerContainer.frame.origin.y - CGFloat(64)
        chatLengthPicker.frame.origin.y = chatLengthPicker.frame.origin.y - CGFloat(64)
        sessionLengthPicker.frame.origin.y = sessionLengthPicker.frame.origin.y - CGFloat(64)
    }
    
    
    //MARK:- Button Actions
    @IBAction func breakSlotAction(sender:UIButton){
        
        if isBreakShowing{
            
            breakHeightConstraintPriority?.priority = UILayoutPriority(rawValue: 999.0)
            isBreakShowing = false
            return
        }
        
        breakHeightConstraintPriority?.priority = UILayoutPriority(rawValue: 250)
        isBreakShowing = true
    }
    
    @IBAction func sessionDateAction(sender:UIButton){
        
        dateTracking()
        if isDatePickerIsShowing{
            
            hidePicker()
            return
        }
        showDatePicker()
        selectedPickerType = .date
        return
    }
    
    @IBAction func timeAction(sender:UIButton){
        
        timeTracking()
        if isTimePickerIsShowing{
            hidePicker()
            return
        }
        showTimePicker()
        selectedPickerType = .time
        return
    }
    
    @IBAction func chatLengthAction(sender:UIButton){
        
        ChatLengthTracking()
        if isCustomPickerShowing{
            hidePicker()
            return
        }
        showChatLengthPicker()
        return
    }
    
    @IBAction func sessionLengthAction(sender:UIButton){
        
        SessionLengthTracking()
        if isCustomPickerShowing{
            hidePicker()
            return
        }
        showSessionLengthPicker()
        return
    }
    
    @IBAction func freeAction(sender:UIButton){
        
        showSponserView()
        hidePriceFillingField()
    }
    
    
    func switchOffSponsor(){
    
        self.scheduleInfo?.isSponsorEnable = false
        self.isSponsorEnable = false
        UIView.animate(withDuration: 0.15, animations: {
            
            self.sponsorShipInfoLabel?.alpha = 0
            self.layoutIfNeeded()
        })
        self.sponsorShipInfoLabel?.text = ""
        self.sponsorShipStatusLabel?.text = "OFF"
    }
    
    func switchONSponsor(){
        
        self.sponsorShipStatusLabel?.text = "ON"
        self.sponsorShipInfoLabel?.text = "People can pay $3 to become a session sponsor and receive special perks."
        self.scheduleInfo?.isSponsorEnable = true
        self.isSponsorEnable = true
        UIView.animate(withDuration: 0.15, animations: {
            
            self.sponsorShipInfoLabel?.alpha = 1
            self.layoutIfNeeded()
        })
    }
    
    func showSponserView(){
        
       self.heightOfSponserConstraint?.priority = UILayoutPriority(250.0)
       self.sponsorshipViewHeightConstraintForFreeSession?.priority = UILayoutPriority(250.0)
    }
    
    func hideSponsorShipView(){
        
         self.heightOfSponserConstraint?.priority = UILayoutPriority(999.0)
        self.sponsorshipViewHeightConstraintForFreeSession?.priority = UILayoutPriority(999.0)
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
        showSponserView()
    }
    
    
    @IBAction func paidActionAction(sender:UIButton){
        
        hideSponsorShipView()
        showHeightPriceFllingField()        
        // Show Price Field existing price
    }
    
    func showHeightPriceFllingField(){
        
        hideSponsorShipView()
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
            self.appDelegate?.earlyCallProcessor?.fetchInfo()

            self.controller?.stopLoader()
            if success{
                
                self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Session details edited successfully.", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                    
                    self.controller?.navigationController?.popViewController(animated: true)
                })
                return
            }
            self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Error occurred", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                
            })
            return
        }
    }
    
    
    @IBAction func standardViewAction(sender:UIButton?){

        self.paintStandardBookingStyle()
        self.currentBookingStyle = .standard
    }
    
    func paintStandardBookingStyle(){
        
        self.standardField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255, alpha: 1)
        self.flexField?.backgroundColor = UIColor.white
    }
    
    func paintFlexBookingStyle(){
      
        self.standardField?.backgroundColor = UIColor.white
        self.flexField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255, alpha: 1)
    }
    
    @IBAction func flexViewAction(sender:UIButton?){

        self.paintFlexBookingStyle()
        self.currentBookingStyle = .flex
    }
    
}

extension EditSessionFormRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = textField
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == priceAmountField?.textField {
            
            Log.echo(key: "yud", text: "priceAmountField event is fired")
            self.priceFieldTracking()
            return
        }
        
        if textField == titleField?.textField {
            
            Log.echo(key: "yud", text: "title event is fired")
            self.titleTracking()
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == priceAmountField?.textField {
            
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
       
        if textField == titleField?.textField{
            
            let _ = titleValidation()
            return
        }
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
        
       return handleScreenScrollOnErrorWithValidation()
    }
    
    func handleScreenScrollOnErrorWithValidation()->Bool{
        
        if self.eventInfo?.slotsInfoLists.count ?? 0 > 0 {
            
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
        
        if !titleValidated{
            scrollView?.scrollToCustomView(customView: titleField)
        }
            
        else if !dateValidated{
            scrollView?.scrollToCustomView(customView: dateField)
        }
            
        else if !timeValidated{
            scrollView?.scrollToCustomView(customView: timeField)
        }
            
        else if !isFutureTimeValidation{
            scrollView?.scrollToCustomView(customView: timeField)
        }
            
        else if !lengthBalanceValidate{
            scrollView?.scrollToCustomView(customView:sessionLength)
        }

        else if !sessionLengthValidation{
            scrollView?.scrollToCustomView(customView:sessionLength)
        }
            
        else if !durationValidated{
            scrollView?.scrollToCustomView(customView: chatLength)
        }
        
        else if !priceValidated{
            scrollView?.scrollToCustomView(customView: priceField)
        }
        
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
        
        if slotSelected == 60 && totalTimeOfChat == .thirtyMinutes{
            
            sessionLength?.showError(text: "Session length must be greater or equal to the chat length.")
            return false
        }
        sessionLength?.resetErrorStatus()
        return true
    }
    
    func validateSessionLength()->Bool {
        
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
        
        if selectedPickerType == .date {
            
            guard let pickerDate = selectedDate else{
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let dateInStr = dateFormatter.string(from: pickerDate)
            dateField?.textField?.text = dateInStr
            let _  = validateDate()

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
            let _ = self.validateTime()
            //birthDay = selectedDate
        }
        
        hidePicker()
        updatescheduleInfo()
        paintChatCalculator()
        paintMaximumEarningCalculator()
    }
    
    func pickerAction(selectedDate:Date?){
        
        if selectedPickerType == .date {
            
            guard let pickerDate = selectedDate else{
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let dateInStr = dateFormatter.string(from: pickerDate)
            dateField?.textField?.text = dateInStr
            let _ = self.validateDate()
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
            let _ = self.validateTime()
            return
        }
    }
    
    private func showDatePicker() {
       
        calenderAction()
//        handleBirthadyFieldScrolling()
//        self.isDatePickerIsShowing = true
//        self.datePickerContainer.isHidden = false
    }
    
    //TODO:- Yet to implement BirthadyFieldScrolling
    func handleBirthadyFieldScrolling(){
    }
}

extension EditSessionFormRootView{
    
    //MARK:- PICKER INITILIZATION
    func initializeTimePicker() {
        
        timePickerContainer.frame = self.frame
        timePickerContainer.frame.origin.y = timePickerContainer.frame.origin.y - CGFloat(64)
        timePickerContainer.timePicker?.datePickerMode = .time
        timePickerContainer.delegate = self
        timePickerContainer.timePicker?.minuteInterval = 30
        timePickerContainer.timePicker?.date = getTodayDate(at: (0,0))
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
    
    func  initializeChatLengthPicker(){
        
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
            return (chatLengthArray[row]+"\(Int(chatLengthArray[row]) ?? 0 <= 1 ? " min":" mins")") as String
        }
        
        if pickerView == sessionLengthPicker.picker {
            return sessionArray[row] as String
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == chatLengthPicker.picker {

            if chatLengthArray.count <= 0 {
                return
            }
            
            if Int(chatLengthArray[row]) ?? 0 <= 1 {
                
                chatLength?.textField?.text = chatLengthArray[row] + " min"
            }else{
               
                chatLength?.textField?.text = chatLengthArray[row] + " mins"
            }
            slotSelected = Int(chatLengthArray[row])
            let _ = self.validateSlotTime()
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
            if row == 4{
                totalTimeOfChat = .twoAndHalf
            }
            if row == 5{
                totalTimeOfChat = .three
            }
            if row == 6{
                totalTimeOfChat = .threeAndHalf
            }
            if row == 7{
                totalTimeOfChat = .four
            }
            if row == 8{
                totalTimeOfChat = .fourAndHalf
            }
            if row == 9{
                totalTimeOfChat = .five
            }
            if row == 10{
                totalTimeOfChat = .fiveAndHalf
            }
            if row == 11{
                totalTimeOfChat = .six
            }
            let _ = self.validateSessionLength()
            return
        }
    }
}

extension EditSessionFormRootView:CustomPickerDelegate{
    
    func pickerDoneTapped(type: CustomPicker.pickerType) {
        
        if type == .sessionLength {
            
            if sessionLengthPicker.picker?.selectedRow(inComponent: 0) == 0 {
                sessionLength?.textField?.text = sessionArray[0]
                totalTimeOfChat = .thirtyMinutes
            }
            let _ = validateSessionLength()
            
        }
        
        if type == .chatLength{
            
            if chatLengthPicker.picker?.selectedRow(inComponent: 0) == 0 {
                
                if chatLengthArray.count >= 1 {
                   
                    if Int(chatLengthArray[0]) ?? 0 <= 1 {
                        chatLength?.textField?.text = chatLengthArray[0] + " min"
                    }else{
                        chatLength?.textField?.text = chatLengthArray[0] + " mins"
                    }
                    slotSelected = Int(chatLengthArray[0])
                }
            }
            let _ = validateSlotTime()
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
            hideBreak()
            return
        }
        guard let startDate = info.startDateTime else{
            hidePaintChatCalculator()
            hideBreak()
            return
        }
        guard let endDate = info.endDateTime else{
            hidePaintChatCalculator()
            hideBreak()
            return
        }
        
        let totalDurationInMinutes = Int(endDate.timeIntervalSince(startDate)/60.0)
        
        var totalSlots = 0
        
        guard let singleChatDuration = self.scheduleInfo?.duration else{
           
            hidePaintChatCalculator()
            hideBreak()
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
            
            let mutableStr  = "\(totalSlots-(getEmptySlotSelectedCount()))".toMutableAttributedString(font: "Nunito-ExtraBold", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
            
            let nextStr = " available 1:1 chats"
            let nextAttrStr  = nextStr.toAttributedString(font: "Nunito-Regular", size: (normalFont-3), color: UIColor(hexString: "#808080"), isUnderLine: false)
            
            mutableStr.append(nextAttrStr)
            chatTotalNumberOfSlots?.attributedText = mutableStr
            createEmptySlots()
            return
        }
        hideBreak()
        hidePaintChatCalculator()
        Log.echo(key: "yud", text: "Total number of the slot is \(totalSlots)")
    }
    
    func updateChatTotalCalculatorWithBreaks(){
        
        guard let info = scheduleInfo else{
            hidePaintChatCalculator()
            hideBreak()
            return
        }
        guard let startDate = info.startDateTime else{
            hidePaintChatCalculator()
            hideBreak()
            return
        }
        guard let endDate = info.endDateTime else{
            hidePaintChatCalculator()
            hideBreak()
            return
        }
        
        let totalDurationInMinutes = Int(endDate.timeIntervalSince(startDate)/60.0)
        
        var totalSlots = 0
        
        guard let singleChatDuration = self.scheduleInfo?.duration else{
            
            hidePaintChatCalculator()
            hideBreak()
            return
        }
        
        totalSlots = totalDurationInMinutes/singleChatDuration
        
        var fontSizeTotalSlot = 30
        var normalFont = 20
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            
            fontSizeTotalSlot = 26
            normalFont = 18
        }
        
        
        let mutableStr  = "\(totalSlots-(getEmptySlotSelectedCount()))".toMutableAttributedString(font: "Nunito-ExtraBold", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        
        let nextStr = " available 1:1 chats"
        let nextAttrStr  = nextStr.toAttributedString(font: "Nunito-Regular", size: (normalFont-3), color: UIColor(hexString: "#808080"), isUnderLine: false)
        
        mutableStr.append(nextAttrStr)
        chatTotalNumberOfSlots?.attributedText = mutableStr
    }
    
        
    func createEmptySlots(){
        
        
        //removing the text from the textField as by calling this function means fetching the new Data for empty Slots.
        self.breakField?.textField?.text = ""
        
        guard let info = scheduleInfo else{
            hidePaintChatCalculator()
            hideBreak()
            return
        }
        
        guard let startTime = info.startDateTime else {
            hideBreak()
            return
        }
        
        guard let endTime = info.endDateTime else {
            hideBreak()
            return
        }
        
        let timeDiffreneceOfSlots = endTime.timeIntervalSince(startTime)

        let totalminutes = (timeDiffreneceOfSlots/60)
        guard let duration = self.scheduleInfo?.duration else {
            hideBreak()
            return
        }
        
        let totalSlots = Int(totalminutes/Double(duration))
        let existingSlots = self.emptySlotList
        self.emptySlotList.removeAll()
        if existingSlots.count == totalSlots {
            
            for i in 0..<totalSlots {
                
                let requiredStartDate = self.scheduleInfo?.startDateTime?.addingTimeInterval(TimeInterval(Double(duration)*60.0*Double(i)))
                let requiredEndDate = requiredStartDate?.addingTimeInterval(TimeInterval(Double(duration)*60.0))
                let emptySlotObj = EmptySlotInfo(startDate: requiredStartDate, endDate: requiredEndDate)
                if existingSlots[i].isSelected == true {
                    emptySlotObj.isSelected = true
                }
                self.emptySlotList.append(emptySlotObj)
            }
        }else{
            for i in 0..<totalSlots {
                
                let requiredStartDate = self.scheduleInfo?.startDateTime?.addingTimeInterval(TimeInterval(Double(duration)*60.0*Double(i)))
                let requiredEndDate = requiredStartDate?.addingTimeInterval(TimeInterval(Double(duration)*60.0))
                let emptySlotObj = EmptySlotInfo(startDate: requiredStartDate, endDate: requiredEndDate)
                self.emptySlotList.append(emptySlotObj)
            }
        }
        
        if emptySlotList.count > 0 {
        
            self.breakAdapter?.update(emptySlots: emptySlotList)
            return
        }
    }
    
    func fillEmptySlotSelectionInfo(){
        
        if emptySlotList.count > 0 {
            
            if self.eventInfo != nil {
                if let emptySlotArray = self.eventInfo?.emptySlotsArray {
                    if emptySlotArray.count > 0 {
                        for i in 0..<emptySlotArray.count {
                            if let dict = emptySlotArray[i].dictionary {
                                if let slotNumber = dict["slotNo"]?.int {
                                    if slotNumber <= 0 {
                                        continue
                                    }
                                    if slotNumber <= self.emptySlotList.count {
                                        self.emptySlotList[slotNumber-1].isSelected = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            //showBreak()
            self.breakAdapter?.update(emptySlots: emptySlotList)
            self.showSelectedIndex()
            self.paintMaximumEarningCalculator()
            return
        }
    }
    
    
    fileprivate func validateSlotTime()->Bool{
        
        Log.echo(key: "yud", text: "Error is slot number \(String(describing: slotSelected))")
        
        if(slotSelected == 0 || slotSelected == nil){
            
            chatLength?.showError(text:"1:1 chat length is required.")
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
        
        guard let totalSlot = info.totalSlots else{
            resetEarningCalculator()
            return
        }
        
        let totalSlots = totalSlot - (breakAdapter?.selectedBreakSlots ?? 0)
        
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
        let calculatorStr = "(\(totalSlots) chats * $\(String(format: "%.2f", price)) per chat) - fees ($\(String(format: "%.2f", serviceFee))) ="
        
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
            
            priceAmountField?.showError(text: "Please set your ticket price.")
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
            
            priceAmountField?.showError(text: "Minimum price is $ \(String(format: "%.2f", self.scheduleInfo?.minimumPlanPriceToSchedule ?? 0.0))")
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
            else if totalTimeOfChat == .twoAndHalf{
                
                date = calendar.date(byAdding: .minute, value: 150, to: newDate)
                self.scheduleInfo?.endDateTime = date
            }
            else if totalTimeOfChat == .three{
                
                date = calendar.date(byAdding: .minute, value: 180, to: newDate)
                self.scheduleInfo?.endDateTime = date
            }
            else if totalTimeOfChat == .threeAndHalf{
                
                date = calendar.date(byAdding: .minute, value: 210, to: newDate)
                self.scheduleInfo?.endDateTime = date
            }
            else if totalTimeOfChat == .four{
                
                date = calendar.date(byAdding: .minute, value: 240, to: newDate)
                self.scheduleInfo?.endDateTime = date
            }
            else if totalTimeOfChat == .fourAndHalf{
                
                date = calendar.date(byAdding: .minute, value: 270, to: newDate)
                self.scheduleInfo?.endDateTime = date
            }
            else if totalTimeOfChat == .five{
                
                date = calendar.date(byAdding: .minute, value: 300, to: newDate)
                self.scheduleInfo?.endDateTime = date
            }
            else if totalTimeOfChat == .fiveAndHalf{
                
                date = calendar.date(byAdding: .minute, value: 330, to: newDate)
                self.scheduleInfo?.endDateTime = date
            }
            else if totalTimeOfChat == .six{
                
                date = calendar.date(byAdding: .minute, value: 360, to: newDate)
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
        fillEmptySlotSelectionInfo()
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
            let requiredNewDate = dateFormatter.string(from: newDate)
            return requiredNewDate
        }
        return nil
    }
    
    var chatDuration:Int?{
        get{
            return self.slotSelected
        }
    }
    
    func updatescheduleInfoForGetParams(){
        
        self.scheduleInfo?.title = titleField?.textField?.text
        self.scheduleInfo?.startDate = self.dateField?.textField?.text
        self.scheduleInfo?.startTime = self.timeField?.textField?.text
        updateStartDateParamForGetParams()
    }
    
    func updateStartDateParamForGetParams(){
        
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
            self.scheduleInfo?.isSponsorEnable = false
            
        }else{
            
            if sponsorShipToggle?.isOn == true{
                self.scheduleInfo?.isSponsorEnable = true
            }else{
                self.scheduleInfo?.isSponsorEnable = false
            }
            self.scheduleInfo?.isFree = true
            self.scheduleInfo?.doublePrice = 0.0
        }
        
//        paintChatCalculator()
//        paintMaximumEarningCalculator()
    }
    
    
    func getParam()->[String:Any]? {
        
        updatescheduleInfoForGetParams()
        
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
           
            if info.isFree{
                
                param["sponsorshipAmount"] = info.isSponsorEnable
            }else{
                param["sponsorshipAmount"] = false
            }
            return param
        }
        
        param["title"] = info.title
        param["start"] = "\(startDate)"
        param["end"] = "\(endDate)"
        param["userId"] = id
        param["duration"] = durate
        param["flexibleBooking"] = self.currentBookingStyle == .standard ? false : true
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
        param["sponsorshipAmount"] = info.isSponsorEnable
        var paramsForSlots = [[String:Any]]()
        if let selectedArray = self.breakAdapter?.emptySlots{
            for index in 0..<selectedArray.count{
                if selectedArray[index].isSelected{
                    if let startDate = selectedArray[index].startDate{
                        if let endDate = selectedArray[index].endDate{
                            let info = ["start":"\(startDate)","end":"\(endDate)","slotNo":index+1] as [String : Any]
                            paramsForSlots.append(info)
                        }
                    }
                }
            }
        }
        param["emptySlots"] = paramsForSlots
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

    func slotIdentifiedDisbaleView() {
        
        dateField?.isUserInteractionEnabled = false
        timeField?.isUserInteractionEnabled = false
        sessionLength?.isUserInteractionEnabled = false
        chatLength?.isUserInteractionEnabled = false
        freeField?.isUserInteractionEnabled = false
        priceField?.isUserInteractionEnabled = false
        priceAmountField?.isUserInteractionEnabled = false
        screenShotCustomSwitch?.isUserInteractionEnabled = false
        breakField?.isUserInteractionEnabled = false
        
        breakField?.textFieldContainer?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        dateField?.textFieldContainer?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        timeField?.textFieldContainer?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        sessionLength?.textFieldContainer?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        chatLength?.textFieldContainer?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        
        if self.eventInfo?.isFree ?? false {
            
            freeField?.backgroundColor = UIColor(red: 254.0/255.0, green: 203.0/255.0, blue: 170.0/255.0, alpha: 1)
            priceAmountField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
            priceField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
            
        }else {
            
            priceField?.backgroundColor = UIColor(red: 254.0/255.0, green: 203.0/255.0, blue: 170.0/255.0, alpha: 1)
            priceAmountField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
            freeField?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        }
    }
}


extension EditSessionFormRootView{
    
    @IBAction func openPaymentPage(sender:UIButton?){
        
        guard let controller = FAQWebController.instance() else{
            return
        }
        controller.nameofTitle = "Payments"
        controller.url = "https://www.chatalyze.com/payments"
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}

extension EditSessionFormRootView:InformForBreakSelectionInterface{
    
    func breakSelectionConfirmed() {
        
        paintMaximumEarningCalculator()
        updateChatTotalCalculatorWithBreaks()
    }
}

extension EditSessionFormRootView{
    
    func getEmptySlotSelectedCount()->Int{
        
        var selectedSlots  = 0
        for info in self.breakAdapter?.emptySlots ?? []{
            if info.isSelected {
               selectedSlots = selectedSlots + 1
            }
        }
        return selectedSlots
    }
}


extension EditSessionFormRootView{
    
    func getTodayDate(at: (hour: Int, minute: Int)) -> Date {
        
        var dateComponents = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day], from: Date())
        
        dateComponents.hour = at.hour
        
        dateComponents.minute = at.minute
        
        return Calendar.autoupdatingCurrent.date(from: dateComponents) ?? Date()
    }
}
