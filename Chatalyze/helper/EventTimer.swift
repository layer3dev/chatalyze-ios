//
//  TimerHandler.swift
//  Kibitz
//
//  Created by Sumant Handa on 25/10/16.
//  Copyright © 2016 MansaInfoTech. All rights reserved.
//

import UIKit


class EventTimer: NSObject {
    
    fileprivate var closure : (()->Void)?
    fileprivate var timer : Timer?
    
    override init(){
        super.init()
    }
    
    func ping(_ closure : (()->Void)?){
        self.closure = closure
    }
    
    func startTimer(withInterval interval : Double = 1.0){
        pauseTimer()
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(processData(_:)), userInfo: nil, repeats: true)
    }
    
    func processData(_ timer : Timer){
        
        weak var weakSelf = self
        DispatchQueue.main.async(execute: {
            weakSelf?.closure?()
        })
        
    }
    
    
    
    func pauseTimer(){
        guard let timerUW = timer
            else{
                return
        }
        timerUW.invalidate()
        timer = nil
    }
    
    func resumeTimer(){
        pauseTimer()
        startTimer()
    }
}
