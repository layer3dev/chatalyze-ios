//
//  CountdownProcessor.swift
//  GGStaff
//
//  Created by Sumant Handa on 16/11/17.
//  Copyright ©2017 GenGold. All rights reserved.
//

import Foundation

class CountdownProcessor{
    
    var timer : EventTimer = EventTimer()
    private static var instance : CountdownProcessor?
    private var timerSync : TimerSync?
    private var lastRefresh : Int = 0
    private var counter = 0
    
    fileprivate var listenerInfo : [Int : CountdownListener] = [Int : CountdownListener]()
    fileprivate var callbackList : [CallbackIdentifierInfo] = [CallbackIdentifierInfo]()

    static func sharedInstance()->CountdownProcessor{
        
        if let oldInstance = instance{
            return oldInstance
        }
        let newInstance = CountdownProcessor()
        instance = newInstance
        newInstance.initializeTimer()
        return newInstance
        
    }
    
    init(){
    }
    
    private func initializeTimer(){
        timerSync = TimerSync.sharedInstance
        timer.startTimer(withInterval: 0.1)
        
        timer.ping { [weak self] in
            guard let weakSelf = self
                else{
                    return
            }
            
            guard let timerSync = weakSelf.timerSync
                else{
                    return
            }
            let seconds = timerSync.getSeconds()
            let lastRefresh = weakSelf.lastRefresh
            
            let diff = seconds - lastRefresh
            
            if(diff <= 0){
                return
            }
            
            weakSelf.lastRefresh = seconds
            self?.refresh()
        }
    }
    
    func add(listener : CountdownListener)->Int{
        let identifier = uniqueIdentifier
        listenerInfo[identifier] = listener
        return identifier
    }
    
    func release(identifier : Int){
        listenerInfo[identifier] = nil
    }
    
    func stopTimer(){
        timer.pauseTimer()
    }
    
    func resumeTimer(){
        timer.resumeTimer()
    }
    
    
    fileprivate func refresh() {
        for (_, listener) in listenerInfo {
            listener.refresh()
        }
    }
    
    
    
    var uniqueIdentifier : Int{
        counter = counter + 1
        return counter
    }
}



