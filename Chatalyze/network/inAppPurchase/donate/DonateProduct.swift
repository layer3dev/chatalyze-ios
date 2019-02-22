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
    private var listener : ((_ success: Bool, _ transaction : SKPaymentTransaction?) -> ())?
    
    init(controller : InterfaceExtendedController){
        self.controller = controller
    }
    
    
    private var productPurchase: InAppPurchaseProduct?
    private let infoManager : DonateProductValueFetch = DonateProductValueFetch()
    
    var value : DonateProductInfo.value?
    var transactionId : String?
    
    
    func buy(value : DonateProductInfo.value, transactionId : String, completionListener: @escaping (_ success: Bool, _ transaction : SKPaymentTransaction?) -> ()) {
        self.value = value
        self.transactionId = transactionId
        self.listener = completionListener
        
        Log.echo(key: "in_app_purchase", text: "init buy")
        
        let isPaymentAllowed = SKPaymentQueue.canMakePayments()
        if(!isPaymentAllowed){
            Log.echo(key: "in_app_purchase", text: "In App Purchase is disabled on this device.")
            callCompletion(false, nil)
            return
        }
        
        infoManager.requestInfo(value: value) {[weak self] (info) in
            Log.echo(key: "in_app_purchase", text: "Info fetched.")
            guard let info = info
                else{
                    self?.callCompletion(false, nil)
                    return
            }
            
            //store transactionId in session.
            _ = DonateTransactionTokenSession.initSharedInstance(token: transactionId)
            
            self?.buyProduct(info : info)
            return
        }
    }
    
    private func buyProduct(info: DonateProductInfo){
        let productPurchase = InAppPurchaseProduct()
        self.productPurchase = productPurchase

        productPurchase.buy(product: info.productInfo, completionListener: {[weak self] (success, message, transaction) in
            if(!success){
                self?.callCompletion(false, transaction)
                return
            }
            self?.completeTransaction(transaction: transaction)
        })
    }
    
    private func callCompletion(_ success: Bool, _ transaction : SKPaymentTransaction?){
        listener?(success, transaction)
        listener = nil
    }
    
    
    
    private func completeTransaction(transaction : SKPaymentTransaction?){
        
        guard let transactionId = transactionId, let value = value
            else{
                callCompletion(false, transaction)
                return
        }
        
        DonateCompleteTransaction().process(transactionId: transactionId, planId: value.getProductId(), completion: {[weak self] (success) in
                self?.callCompletion(success, transaction)
        })
        
    }
    
}

