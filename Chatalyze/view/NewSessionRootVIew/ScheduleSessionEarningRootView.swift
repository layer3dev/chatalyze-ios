//
//  ScheduleSessionEarningRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 31/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//


import UIKit

protocol ScheduleSessionEarningRootViewDelegate {
    func getSchduleSessionInfo()->ScheduleSessionInfo?
}

class ScheduleSessionEarningRootView: ExtendedView{
    
    enum slotDurationMin:Int{

        case two = 0
        case three = 1
        case five = 2
        case ten = 3
        case fifteen = 4
        case thirty = 5
        case none = 6
    }

    @IBOutlet var priceField:SigninFieldView?

    @IBOutlet var twoMinutesBtn:UIButton?
    @IBOutlet var threeMinutesBtn:UIButton?
    @IBOutlet var fiveMinutesBtn:UIButton?
    @IBOutlet var tenMinutesBtn:UIButton?
    @IBOutlet var fifteenMinutesBtn:UIButton?
    @IBOutlet var thirtyMinutesBtn:UIButton?

    var slotSelected:slotDurationMin = .none

    @IBOutlet var slotDurationErrorLbl:UILabel?

    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollContentBottonOffset:NSLayoutConstraint?

    @IBOutlet var chatCalculatorLbl:UILabel?
    @IBOutlet var chatTotalNumberOfSlots:UILabel?

    @IBOutlet var earningFormulaLbl:UILabel?
    @IBOutlet var totalEarningLabel:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
//        self.priceField?.textField?.doneAccessory = true
//        self.priceField?.isCompleteBorderAllow = true
//        initializeVariable()
    }
    
    
    func initializeVariable(){

        scrollView?.bottomContentOffset = scrollContentBottonOffset
        priceField?.textField?.delegate = self
        priceField?.textField?.keyboardType = UIKeyboardType.numberPad
        //priceField?.textField?.addTarget(self, action: "textFieldDidChange:", for: UIControl.Event.EditingChanged)
        priceField?.textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        paintMaximumEarningCalculator()
        priceValidation()
    }
    
    func resetDurationSelection(){

        twoMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        threeMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        fiveMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        tenMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        fifteenMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        thirtyMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
    }
    

    @IBAction func chatSlotDurationAction(sender:UIButton){

        if sender.tag == 0 {

            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .two
        }
        else if sender.tag == 1 {

            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .three
        }
        else if sender.tag == 2 {

            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .five
        }
        else if sender.tag == 3 {

            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .ten
        }
        else if sender.tag == 4 {

            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .fifteen
        }
        else if sender.tag == 5 {

            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .thirty
        }
        paintChatCalculator()
        paintMaximumEarningCalculator()
        validateSlotTime()
    }
    
    
    
    @IBAction func nextAction(sender:UIButton?){

        if(validateFields()){
            self.resetErrorStatus()
        }
    }
    
    
    func getParameter()->[String:Any]{

        
        //        {"isFree":false,"eventFeedbackInfo":null,"youtubeURL":null,"emptySlots":null,"screenshotAllow":"automatic"}

        var param = [String:Any]()

        if slotSelected == .none{
        }
        if slotSelected == .two{
            param["duration"] = 2
        }
        if slotSelected == .three{
            param["duration"] = 3
        }
        if slotSelected == .five{
            param["duration"] = 5
        }
        if slotSelected == .ten{
            param["duration"] = 10
        }
        if slotSelected == .fifteen{
            param["duration"] = 15
        }
        if slotSelected == .thirty{
            param["duration"] = 30
        }
        //Calculating the price for one hour
        param["price"] = priceField?.textField?.text
        return param
    }
    
}


extension ScheduleSessionEarningRootView:UITextFieldDelegate{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        scrollView?.activeField = priceField
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

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

