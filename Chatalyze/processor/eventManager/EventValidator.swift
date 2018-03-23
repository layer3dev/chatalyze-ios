//
//  EventValidator.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class EventValidator{
    
    func isPreConnectEligible(start : Date, end : Date)->Bool{
        if(end.isPast()){
            return false
        }
        
        let startTime = start.timeIntervalSinceNow
        if(startTime <= 30*60){
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
