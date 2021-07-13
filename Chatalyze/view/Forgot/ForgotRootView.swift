//
//  ForgotRootView.swift
//  Chatalyze
//
//  Created by Mansa on 03/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class ForgotRootView:ExtendedView{
    
    var controller : ForgotPasswordController?
    @IBOutlet fileprivate var emailField : SigninFieldView?
    @IBOutlet fileprivate var errorLabel : UILabel?
    @IBOutlet var sendBtn:UIButton?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollViewBottomConstraints:NSLayoutConstraint?
    @IBOutlet var signupBtn:UIButton?
    
    @IBAction func sendAction(sender:UIButton){
        
        self.errorLabel?.textColor = UIColor.red
        self.errorLabel?.text = ""
        if(validateFields()){
            
            self.resetErrorStatus()
            sendResetPassword()
        }
    }
    
    func sendResetPassword(){
        
        let email = emailField?.textField?.text ?? ""
        self.controller?.showLoader()
        
        ForgotPasswordProcessor().sendPassword(withEmail: email) { (success, message, response) in
            self.controller?.stopLoader()
          
            if success{
                
                self.showError(text: (("Password reset link sent. Please check your email ".localized() ?? "") + "\(email)"))
                self.errorLabel?.textColor = UIColor(hexString: AppThemeConfig.themeColor)
                self.emailField?.textField?.text = ""
                return
            }
             self.errorLabel?.textColor = UIColor.red
            self.showError(text: message)
            return
        }
    }
    
    @IBAction func  cancelAction(){
        
        self.controller?.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func signupAction(sender:UIButton){
        self.controller?.navigationController?.popToRootViewController(animated: true)
        
        DispatchQueue.main.async {
            if let handler = self.controller?.signUpHandler {
                handler()
            }
        }
        
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        initialisation()
    }
    
    func paintInterface(){
        
        sendBtn?.layer.cornerRadius = 3
        sendBtn?.layer.masksToBounds = true
    }
    
    func initialisation(){
        emailField?.textField?.placeholder = "Email".localized()
        emailField?.textField?.delegate = self
        scrollView?.bottomContentOffset = scrollViewBottomConstraints
    }
    
}

extension ForgotRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = textField
        return true
    }
}

extension ForgotRootView{
    
    fileprivate func validateEmail()->Bool{
        
        if(emailField?.textField?.text == ""){
            emailField?.showError(text: "Email field can't be left empty !".localized())
            return false
        }
        else if !(FieldValidator.sharedInstance.validateEmailFormat(emailField?.textField?.text ?? "")){
            emailField?.showError(text: "Email looks incorrect !".localized())
            return false
        }
        emailField?.resetErrorStatus()
        return true
    }
    
    func validateFields()->Bool{
        
        let emailValidated  = validateEmail()
        return emailValidated
    }
    
    func resetErrorStatus(){

        errorLabel?.text = ""
        emailField?.resetErrorStatus()
    }
    
    func showError(text : String?){
        
        errorLabel?.text = text
    }
}

