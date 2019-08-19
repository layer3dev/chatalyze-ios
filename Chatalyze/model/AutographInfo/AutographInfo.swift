//
//  AutographInfo.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 17/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class AutographInfo {
    
    var id : String?
    var userId : String?
    var analystId : String?
    var screenshot : String?
    var signed : Bool = false
    
    var requestedAutograph : Bool = false
    
    var text : String?
    
    var color : String?
    var paid : Bool = false
    
    var viewedAt : Date?
    var createdAt : Date?
    var updatedAt : Date?
    var deletedAt : Date?
    
    var callBookingId : String?
    
    var amount : Double?
    var sender : AutographUserInfo?
    var receiver : AutographUserInfo?
    
    var callScheduleId : String?
    
    init(){
    }
    
    init(info : JSON?){
        fillInfo(info: info)
    }
    
    func fillInfo(info : JSON?){
        
        guard let info = info?.dictionary
            else{
                return
        }
        
        id = info["id"]?.stringValue
        userId = info["userId"]?.stringValue
        analystId = info["analystId"]?.stringValue
        
        screenshot = info["screenshot"]?.stringValue
        signed = info["signed"]?.boolValue ?? false
        requestedAutograph = info["requestedAutograph"]?.boolValue ?? false
        
        text = info["text"]?.stringValue
        color = info["color"]?.stringValue
        paid = info["paid"]?.boolValue ?? false
        
        let viewedAt = info["viewedAt"]?.stringValue
        self.viewedAt = DateParser.UTCStringToDate(viewedAt ?? "")
        
        let createdAt = info["createdAt"]?.stringValue
        self.createdAt = DateParser.UTCStringToDate(createdAt ?? "")
        
        let updatedAt = info["updatedAt"]?.stringValue
        self.updatedAt = DateParser.UTCStringToDate(updatedAt ?? "")
        
        let deletedAt = info["deletedAt"]?.stringValue
        self.deletedAt = DateParser.UTCStringToDate(deletedAt ?? "")
        callScheduleId = info["callScheduleId"]?.stringValue
        
        callBookingId = info["callbookingId"]?.stringValue
        amount = info["amount"]?.doubleValue
        
        sender = AutographUserInfo(info: info["sender"])
        receiver = AutographUserInfo(info : info["reciever"])
    }
    
    func dictValue()->[String : Any?]{
      
        var params = [String : Any?]()
        params["id"] = id
        params["userId"] = userId
        params["analystId"] = analystId
        params["screenshot"] = screenshot
        params["signed"] = signed
        params["analystId"] = analystId
        params["text"] = text
        params["color"] = color
        params["paid"] = paid
        params["viewedAt"] = viewedAt
        //        params["image"] = image
        //params["senderName"] = senderName
        
        return params
    }
    
    var userHashedId : String{
        get{
            return UniqueUserIdentifier().generateUniqueIdentifier(userId: userId)
        }
    }
    
    var analystHashedId : String{
        get{
            return UniqueUserIdentifier().generateUniqueIdentifier(userId: analystId)
        }
    }
    
    var amountString : String{
        get{
            guard let amount  = amount
                else{
                    return ""
            }
            
            return String(format: "$%.2f", amount)
        }
    }
    
}

