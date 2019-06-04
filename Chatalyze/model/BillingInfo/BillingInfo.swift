//
//  BillingInfo.swift
//  Chatalyze
//
//  Created by mansa infotech on 04/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class BillingInfo: NSObject {

//    {"":"13291.83","":"3677.58","":"4.74","":"0.00"}
    
    var pendingAmount:String?
    var earnedAmount:String?
    var tipAmount:String?
    var sponsorAmount:String?
    
    
    init(info:JSON?) {
        super.init()
        
        self.fillInfo(info: info)
    }
    
    func fillInfo(info:JSON?){
    
        guard let valuesInfo = info?.dictionary else{
            return
        }
        
        self.pendingAmount = valuesInfo["pendingAmt"]?.stringValue
        self.earnedAmount = valuesInfo["earnedAmt"]?.stringValue
        self.tipAmount = valuesInfo["tipAmt"]?.stringValue
        self.sponsorAmount = valuesInfo["sponsorAmt"]?.stringValue
    }
    
    
    
}
