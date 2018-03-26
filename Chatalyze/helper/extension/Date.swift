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
    
    func countdownTimeFromNow()->(hours : String, minutes : String, seconds : String)?{
        
        let totalSeconds = Int(self.timeIntervalSinceNow)
        let hours = (totalSeconds) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds % 3600) % 60
        
        
        let hourString = String(format: "%02d", hours)
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)
        
        return (hourString, minuteString, secondString)
    }
    
    func countdownMinutesFromNow()->(minutes : String, seconds : String)?{
        
        let totalSeconds = Int(self.timeIntervalSinceNow)
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
