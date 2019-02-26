//
//  EventScheduleCoreInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 27/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

/*Includes child slot information*/
class EventScheduleCoreInfo: EventInfo {
    
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
        let emptySlotInfos = json["emptySlots"].arrayValue
        
        var localSlotInfos = parseCallSlot(bookingInfos : bookingInfos)
        let localEmptySlotInfos = parseEmptySlot(bookingInfos : emptySlotInfos)
        
        
        localSlotInfos.append(contentsOf: localEmptySlotInfos)
        localSlotInfos = sortSlots(slotInfos: localSlotInfos)
        
        self.slotInfos = localSlotInfos
        slotsUpdated()
    }
    
    
    private func parseCallSlot(bookingInfos : [JSON]?) -> [SlotInfo]{
        var localSlotInfos = [SlotInfo]()
        guard let bookingInfos = bookingInfos
            else{
                return localSlotInfos
        }
        
        for bookingInfo in bookingInfos {
//            let slotInfo = SlotInfo(info: bookingInfo)
            guard let slotInfo = SlotInfo.instance(info: bookingInfo)
                else{
                    continue
            }
            if let oldSlotInfo = fetchSlotInfo(id: (slotInfo.id ?? 0)){
                slotInfo.updateFlags(info: oldSlotInfo)
            }
            localSlotInfos.append(slotInfo)
        }
        return localSlotInfos
    }
    
    private func parseEmptySlot(bookingInfos : [JSON]?) -> [SlotInfo]{
        
        var localSlotInfos = [SlotInfo]()
        guard let bookingInfos = bookingInfos
            else{
                return localSlotInfos
        }
        
        for bookingInfo in bookingInfos {
            
//            let slotInfo = SlotInfo(info: bookingInfo)
            guard let slotInfo = SlotInfo.instance(info: bookingInfo)
                else{
                    continue
            }
            if let oldSlotInfo = fetchSlotInfo(id: (slotInfo.id ?? 0)){
                slotInfo.updateFlags(info: oldSlotInfo)
            }
            slotInfo.isBreak = true
            localSlotInfos.append(slotInfo)
        }
        return localSlotInfos
    }
    
    //to be overridden by child class
    func slotsUpdated(){
    }
    
    private func fetchSlotInfo(id : Int)->SlotInfo?{
        
        guard let slotInfos = self.slotInfos
            else{
                return nil
        }
        
        for slotInfo in slotInfos {
            guard let slotId = slotInfo.id
                else{
                    continue
            }
            if(slotId == id){
                return slotInfo
            }
        }
        return nil
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
    
    
    var currentSlotInfo : (index : Int, slotInfo : SlotInfo?)?{
        guard let slotInfos = self.slotInfos
            else{
                return nil
        }
        
        return getCurrentSlotInfo(slotInfos : slotInfos)
    }
    
    private func getCurrentSlotInfo(slotInfos : [SlotInfo])->(index : Int, slotInfo : SlotInfo?)?{
       
        for index in 0..<slotInfos.count{
            let slotInfo = slotInfos[index]
            if(slotInfo.isLIVE){
                return (index,slotInfo)
            }
        }
        return nil
    }
    
    //this will return active slots while ignoring break slots
    var activeSlotCount : Int{
        var count = 0
        guard let slotInfos = slotInfos
            else{
                return count
        }
        
        for slotInfo in slotInfos {
            if(slotInfo.isBreak){
               continue
            }
            count = count + 1
        }
        
        return count
    }
    
    var myCurrentSlotInfo : (index : Int, slotInfo : SlotInfo?)?{
        guard let slotInfos = self.slotInfos
            else{
                return nil
        }
        
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return (0, nil)
        }
        
        for index in 0..<slotInfos.count{
            let slotInfo = slotInfos[index]
            let slotUserId = slotInfo.user?.id ?? "0"
            if(slotInfo.isLIVE && selfId == slotUserId){
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
    
    //this will return
    //LIVE slot OR Preconnect Slot or Future Slot.
    var myUpcomingSlotInfo : (index : Int, slotInfo : SlotInfo?)?{
        get{
            guard let slotInfos = slotInfos
                else{
                    return nil
            }
    
            guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return (0, nil)
            }
            
            for index in 0 ..< slotInfos.count{
                let slotInfo = slotInfos[index]
                let slotUserId = slotInfo.user?.id ?? "0"
                if((slotInfo.isLIVE || slotInfo.isPreconnectEligible || slotInfo.isFuture)  && selfId == slotUserId){
                    return (index, slotInfo)
                }
            }
            return nil
        }
    }
    
    var myUpcomingSlot : SlotInfo?{
        return myUpcomingSlotInfo?.slotInfo
    }
    
    
    //this will return
    //LIVE slot OR Preconnect Slot or Future Slot.
    var upcomingSlotInfo : (index : Int, slotInfo : SlotInfo?)?{
        get{
            guard let slotInfos = slotInfos
                else{
                    return nil
            }
            
            for index in 0 ..< slotInfos.count{
                let slotInfo = slotInfos[index]
                if(slotInfo.isLIVE || slotInfo.isPreconnectEligible || slotInfo.isFuture){
                     return (index, slotInfo)
                }
            }
            return nil
        }
    }
    
    var upcomingSlot : SlotInfo?{
        return upcomingSlotInfo?.slotInfo
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
    
    var myLastCompletedSlot : SlotInfo?{
        guard let slotInfos = self.slotInfos
            else{
                return nil
        }
        
        if(slotInfos.count <= 0){
            return nil
        }
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return nil
        }
        
        for index in (0..<slotInfos.count).reversed(){
            let slotInfo = slotInfos[index]
            let slotUserId = slotInfo.user?.id ?? "0"
            if(slotInfo.isExpired && selfId == slotUserId){
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
        
        return getMyValidSlot(slotInfos: slotInfos)
    }
    
    private func getMyValidSlot(slotInfos : [SlotInfo])->(slotNumber : Int, slotInfo : SlotInfo?){
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
                //                Log.echo(key: "myValidSlot", text: "Here is your slot and index -> \(index)")
                return (index, slotInfo)
            }
            
        }
        
        //        Log.echo(key: "myValidSlot", text: "no valid slot found")
        
        return (0, nil)
    }
    
}

