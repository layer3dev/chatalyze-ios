//
//  File.swift
//  Chatalyze
//
//  Created by Sumant Handa on 19/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

//deprecated
class TransactionProcess{
    
    enum state {
        case ideal
        case registrationInProcess
        case registered
        case completed
        case failed
    }
    
    var transactionState : state = .ideal
    
    private var createTransactionHandler = DonateCreateTransaction()
    
    
    typealias registerListener =  ((_ success : Bool)->())
    
    var listener : registerListener?
   
    
    private func setListener(listener : @escaping registerListener){
        self.listener = listener
    }
   
    
    func createTransactionId(value : DonateProductInfo.value, transactionId : String){
        transactionState = .registrationInProcess
        /*createTransactionHandler.createTransaction(value: value, transactionId: transactionId) {[weak self] (success) in
            if(!success){
                self?.transactionState = .ideal
                return
            }
            self?.transactionState = .registered
            self?.listener?(true)
        }*/
    }
    
    
    func confirmRegistration(value : DonateProductInfo.value, transactionId : String, listener :  @escaping registerListener){
        if(transactionState == .registered){
            listener(true)
            return
        }
        
        if(transactionState == .registrationInProcess){
            self.setListener(listener: listener)
            return
        }
        
        if(transactionState != .ideal){
            listener(false)
            return
        }
        
        self.setListener(listener: listener)
        self.createTransactionId(value: value, transactionId: transactionId)
    }
    
}
