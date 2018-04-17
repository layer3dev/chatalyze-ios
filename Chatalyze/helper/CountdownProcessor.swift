//
//  CountdownProcessor.swift
//  GGStaff
//
//  Created by Sumant Handa on 16/11/17.
//  Copyright © 2017 GenGold. All rights reserved.
//

import Foundation

class CountdownProcessor{
    
    var timer : EventTimer = EventTimer()
    private static var instance : CountdownProcessor?
//    var timerSync = TimerSync.sharedInstance
    
  
    fileprivate var callbackList : [()->()] = [()->()]()
    
    static func sharedInstance()->CountdownProcessor{
        
        if let oldInstance = instance{
            return oldInstance
        }
        
        let newInstance = CountdownProcessor()
        newInstance.initializeTimer()
        instance = newInstance
        
        return newInstance
        
    }
    
    init() {
        
    }
    
    private func initializeTimer(){
        timer.startTimer(withInterval: 0.1)
        timer.ping { [weak self] in
            
            self?.refresh()
        }
    }
    
    func add(listener : @escaping ()->()){
        callbackList.append(listener)
    }
}



extension CountdownProcessor{
    fileprivate func refresh() {
        for callback in callbackList {
            callback()
        }
    }
    
}
