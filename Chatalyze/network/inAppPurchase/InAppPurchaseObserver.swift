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
                Log.echo(key: "in_app_purchase", text: "transaction.transactionState -> purchasing")
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        Log.echo(key: "in_app_purchase", text: "transaction.transactionState -> complete")
        
        validateReceipt(transaction : transaction)
        
        
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
        
        completionListener?(success, message, transaction)
        completionListener = nil
    }
    
    
    
    private func validateReceipt(transaction: SKPaymentTransaction) {
        let mainBundle = Bundle.main
        guard let receiptUrl = mainBundle.appStoreReceiptURL
            else{
                return
        }
        guard let isPresent = try? receiptUrl.checkResourceIsReachable()
            else{
                return
        }
        
        if(!isPresent){
            return
        }
        
        
        
        guard let receipt = NSData(contentsOf: receiptUrl)
            else{
                return
        }
        
        let receiptData = receipt.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        configureValidationRequest(receiptData: receiptData) { (success) in
            if(!success){
                return
            }
            SKPaymentQueue.default().finishTransaction(transaction) // finish transaction only when response from server is received
            callCompletion(success: true, message: "successful", transaction: transaction)
        }
        
    }
    
    private func configureValidationRequest(receiptData: String, completion: (_ success : Bool) -> ()) {
        Log.echo(key : "in_app_purchase", text : "receiptData -> \(receiptData)")
        completion(true)
    }
}
