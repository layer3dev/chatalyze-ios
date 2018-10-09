//
//  ForgotPasswordController.swift
//  Chatalyze
//
//  Created by Mansa on 02/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ForgotPasswordController: InterfaceExtendedController {

    @IBOutlet var rootView:ForgotRootView?
    var signUpHandler:(()->())?

    override func viewDidLayout(){
        super.viewDidLayout()
 
        paintInterface()
        initializeVariable()
    }
    
    fileprivate func initializeVariable(){
        
        rootView?.controller = self
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "FORGOT PASSWORD")
        paintBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ForgotPasswordController{
    
    class func instance()->ForgotPasswordController?{
        
        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ForgotPassword") as? ForgotPasswordController
        return controller
    }
}

