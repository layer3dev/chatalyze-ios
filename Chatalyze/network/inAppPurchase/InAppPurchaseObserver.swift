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
    
    private var detachedTransactionManager : DetachedTransactionHandler?
    
    override init() {
        super.init()
        
        let transactionId = DonateTransactionTokenSession.sharedInstance?.token ?? ""
        Log.echo(key: "in_app_purchase", text: "last transactionid ->  -- \(transactionId)")
    }
    
    static let sharedInstance = InAppPurchaseObserver()
    
    private var completionListener : ((_ success: Bool, _ message : String?, _ transaction:SKPaymentTransaction?) -> ())?
    
    func setListener(completionListener: @escaping (_ success: Bool, _ message : String?, _ transaction:SKPaymentTransaction?) -> ()) {
        self.completionListener = completionListener
    }
    
}


// MARK: - SKPaymentTransactionObserver
extension InAppPurchaseObserver : SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        Log.echo(key: "in_app_purchase", text: "paymentQueue -> triggerred")
        for transaction in transactions {
             Log.echo(key: "in_app_purchase", text: "paymentQueue -> looping triggerred -> \(transaction.transactionState)")
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
        
        
        
        DispatchQueue.main.async {[weak self] in
            Log.echo(key: "in_app_purchase", text: "transaction.transactionState -> complete -- \(String(describing: transaction.transactionIdentifier))")
            
            if(self?.completionListener == nil){
                Log.echo(key: "in_app_purchase", text: "complete but detached --)")
                self?.handleDetached(transaction: transaction)
                return
            }
            Log.echo(key: "in_app_purchase", text: "complete and attached --)")
            self?.completionListener?(true, "successful", transaction)
            self?.completionListener = nil
        }
        
        
        /*if(isProcessed){
            SKPaymentQueue.default().finishTransaction(transaction)
        }*/
        
//        validateReceipt(transaction : transaction)
    }
    
    
    private func handleDetached(transaction : SKPaymentTransaction){
        let detachedHandler = DetachedTransactionHandler()
        self.detachedTransactionManager = detachedHandler
        
        detachedHandler.processDetached(transaction: transaction) { (success) in
            if(success){
                SKPaymentQueue.default().finishTransaction(transaction)
            }else{
                //temp
                //todo
                //need to be handled with fallback logging
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        Log.echo(key: "in_app_purchase", text: "transaction.transactionState -> restore")
        SKPaymentQueue.default().finishTransaction(transaction)
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
        DispatchQueue.main.async {[weak self] in
            self?.completionListener?(success, message, transaction)
            self?.completionListener = nil
        }
        
        
    }
    
}
