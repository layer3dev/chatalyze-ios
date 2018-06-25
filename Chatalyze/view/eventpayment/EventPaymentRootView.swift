//
//  EventPaymentRootView.swift
//  Chatalyze
//
//  Created by Mansa on 29/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import InputMask
import Stripe

class EventPaymentRootView:ExtendedView,MaskedTextFieldDelegateListener{
    
    @IBOutlet var cardField:SigninFieldView?
    @IBOutlet var cvcField:SigninFieldView?
    @IBOutlet var dateMonthField:SigninFieldView?
    var controller:EventPaymentController?
    var maskedDelegate: MaskedTextFieldDelegate?
    var dateMonthMask: MaskedTextFieldDelegate?
    var cvcMask: MaskedTextFieldDelegate?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollViewBottomConstraints:NSLayoutConstraint?
    var isPickerHidden = true
    @IBOutlet var  pickerContainer:UIView?
    var isCardSave = false
    @IBOutlet var timePicker:UIDatePicker?
    @IBOutlet var tickImage:UIImageView?
    var numberOfSaveCards = 0
    @IBOutlet var cardOneHeightConstraint:NSLayoutConstraint?
    @IBOutlet var cardTwoHeightConstraint:NSLayoutConstraint?
    @IBOutlet var addOtherCardInfoHeightContraint:NSLayoutConstraint?
    @IBOutlet var CardInfoHeightContraint:NSLayoutConstraint?
    @IBOutlet var cardOneField:SigninFieldView?
    @IBOutlet var cardTwoField:SigninFieldView?
    var isFirstCardSelected = false
    var isSecondCardSelected = false
    var info:EventInfo?
    var cardInfoArray = [CardInfo]()
    var currentcardInfo:CardInfo?
    @IBOutlet var errorLable:UILabel?
    @IBOutlet var amountLbl:UILabel?
    @IBOutlet var serviceFees:UILabel?
    @IBOutlet var totalAmount:UILabel?
    var delegate:EventPaymentDelegte?
    
    override func viewDidLayout() {
        super.viewDidLayout()
      
        paintInterface()
        initializeVariable()
    }
    
    @IBAction func saveCardAction(sender:UIButton?){
        
        if isCardSave{
            
            isCardSave = false
            tickImage?.image = UIImage(named: "untick")
            return
        }
        isCardSave = true
        tickImage?.image = UIImage(named: "tick")
        return
    }
    
    @IBAction func selectCardOneAction(sender:UIButton?){
        
        if isFirstCardSelected{
            
            isFirstCardSelected = false
            cardOneField?.image?.image = UIImage(named: "untick")
            return
        }
        isFirstCardSelected = true
        cardOneField?.image?.image = UIImage(named: "tick")
        setCurrentCardInfo(selectedCard: 0)
        isSecondCardSelected = false
        cardTwoField?.image?.image = UIImage(named: "untick")
        return
    }
    
    func setCurrentCardInfo(selectedCard:Int){
        
        if selectedCard == 0 {
            if cardInfoArray.count >= 1{
                currentcardInfo = cardInfoArray[0]
            }
        }
        else if selectedCard == 1{
            if cardInfoArray.count >= 2{
                currentcardInfo = cardInfoArray[1]
            }
        }
    }
    
    
    @IBAction func selectCardSecondAction(sender:UIButton?){
       
        if isSecondCardSelected{
            
            isSecondCardSelected = false
            cardTwoField?.image?.image = UIImage(named: "untick")
            return
        }
        isSecondCardSelected = true
        cardTwoField?.image?.image = UIImage(named: "tick")
        setCurrentCardInfo(selectedCard:1)
        isFirstCardSelected = false
        cardOneField?.image?.image = UIImage(named: "untick")
        return
    }
    
    func paintInterfaceForSavedCard(){
        
        if numberOfSaveCards == 0 {
            
            cardOneHeightConstraint?.constant = 0
            cardTwoHeightConstraint?.constant = 0
            addOtherCardInfoHeightContraint?.constant  = 0
            CardInfoHeightContraint?.constant  = 220
            self.superview?.updateConstraints()
            self.superview?.layoutIfNeeded()
            return
        }
        if numberOfSaveCards == 1{
            
            if cardInfoArray.count >= 1{
                
                cardOneField?.textField?.placeholder = "XXXX-XXXX-XXXX-" + (cardInfoArray[0].lastDigitAccount ?? "")
            }
            cardOneHeightConstraint?.constant = 62
            cardTwoHeightConstraint?.constant = 0
            addOtherCardInfoHeightContraint?.constant  = 50
            CardInfoHeightContraint?.constant  = 0
            self.superview?.updateConstraints()
            self.superview?.layoutIfNeeded()
            return
        }
        if numberOfSaveCards == 2{
            
            if cardInfoArray.count >= 2{
                
                cardOneField?.textField?.placeholder = "XXXX-XXXX-XXXX-" + (cardInfoArray[0].lastDigitAccount ?? "")
                cardTwoField?.textField?.placeholder = "XXXX-XXXX-XXXX-" + (cardInfoArray[1].lastDigitAccount ?? "")
            }
            cardOneHeightConstraint?.constant = 62
            cardTwoHeightConstraint?.constant = 62
            addOtherCardInfoHeightContraint?.constant  = 0
            CardInfoHeightContraint?.constant  = 0
            self.superview?.updateConstraints()
            self.superview?.layoutIfNeeded()
            return
        }
    }
    
    
    @IBAction func addAnotherCardInfo(sender:UIButton?){
        
        cardOneHeightConstraint?.constant = 0
        cardTwoHeightConstraint?.constant = 0
        addOtherCardInfoHeightContraint?.constant  = 0
        CardInfoHeightContraint?.constant  = 220
        resetSaveCardsDetail()
        self.superview?.updateConstraints()
        self.superview?.layoutIfNeeded()
        return
    }
    
