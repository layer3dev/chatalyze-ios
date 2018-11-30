//
//  EventValidator.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class EventValidator{
    
    func isPreconnectEligible(start : Date, end : Date)->Bool{
        if(end.isPast()){
            return false
        }
        
        let startTime = start.timeIntervalTillNow
        if(startTime <= 30 && startTime > 0){
            return true
        }
        
        return false
    }
    
    func isWholeConnectEligible(start : Date, end : Date)->Bool{
       
        if(end.isPast()){
            return false
        }
        
        let startTime = start.timeIntervalTillNow
        if(startTime <= 30){
            return true
        }
        
        return false
    }
    
    func isRoomEligible(start : Date, end : Date)->Bool{
        if(start.isPast() || end.isPast()){
            return false
        }
        
        let startTimeInterval = start.timeIntervalTillNow
        if(startTimeInterval <= 120*60 && startTimeInterval > 0){
            return true
        }
        
        return false
    }
    
    func isFutureEvent(start : Date, end : Date)->Bool{
        if(start.isPast() || end.isPast()){
            return false
        }
        
        return true
    }
}
