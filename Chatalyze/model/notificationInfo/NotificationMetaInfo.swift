//
//  NotificationMetaInfo.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 28/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import SwiftyJSON

class NotificationMetaInfo{
    
    enum NotificationType : Int{
        case undefined = 0
        case general = 1
        case signRequest = 2
        case greetingRequest = 3
        case slotBooked = 4
        
    }

    var activityId : String?
    var activityType : String?
    
    var callScheduleId : Int?
    var title : String?
    

    
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
        
        activityId = info["activity_id"]?.stringValue
        activityType = info["activity_type"]?.stringValue
        callScheduleId = info["callscheduleId"]?.intValue
        title = info["title"]?.stringValue
    }
    
}

extension NotificationMetaInfo{
    var type : NotificationType{
        get{
            return parseNotificationType()
        }
    }
    
    fileprivate func parseNotificationType()-> NotificationType{
        
        guard let activityType = activityType
        else{
            return .undefined
        }
        switch(activityType){
            case "sign_request":
                return .signRequest
            case "greeting_request":
                return .greetingRequest
            case "call_booked":
                return .slotBooked
            default:
                return .undefined
        }
    }
}
