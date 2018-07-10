//
//  CardInfo.swift
//  Chatalyze
//
//  Created by Mansa on 01/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON



class CardInfo: NSObject {
    
    var lastDigitAccount:String?
    var customerToken:String?
    var idToken:String?
    var expiryYear:String?
    var expiryMonth:String?
    var fingerPrint:String?
    var country:String?
    var number:String?
    
    override init(){
        super.init()
    }
    
    init(info : JSON?){
        super.init()
        fillInfo(info: info)
    }
    
//    {
//    "dynamic_last4" : null,
//    "metadata" : {
//
//    },
//    "name" : null,
//    "tokenization_method" : null,
//    "object" : "card",
//    "address_line1_check" : null,
//    "address_country" : null,
//    "funding" : "credit",
//    "last4" : "4242",
//    "exp_month" : 2,
//    "address_state" : null,
//    "customer" : "cus_CsSxXKyGNtvmpj",
//    "address_city" : null,
//    "brand" : "Visa",
//    "id" : "card_1CSi1lKTB4KYMcwO2049QyrY",
//    "exp_year" : 2022,
//    "address_line2" : null,
//    "address_zip_check" : null,
//    "address_zip" : null,
//    "cvc_check" : "pass",
//    "fingerprint" : "AL26TvSpf0yr7TvH",
//    "address_line1" : null,
//    "country" : "US"
//    }
    
    func fillInfo(info : JSON?) {
        
        guard let json = info
            else{
                return
        }
        
        self.lastDigitAccount = json["number"].stringValue
        self.customerToken = json["customer"].stringValue
        self.idToken = json["id"].stringValue
        self.expiryYear = json["exp_year"].stringValue
        self.expiryMonth = json["exp_month"].stringValue
        self.fingerPrint = json["fingerprint"].stringValue
        self.country = json["country"].stringValue
    }
}
