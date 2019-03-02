//
//  SigninController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 24/02/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import FacebookLogin

class SigninController: InterfaceExtendedController {
    
    var googleSignInAction:(()->())?
    var signUpHandler:(()->())?
    var didLoad:(()->())?
    
    @IBOutlet var unavailableSignUpAlertLabel:UILabel?
    
    func paintUnavailableSignUpAlertLabel(){
        
        DispatchQueue.main.async {
           
            let firstStr = "This app is only available to registered Chatalyze users. "
            
            let secondStr = "Learn more"
            
            let firstMuatbleStr = firstStr.toMutableAttributedString(font: "Questrial",size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor.white , isUnderLine: false)
            
            let secondAttrStr = secondStr.toMutableAttributedString(font: "Questrial",size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor.white, isUnderLine: true)
            
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
    }
    
    fileprivate func initializeVariable(){
        
        rootView?.controller = self
    }
    
    fileprivate func paintInterface(){
        
        paintNavigationTitle(text: "SIGN IN")
        paintUnavailableSignUpAlertLabel()
        //paintBackButton()
    }
    
    var rootView : SigninRootView?{
        return self.view as? SigninRootView
    }
}

extension SigninController{
    
    class func instance()->SigninController?{
        
        let storyboard = UIStoryboard(name: "signin", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "signin") as? SigninController
        return controller
    }
}
