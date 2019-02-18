//
//  InAppPurchaseTransactionState.swift
//  Chatalyze
//
//  Created by Sumant Handa on 18/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class InAppPurchaseTransactionState{
    
    enum transactionState {
        case started
        case registered
        case processed
        case failed
    }
    
    typealias registerListener =  ((_ success : Bool)->())
    
    var state : transactionState
    var listener : registerListener?
    
    init(){
        state = .started
    }
    
    func setListener(listener : @escaping registerListener){
        self.listener = listener
    }
    
}
