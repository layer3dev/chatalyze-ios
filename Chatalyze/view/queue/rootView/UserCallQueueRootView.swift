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
        guard let slotMetaInfo = eventInfo?.myValidSlot
            else{
                return
        }
        
        slotNumberLabel?.slotNumber = slotMetaInfo.slotNumber
        
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
            countdownLabel?.text = "Finished"
            return
        }
        
        let countdownTime = "\(countdownInfo.minutes) : \(countdownInfo.seconds)"
        countdownLabel?.text = countdownTime
    }
    
    
}
