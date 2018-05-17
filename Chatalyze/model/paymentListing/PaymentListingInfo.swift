//
//  PaymentListingInfo.swift
//  Chatalyze
//
//  Created by Mansa on 17/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON



class PaymentListingInfo: NSObject {
    
    var id : Int?
    var eventId:Int?
    var eventType:String?
    var amount:Double?
    
    
    override init(){
        super.init()
    }
    
    init(info : JSON?){
        super.init()
        fillInfo(info: info)
    }
    
    func fillInfo(info : JSON?) {
        
        guard let json = info
            else{
                return
        }
        
        self.id = json["id"].int
        
        if let eventInfo = json["event"].dictionary{
            self.eventId = eventInfo["id"]?.int
            self.eventType = eventInfo["type"]?.stringValue
        }
        
        self.amount = json["amount"].double
    }
}
