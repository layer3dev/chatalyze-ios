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
import FBSDKCoreKit
import FBSDKLoginKit


class SigninRootView: ExtendedView {
    
    var controller : SigninController?
    
    @IBOutlet fileprivate var emailField : SigninFieldView?
    @IBOutlet fileprivate var passwordField : SigninFieldView?
    @IBOutlet fileprivate var errorLabel : UILabel?
    
    @IBOutlet fileprivate var scrollView : FieldManagingScrollView?
    @IBOutlet fileprivate var scrollContentBottomOffset : NSLayoutConstraint?
    
    @IBOutlet fileprivate var signUpView:Signupview?
    
    @IBOutlet fileprivate var signInView:UIView?
    @IBOutlet fileprivate var facebookView:UIView?
    
    
    @IBAction fileprivate func fbLoginAction(){
        
        //showWelcomeScreen(response: {
           
            self.resetErrorStatus()
            self.fbLogin()
        //})
    }
    
    func paintCurveSignInView(){
        
        signInView?.layer.cornerRadius = (UIDevice.current.userInterfaceIdiom == .phone ? 22.5:32.5)
        signInView?.layer.masksToBounds = true
        
        facebookView?.layer.cornerRadius = (UIDevice.current.userInterfaceIdiom == .phone ? 22.5:32.5)
        facebookView?.layer.masksToBounds = true
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
    
    @IBAction fileprivate func loginAction(){
        
        if(validateFields()){
            self.resetErrorStatus()
            signIn()
        }
    }
    
    @IBAction fileprivate func forgotPasswordAction(sender:UIButton){
        
        guard let controller = ForgotPasswordController.instance() else {
            return
        }
        controller.signUpHandler = self.controller?.signUpHandler
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
        
    }
    
    fileprivate func initialization(){
        
        initializeVariable()
    }
    
    fileprivate func initializeVariable(){
        
        emailField?.textField?.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordField?.textField?.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailField?.textField?.delegate = self
        passwordField?.textField?.delegate = self
        scrollView?.bottomContentOffset = scrollContentBottomOffset
        paintCurveSignInView()
    }
}

extension SigninRootView{
    
    func validateFields()->Bool{
        
        let emailValidated  = validateEmail()
        let passwordValidated = validatePassword()
        return emailValidated && passwordValidated
    }
    
    fileprivate func validateEmail()->Bool{
        
        if(emailField?.textField?.text == ""){
            
            emailField?.showError(text: "Email is required")
            return false
        }
        
        if !(FieldValidator.sharedInstance.validateEmailFormat(emailField?.textField?.text ?? "")){
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

        loginManager.logOut()

        loginManager.logIn(permissions: [Permission.publicProfile,Permission.email], viewController: controller) { [weak self] (loginResult) in
            
            Log.echo(key: "yud", text: "loginResult in the facebook is \(loginResult)")
            
            switch loginResult {
            case .failed(let error):
                
                self?.showError(text: error.localizedDescription)
                Log.echo(key: "yud", text: "Error in the facebook is \(error.localizedDescription)")
            case .cancelled:
                self?.showError(text: "Login Cancelled !")
            case .success( _,  _, let accessToken):
                self?.fetchFBUserInfo(accessToken: accessToken)
                Log.echo(key: "yud", text: "Succes facebook token is \(accessToken)")
                break
            }
        }
    }
    
    
    fileprivate func fetchFBUserInfo(accessToken :AccessToken?){
        
        DispatchQueue.main.async(execute: {
            self.controller?.showLoader()
            FacebookLogin().signin(accessToken: accessToken, completion: { (success, message, info) in
                self.controller?.stopLoader()
                if(success){
                    RootControllerManager().updateRoot()
                    return
                }
                self.showError(text: message)
            })
        })
    }
}

extension SigninRootView{
    
    fileprivate func signIn(){
        
        let email = emailField?.textField?.text ?? ""
        let password = passwordField?.textField?.text ?? ""
        self.controller?.showLoader()
        
        signInRequest(email: email, password: password) { [weak self] (success, message)  in
            
            self?.controller?.stopLoader()
            if(success){
                RootControllerManager().updateRoot()
                return
            }
            self?.showError(text: message)
            return
        }
    }
    
    func signInRequest(email : String, password : String, completion : ((_ success : Bool, _ message : String)->())?){
        
        EmailSigninHandler().signin(withEmail: email, password: password) { (success, error, info) in
            completion?(success, error)
        }
    }
    
    
    func showError(text : String?){
        
        errorLabel?.text = text
    }
    
    func resetErrorStatus(){
        
        errorLabel?.text = ""
        emailField?.resetErrorStatus()
        passwordField?.resetErrorStatus()
    }
}

