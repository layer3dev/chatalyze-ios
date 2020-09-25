//
//  SignUpController.swift
//  Chatalyze
//
//  Created by Mansa on 02/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import AuthenticationServices
import Analytics
import GoogleSignIn

class SignUpController: InterfaceExtendedController {
  
    var googleSignInAction:(()->())?
    @IBOutlet var rootView:SignupRootView?
    @IBOutlet var termsLbl:UILabel?
    @IBOutlet var privacyLbl:UILabel?
    @IBOutlet var signInLabel:UILabel?
    var signInAction:(()->())?
    @IBOutlet var headerLabel:UILabel?
   @IBOutlet weak var appleSigninView: UIView?
   @IBOutlet weak var appleSiginHightConstraint: NSLayoutConstraint?
    @IBOutlet weak var googleSignupView : UIView?
  
    @IBAction func signinAction(sender:UIButton){
        self.signInAction?()
    }
    
    func maketextLinkable(){
        
        DispatchQueue.main.async {
            
            let text = "By signing up, you agree to our "
            
            let textOneMutable = text.toMutableAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor.white, isUnderLine: false)
            
            let text1 = "Terms of Service "
            
            let textTwoMutable = text1.toMutableAttributedString(font: "Nunito-ExtraBold", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor.white, isUnderLine: false)
            
            let text2 = "and"
            
            let textThreeMutable = text2.toMutableAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor.white, isUnderLine: false)
            
            let text3 = "Privacy Policy."
            
            let textFourMutable = text3.toMutableAttributedString(font: "Nunito-ExtraBold", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:14, color: UIColor.white, isUnderLine: false)
            
            textOneMutable.append(textTwoMutable)
            textOneMutable.append(textThreeMutable)
            //textOneMutable.append(textFourMutable)
            
            self.termsLbl?.attributedText = textOneMutable
            self.termsLbl?.isUserInteractionEnabled = true
            
            let privacyTextOne = "Have an account? "
            let privacyTextTwo = "Sign in"
            
