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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
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
