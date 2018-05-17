//
//  PaymentListingController.swift
//  Chatalyze
//
//  Created by Mansa on 17/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class PaymentListingController: InterfaceExtendedController {

    @IBOutlet var rootView:PaymentListRootView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
       
        paintInterface()
        initializeVariable()
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "PAYMENT HISTORY")
        paintBackButton()
    }
    
    func initializeVariable(){
        
    }
    
    func getPaymentInfo(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
                
        PaymentHistoryProcessor().fetchInfo(id: id, offset: 0) { (success, info) in
            
        }
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
