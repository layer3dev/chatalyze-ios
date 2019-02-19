//
//  InAppPurchaseProduct.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchaseProduct : NSObject{
    
    private var completionListener : ((_ success: Bool, _ message : String?, _ transaction:SKPaymentTransaction?) -> ())?
    
    
    func buy(product : SKProduct , completionListener: @escaping (_ success: Bool, _ message : String?, _ transaction:SKPaymentTransaction?) -> ()) {
        self.completionListener = completionListener
        
        InAppPurchaseObserver.sharedInstance.setListener { (success, message, transaction) in
            completionListener(success, message, transaction)
        }
        
        print("Buying \(product.productIdentifier)...")
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
}


