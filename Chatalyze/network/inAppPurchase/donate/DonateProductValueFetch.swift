//
//  DonateProductValueFetch.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//


import UIKit
import StoreKit


class DonateProductValueFetch{
    
    private var productRequest: DonateProductFetch = DonateProductFetch()
    
    func requestInfo(value : DonateProductInfo.value, completionListener: @escaping (_ info: DonateProductInfo?) -> ()) {
        
        productRequest.requestProducts { (success, infos) in
            guard let infos = infos
                else{
                   completionListener(nil)
                    return
            }
            
            for info in infos{
                guard let productValue = info.productValue
                    else{
                        continue
                }
                
                if(value == productValue){
                    completionListener(info)
                    return
                }
            }
             completionListener(nil)
        }
        
    }
    
}
