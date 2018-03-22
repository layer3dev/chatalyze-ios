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
    
    @IBAction fileprivate func loginAction(){
        signIn()
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
            case .success( _,  _, let accessToken):
                print("User loggedin!!")
                self.fetchFBUserInfo(accessToken: accessToken)
                break
            }
        }
    }
    
    fileprivate func fetchFBUserInfo(accessToken : FacebookCore.AccessToken?){
        DispatchQueue.main.async(execute: {
            self.controller?.showLoader()
            FacebookLogin().signin(accessToken: accessToken, completion: { (success, message, info) in
                self.controller?.stopLoader()
                if(success){
                    RootControllerManager().updateRoot()
                }
            })
        })
    }
        
}


extension SigninRootView{
    fileprivate func signIn(){
        let email = emailField?.textField?.text ?? ""
        let password = passwordField?.textField?.text ?? ""
        self.controller?.showLoader()
        
        signInRequest(email: email, password: password) { (success) in
            self.controller?.stopLoader()
            if(success){
                RootControllerManager().updateRoot()
            }
        }
        
    }
    
    func signInRequest(email : String, password : String, completion : ((_ success : Bool)->())?){
        
        EmailSigninHandler().signin(withEmail: email, password: password) { (success, error, info) in
            completion?(success)
        }
    }

    
}
