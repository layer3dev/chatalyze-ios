//
//  EventValidator.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class EventValidator{
    
    func isPreconnectEligible(start : Date, end : Date, duration: Double)->Bool{
        
        
        if(end.isPast()){
            return false
        }
        
        let startTime = start.timeIntervalTillNow
        Log.echo(key: "vijay", text: "duration received\(duration)")
        
        switch duration {
        case 30:
            if(startTime <= 15 && startTime > 0){
                Log.echo(key: "vijay30Seconds", text: "PreConnected:True")
                return true
            }
        case 15:
            if(startTime <= 12 && startTime > 0){
                Log.echo(key: "vijay15Seconds", text: "PreConnected:True")
                return true
            }
        default:
            if(startTime <= 30 && startTime > 0){
                Log.echo(key: "vijay", text: "PreConnected:True")
                return true
            }
        }
//
//        if duration == 30 || duration == 15 {
//            if(startTime <= 15 && startTime > 0){
//                Log.echo(key: "vijay", text: "PreConnected:True")
//                return true
//            }
//        }else{
//            if(startTime <= 30 && startTime > 0){
//                Log.echo(key: "vijay", text: "PreConnected:True")
//                return true
//            }
//        }
        Log.echo(key: "vijay", text: "PreConnected:False")
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
