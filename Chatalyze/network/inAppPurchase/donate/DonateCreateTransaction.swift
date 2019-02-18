//
//  DonateCreateTransaction.swift
//  Chatalyze
//
//  Created by Sumant Handa on 18/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//


import UIKit
import StoreKit

class DonateCreateTransaction{

    init(){
    }
    
    
    func createTransaction(value : DonateProductInfo.value, transactionId : String, completionListener: @escaping (_ success: Bool) -> ()) {
        let productId = value.getProductId()
        completionListener(true)
    }
    
}

