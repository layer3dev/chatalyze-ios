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
        isSecondCardSelected = false
        cardTwoField?.image?.image = UIImage(named: "untick")
        return
    }
    
    @IBAction func selectCardSecondAction(sender:UIButton?){
       
        if isSecondCardSelected{
            
            isSecondCardSelected = false
            cardTwoField?.image?.image = UIImage(named: "untick")
            return
        }
        isSecondCardSelected = true
        cardTwoField?.image?.image = UIImage(named: "tick")
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
            
            cardOneHeightConstraint?.constant = 62
            cardTwoHeightConstraint?.constant = 0
            addOtherCardInfoHeightContraint?.constant  = 50
            CardInfoHeightContraint?.constant  = 0
            self.superview?.updateConstraints()
            self.superview?.layoutIfNeeded()
            return
        }
        if numberOfSaveCards == 2{
            
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
        self.superview?.updateConstraints()
        self.superview?.layoutIfNeeded()
        return
    }
    
    
    @IBAction func cancelAction(sendre:UIButton){
        
        self.controller?.dismiss(animated: true, completion: {
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
      
        scrollView?.activeField = self
    }
}

extension EventPaymentRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = self
        return true
    }
}

extension EventPaymentRootView{
    
    @IBAction func submitPayment(sender:UIButton){
        
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
            Log.echo(key: "yud", text: "Error is \(error)")
            guard let token = token, error == nil else {
                return
            }
            Log.echo(key: "yud", text: "The card token description is \(token.description)")
            Log.echo(key: "yud", text: "The card token is \(token.description)")
            self.sendPayment(token:token.description)
            
        }
    }
    
    
    func sendPayment(token:String){
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return
        }
        
        guard let info = self.info else{
            return
        }
        
        var param = [String:Any]()
        param["token"] = token
        param["card"] = true
        param["amount"] = info.price
        param["serviceFee"] = "1.0"
        param["userId"] = id
        param["callscheduleId"] = info.id
        EventPaymentProcessor().pay(param: param) { (success, message, response) in
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

