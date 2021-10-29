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
    var chatalyzeFee:Int?
    
    override init(){
        super.init()
    }
    
    init(info:JSON?) {
        super.init()
        
        fillInfo(data:info)
    }
    
    func fillInfo(data:JSON?) {
        
        guard let info = data?.dictionary else {
            return
        }
        self.id = info["id"]?.stringValue
        self.name = info["name"]?.stringValue
        
        if info["minAmt"]?.string == nil || info["minAmt"]?.string == ""{
            self.minPrice = 1.0
        }else{
            self.minPrice = Double(info["minAmt"]?.string ?? "1")
        }
        
        if let subscriptionInfo = info["subscription"]?.dictionary{
            self.isTrial = subscriptionInfo["isTrial"]?.boolValue
        }
        if let subscriptionInfo = info["subscription"]?.dictionary{
            self.isTrial = subscriptionInfo["isTrial"]?.boolValue
        }
        if let rule = info["rule"]?.dictionary{
            self.chatalyzeFee = rule["chatalyzeShare"]?.int
        }
    }
}

