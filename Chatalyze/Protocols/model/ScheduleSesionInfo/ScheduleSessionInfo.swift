//
//  ScheduleSessionInfo.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class ScheduleSessionInfo:NSObject {
    
    var endDateTime:Date?
    var startDateTime:Date?
    var startDate:String?
    var startTime:String?
    var price:Double?
    var isFree:Bool = false
    var title:String? = "Chat Session"
    var eventDescription:String?
    var duration:Float?
    var isScreenShotAllow:Bool = false
    var isAutographAllow:Bool = false
    var screenShotParam = "automatic"
    var autographParam = "automatic"
    var eventInfo:EventInfo?
    var bannerImage:UIImage?
    var tipEnabled:Bool = false
    var isSponsorEnable = false 
    var minimumPlanPriceToSchedule:Double = 0.0
    var doublePrice:Double?
    var chatalyzeFeePercent:Int? 
    
    //["end": "2019-01-30T10:30:00.000+0000", "price": "11100", "isFree": false, "userId": "36", "start": "2019-01-30T09:30:00.000+0000", "eventBannerInfo": false, "title": "Chat Session", "description": "", "duration": 3]
    
    override init(){
        super.init()
    }
    
    var totalSlots:Int?{
       
        get{
            
            guard let start = self.startDateTime else {
                return nil
            }
            guard let end = self.endDateTime else {
                return nil
            }
            guard let singleChatTime = self.duration else {
                return nil
            }
            let duration = end.timeIntervalSince(start)
            return Int(Float(Int((duration/60.0)))/singleChatTime)
        }
    }
    
    var totalTimeInMinutes:Int?{
        
        guard let start = self.startDateTime else {
            return nil
        }
        guard let end = self.endDateTime else {
            return nil
        }
        let duration = end.timeIntervalSince(start)
        return Int((duration/60.0))
    }
}