    func resetSaveCardsDetail(){
        
        isFirstCardSelected = false
        isSecondCardSelected = false
        currentcardInfo = nil
    }
    
    @IBAction func cancelAction(sendre:UIButton){
        
        self.controller?.presentingControllerObj?.dismiss(animated: true, completion: {
            
        })
    }
    
    @IBAction func pickerDoneAction(sender:UIButton?){
        
        if isPickerHidden == false {
            
            isPickerHidden = true
            pickerContainer?.isHidden = true
        }
    }
    
    
    @IBAction func datePickerAction(_ sender: Any) {
     
        dateMonthMask?.put(text: selectedTime, into: (dateMonthField?.textField)!)
    }
    
    @IBAction func dateAction(){
        
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
            dateFormatter.dateFormat = "MM:yy"
            if let cd  = timePicker?.date{
                return dateFormatter.string(from: cd).replacingOccurrences(of: ":", with: "")
            }
            return ""
        }
    }
    
    func paintInterface(){
        
        paintInterfaceForSavedCard()
    }
    
    func initializeVariable(){
        
        let serviceFeeCharge = String(format: "%.2f", self.info?.serviceFee ?? 0.0)
        let amountCharge = String(format: "%.2f", self.info?.price ?? 0.0)
        let total = ((self.info?.price ?? 0.0) + (self.info?.serviceFee ?? 0.0))
        let totalAmountCharge = String(format: "%.2f", total)
        
        
        serviceFees?.text = "$ "+"\(serviceFeeCharge)"
        amountLbl?.text = "$ "+"\(amountCharge)"
        totalAmount?.text = "$ "+"\(totalAmountCharge)"
        
        scrollView?.bottomContentOffset = scrollViewBottomConstraints
        
        maskedDelegate = MaskedTextFieldDelegate(format: "[0000]-[0000]-[0000]-[0000]")
        
        maskedDelegate?.listener = self
        cardField?.textField?.delegate = maskedDelegate
        
        dateMonthMask = MaskedTextFieldDelegate(format: "[00]/[00]")
        dateMonthMask?.listener = self
        dateMonthField?.textField?.delegate = dateMonthMask
        
        cvcMask = MaskedTextFieldDelegate(format: "[000]")
        cvcMask?.listener = self
        cvcField?.textField?.delegate = cvcMask
        
        //cardMask.put(text: "", into: (cardField?.textField)!)
    }
    
    open func textField(_ textField: UITextField,didFillMandatoryCharacters complete:Bool,didExtractValue value: String){
      
        scrollView?.activeField = textField
    }
}

extension EventPaymentRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        pickerDoneAction(sender: nil)
        scrollView?.activeField = textField
        return true
    }
}

extension EventPaymentRootView{
    
    @IBAction func submitPayment(sender:UIButton){
        
        if isFirstCardSelected{
            
            sendPaymentFromSavedCards(info: currentcardInfo)
            return
        }
        if isSecondCardSelected{
            
            sendPaymentFromSavedCards(info: currentcardInfo)
            return
        }
        
        if(validateFields()){
            self.resetErrorStatus()
            
            guard let accountNumber = cardField?.textField?.text?.replacingOccurrences(of: "-", with: "")  else{
                return
            }
            guard let cvcNumber = cvcField?.textField?.text else{
                return
            }
            pay(accountNumber:accountNumber,expMonth:selectedMonth,expiryYear:selectedYear,cvc:cvcNumber)
            
            Log.echo(key: "yud", text: "Account Number is \(accountNumber) Expiry Month is \(selectedMonth) Expiry year is \(selectedYear) cvc number is \(cvcNumber)")
        }
    }
}

extension EventPaymentRootView{
    
    func validateFields()->Bool{
        
        let cardValidate  = validateCard()
        let expiryValidate = validateExpiryField()
        let cvcValidation = cvcValidate()
        return cardValidate && expiryValidate && cvcValidation
    }
    
    func resetErrorStatus(){
        
        //errorLabel?.text = ""
        cardField?.resetErrorStatus()
        dateMonthField?.resetErrorStatus()
        cvcField?.resetErrorStatus()
    }
    
    func showError(text : String?){
        
        //errorLabel?.text = text
    }
    
