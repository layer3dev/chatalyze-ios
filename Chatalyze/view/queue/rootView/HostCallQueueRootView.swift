//
//  HostCallQueueRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostCallQueueRootView: CallQueueRootView {
    
    override func refresh(){
        
        

        guard let startDate = eventInfo?.startDate
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
        
        countdownLabel?.updateText(label: "Event will begin in ", countdown: countdownTime)
    }
}
