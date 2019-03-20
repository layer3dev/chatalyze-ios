//
//  EventDate.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

public extension Date {
    
    func isPast()->Bool{
        return !isFuture()
    }
    
    func isFuture()->Bool{
             
        let timeInterval = self.timeIntervalTillNow
        if(timeInterval > 0){
            return true
        }
        return false
    }
    
    
    var timeIntervalTillNow : TimeInterval{
        
        let interval = self.timeIntervalSince1970
        let secondsNow = Double(TimerSync.sharedInstance.getSeconds())
        return interval - secondsNow
    }
}

