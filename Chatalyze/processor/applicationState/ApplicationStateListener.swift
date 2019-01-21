//
//  ApplicationStateListener.swift
//  Chatalyze
//
//  Created by Sumant Handa on 21/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class ApplicationStateListener{
    
    private var backgroundListener : (()->())?
    private var foregroundListener : (()->())?
    
    private var isReleased = false
    
    init() {
        registerForAppState()
    }
    
    func setBackgroundListener(backgroundListener : (()->())?){
        self.backgroundListener = backgroundListener
    }
    
    func setForegroundListener(foregroundListener : (()->())?){
        self.foregroundListener = foregroundListener
    }
    
    private func registerForAppState(){
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    private func unregisterForAppState(){
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    @objc func appMovedToBackground() {
        if(isReleased){
            return
        }
        backgroundListener?()
    }
    
    @objc func appMovedToForeground() {
        if(isReleased){
            return
        }
        foregroundListener?()
    }
    
    func releaseListener(){
        backgroundListener = nil
        foregroundListener = nil
        isReleased = true
    }
    
}
