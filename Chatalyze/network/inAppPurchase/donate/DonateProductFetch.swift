

//
//  DonateProductFetch.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import StoreKit


class DonateProductFetch{
    
    private var productsRequest: InAppPurchaseProductFetch = InAppPurchaseProductFetch()
    
    func requestProducts(completionListener: @escaping (_ success: Bool, _ products: [DonateProductInfo]?) -> ()) {
       
        productsRequest.requestProducts(identifiers: DonateProductInfo.identifiers) { (success, products) in
            if(!success){
                completionListener(false, nil)
                return
            }
            
            guard let products = products
                else{
                    completionListener(false, nil)
                    return
            }
            
            var infos = [DonateProductInfo]()
            
            for product in products{
                let info = DonateProductInfo(info : product)
                infos.append(info)
            }
            completionListener(true, infos)
            
        }
        
    }
    
}
