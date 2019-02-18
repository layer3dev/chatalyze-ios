//
//  ApplicationConfirmForeground.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class ApplicationConfirmForeground{
    
    private var stateListener : (()->())?
    
    private var isReleased = false
    
    init() {
        registerForAppState()
    }
    
 
    func confirmIfActive(listener : (()->())?){
        let state = UIApplication.shared.applicationState
        if state == .active {
            listener?()
            return
        }
        self.stateListener = listener
    }
    
    private func registerForAppState(){
        let notificationCenter = NotificationCenter.default
        

        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    private func unregisterForAppState(){
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
   
    
    @objc func appMovedToForeground() {
        if(isReleased){
            return
        }
        stateListener?()
        releaseListener()
    }
    
    func releaseListener(){
        stateListener = nil
        isReleased = true
    }
    
}
