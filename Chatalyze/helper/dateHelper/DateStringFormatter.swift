//
//  DateFormatter.swift
//  ICS
//
//  Created by Sumant Handa on 28/04/16.
//  Copyright © 2016 MansaInfoTech. All rights reserved.
//

import UIKit

class DateStringFormatter: NSObject {

    fileprivate static func getFormatString(_ timeInterval : Int)->String{
        
        if(timeInterval < 0){
            return "%@ ago"
        }
        return "in %@"
    }
    
    static func formatTimeInterval(_ timeIntervalLocal :Int)->String{
        
        var timeInterval = timeIntervalLocal
        let formatString = getFormatString(timeInterval)
        
        if(timeInterval < 0){
            timeInterval *= -1
        }
        
        if(timeInterval == 0){
            return "Just Now"
        }
        
        let timeIntervalString = getTimeIntervalString(timeInterval)

        return String(format: formatString, timeIntervalString)
    }
    
    
     static func getTimeIntervalString(_ timeIntervalLocal : Int)->String{
        var timeInterval = timeIntervalLocal
        
        if(timeInterval < 0){
            timeInterval *= -1
        }
        

        if(timeInterval == 0){
            return "Just Now"
        }
        if(timeInterval <= 1){
            return String(timeInterval) + " second"
        }
        
        if(timeInterval < 60){
            return String(timeInterval) + " seconds"
        }
        
        timeInterval = timeInterval/60
        
        if(timeInterval <= 1){
            return String(timeInterval) + " minute"
        }
        
        if(timeInterval < 60){
            return String(timeInterval) + " minutes"
        }
        
        timeInterval = timeInterval/60
        
        if(timeInterval <= 1){
            return String(timeInterval) + " hour"
        }
        
        if(timeInterval < 24){
            return String(timeInterval) + " hours"
        }
        
        timeInterval = timeInterval/24
        
        if(timeInterval <= 1){
            return String(timeInterval) + " day"
        }
        
        if(timeInterval < 60){
            return String(timeInterval) + " days"
        }
        return "month"
    }
}
