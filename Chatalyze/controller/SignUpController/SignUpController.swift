//
//  SignUpController.swift
//  Chatalyze
//
//  Created by Mansa on 02/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SignUpController: InterfaceExtendedController {
  
    var googleSignInAction:(()->())?
    @IBOutlet var rootView:SignupRootView?
    @IBOutlet var termsLbl:UILabel?
    @IBOutlet var privacyLbl:UILabel?
    @IBOutlet var signInLabel:UILabel?
    var signInAction:(()->())?
    @IBOutlet var headerLabel:UILabel?
    
    @IBAction func signinAction(sender:UIButton){
        
       self.signInAction?()
        //self.navigationController?.popToRootViewController(animated: true)
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
    }
    
    func initialization(){
        
        rootView?.controller = self
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "SIGN UP")
        paintBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSigUpHeaderInfo()
        hideNavigationBar()
        SEGAnalytics.shared().track("SignUp Page")
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
        
        if let action = googleSignInAction{
            action()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
}

extension SignUpController{
    
    class func instance()->SignUpController?{
        
        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpController") as? SignUpController
        return controller
    }
}
