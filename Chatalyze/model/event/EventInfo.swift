//
//  EventInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 22/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventInfo: NSObject {
    var id : Int?
    var start : String?
    var end : String?
    var slotNo : Int?
    var callscheduleId : Int?
    var userId : Int?
    var isPublic: Bool?
    var bordercolor : String?
    var backgroundcolor : String?
    var textcolor : String?
    var countryCode : String?
    var mobile : String?
    var createdAt : String?
    var updatedAt : String?
    var deletedAt : String?
    var user : UserInfo?
    var callschedule : EventSlotInfo?
    var href : String?
    
    
    init(info : JSON?){
        super.init()
        fillInfo(info: info)
    }
    
    func fillInfo(info : JSON?) {
        guard let json = info
            else{
                return
        }

        id = json["id"].int
        start = json["start"].string
        end = json["end"].string
        slotNo = json["slotNo"].int
        callscheduleId = json["callscheduleId"].int
        userId = json["userId"].int
        isPublic = json["isPublic"].bool
        bordercolor = json["bordercolor"].string
        backgroundcolor = json["backgroundcolor"].string
        textcolor = json["textcolor"].string
        countryCode = json["countryCode"].string
        mobile = json["mobile"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        deletedAt = json["deletedAt"].string
//        if (json["user"] != nil) { user = User(json: json["user"] as! NSDictionary) }
        callschedule = EventSlotInfo(info: json["callschedule"])
        href = json["href"].string
        
    }
    
}

