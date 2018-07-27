//
//  EventSoldOutController.swift
//  Chatalyze
//
//  Created by Mansa on 24/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventSoldOutController: InterfaceExtendedController {

    var dismissListner:(()->())?
    var info:EventInfo?
    @IBOutlet var messageLbl:UILabel?
    @IBOutlet var emailField:SigninFieldView?
    override func viewDidLayout() {
        super.viewDidLayout()
       
        paintInterface()
    }
    
    func paintInterface(){
        
        messageLbl?.text = "Submit your email address below to receive notice when \(info?.user?.firstName ?? "this analyst")'s next session is scheduled."
    }
    
    func validateFields()->Bool{
        
        let emailValidated  = validateEmail()
        return emailValidated
    }
    
    fileprivate func validateEmail()->Bool{
        
        if(emailField?.textField?.text == ""){
            emailField?.showError(text: "Email field can't be left empty !")
            return false
        }
        else if !(FieldValidator.sharedInstance.validateEmailFormat(emailField?.textField?.text ?? "")){
            emailField?.showError(text: "Email looks incorrect !")
            return false
        }
        emailField?.resetErrorStatus()
        return true
    }
    
    
    @IBAction func cancelAction(sender:UIButton){
        
        if let listner = self.dismissListner{
            listner()
        }
    }
    
    func submit(){
        
        guard let analystID = self.info?.user?.id else{
            return
        }
        let email = emailField?.textField?.text ?? ""
        self.showLoader()
        SubmitRequestForNextEventNotification().save(analystId: analystID, email: email) { (success, message, response) in
            
            self.stopLoader()
            if let listner = self.dismissListner{
                listner()
            }
        }
    }
    
    
   @IBAction func submitAction(sender:UIButton){
  
    if(validateFields()){
        //self.resetErrorStatus()
        submit()
    }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
