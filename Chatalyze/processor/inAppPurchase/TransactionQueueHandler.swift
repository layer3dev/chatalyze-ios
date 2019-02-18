//
//  TransactionQueueHandler.swift
//  Chatalyze
//
//  Created by Sumant Handa on 18/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class TransactionQueueHandler{
    
    enum state {
        case started
        case registered
        case processed
        case failed
    }
    
    
    static let sharedInstance = TransactionQueueHandler()
    var infos = [String : InAppPurchaseTransactionState]()
    
    private var createTransactionHandler = DonateCreateTransaction()
    
    
    func isRegistered(transactionId : String)->Bool{
        guard let _ = infos[transactionId]
            else{
                return false
        }
        return true
    }
    
    func createTransactionId(value : DonateProductInfo.value, transactionId : String){
        let transactionInfo = InAppPurchaseTransactionState()

        infos[transactionId] = transactionInfo
        
        createTransactionHandler.createTransaction(value: value, transactionId: transactionId) {[weak self] (success) in
            if(!success){
                self?.infos[transactionId] = nil
                return
            }
            transactionInfo.state = .registered
            transactionInfo.listener?(true)
        }
        
    }
    
    
    private func confirmIfRegistered(transactionId : String, listener :  @escaping InAppPurchaseTransactionState.registerListener){
        guard let transactionInfo = infos[transactionId]
            else{
                listener(false)
                return
        }
        transactionInfo.setListener { (success) in
            listener(success)
        }
    }
    
    func confirmRegistration(value : DonateProductInfo.value, transactionId : String, listener :  @escaping InAppPurchaseTransactionState.registerListener){
        if(isRegistered(transactionId: transactionId)){
            listener(true)
            return
        }
        registerAndListen(value: value, transactionId: transactionId, listener: listener)
    }
    
        private func registerAndListen(value : DonateProductInfo.value, transactionId : String, listener :  @escaping InAppPurchaseTransactionState.registerListener){
            self.createTransactionId(value : value, transactionId: transactionId)
            self.confirmIfRegistered(transactionId: transactionId, listener: { (success) in
                listener(success)
            })
        }
        
    }
    
    

    

