//
//  UserCallQueueRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class UserCallQueueRootView: CallQueueRootView {
    
    @IBOutlet var slotNumberLabel : EventSlotNumberLabel?
    override func refresh(){
        super.refresh()
        
        guard let slotMetaInfo = eventInfo?.myNextActiveSlot
            else{
                return
        }
        
        if(slotMetaInfo.slotInfo != nil){
            slotNumberLabel?.slotNumber = slotMetaInfo.slotNumber + 1
        }
        else{
            slotNumberLabel?.slotNumber = 0
        }
        
        guard let slotInfo = slotMetaInfo.slotInfo
            else{
                return
        }
        guard let startDate = slotInfo.startDate
            else{
                return
        }
        
        guard let countdownInfo = startDate.countdownTimeFromNow()
            else{
                return
        }
        if(!countdownInfo.isActive){
            countdownLabel?.updateText(label: "Your chat is finished ", countdown: "finished")
            return
        }
        
        let countdownTime = "\(countdownInfo.minutes) : \(countdownInfo.seconds)"
        
        countdownLabel?.updateText(label: "Your chat will begin in ", countdown: countdownTime)
    }
    
    
}
