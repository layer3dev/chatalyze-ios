//
//  EventSlotInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 22/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

//includes ParentEvent Information

class EventSlotInfo: SlotInfo {

    var callschedule : EventInfo?
    
    override func fillInfo(info : JSON?) {
        super.fillInfo(info: info)
        
        guard let json = info
            else{
                return
        }
        callschedule = EventInfo(info: json["callschedule"])
    }
}

