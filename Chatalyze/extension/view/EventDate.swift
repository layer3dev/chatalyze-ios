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
        
        Log.echo(key: "logging", text: "interval -> \(interval)")
        Log.echo(key: "logging", text: "secondsNow -> \(secondsNow)")
        Log.echo(key: "logging", text: "diff -> \(interval - secondsNow)")
        
        return interval - secondsNow
    }
}

