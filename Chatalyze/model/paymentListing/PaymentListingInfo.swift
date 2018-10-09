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
    var amount:String?
    var _date:String?
    var refundedAmount:String?
    
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
        
        self.amount = json["amount"].stringValue
        _date = json["createdAt"].stringValue
        
        if let refundInfo = json["refund"].dictionary{
            if let refundedAmount = refundInfo["amount"]?.string{
                self.refundedAmount =  "$"+refundedAmount+" Refunded"
            }
//            Refunded Amount: $
//            self.refundedAmount = refundInfo["amount"]?.string
        }
    }
    
    var paymentDate:String?{
        
        get{
            return DateParser.convertDateToDesiredFormat(date: _date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "MMM dd, yyyy h:mm:ss a")
            //Jan 16, 2018 5:51:48 PM
           //EE, MMM dd h:mm
        }
    }
}
