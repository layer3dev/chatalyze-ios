//
//  InAppPurchaseObserver.swift
//  Chatalyze
//
//  Created by Sumant Handa on 18/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchaseObserver : NSObject{
    
    static let sharedInstance = InAppPurchaseObserver()
    
    private var completionListener : ((_ success: Bool, _ message : String?, _ transaction:SKPaymentTransaction?) -> ())?
    
    func setListener(completionListener: @escaping (_ success: Bool, _ message : String?, _ transaction:SKPaymentTransaction?) -> ()) {
        self.completionListener = completionListener
    }
    
}


// MARK: - SKPaymentTransactionObserver
extension InAppPurchaseObserver : SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                Log.echo(key: "in_app_purchase", text: "transaction.transactionState -> deferred")
                break
            case .purchasing:
                Log.echo(key: "in_app_purchase", text: "transaction.transactionState -> purchasing --> \(String(describing: transaction.transactionIdentifier))")
                break
            }
        }
    }
    
    
    private func complete(transaction: SKPaymentTransaction) {
        Log.echo(key: "in_app_purchase", text: "transaction.transactionState -> complete -- \(String(describing: transaction.transactionIdentifier))")
        
        
        completionListener?(true, "successful", transaction)
        SKPaymentQueue.default().finishTransaction(transaction)
        /*if(isProcessed){
            SKPaymentQueue.default().finishTransaction(transaction)
        }*/
        completionListener = nil
//        validateReceipt(transaction : transaction)
    }
    
    
    private func restore(transaction: SKPaymentTransaction) {
        Log.echo(key: "in_app_purchase", text: "transaction.transactionState -> restore")
        
        callCompletion(success: true, message: "successful", transaction: transaction)
    }
    
    
    private func fail(transaction: SKPaymentTransaction) {
        Log.echo(key: "in_app_purchase", text: "transaction.transactionState -> fail")
        
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
            Log.echo(key: "in_app_purchase", text: "error Code -> \(transactionError.code)")
        }
        
        let error = transaction.error?.localizedDescription ?? "Error Occurred."
        
        SKPaymentQueue.default().finishTransaction(transaction)
        callCompletion(success: false, message: error, transaction: transaction)
    }
    
    
    private func callCompletion(success : Bool, message : String, transaction : SKPaymentTransaction?){
        
        completionListener?(success, message, transaction)
        completionListener = nil
    }
    
    
    
    
}