    func isPriceZero(text:String?)->Bool{

        if let priceStr = text{

            guard priceStr.count > 0 else { return true }
            let nums: Set<Character> = ["0"]
            return Set(priceStr).isSubset(of: nums)
        }
        return false
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


extension ScheduleSessionEarningRootView{
    
    func paintMaximumEarningCalculator(){
        
        guard let price = Int(priceField?.textField?.text ?? "0") else{
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
        
        var totalSlots = 0
        var totalMinutesOfChat = 0
        var singleChatMinutes = 0
        let currentParams = getParameter()
        
        if let durate = currentParams["duration"] as? Int{
            singleChatMinutes = durate
            if let durationType =  currentParams["selectedHourSlot"] as? SessionTimeDateRootView.DurationLength {
                
                if durationType == .none{
                    return
                }
                if durationType == .oneHour{
                    
                    totalMinutesOfChat = 60
                    totalSlots = 60/durate
                }
                if durationType == .twohour{
                    
                    totalMinutesOfChat = 120
                    totalSlots = 120/durate
                }
                if durationType == .thirtyMin{
                    
                    totalMinutesOfChat = 30
                    totalSlots = 30/durate
                }
                if durationType == .oneAndhour{
                    
                    totalMinutesOfChat = 90
                    totalSlots = 90/durate
                }
            }else{
                return
            }
        }else{
            return
        }
        
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
        // let serviceFee = totalSeviceFee
        
        let serviceFee = (round((totalSeviceFee*1000))/1000)
        let totalEarningRoundedPrice = (round((totalEarning*1000))/1000)
        
        //Log.echo(key: "yud", text: "Service fee is \(serviceFee) and the total earning is \(totalEarning) paypal fee is \(paypalFeeofSingleChat) and the cost of the single chat is \(price)")
        
        var fontSizeTotalSlot = 30
        var normalFont = 20
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            fontSizeTotalSlot = 26
            normalFont = 18
        }
        
        let calculatorStr = "\(totalSlots) chats * $\(price) per chat) - $\(String(format: "%.2f", serviceFee)) ="
        
        let calculateAttrStr  = calculatorStr.toAttributedString(font: "Questrial", size: normalFont, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        let mutableStr  = "$\(String(format: "%.2f", totalEarningRoundedPrice))".toAttributedString(font: "Poppins", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        
        earningFormulaLbl?.attributedText = calculateAttrStr
        totalEarningLabel?.attributedText = mutableStr
        //chatTotalNumberOfSlots?.attributedText = mutableStr
    }
    
    func resetEarningCalculator(){
        
        var fontSizeTotalSlot = 30
        var normalFont = 20
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            
            fontSizeTotalSlot = 26
            normalFont = 18
        }
        
        let calculatorStr = "(\(0) chats * $\(0) per chat) - $\(0) ="
        
        let calculateAttrStr  = calculatorStr.toAttributedString(font: "Questrial", size: normalFont, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        let mutableStr  = "$\(0)".toAttributedString(font: "Poppins", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        
        earningFormulaLbl?.attributedText = calculateAttrStr
        totalEarningLabel?.attributedText = mutableStr
    }
    
    func paintChatCalculator(){
        
        //Log.echo(key: "yud", text: "Calculator response is \(param)")
        
        var totalSlots = 0
        var totalMinutesOfChat = 0
        var singleChatMinutes = 0
        let currentParams = getParameter()
        
        //Log.echo(key: "yud", text: "Calculator duration is \(currentParams) and the duration is \(currentParams["duration"] as? Int)Type is \(self.controller?.selectedDurationType)")
        
        if let durate = currentParams["duration"] as? Int{
            singleChatMinutes = durate
            if let durationType =  currentParams["selectedHourSlot"] as? SessionTimeDateRootView.DurationLength {
                
                if durationType == .none{
                    return
                }
                if durationType == .oneHour{
                    
                    totalMinutesOfChat = 60
                    totalSlots = 60/durate
                }
                if durationType == .twohour{
                    
                    totalMinutesOfChat = 120
                    totalSlots = 120/durate
                }
                if durationType == .thirtyMin{
                    
                    totalMinutesOfChat = 30
                    totalSlots = 30/durate
                }
                if durationType == .oneAndhour{
                    
                    totalMinutesOfChat = 90
                    totalSlots = 90/durate
                }
            }
        }
        
        var fontSizeTotalSlot = 30
        var normalFont = 20
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            
            fontSizeTotalSlot = 26
            normalFont = 18
        }
        
        if totalSlots > 0 && totalMinutesOfChat > 0 && singleChatMinutes > 0{
            
            Log.echo(key: "yud", text: "Slot number fetch SuccessFully \(totalSlots) and the totalMinutesOfChat is \(totalMinutesOfChat) and the single Chat is \(singleChatMinutes)")
            
            chatCalculatorLbl?.text = "\(totalMinutesOfChat) mins. / \(singleChatMinutes) mins. ="
            
            let mutableStr  = "\(totalSlots)".toMutableAttributedString(font: "Poppins", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
            
            let nextStr = " Available 1:1 chats"
            let nextAttrStr  = nextStr.toAttributedString(font: "Questrial", size: normalFont, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
            
            mutableStr.append(nextAttrStr)
            chatTotalNumberOfSlots?.attributedText = mutableStr
        }
        Log.echo(key: "yud", text: "total number of the slot is \(totalSlots)")
    }
    
    func resetErrorStatus(){
        
        slotDurationErrorLbl?.text = ""
        priceField?.resetErrorStatus()
    }
    
    func validateFields()->Bool{
        
        let priceValidated  = priceValidation()
        let durationValidated = validateSlotTime()
        return priceValidated && durationValidated
    }
    
    fileprivate func priceValidation()->Bool{
        
        if(priceField?.textField?.text == ""){
            
            priceField?.showError(text: "Price is required.")
            return false
        }
        else if isPriceZero(text: priceField?.textField?.text){
            
            priceField?.showError(text: "Minimum price is $1")
            return false
        }
        else if isExceedsMaximumPrice(text: priceField?.textField?.text){
            
            priceField?.showError(text: "Price can't be more than 9999.")
            return false
        }
        priceField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validateSlotTime()->Bool{
        
        if(slotSelected == .none){
            
            slotDurationErrorLbl?.text = "Chat duration is required."
            return false
        }
        slotDurationErrorLbl?.text = ""
        return true
    }

    func showError(message:String?){
        
        //errorLbl?.text =  message ?? ""
    }
}




