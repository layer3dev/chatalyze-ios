//
//  DetachedTransactionHandler.swift
//  Chatalyze
//
//  Created by Sumant Handa on 21/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import StoreKit

class DetachedTransactionHandler : DonateCompleteTransaction{
    
    func processDetached(transaction : SKPaymentTransaction?, completion : @escaping (_ success : Bool)->()){
        
        guard let transaction = transaction
            else{
                completion(false)
                return
        }
        
        guard let transactionId = DonateTransactionTokenSession.sharedInstance?.token
            else{
                completion(false)
                return
        }
        
        let planId = transaction.payment.productIdentifier
        
        process(transactionId: transactionId, planId: planId) { (success) in
            completion(success)
        }
        
        
    }
}
