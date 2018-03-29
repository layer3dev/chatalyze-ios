//
//  EventScheduleInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 28/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

/*Includes child slot information*/
class EventScheduleInfo: EventInfo {
    var slotInfos : [SlotInfo]?
    
    override init(){
        super.init()
    }
    
    override init(info : JSON?){
        super.init(info : info)
       
    }
    
    override func fillInfo(info: JSON?) {
        super.fillInfo(info: info)
        
        guard let json = info
            else{
                return
        }
        
        let bookingInfos = json["callbookings"].arrayValue
        
        var localSlotInfos = [SlotInfo]()
        for bookingInfo in bookingInfos {
            let slotInfo = SlotInfo(info: bookingInfo)
            localSlotInfos.append(slotInfo)
        }
        
        self.slotInfos = localSlotInfos
        
    }
    
    
    
    var currentSlot : SlotInfo?{
        
        guard let slotInfos = self.slotInfos
            else{
                return nil
        }
        
        for slotInfo in slotInfos {
            if(slotInfo.isLIVE){
                return slotInfo
            }
        }
        
        return nil
    }
    
    var preConnectSlot : SlotInfo?{
        guard let slotInfos = self.slotInfos
            else{
                return nil
        }
        
        for slotInfo in slotInfos {
            if(slotInfo.isPreconnectEligible){
                return slotInfo
            }
        }
        
        return nil
    }
    
}
