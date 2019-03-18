//
//  PlanInfo.swift
//  Chatalyze
//
//  Created by mansa infotech on 18/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class PlanInfo: NSObject {
    
    var id:String?
    var name:String?
    var isTrial:Bool?
    var minPrice:Double?
    
    override init(){
        super.init()
    }
    
    
//    {
//    "rule" : {
//
//    },
//    "freeSeconds" : null,
//    "name" : "Chatalyze Pro Plan",
//    "interval" : "month",
//    "id" : 2,
//    "desc" : "Chatalyze Pro Plan",
//    "amount" : 29,
//    "minAmt" : "1",
//    "identifier" : "pro",
//    "isPro" : true,
//    "subscription" : {
//    "canceled" : true,
//    "id" : 181,
//    "lastPaymentDate" : null,
//    "nextSubscriptionDate" : "2019-03-19T10:11:14.000Z",
//    "isTrial" : true,
//    "subscriptionId" : null,
//    "hostId" : 860,
//    "subscriptionPlanId" : 2
//    }
//    }
    init(info:JSON?) {
        super.init()
        
        fillInfo(data:info)
    }
    
    func fillInfo(data:JSON?){
        
        guard let info = data?.dictionary else {
            return
        }
        self.id = info["id"]?.stringValue
        self.name = info["name"]?.stringValue
        self.minPrice = info["minAmt"]?.doubleValue
        if let subscriptionInfo = info["subscription"]?.dictionary{
            self.isTrial = subscriptionInfo["isTrial"]?.boolValue
        }
    }
}
