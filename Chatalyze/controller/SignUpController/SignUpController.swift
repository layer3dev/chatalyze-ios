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
    @IBAction func signinAction(sender:UIButton){
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
       
        paintInterface()
        initialization()
    }
    
    func initialization(){
        
        rootView?.controller = self
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "SIGN UP")
        paintBackButton()
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
