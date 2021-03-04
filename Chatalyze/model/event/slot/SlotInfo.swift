//
//  SlotInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 22/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

/* Doesn't include ParentEvent Information*/

class SlotInfo: SlotTimeInfo {
    
    var id : Int?
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
    var href : String?
    var json : JSON?
    
    var formattedStartTime:String?
    var formattedEndTime:String?
    var formattedStartDate:String?
    var fromattedEndDate:String?
    var started:String?
    var notified:String?
    
    var price:String?
    var eventTitle:String?
    var sponserId:Int?
    var removeLogo: Bool?
    
    override init(info : JSON?){
        super.init(info : info)
        
        self.json = info
        fillInfo(info: info)
    }
    
    //This should be used instead of default constructor, so that nil value gets returned in case of invalid JSON or invalid Slot
    class func instance(info : JSON?)->SlotInfo?{
        
        let slotInfo = SlotInfo(info : info)
        if(slotInfo.slotNo == nil){
            return nil
        }
        return slotInfo
    }
    
    func fillInfo(info : JSON?) {
    
        guard let json = info
            else{
                return
        }
        id = json["id"].int
        if let sponsor = json["sponsor"].dictionary{
            self.sponserId = sponsor["id"]?.int
        }
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
        user = UserInfo(userInfoJSON: json["user"])
        href = json["href"].string
        removeLogo = json["removeLogo"].boolValue
        
        if let callScheduleInfo = json["callschedule"].dictionary{
         
            self.eventTitle = callScheduleInfo["title"]?.stringValue            
            self.price = String(format: "%.2f", callScheduleInfo["price"]?.stringValue ?? "0.0")
            self.started = callScheduleInfo["started"]?.stringValue
            self.notified = callScheduleInfo["notified"]?.stringValue
        }
    }
    
    var roomId : String{
        get{
            return "call-\(self.callscheduleId ?? 0)"
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
    
    
    //used by host to unmute the stream one second advance
    var isReadyToGoLive : Bool{
        
        get{
            guard let startDate = startDate
                else{
                    return false
            }
            
            guard let endDate = endDate
                else{
                    return false
            }
            
            if(isReadyToActivate(date : startDate) && endDate.isFuture()){
                return true
            }
        
            return false
        }
    }
    
    
    private func isReadyToActivate(date : Date)->Bool{
             
        let timeInterval = date.timeIntervalTillNow
        if(timeInterval <= 1){
            return true
        }
        return false
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
            
            guard let startDate = startDate
                else{
                    return false
            }
            
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
            let timeDiffrenece = endDate.timeIntervalSince(startDate)
            
            let duration = Double(timeDiffrenece)
            
        
            return EventValidator().isPreconnectEligible(start: startDate, end: endDate, duration: duration)
        }
    }
}

extension SlotInfo : NSCopying{
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = SlotInfo(info: self.json)
        return copy
    }
}


