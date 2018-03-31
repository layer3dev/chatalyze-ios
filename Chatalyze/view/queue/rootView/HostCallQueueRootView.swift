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
            countdownLabel?.text = "Finished"
            return
        }
        
        let countdownTime = "\(countdownInfo.minutes) : \(countdownInfo.seconds)"
        countdownLabel?.text = countdownTime
    }
}
