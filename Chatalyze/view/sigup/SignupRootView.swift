//
//  SignupRootView.swift
//  Chatalyze
//
//  Created by Mansa on 02/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import Bugsnag

class SignupRootView:ExtendedView{
    
    var controller : SignUpController?
    @IBOutlet fileprivate var emailField : SigninFieldView?
    @IBOutlet fileprivate var passwordField : SigninFieldView?
    @IBOutlet fileprivate var firstName : SigninFieldView?
    @IBOutlet fileprivate var errorLabel : UILabel?
    @IBOutlet var signUpBtn:UIButton?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollViewBottomConstraints:NSLayoutConstraint?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        initializeVariable()
        paintInterface()
        changePlaceHolderColor()
    }
    
    func resetInfo(){
     
        self.emailField?.textField?.text = ""
        self.passwordField?.textField?.text = ""
        self.firstName?.textField?.text = ""
        
        self.emailField?.resetErrorStatus()
        self.passwordField?.resetErrorStatus()
        self.firstName?.resetErrorStatus()
    }
    
    fileprivate func changePlaceHolderColor(){
        
        emailField?.textField?.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordField?.textField?.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
      
        firstName?.textField?.attributedPlaceholder = NSAttributedString(string: "Full Name",
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @IBAction fileprivate func signupAction(sender:UIButton){
        
        if(validateFields()){
            self.resetErrorStatus()
            signUp()
        }
    }
    
    func signUp(){
        
        let email = emailField?.textField?.text ?? ""
        let password = passwordField?.textField?.text ?? ""
        let firstname = firstName?.textField?.text ?? ""
        
        self.controller?.showLoader()
        
        SignupProcessor().signup(withEmail: email, password: password, name: firstname) { (success, message, info) in
            
            if (success){
                self.signin(email:email,password:password)
                return
            }
            self.controller?.stopLoader()
            self.showError(text: message)
            return
        }
    }
    
    func signin(email:String?,password:String?){
        
        let email = email ?? ""
        let password = password ?? ""
        self.controller?.showLoader()
        EmailSigninHandler().signin(withEmail: email, password: password) { (success, error, info) in
            self.controller?.stopLoader()
            if success{
                
                Log.echo(key: "yud", text: "teck am host with role if \(SignedUserInfo.sharedInstance?.role)and the roleID is \(SignedUserInfo.sharedInstance?.roleId) and the signed Info is is \(String(describing: SignedUserInfo.sharedInstance?.id))")

                
                self.registerWithSegmentAnalytics(info : info)
                //isOnBoardShowed is set to true in order to see the onboarding graphics only after each sign up.
                if SignedUserInfo.sharedInstance?.role == .analyst{
                    UserDefaults.standard.set(true, forKey: "isHostWelcomeScreenNeedToShow")
                }else{
                    UserDefaults.standard.set(true, forKey: "isOnBoardShowed")
                }
                RootControllerManager().updateRoot()
                return
            }
        }
    }
    
    private func registerWithSegmentAnalytics(info : SignedUserInfo?){
        guard let info = info
            else{
                return
        }
        
        //shouldn't happen but can't let sky fall if it happens
        guard let userId = info.id
            else{
                return
        }
        
        //alias don't seem to have any option to share user's information so both alias and identify will be called consecutively
        SEGAnalytics.shared().alias(userId)
        SEGAnalytics.shared().identify(info.id, traits: ["name":info.firstName ?? "","email":info.email ?? ""])
        Bugsnag.configuration()?.setUser(info.id ?? "", withName:info.firstName ?? "",
                                         andEmail:info.email ?? "")
    }
    
    @IBAction fileprivate func fbLoginAction(){
        
        showWelcomeScreen(response: {
            
            self.resetErrorStatus()
            self.fbLogin()
        })
    }
    
    
    func showWelcomeScreen(response:@escaping (()->())){
        
        guard let controller = WelcomeController.instance() else {
            return
        }
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.dismiss = {
            response()
        }
        self.controller?.present(controller, animated: true, completion: {
        })
    }
    
    func initializeVariable(){
        
        firstName?.textField?.autocapitalizationType = .words
        emailField?.textField?.delegate = self
        passwordField?.textField?.delegate = self
        firstName?.textField?.delegate = self
        scrollView?.bottomContentOffset = scrollViewBottomConstraints
    }
    
    func paintInterface(){
        
        signUpBtn?.layer.cornerRadius = 3
        signUpBtn?.layer.masksToBounds = true
    }
}

extension SignupRootView:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView?.activeField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField == firstName?.textField{
            emailField?.textField?.becomeFirstResponder()
        }else if textField == emailField?.textField{
            passwordField?.textField?.returnKeyType = UIReturnKeyType.done
            passwordField?.textField?.becomeFirstResponder()            
        }else  if textField == passwordField?.textField{
            //textField.resignFirstResponder()
        }
        return true
    }
}

extension SignupRootView{
    
    func validateFields()->Bool{
        
        let confirmPasswordValidate = valiadteConfirmPassword()
        let emailValidated  = validateEmail()
        let passwordValidated = validatePassword()
        return emailValidated && passwordValidated && confirmPasswordValidate
    }
    
    func resetErrorStatus(){
        
        errorLabel?.text = ""
        emailField?.resetErrorStatus()
        passwordField?.resetErrorStatus()
        firstName?.resetErrorStatus()
    }
    
    func showError(text : String?){
        
        errorLabel?.text = text
    }
    
    fileprivate func validateEmail()->Bool{
        
        if(emailField?.textField?.text == ""){
            
            emailField?.showError(text: "Email is required")
            return false
        }
        else if !(FieldValidator.sharedInstance.validateEmailFormat(emailField?.textField?.text ?? "")){
            
            emailField?.showError(text: "Email looks incorrect !")
            return false
        }
        emailField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validatePassword()->Bool{
        
        if(passwordField?.textField?.text == ""){
            
            passwordField?.showError(text: "Password is required")
            return false
        }
        passwordField?.resetErrorStatus()
        return true
    }
    
    fileprivate func valiadteConfirmPassword()->Bool{
        
        if(firstName?.textField?.text == ""){
            
            firstName?.showError(text: "Firstname is required")
            return false
        }
            
        else if !(FieldValidator.sharedInstance.validatePlainString(firstName?.textField?.text ?? "")){
            
            firstName?.showError(text: "Firstname looks incorrect !")
            return false
        }
        firstName?.resetErrorStatus()
        return true
    }
}

extension SignupRootView{
    
    fileprivate func fbLogin(){
        
        let loginManager = LoginManager()
        loginManager.logOut() 
        loginManager.logIn(permissions: [Permission.publicProfile , Permission.email], viewController: controller) { [weak self] (loginResult) in
            
            switch loginResult {
            case .failed(let error):
                self?.showError(text: error.localizedDescription)
            case .cancelled:
                self?.showError(text: "Login Cancelled !")
            case .success( _,  _, let accessToken):
                self?.fetchFBUserInfo(accessToken: accessToken)
                break
            }
        }
    }
    
    fileprivate func fetchFBUserInfo(accessToken : AccessToken?){
        
        DispatchQueue.main.async(execute: {
            self.controller?.showLoader()
         
            FacebookLogin().signup(accessToken: accessToken, completion: { (success, message, info) in
                
                self.controller?.stopLoader()
                
                if(success){
                    
                    self.registerWithSegmentAnalytics(info : info)
                    
                    RootControllerManager().updateRoot()
                    return
                }
                self.showError(text: message)
            })
        })
    }
}



