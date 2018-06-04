//
//  PaymentSuccessController.swift
//  Chatalyze
//
//  Created by Mansa on 25/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class PaymentSuccessController: InterfaceExtendedController {

    
    @IBOutlet var rootView:PaymentSuccessRootView?
    var presentingControllerObj:EventController?
    var info:PaymentSuccessInfo?
    @IBOutlet var heightOfMobileField:NSLayoutConstraint?
    @IBOutlet var heightOfMobileAlertField:NSLayoutConstraint?
    
    override func viewDidLayout() {
        super.viewDidLayout()
       
        painInterface()
        initializationVariable()
    }
    
    func painInterface(){
        
        paintNavigationTitle(text: "PAYMENT SUCCESS")
        paintBackButton()
        //paintMobileField()
    }
    
   
    
    func initializationVariable(){
        
        rootView?.controller = self
        rootView?.info = self.info
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PaymentSuccessController{
    
    class func instance()->PaymentSuccessController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PaymentSuccess") as? PaymentSuccessController
        return controller
    }
}
