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
    var mergeSlotInfos : [SlotInfo]?
    
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
        self.updateMergeSlots()
        
    }
    
    private func updateMergeSlots(){
        guard let slotInfos = slotInfos
            else{
                return
        }
        
        var mergeInfos = [SlotInfo]()
        if(slotInfos.count <= 0){
            return
        }
        
        var lastSlot = slotInfos[0]
        for slotInfo in slotInfos {
            guard let currentSlot = slotInfo.copy() as? SlotInfo
                else{
                    continue
            }
            let isMerged = mergeSlot(lastSlot: lastSlot, currentSlot: currentSlot)
            
            if(!isMerged){
                mergeInfos.append(currentSlot)
                lastSlot = currentSlot
            }
        }
        
        self.mergeSlotInfos = mergeInfos
        
        Log.echo(key: "merge", text: "mergeSlotInfos -> count \(mergeInfos.count)")
        printMerge()
    }
    
    private func printMerge(){
        guard let slotInfos = mergeSlotInfos
            else{
                return
        }
        
        for slot in slotInfos {
            Log.echo(key: "merge", text: "slot \(slot.slotNo)")
            Log.echo(key: "merge", text: "slot \(slot.start)")
            Log.echo(key: "merge", text: "slot \(slot.end)")
        }
    }
    
    private func mergeSlot(lastSlot : SlotInfo, currentSlot : SlotInfo)->Bool{
        guard let lastSlotId = lastSlot.id
            else{
                return false
        }
        
        guard let currentSlotId = currentSlot.id
            else{
                return false
        }
        
        guard let currentStartDate = currentSlot.startDate
            else{
                return false
        }
        
        guard let lastEndDate = lastSlot.endDate
            else{
                return false
        }
        
        guard let lastSlotUserId = lastSlot.user?.id
            else{
                return false
        }
        
        guard let currentSlotUserId = currentSlot.user?.id
            else{
                return false
        }
        
        if(lastSlotId == currentSlotId){
            return false
        }
        
        if(lastSlotUserId != currentSlotUserId){
            return false
        }
        
        if(currentStartDate != lastEndDate){
            return false
        }
        
        lastSlot.end = currentSlot.end
        return true
        
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
    
    
    var currentSlotInfoFromMerge : (index : Int, slotInfo : SlotInfo?)?{
        guard let slotInfos = self.mergeSlotInfos
            else{
                return nil
        }
        
        for index in 0..<slotInfos.count{
            let slotInfo = slotInfos[index]
            if(slotInfo.isLIVE){
                return (index,slotInfo)
            }
        }
        
        
        return nil
    }
    
    
    var currentSlotInfo : (index : Int, slotInfo : SlotInfo?)?{
        guard let slotInfos = self.slotInfos
            else{
                return nil
        }
        
        for index in 0..<slotInfos.count{
            let slotInfo = slotInfos[index]
            if(slotInfo.isLIVE){
                return (index,slotInfo)
            }
        }
    
        
        return nil
    }
    
    var currentSlot : SlotInfo?{
        
        guard let info = currentSlotInfo
            else{
                return nil
        }
        
        return info.slotInfo
   
    }
    
    
    var currentSlotFromMerge : SlotInfo?{
        
        guard let info = currentSlotInfoFromMerge
            else{
                return nil
        }
        
        return info.slotInfo
        
    }
    
    
    
    var preConnectSlotFromMerge : SlotInfo?{
        guard let slotInfos = self.mergeSlotInfos
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
    
    
    var preConnectSlotInfo : (index : Int, slotInfo : SlotInfo?)?{
        guard let slotInfos = self.slotInfos
            else{
                return nil
        }
        
        for index in 0..<slotInfos.count{
            let slotInfo = slotInfos[index]
            if(slotInfo.isPreconnectEligible){
                return (index, slotInfo)
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
                Log.echo(key: "myValidSlot", text: "Here is your slot and index -> \(index)")
                return (index, slotInfo)
            }
            
        }
        
        Log.echo(key: "myValidSlot", text: "no valid slot found")
        
        return (0, nil)
    }
    
}