    fileprivate func validateCard()->Bool{
        
        if(cardField?.textField?.text == ""){
            cardField?.showError(text: "Card field can't be left empty !")
            return false
        }
        else if ((cardField?.textField?.text?.count ?? 0) < 19){
            cardField?.showError(text: "Card number looks incorrect !")
            return false
        }
        cardField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validateExpiryField()->Bool{
        
        if(dateMonthField?.textField?.text == ""){
            dateMonthField?.showError(text: "Expiry field can't be left empty !")
            return false
        }
        dateMonthField?.resetErrorStatus()
        return true
    }
    
    fileprivate func cvcValidate()->Bool{
        
        if(cvcField?.textField?.text == ""){
            cvcField?.showError(text: "CVC field can't be left empty !")
            return false
        }
        else if ((cvcField?.textField?.text?.count ?? 0) < 3){
            cvcField?.showError(text: "CVC looks incorrect !")
            return false
        }
        cvcField?.resetErrorStatus()
        return true
    }
}

extension EventPaymentRootView{
    
    func pay(accountNumber:String,expMonth:String,expiryYear:String,cvc:String){
        
        let cardParams = STPCardParams()
        cardParams.number = accountNumber
        cardParams.expMonth = UInt(expMonth) ?? 0
        cardParams.expYear = UInt(expiryYear) ?? 0
        cardParams.cvc = cvc
        
        Log.echo(key: "yud", text: "Card param are \(cardParams)")
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            
            guard let token = token, error == nil else {
                return
            }
            self.sendPayment(token:token.description)
        }
    }
    
    
    
    func sendPaymentFromSavedCards(info:CardInfo?){
        
        guard let cardInfo =  info else {
            return
        }
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            Log.echo(key: "yud", text: "I am returning as ID did not found")
            return
        }
        
        guard let info = self.info else{
            Log.echo(key: "yud", text: "I am returning as info did not found")
            return
        }
        
        guard let callScheduleId = info.id else{
            
            Log.echo(key: "yud", text: "I am returning as info did not found")
            return
        }
        
        Log.echo(key: "yud", text: "The amount is \(info.price)")
        Log.echo(key: "yud", text: "Service fee is \(info.serviceFee)")
        
        //{"amount":"5.00","serviceFee":"0.46","card":true}
        
        
        guard let amount = info.price else{
            return
        }
        
        guard let serviceFee = info.serviceFee else{
            return
        }
        
        var param = [String:Any]()
        param["token"] = cardInfo.idToken
        param["card"] = true
        param["amount"] = String(amount)
        param["serviceFee"] = String(serviceFee)
        param["userId"] = Int(id)
        param["callscheduleId"] = Int(callScheduleId)
        param["remember"] = isCardSave
        
        self.controller?.showLoader()
    
        EventPaymentProcessor().pay(param: param) { (success, message, response) in
            
            Log.echo(key: "yud", text: "the response is \(response)")
            Log.echo(key: "yud", text: "success  is \(success)")
            Log.echo(key: "yud", text: "Message is \(message)")
            
            self.controller?.stopLoader()
            
            if !success{
                
                self.errorLable?.text = message
                return
            }
            
            guard let response = response else{
                return
            }
            
            guard let controller = PaymentSuccessController.instance() else{
                return
            }
            
            controller.presentingControllerObj = self.controller?.presentingControllerObj
            controller.info = response            
            self.controller?.present(controller, animated: true, completion: {
            })
            return
        }
    }
    
    func sendPayment(token:String){
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            Log.echo(key: "yud", text: "I am returning as ID did not found")
            return
        }
        
        guard let info = self.info else{
            Log.echo(key: "yud", text: "I am returning as info did not found")
            return
        }

        guard let callScheduleId = info.id else{
            Log.echo(key: "yud", text: "I am returning as info did not found")
            return
        }
        
        guard let amount = info.price else{
            return
        }
        
        guard let serviceFee = info.serviceFee else{
            return
        }
        
        var param = [String:Any]()
        param["token"] = token
        param["card"] = false
        param["amount"] = String(amount)
        param["serviceFee"] = String(serviceFee)
        param["userId"] = Int(id)
        param["callscheduleId"] = Int(callScheduleId)
        param["remember"] = isCardSave
        
        self.controller?.showLoader()
        EventPaymentProcessor().pay(param: param) { (success, message, response) in

            Log.echo(key: "yud", text: "the response is \(response)")
            Log.echo(key: "yud", text: "success  is \(success)")
            Log.echo(key: "yud", text: "Message is \(message)")
            
            self.controller?.stopLoader()
            if !success{
                
                self.errorLable?.text = message
                return
            }
            
            guard let response = response else{
                return
            }
            
            guard let controller = PaymentSuccessController.instance() else{
                return
            }
            controller.presentingControllerObj = self.controller?.presentingControllerObj
            //controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            controller.info = response
            self.controller?.present(controller, animated: true, completion: {
            })
        }
    }
    
    
    var selectedYear:String{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy"
            if let cd  = timePicker?.date{
                return dateFormatter.string(from: cd)
            }
            return ""
        }
    }
    
    var selectedMonth:String{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "MM"
            if let cd  = timePicker?.date{
                return dateFormatter.string(from: cd)
            }
            return ""
        }
    }
}