            let privacyMutableText = privacyTextOne.toMutableAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor.white, isUnderLine: false)
            
            let privacyAttrText = privacyTextTwo.toAttributedString(font: "Nunito-ExtraBold", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:14, color: UIColor.white, isUnderLine: false)
            
            privacyMutableText.append(privacyAttrText)
            self.privacyLbl?.attributedText = textFourMutable
            self.signInLabel?.attributedText = privacyMutableText
        }
    }
    
    func tapActionTermsLbl(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(recognizer:)))
        tap.delegate = self
        termsLbl?.isUserInteractionEnabled = true
        termsLbl?.addGestureRecognizer(tap)
    }
    
    @objc func tapAction(recognizer:UITapGestureRecognizer){
        
        guard let controller = TermsConditionController.instance() else {
            return
        }
        //controller.url = "https://dev.chatalyze.com/terms-app"
        controller.url = AppConnectionConfig.basicUrl + "/terms-app"

        controller.headerText = "TERMS OF SERVICE"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func tapActionPrivacyLbl(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapActionPrivacyLbl(recognizer:)))
        tap.delegate = self
        privacyLbl?.isUserInteractionEnabled = true
        privacyLbl?.addGestureRecognizer(tap)
    }
    
    @objc func tapActionPrivacyLbl(recognizer:UITapGestureRecognizer){
        
        guard let controller = TermsConditionController.instance() else {
            return
        }
        controller.url = AppConnectionConfig.basicUrl + "/privacy-app"
        controller.headerText = "PRIVACY POLICY"
        //controller.url = "https://dev.chatalyze.com/privacy-app"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        initialization()
        tapActionTermsLbl()
        tapActionPrivacyLbl()
        maketextLinkable()
        SEGAnalytics.shared().track("SignUp Page")
      
    }
    
    func initialization(){
        
        rootView?.controller = self
      self.appleSigninView?.clipsToBounds = true
      if UIDevice.current.userInterfaceIdiom == .phone{
        self.appleSigninView?.layer.cornerRadius = 20

           }else{
             self.appleSigninView?.layer.cornerRadius = 65/2
           }
      if #available(iOS 13.0, *) {
        GetApppleSignInButton.sharedGetApppleSignInButton?.getButtonWith(target: self, selector: #selector(appleLoginAction), superView: self.appleSigninView ?? UIView(), isActiveConstraintsNeeded: true)
      } else {
        // Fallback on earlier versions
        appleSigninView?.translatesAutoresizingMaskIntoConstraints = false
        appleSigninView?.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
      }
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        googleSignupView?.clipsToBounds = true
       
        if UIDevice.current.userInterfaceIdiom == .phone{
            self.googleSignupView?.layer.cornerRadius = 45/2
        }else{
            self.googleSignupView?.layer.cornerRadius = 65/2
        }
        
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "SIGN UP")
        paintBackButton()
    }
  
  @objc func appleLoginAction(){
     Log.echo(key: "dhi", text:"apple btn tapped")
     if #available(iOS 13.0, *) {
       let provider = ASAuthorizationAppleIDProvider()
       let request = provider.createRequest()
       request.requestedScopes = [.fullName,.email]
       let controller = ASAuthorizationController(authorizationRequests: [request])
       controller.delegate = self
       controller.presentationContextProvider = self
      
       controller.performRequests()
     } else {
       // Fallback on earlier versions
     }
     

   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSigUpHeaderInfo()
        hideNavigationBar()
    }
    
    func resetInfo() {
        
        self.rootView?.resetInfo()
    }
    
    func updateSigUpHeaderInfo(){
        
        if LoginSignUpContainerController.roleId == 3 {
            self.headerLabel?.text = "Fan sign up"
        }
        
        if LoginSignUpContainerController.roleId == 2{
            self.headerLabel?.text = "Creator sign up"
        }
    }
    
    
    @IBAction func googleSignIn(){
        
        GIDSignIn.sharedInstance()?.signIn()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
}

extension SignUpController {
    
    class func instance()->SignUpController?{
        
        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpController") as? SignUpController
        return controller
    }
}

extension SignUpController : GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        rootView?.resetErrorStatus()
        SignUpController().showLoader()
        if error != nil{
            rootView?.showError(text: error.localizedDescription)
            SignUpController().stopLoader()
            return
        }
        
        let idToken = user.authentication.accessToken
        
        GoogleSignIn().signin(accessToken: idToken) { (success, message, info) in
            SignUpController().stopLoader()
            
            if(success){
                
                SigninRootView().registerWithSegmentAnalytics(info : info)
                RootControllerManager().updateRoot()
                 return
            }else{
                self.rootView?.showError(text: message)
               
            }
        }
    }
}

extension SignUpController: ASAuthorizationControllerDelegate{
  
  @available(iOS 13.0, *)
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
    switch authorization.credential {
    case  let credential as ASAuthorizationAppleIDCredential:
      let authorizationCode = String(data: credential.authorizationCode ?? Data(), encoding: .utf8)
    
      
      SigninController().showLoader()
      let fullName = "\(credential.fullName?.givenName ?? "") \(credential.fullName?.familyName ?? "")"
      AppleLogin().signup(clientId: Bundle.main.bundleIdentifier, authCode: authorizationCode, name: fullName) { (success, message, info) in
        SigninController().stopLoader()
      if(success){
        
       SigninRootView().registerWithSegmentAnalytics(info : info)
        
        RootControllerManager().updateRoot()
        return
      }
    }
      break
    default:break
    }
  }
  
  @available(iOS 13.0, *)
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    Log.echo(key: "dhi", text: "we got error while Sigin in with Apple:\(error.localizedDescription)")
  }
  
}

extension SignUpController : ASAuthorizationControllerPresentationContextProviding{
  @available(iOS 13.0, *)
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    
    return view.window!
  }
  
  
}
