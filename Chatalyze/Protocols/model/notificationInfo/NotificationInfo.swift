//
//  NotificationInfo.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 28/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import SwiftyJSON


class NotificationInfo{
    
    var fromUser : UserInfo?
    
    var id : String?
    var fromId : String?
    var toId : String?
    var metaInfo : NotificationMetaInfo?
    
    var viewedAt : Date?
    var createdAt : Date?
    var updatedAt : Date?
    var deletedAt : Date?
    var href : String?
    var activityId:String?
    
    
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
        fromId = info["fromId"]?.stringValue
        toId = info["toId"]?.stringValue
        metaInfo = NotificationMetaInfo(info : info["meta"])
        
        
        let viewedAt = info["viewedAt"]?.stringValue
        self.viewedAt = DateParser.UTCStringToDate(viewedAt ?? "")
        
        let createdAt = info["createdAt"]?.stringValue
        self.createdAt = DateParser.UTCStringToDate(createdAt ?? "")
        
        let updatedAt = info["updatedAt"]?.stringValue
        self.updatedAt = DateParser.UTCStringToDate(updatedAt ?? "")
        
        let deletedAt = info["deletedAt"]?.stringValue
        self.deletedAt = DateParser.UTCStringToDate(deletedAt ?? "")
        
        fromUser = UserInfo(userInfoJSON : info["fromUser"])
        href = info["href"]?.stringValue
    }
    
    
    func getParsedDescription()->String{
        
        guard let type = metaInfo?.type
            else{
        
                return ""
        }
        
        switch type {
        case .signRequest:
            return "Sent request to sign screenshot"
        case .greetingRequest:
            return "Sent request to record greeting"
        default:
            return "Note : This notification is not in reference to Autography and is not supported yet!"
        }
    }
}

extension NotificationInfo{
    
    var timePassed : String{
        get{
            let timeInterval = Int((createdAt?.timeIntervalTillNow) ?? 0)
            return DateStringFormatter.formatTimeInterval(timeInterval)
        }
    }
}
