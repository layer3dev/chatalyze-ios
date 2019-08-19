
//
//  EventInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 22/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

/*Doesn't include child slot information*/

class EventInfo: NSObject {
  
    var id : Int?
    var _start : String?
    var startDate : Date?
    var endDate : Date?
    var _end : String?
    var youtubeURL : String?
    var userId : Int?
    var title : String?
    var eventDescription : String?
    var duration : Double?
    var price : Double?
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
    //var tag : Tag? //:todo
    var isFree : Bool?
    var eventFeedbackInfo : String?
    var createdAt : String?
    var updatedAt : String?
    var deletedAt : String?
    var user : UserInfo?
    var href : String?
    var serviceFee:Double?
    var callBookings:[JSON] = [JSON]()
    var isScreenShotAllowed:String?
    var tipEnabled : Bool?
    var slotsInfoLists:[SlotInfo]  = [SlotInfo]()
    var emptySlotsArray:[JSON]? = [JSON]()
    var isSponsorEnable = false
    var isAutographAllow:String?
    var callSchduleId:String?
    
    override init(){
        super.init()
    }
    
    init(info : JSON?){
        super.init()
        fillInfo(info: info)
    }
    
     func fillInfo(info : JSON?){
      
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
        duration = json["duration"].doubleValue
        _price = json["price"].doubleValue
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
        
        // if (json["tag"] != nil) { tag = Tag(json: json["tag"] as! NSDictionary) } //todo:
        isFree = json["isFree"].boolValue
        eventFeedbackInfo = json["eventFeedbackInfo"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        deletedAt = json["deletedAt"].string
        tipEnabled = json["tipEnabled"].bool
        if json["sponsorshipAmount"].intValue > 0{
            isSponsorEnable = true
        }

        isScreenShotAllowed = json["screenshotAllow"].string
        isAutographAllow = json["autographAllow"].string
        
        emptySlotsArray = json["emptySlots"].array
        
        user = UserInfo(userInfoJSON: json["user"])
        href = json["href"].string
        if let  callBokingArray = json["callbookings"].array {
            self.callBookings = callBokingArray
        }
        
        for info in self.callBookings{
            
            let info = SlotInfo(info: info)
            self.slotsInfoLists.append(info)
        }        
    }
    
    private var _price:Double?{
        
        get{
            return price
        }
        set{
            
            let price = newValue ?? 0.0
            self.price = (price/60.0)*(self.duration ?? 0.0)
            self.price = self.price?.roundTo(places: 3)
            Log.echo(key: "yud", text: "Round 3 price is \(self.price)")
            self.price =  round((self.price ?? 0.0)*100)/100
            Log.echo(key: "yud", text: "Round 2 price is \(self.price)")
            self.serviceFee = (((self.price ?? 0.0)+0.30)/0.971) - (self.price ?? 0.0)
            self.serviceFee = ((round((self.serviceFee ?? 0.0))*1000))/1000
        }
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
    
    var roomId : String{
        get{
            return "call-\(self.id ?? 0)"
        }
    }
        
    var isLIVE : Bool{
      
        get{
            guard let startDate = startDate
                else{
                    return false
            }
            
            guard let endDate = endDate
                else{
                    return false
            }
            
            if(startDate.isPast() && endDate.isFuture()){
                return true
            }
            
            return false
        }
    }
    
    var isFuture : Bool{
        
        get{
            guard let startDate = startDate
                else{
                    return false
            }
            if(startDate.isFuture()){
                return true
            }
            return false
        }
    }
    
    var isExpired : Bool{
        
        get{
            guard let endDate = endDate
                else{
                    return false
            }
            if(endDate.isPast()){
                return true
            }
            return false
        }
    }
    
    var isWholeConnectEligible : Bool{
        
        get{
            guard let startDate = startDate
                else{
                    return false
            }
            
            guard let endDate = endDate
                else{
                    return false
            }
            
            return EventValidator().isWholeConnectEligible(start: startDate, end: endDate)
        }
    }
    
    var isPreconnectEligible : Bool{
        
        get{
            guard let startDate = startDate
                else{
                    return false
            }
            
            guard let endDate = endDate
                else{
                    return false
            }
            
            return EventValidator().isPreconnectEligible(start: startDate, end: endDate)
        }
    }
    
    
   
}
