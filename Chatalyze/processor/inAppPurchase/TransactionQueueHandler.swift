//
//  TransactionQueueHandler.swift
//  Chatalyze
//
//  Created by Sumant Handa on 18/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

//deprecated
class TransactionQueueHandler{
    
    static let sharedInstance = TransactionQueueHandler()
    
    var infos = [String : TransactionProcess]()
    
    

    func getWriteProcess(transactionId : String)->TransactionProcess{
        guard let info = infos[transactionId]
            else{
                let newTransaction = TransactionProcess()
                infos[transactionId] = newTransaction
                return newTransaction
        }
        
        return info
    }
    

}
    
    

    

