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
    var eventBAnnerInfo:Bool = false
    var title:String?
    var eventDescription:String?
    var duration:Double?
    
//    ["end": "2019-01-30T10:30:00.000+0000", "price": "11100", "isFree": false, "userId": "36", "start": "2019-01-30T09:30:00.000+0000", "eventBannerInfo": false, "title": "Chat Session", "description": "", "duration": 3]

    override init(){
        super.init()
    }
}
