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
    func goToNextScreen()
}

class ScheduleSessionEarningRootView: ExtendedView{

    var delegate:ScheduleSessionEarningRootViewDelegate?
    
    @IBOutlet var priceField:SigninFieldView?

    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollContentBottonOffset:NSLayoutConstraint?

    @IBOutlet var earningFormulaLbl:UILabel?
    @IBOutlet var totalEarningLabel:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.priceField?.textField?.doneAccessory = true
        self.priceField?.isCompleteBorderAllow = true
        initializeVariable()
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
    
    func updateParameter(){
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        info.price = Int(priceField?.textField?.text ?? "0")
    }
    
    
    //MARK:- Button Action
    
    @IBAction func nextAction(sender:UIButton?){

        if(!validateFields()){
            return
        }
        self.resetErrorStatus()
        updateParameter()
        delegate?.goToNextScreen()
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
        
        guard let info = delegate?.getSchduleSessionInfo() else{
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
    
    func resetErrorStatus(){
        
        priceField?.resetErrorStatus()
    }
    
    func validateFields()->Bool{
        
        let priceValidated  = priceValidation()
        return priceValidated
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

    func showError(message:String?){
        
        //errorLbl?.text =  message ?? ""
    }
}




