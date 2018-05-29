//
//  EventPaymentController.swift
//  Chatalyze
//
//  Created by Mansa on 29/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventPaymentController: InterfaceExtendedController {

    @IBOutlet var rootView:EventPaymentRootView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        rootView?.controller = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EventPaymentController{
    
    class func instance()->EventPaymentController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EventPayment") as? EventPaymentController
        return controller
    }
}

