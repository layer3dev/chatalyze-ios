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
class SlotInfo: NSObject {
    var id : Int?
    var _start : String?
    var startDate : Date?
    var endDate : Date?
    var _end : String?
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
        
        user = UserInfo(userInfoJSON: json["user"])
    
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
    
    var isFuture : Bool{
        get{
            guard let startDate = startDate
                else{
                    return false
            }
            
            guard let endDate = endDate
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
            
            return EventValidator().isPreconnectEligible(start: startDate, end: endDate)
        }
    }
    
    
}


