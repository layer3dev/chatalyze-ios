
//
//  EventSlotInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 22/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventSlotInfo: NSObject {
    var id : Int?
    var _start : String?
    var startDate : Date?
    var endDate : Date?
    var _end : String?
    var youtubeURL : String?
    var userId : Int?
    var title : String?
    var eventDescription : String?
    var duration : Int?
    var price : Int?
    var backgroundcolor : String?
    var bordercolor : String?
    var textcolor : String?
    var cancelled : Bool?
    var notified : String?
    var started : String?
    var groupId : String?
    var paymentTransferred : Bool?
    var leadPageUrl : String?
    var eventBannerUrl : String?
    var isPrivate : Bool?
    //    var tag : Tag? //:todo
    var isFree : Bool?
    var eventFeedbackInfo : String?
    var createdAt : String?
    var updatedAt : String?
    var deletedAt : String?
    //    var user : User? //:todo
    var href : String?
    
    
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
        start = json["start"].string
        end = json["end"].string
        youtubeURL = json["youtubeURL"].string
        userId = json["userId"].int
        title = json["title"].string
        eventDescription = json["description"].string
        duration = json["duration"].int
        price = json["price"].int
        backgroundcolor = json["backgroundcolor"].string
        bordercolor = json["bordercolor"].string
        textcolor = json["textcolor"].string
        cancelled = json["cancelled"].bool
        notified = json["notified"].string
        started = json["started"].string
        groupId = json["groupId"].string
        paymentTransferred = json["paymentTransferred"].bool
        leadPageUrl = json["leadPageUrl"].string
        eventBannerUrl = json["eventBannerUrl"].string
        isPrivate = json["isPrivate"].bool
        //        if (json["tag"] != nil) { tag = Tag(json: json["tag"] as! NSDictionary) } //todo:
        isFree = json["isFree"].bool
        eventFeedbackInfo = json["eventFeedbackInfo"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        deletedAt = json["deletedAt"].string
//        if (json["user"] != nil) { user = User(json: json["user"] as! NSDictionary) } //todo:
        href = json["href"].string
    }
    
    var start : String?{
        get{
            return _start
        }
        set{
            _start = newValue
            guard let startLocal = _start
                else{
                    return
            }
            startDate = DateParser.UTCStringToDate(startLocal)
        }
    }
    
    var end : String?{
        get{
            return _end
        }
        set{
            _end = newValue
            guard let endLocal = _end
                else{
                    return
            }
            endDate = DateParser.UTCStringToDate(endLocal)
        }
    }
}
