//
//  SigninController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 24/02/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import FacebookLogin
import AuthenticationServices

class SigninController: InterfaceExtendedController {
    
    var googleSignInAction:(()->())?
    var signUpHandler:(()->())?
    var didLoad:(()->())?
    
  @IBOutlet weak var appleSiginView: UIView?
  @IBOutlet weak var appleSiginHightContraint: NSLayoutConstraint!

  
  @IBOutlet var unavailableSignUpAlertLabel:UILabel?
    
    func paintUnavailableSignUpAlertLabel(){
        
        DispatchQueue.main.async {
           
            let firstStr = "This app is only available to registered Chatalyze users. "
            
            let secondStr = "Learn more"
            
            let firstMuatbleStr = firstStr.toMutableAttributedString(font: "Nunito-Regular",size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor.white , isUnderLine: false)
            
            let secondAttrStr = secondStr.toMutableAttributedString(font: "Nunito-Regular",size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor.white, isUnderLine: true)
            
            firstMuatbleStr.append(secondAttrStr)
            
            self.unavailableSignUpAlertLabel?.attributedText = firstMuatbleStr
        }
    }
    
    @IBAction fileprivate func signinAction(){
       
        signin()
    }
    
    fileprivate func signin(){
        
        let isValidated = rootView?.validateFields() ?? false
        if(!isValidated){
            return
        }
    }
    
    @IBAction func signupAction(sender:UIButton){
        
        guard let controller = SignUpController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func googleSignIn(){
        
        if let action = googleSignInAction{
            action()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
        didLoad?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }

    
    fileprivate func initialization(){
        
        initializeVariable()
        paintInterface()
      self.appleSiginView?.clipsToBounds = true
      self.appleSiginView?.layer.cornerRadius = (appleSiginView?.frame.height)! / 2
    }
    
    fileprivate func initializeVariable(){
        
        rootView?.controller = self
      if #available(iOS 13.0, *) {
        GetApppleSignInButton.sharedGetApppleSignInButton?.getButtonWith(target: self, selector: #selector(appleLoginAction), superView: self.appleSiginView ?? UIView(), isActiveConstraintsNeeded: true)
      } else {
        // Fallback on earlier versions
        appleSiginHightContraint.constant = 0
      }
    }
    
    fileprivate func paintInterface(){
        
        paintNavigationTitle(text: "SIGN IN")
        paintUnavailableSignUpAlertLabel()
        //paintBackButton()
    }
    
    var rootView : SigninRootView?{
        return self.view as? SigninRootView
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
    
    @IBAction func learnMoreAction(sender:UIButton){
        
        guard let controller = SignInLearnMoreController.instance() else {
            return
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension SigninController{
    
    class func instance()->SigninController?{
        
        let storyboard = UIStoryboard(name: "signin", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "signin") as? SigninController
        return controller
    }
}

extension SigninController : ASAuthorizationControllerDelegate{
  
  @available(iOS 13.0, *)
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
    switch authorization.credential {
    case  let credential as ASAuthorizationAppleIDCredential:
    let user = AppleUserDetails(credentails: credential)
//    performSegue(withIdentifier: "segue", sender: user)
      break
    default:break
    }
  }
  
  @available(iOS 13.0, *)
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    Log.echo(key: "dhi", text: "we got error while Sigin in with Apple:\(error.localizedDescription)")
  }
  
}

extension SigninController : ASAuthorizationControllerPresentationContextProviding{
  @available(iOS 13.0, *)
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    
    return view.window!
  }
  
  
}
