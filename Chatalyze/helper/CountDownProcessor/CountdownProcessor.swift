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
    private var lastRefresh = Date()
    
    fileprivate var callbackList : [()->()] = [()->()]()

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
            
            let diff = timerSync.getDate().timeIntervalSince(weakSelf.lastRefresh)
            if(diff <= 0){
                return
            }
            
            weakSelf.lastRefresh = timerSync.getDate()
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
