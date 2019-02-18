//
//  DonateProduct.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import StoreKit

class DonateProduct{
    
    private var controller : InterfaceExtendedController
    
    init(controller : InterfaceExtendedController){
        self.controller = controller
    }
    
    
    private var productPurchase: InAppPurchaseProduct?
    private let infoManager : DonateProductValueFetch = DonateProductValueFetch()
    
    
    
    func buy(value : DonateProductInfo.value, completionListener: @escaping (_ success: Bool, _ message : String?, _ transaction:SKPaymentTransaction?) -> ()) {
        
        Log.echo(key: "in_app_purchase", text: "init buy")
        
        let isPaymentAllowed = SKPaymentQueue.canMakePayments()
        if(!isPaymentAllowed){
            Log.echo(key: "in_app_purchase", text: "In App Purchase is disabled on this device.")
            completionListener(false, "In App Purchase is disabled on this device.", nil)
            return
        }
        
        controller.showLoader()
        infoManager.requestInfo(value: value) {[weak self] (info) in
            self?.controller.stopLoader()
            
            Log.echo(key: "in_app_purchase", text: "Info fetched.")
            guard let info = info
                else{
                    completionListener(false, "Invalid Payment.", nil)
                    return
            }
            
            let productPurchase = InAppPurchaseProduct()
            self?.productPurchase = productPurchase
            
            productPurchase.buy(product: info.productInfo, completionListener: completionListener)
        }
    }
    

    
}

