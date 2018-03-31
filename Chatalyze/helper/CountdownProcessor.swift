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
    
    func initializeTimer(){
        timer.startTimer(withInterval: 1.0)
        timer.ping { [weak self] in
            self?.refresh()
        }
    }
    
    func add(listener : @escaping ()->()){
        callbackList.append(listener)
    }
}



extension CountdownProcessor{
    func refresh() {
        for callback in callbackList {
            callback()
        }
    }
    
}
