//
//  EventPaymentController.swift
//  Chatalyze
//
//  Created by Mansa on 29/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit
import Stripe

class EventPaymentController: InterfaceExtendedController {

    @IBOutlet var rootView:EventPaymentRootView?
    var info:EventInfo?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        rootView?.controller = self
        rootView?.info = self.info
        fetchCardDetails()
    }
    
    func fetchCardDetails(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        self.showLoader()
        FetchSavedCardDetails().fetchInfo(id: id) { (success, response) in
            self.stopLoader()
            if success{
            }
        }
    }
    
    override func didReceiveMemoryWarning(){
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

