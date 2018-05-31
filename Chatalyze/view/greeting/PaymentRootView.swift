
//
//  PaymentRootView.swift
//  Chatalyze
//
//  Created by Mansa on 10/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class PaymentRootView: ExtendedView {

    @IBOutlet fileprivate var cardNumber : SigninFieldView?
    @IBOutlet fileprivate var expirydate : SigninFieldView?
    @IBOutlet fileprivate var cvcNumber : SigninFieldView?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollViewBottomConstraints:NSLayoutConstraint?
    var controller:PaymentController?
    var param = [String:Any]()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        initializeVariable()
    }
    
    func paintInterface(){        
    }
    
    func initializeVariable(){
        
        cardNumber?.textField?.delegate = self
        expirydate?.textField?.delegate = self
        cvcNumber?.textField?.delegate = self
        scrollView?.bottomContentOffset = scrollViewBottomConstraints
    }
    
    @IBAction func completePurchaseAction(sender:UIButton){
        
        if validateFields(){
            self.resetErrorStatus()
            uploadGreeting()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
         override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func uploadGreeting(){
       
        GreetingBookingProcessor().fetchInfo(param: self.param) { (success, data) in
            
            if success{
            }
        }
    }
}

extension PaymentRootView{
    
    func validateFields()->Bool{
        
        let confirmPasswordValidate = validateCard()
        let emailValidated  = validateExpirydate()
        let passwordValidated = valiadteCVCNumber()
        return confirmPasswordValidate && emailValidated && passwordValidated
    }
    
    func resetErrorStatus(){
        
        //errorLabel?.text = ""
        cardNumber?.resetErrorStatus()
        expirydate?.resetErrorStatus()
        cvcNumber?.resetErrorStatus()
    }
    
    func showError(text : String?){
        
        //errorLabel?.text = text
    }
    
    fileprivate func validateCard()->Bool{
        
        if(cardNumber?.textField?.text == ""){
            cardNumber?.showError(text: "Card field can't be left empty !")
            return false
        }
        cardNumber?.resetErrorStatus()
        return true
    }
    
    fileprivate func validateExpirydate()->Bool{
        
        if(expirydate?.textField?.text == ""){
            expirydate?.showError(text: "Expiry date field can't be left empty !")
            return false
        }
        expirydate?.resetErrorStatus()
        return true
    }
    
    fileprivate func valiadteCVCNumber()->Bool{
        
        if(cvcNumber?.textField?.text == ""){
            cvcNumber?.showError(text: "CVC field can't be left empty !")
            return false
        }
        cvcNumber?.resetErrorStatus()
        return true
    }
}

extension PaymentRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = textField
        return true
    }
}

