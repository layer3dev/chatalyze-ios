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
        
        localSlotInfos = sortSlots(slotInfos: localSlotInfos)
        
        self.slotInfos = localSlotInfos
        
    }
    
    private func sortSlots(slotInfos : [SlotInfo])->[SlotInfo]{
        let infos = slotInfos.sorted { (slotOne, slotTwo) -> Bool in
            let slotOneNo = slotOne.slotNo ?? 0
            let slotTwoNo = slotTwo.slotNo ?? 0
            return slotOneNo < slotTwoNo
        }
        return infos
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
    
    var wholeConnectSlot : SlotInfo?{
        guard let slotInfos = self.slotInfos
            else{
                return nil
        }
        
        for slotInfo in slotInfos {
            if(slotInfo.isWholeConnectEligible){
                return slotInfo
            }
        }
        
        return nil
    }
    
    var myValidSlot : (slotNumber : Int, slotInfo : SlotInfo?){
        guard let slotInfos = self.slotInfos
            else{
                return (0, nil)
        }
        
        if(slotInfos.count <= 0){
            return (0, nil)
        }
        
        for index in 0...slotInfos.count{
            let slotInfo = slotInfos[index]
            if(slotInfo.isWholeConnectEligible){
                return (index, slotInfo)
            }
            
        }
        
        return (0, nil)
    }
    
}
