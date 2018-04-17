//
//  Date.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 05/01/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import Foundation
import UIKit

public extension Date {
    
    
    func toString()->String?{
        let defaultFormat = "MMM d, yyyy"
        return DateParser.dateToString(self, requiredFormat : defaultFormat)
    }
    
    func countdownTimeFromNowAppended()->(isActive : Bool, time : String)?{
        guard let time = countdownTimeFromNow()
            else{
                return (false, "00")
        }
        if(!time.isActive){
            return (false, "00")
        }
        
        var formatted = ""
        
        if(time.hours != "00"){
            formatted = time.hours + " : "
        }
        
        formatted = formatted + "\(time.minutes) : \(time.seconds)"
        
        return (true, formatted)
    }
    
    func countdownTimeFromNow()->(isActive : Bool, hours : String, minutes : String, seconds : String)?{
        
        
        let totalSeconds = Int(self.timeIntervalSinceNow + 1)
        
        if(totalSeconds < 0){
            return (false, "00", "00", "00")
        }
        let hours = (totalSeconds) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds % 3600) % 60
        
        
        let hourString = String(format: "%02d", hours)
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)
        
        return (true, hourString, minuteString, secondString)
    }
    
    func countdownMinutesFromNow()->(minutes : String, seconds : String)?{
        
        let totalSeconds = Int(self.timeIntervalSinceNow + 1)
        
        if(totalSeconds < 0){
            return ("00", "00")
        }
        let minutes = (totalSeconds) / 60
        let seconds = (totalSeconds % 60) % 60
        
        
        
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)
        
        return (minuteString, secondString)
    }
    
    public func removeTimeStamp() -> Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return date
    }

}
