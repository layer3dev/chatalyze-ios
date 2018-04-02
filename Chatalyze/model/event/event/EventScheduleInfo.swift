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
    
    var myNextActiveSlot : (slotNumber : Int, slotInfo : SlotInfo?){
        guard let slotInfos = self.slotInfos
            else{
                Log.echo(key: "myValidSlot", text: "slotinfos is nil")
                return (0, nil)
        }
        
        if(slotInfos.count <= 0){
            Log.echo(key: "myValidSlot", text: "slotinfos count is 0")
            return (0, nil)
        }
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return (0, nil)
        }
        
        
        for index in 0..<slotInfos.count{
            let slotInfo = slotInfos[index]
            let slotUserId = slotInfo.user?.id ?? "0"
            
            Log.echo(key: "myValidSlot", text: "userId - > \(slotUserId) and selfId -> \(selfId)")
            
            if(slotInfo.isFuture && selfId == slotUserId){
                return (index, slotInfo)
            }else{
                Log.echo(key: "myValidSlot", text: "not valid userId - > \(slotUserId) and selfId -> \(selfId)")
            }
            
        }
        
        Log.echo(key: "myValidSlot", text: "no valid slot found")
        
        return (0, nil)
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
                Log.echo(key: "myValidSlot", text: "slotinfos is nil")
                return (0, nil)
        }
        
        if(slotInfos.count <= 0){
            Log.echo(key: "myValidSlot", text: "slotinfos count is 0")
            return (0, nil)
        }
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return (0, nil)
        }
        
        
        for index in 0..<slotInfos.count{
            let slotInfo = slotInfos[index]
            let slotUserId = slotInfo.user?.id ?? "0"
            if(slotInfo.isWholeConnectEligible && selfId == slotUserId){
                return (index, slotInfo)
            }
            
        }
        
        Log.echo(key: "myValidSlot", text: "no valid slot found")
        
        return (0, nil)
    }
    
}
