//
//  SyncTimer.swift
//  Chatalyze
//
//  Created by Sumant Handa on 17/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit


class SyncTimer: NSObject {
    
    private let TAG = "SyncTimer"
    
    var shouldLog = false
    
    fileprivate var closure : (()->Void)?
    fileprivate var timer : Timer?
    
    private var timerSync = TimerSync.sharedInstance
    private var lastRefresh : Int = 0
    
    override init(){
        super.init()
    }
    
    func ping(_ closure : (()->Void)?){
        self.closure = closure
    }
    
    func startTimer(){
        pauseTimer()
        
        //Although frequency is of 0.1, but it will only ping after 1 second
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(processData(_:)), userInfo: nil, repeats: true)
    }
    
    
    @objc func processData(_ timer : Timer){
        

        
        weak var weakSelf = self
        DispatchQueue.main.async(execute: {
            guard let weak = weakSelf
                else{
                    return
            }
            
            let seconds = weak.timerSync.getSeconds()
            let lastRefreshSeconds = weak.lastRefresh
            
            let diff = seconds - lastRefreshSeconds
            
            if(diff <= 0){
                return
            }
            
            weak.lastRefresh = seconds
            
            //flag to log the closure trigger
            if(weak.shouldLog){
                Log.echo(key: weak.TAG, text: "processData")
            }
            
            weak.closure?()
        })
    }
    
    
    
    func pauseTimer(){
        
        Log.echo(key: TAG, text: "pauseTimer")
        
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
