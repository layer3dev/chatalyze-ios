//
//  CountdownListener.swift
//  Chatalyze
//
//  Created by Sumant Handa on 03/11/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class CountdownListener{
    
    var identifier : Int = 0
    var isReleased = false
    
    fileprivate var callbackList : [CallbackIdentifierInfo] = [CallbackIdentifierInfo]()
    
    
    init(){
        
        self.identifier = countdownProcessor?.add(listener: self) ?? 0
    }
    
    func releaseListener(){
        
        countdownProcessor?.release(identifier: identifier)
        callbackList.removeAll()
        isReleased = true
    }
    
    func start(){
        
        if(!isReleased){
            return
        }
        self.identifier = countdownProcessor?.add(listener: self) ?? 0
    }
    
    
    var countdownProcessor : CountdownProcessor?{
        
        return CountdownProcessor.sharedInstance()
    }
    
    func add(listener : @escaping ()->()){
        
        let callbackInfo = CallbackIdentifierInfo(callback: listener)
        callbackList.append(callbackInfo)
    }
    
    
    func release(identifier : Int){
        
        if(identifier == 0){
            return
        }
        
        let size = callbackList.count
        for index in  0 ..< size{
            let callback = callbackList[index]
            if(callback.uniqueIdentifier == identifier){
                callbackList.remove(at: index)
                return
            }
        }
    }
    
    func refresh() {
        
        for callback in callbackList {
            callback.listener?()
        }
    }
}
