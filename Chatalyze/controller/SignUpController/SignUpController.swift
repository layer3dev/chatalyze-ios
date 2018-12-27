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
    
    @IBAction func signinAction(sender:UIButton){
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func maketextLinkable(){
        
        let attributeForFirstString = [NSAttributedString.Key.font:UIFont(name: "Questrial", size:18),NSAttributedString.Key.foregroundColor: UIColor(hexString: "#728690")] as [NSAttributedString.Key : Any]
        
        let attributeForSecondString = [NSAttributedString.Key.font:UIFont(name: "Poppins", size:18),NSAttributedString.Key.foregroundColor: UIColor(hexString: "#728690")] as [NSAttributedString.Key : Any]
        
        let text = NSMutableAttributedString(string: "By signing up, you agree to our ")
        
        text.addAttributes(attributeForFirstString, range: NSMakeRange(0,text.length))
        
        let text1 = NSMutableAttributedString(string: "Terms of Service ")
        text1.addAttributes(attributeForSecondString, range: NSMakeRange(0, text1.length))
        
        
        let text2 = NSMutableAttributedString(string: "and")
        text2.addAttributes(attributeForFirstString, range: NSMakeRange(0, text2.length))
        
        
        let text3 = NSMutableAttributedString(string: "Privacy Policy.")
        text3.addAttributes(attributeForSecondString, range: NSMakeRange(0, text3.length))
        
        text.append(text1)
        text.append(text2)
        text.append(text3)
        
        termsLbl?.attributedText = text
        termsLbl?.isUserInteractionEnabled = true
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
        controller.url = AppConnectionConfig.systemTestUrl + "/terms-app"

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
        controller.url = AppConnectionConfig.systemTestUrl + "/privacy-app"
        //controller.url = "https://dev.chatalyze.com/privacy-app"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
     
        paintInterface()
        initialization()
        tapActionTermsLbl()
        tapActionPrivacyLbl()
        
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
        
        hideNavigationBar()
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
