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
    private var listener : ((_ success: Bool) -> ())?
    
    init(controller : InterfaceExtendedController){
        self.controller = controller
    }
    
    
    private var productPurchase: InAppPurchaseProduct?
    private let infoManager : DonateProductValueFetch = DonateProductValueFetch()
    
    var value : DonateProductInfo.value?
    var transactionId : String?
    
    
    func buy(value : DonateProductInfo.value, transactionId : String, completionListener: @escaping (_ success: Bool) -> ()) {
        self.value = value
        self.transactionId = transactionId
        self.listener = completionListener
        
        Log.echo(key: "in_app_purchase", text: "init buy")
        
        let isPaymentAllowed = SKPaymentQueue.canMakePayments()
        if(!isPaymentAllowed){
            Log.echo(key: "in_app_purchase", text: "In App Purchase is disabled on this device.")
            callCompletion(false)
            return
        }
        
        
        infoManager.requestInfo(value: value) {[weak self] (info) in
            
            Log.echo(key: "in_app_purchase", text: "Info fetched.")
            guard let info = info
                else{
                    self?.callCompletion(false)
                    return
            }
            
        
            self?.buyProduct(info : info)
            return
           
        }
    }
    
    private func buyProduct(info: DonateProductInfo){
        
        let productPurchase = InAppPurchaseProduct()
        
        self.productPurchase = productPurchase
        productPurchase.buy(product: info.productInfo, completionListener: {[weak self] (success, message, transaction) in
            if(!success){
                self?.callCompletion(false)
                return
            }
            self?.completeTransaction()
            
        })
    }
    
    private func callCompletion(_ success: Bool){
        listener?(success)
        listener = nil
    }
    
    
    
    private func completeTransaction(){
        
        guard let transactionId = transactionId, let value = value
            else{
                callCompletion(false)
                return
        }
        
        DonateCompleteTransaction().process(transactionId: transactionId, planId: value.getProductId(), completion: {[weak self] (success) in
                self?.callCompletion(success)
            
            
        })
        
    }
    
}

