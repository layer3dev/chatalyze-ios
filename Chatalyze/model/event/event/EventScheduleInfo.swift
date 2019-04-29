//
//  EventScheduleInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 28/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventScheduleInfo : EventScheduleCoreInfo {
    
    var mergeSlotInfo : EventScheduleCoreInfo?
    
    override init(info : JSON?){
        super.init(info : info)
    }
    
    override func slotsUpdated(){
        super.slotsUpdated()
        
        updateMergeSlots()
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

                if currentSlot.id == nil {
                   
                    //This was implementing in the parseEmptySlots but now we have to implement it here. done by yudh.
                    currentSlot.isBreak = true
                }
                mergeInfos.append(currentSlot)
                lastSlot = currentSlot
            }
        }
        
        self.mergeSlotInfo = EventScheduleCoreInfo()
        self.mergeSlotInfo?.slotInfos = mergeInfos
        
        //Log.echo(key: "merge", text: "mergeSlotInfos -> count \(mergeInfos.count)")
        //printMerge()
    }
    
    
    private func printMerge(){
        
        guard let slotInfos = self.mergeSlotInfo?.slotInfos
            else{
                return
        }
        
        for slot in slotInfos {
            
            Log.echo(key: "merge", text: "After merge slot \(String(describing: slot.slotNo))")
            Log.echo(key: "merge", text: "After merge slot \(String(describing: slot.isBreak))")
            Log.echo(key: "merge", text: "After merge slot \(String(describing: slot.start))")
            Log.echo(key: "merge", text: "After merge slot \(String(describing: slot.end))")
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
}
