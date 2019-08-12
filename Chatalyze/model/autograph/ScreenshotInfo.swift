
//
//  ScreenshotInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 05/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class ScreenshotInfo : NSObject{
    
    var id : Int?
    var isPrivate : Bool?
    var userId : Int?
    var analystId : Int?
    var screenshot : String?
    var signed : Bool?
    var text : String?
    var color : String?
    var paid : Bool?
    var viewedAt : String?
    var callbookingId : Int?
    var amount : Int?
    var callScheduleId : Int?
    var requestedAutograph : Bool?
    var defaultImage : Bool?
    var isImplemented : Bool?
    var sharedOn : Bool?
    
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
        
        id = json["id"].int
        isPrivate = json["isPrivate"].boolValue
        userId = json["userId"].int
        analystId = json["analystId"].int
        screenshot = json["screenshot"].string
        signed = json["signed"].boolValue
        text = json["text"].string
        color = json["color"].string
        paid = json["paid"].boolValue
        viewedAt = json["viewedAt"].string
        callbookingId = json["callbookingId"].int
        amount = json["amount"].int
        callScheduleId = json["callScheduleId"].int
        requestedAutograph = json["requestedAutograph"].boolValue
        defaultImage = json["defaultImage"].boolValue
        isImplemented = json["isImplemented"].boolValue
        sharedOn = json["sharedOn"].boolValue
    }
    
    func toDict()->[String : Any]{
        
        var message = [String : Any]()
        message["text"] = text
        message["analystId"] = analystId ?? ""
        message["screenshot"] = screenshot ?? ""
        message["userId"] = userId ?? ""
        message["id"] = id
        message["signed"] = false
        message["color"] = color
        message["paid"] = false
        
        return message
    }

}
