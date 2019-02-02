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
    var price:Int?
    var isFree:Bool = false
    var title:String? = "Chat Session"
    var eventDescription:String?
    var duration:Int?
    var isScreenShotAllow:Bool = false
    var screenShotParam = "automatic"
    var eventInfo:EventInfo?
    var bannerImage:UIImage?
    
//    ["end": "2019-01-30T10:30:00.000+0000", "price": "11100", "isFree": false, "userId": "36", "start": "2019-01-30T09:30:00.000+0000", "eventBannerInfo": false, "title": "Chat Session", "description": "", "duration": 3]

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
            guard let sinleChatTime = self.duration else {
                return nil
            }
            let duration = end.timeIntervalSince(start)
            return Int(Int((duration/60.0))/sinleChatTime)
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
