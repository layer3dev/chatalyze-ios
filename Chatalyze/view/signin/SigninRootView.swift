//
//  SigninRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 26/02/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class SigninRootView: ExtendedView {
    
    var controller : SigninController?
    
    @IBOutlet fileprivate var emailField : SigninFieldView?
    @IBOutlet fileprivate var passwordField : SigninFieldView?
    
    @IBOutlet fileprivate var scrollView : FieldManagingScrollView?
    @IBOutlet fileprivate var scrollContentBottomOffset : NSLayoutConstraint?
    
    @IBAction fileprivate func fbLoginAction(){
        fbLogin()
    }

    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    fileprivate func initialization(){
        initializeVariable()
    }
    
    fileprivate func initializeVariable(){
        emailField?.textField?.delegate = self
        passwordField?.textField?.delegate = self
        
        scrollView?.bottomContentOffset = scrollContentBottomOffset
    }
    

}

extension SigninRootView{
    
    func validateFields()->Bool{
        return validateEmail() && validatePassword()
    }
    
    fileprivate func validateEmail()->Bool{
        if(emailField?.textField?.text == ""){
            emailField?.showError(text: "Email field can't be left empty !")
            return false
        }
        emailField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validatePassword()->Bool{
        if(passwordField?.textField?.text == ""){
            passwordField?.showError(text: "Password field can't be left empty !")
            return false
        }
        passwordField?.resetErrorStatus()
        return true
    }
    
}




extension SigninRootView : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView?.activeField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == emailField?.textField){
            passwordField?.textField?.becomeFirstResponder()
        }else{
            passwordField?.textField?.resignFirstResponder()
        }
        return true
    }
}


extension SigninRootView{
    
    fileprivate func fbLogin(){
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ ReadPermission.publicProfile ], viewController: controller) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                FacebookLogin().signin(accessToken: accessToken.authenticationToken, completion: { (success, message, info) in
                    
                })
                break
            }
        }
    }
        
}
