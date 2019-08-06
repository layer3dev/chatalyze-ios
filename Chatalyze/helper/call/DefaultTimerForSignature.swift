//
//  DefaultTimerForSignature.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 06/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//


import UIKit

class DefaultTimerForSignature:NSObject {
    
    var signatureTimer = CountdownListener()
    var screenShotListner:(()->())?
    var requiredDate:Date?
    var isRunning = false
    
    override init() {
        super.init()
    }
    
    func reset(){
        
        invalidateTimer()
    }
    
    func start(){
        
        self.invalidateTimer()
        self.runTimer()
    }
    
    private func registerForTimer(){
        
        Log.echo(key: "yud", text: "Registering my self")
        
        self.signatureTimer.add {
            
            Log.echo(key: "yud", text: "Signature added")
            self.updateTimer()
        }
    }
    
    func currentDateTimeGMT()->Date{
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: "\(date))") ?? Date()
    }
   
    private func invalidateTimer(){
        
        self.signatureTimer.releaseListener()
        isRunning = false
    }
    
    private func runTimer(){
        
        if isRunning{
            return
        }
        self.signatureTimer.releaseListener()
        isRunning = true
        self.signatureTimer.start()
        self.registerForTimer()
    }
    
    
    func updateTimer(){
        
        Log.echo(key: "yud", text: "Required date is \(requiredDate)")
        
        if let date = requiredDate {
            
            Log.echo(key: "yud", text: "The current time date is \(currentDateTimeGMT()) and the Required Date is \(String(describing: requiredDate)) and the diffrence is \(date.timeIntervalTillNow)")
            
            let difference = date.timeIntervalTillNow
            
            Log.echo(key: "yud", text: "The diffrence in default timer is date is \(difference)")
            
            if difference <= -8 {
                
                screenShotListner?()
                self.invalidateTimer()
            }
        }
    }
}


