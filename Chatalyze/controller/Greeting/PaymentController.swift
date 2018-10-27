//
//  PaymentController.swift
//  Chatalyze
//
//  Created by Mansa on 10/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class PaymentController: InterfaceExtendedController {

    @IBOutlet var rootView:PaymentRootView?
    var param = [String:Any]()
    
    override func viewDidLayout() {
        super.viewDidLayout()
     
        initializeVariable()
        paintInterface()
    }
    
    func paintInterface(){
        
        self.paintNavigationTitle(text: "Payment")
        self.paintBackButton()
    }
    
    func initializeVariable(){
        
        self.rootView?.param = self.param
        self.rootView?.controller = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension PaymentController{
    
    class func instance()->PaymentController?{
        
        let storyboard = UIStoryboard(name: "Greeting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Payment") as? PaymentController
        return controller
    }
}
