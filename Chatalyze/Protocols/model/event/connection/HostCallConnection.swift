//
//  HostCallConnection.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import TwilioVideo

class HostCallConnection: CallConnection {
    
    //New info above
    
    //This variable will store timestamp when signalling gets triggered from host and will be used as a timeout to restart signalling process after 10 seconds.
    
    //no need to use synced time here.
                
    var signallingStartTimestamp : Date?
    var isInitiated = false
    
    private var disposeListener : (()->())?
    
    override func callFailed(){
        super.callFailed()
        
        isInitiated = false
    }
    
    func setDisposeListener(disposeListener : (()->())?){
        self.disposeListener = disposeListener
    }
    
    func interval(){
    }
    
    private func processTimeout(){
        
        if(!isSignallingCompleted){
            return
        }
        
        guard let lastDisconnect = lastDisconnect
            else{
                return
        }
        
        Log.echo(key: "_connection_", text: "disconnect countdown \(lastDisconnect.timeIntervalSinceNow)")
        
        //no need to use synced time here
        if(lastDisconnect.timeIntervalSinceNow > -2){
            return
        }
        
        Log.echo(key: "_connection_", text: "disconnect timedout")
        self.lastDisconnect = nil
        // processCallFailure()
    }
    
    private func resetIfBroken(){
        
        let isSignallingBroken = isBroken()
        if(!isSignallingBroken){
            return
        }
        
        Log.echo(key: "_connection_", text: "signalling broken - resetting")
        
        signallingStartTimestamp = nil
        
        //not able to recover from unstable state in this case
        //      initateHandshake()
        
        //need to reset everything and restart
        // processCallFailure()
    }
    
    var isSignallingCompleted : Bool{
        if(signallingStartTimestamp == nil){
            return false
        }
        
        guard let connection = connection
            else{
                return false
        }
        
        return true
        //  return connection.isSignallingCompleted()
        
    }
    
    //dropped in between signalling
    func isBroken() -> Bool{
        
        //signalling not started
        guard let timestamp = signallingStartTimestamp
            else{
                return false
        }
        
        if(isSignallingCompleted){
            return false
        }
        
        Log.echo(key: "_connection_", text: "signalling countdown \(timestamp.timeIntervalSinceNow)")
        
        //no need to use synced time here
        if(timestamp.timeIntervalSinceNow > -10){
            return false
        }
        
        Log.echo(key: "_connection_", text: "signalling timedout")
        return true
    }
    
    
    override var targetHashId : String?{
        get{
            guard let senderHash = self.slotInfo?.user?.hashedId
                else{
                    return nil
            }
            return senderHash
        }
    }
    
    //overridden
    override var targetUserId : String?{
        
        get{
            guard let userId = self.slotInfo?.user?.id
                else{
                    return nil
            }
            return userId
        }
    }
    
    override func registerForListeners(){
        super.registerForListeners()
        
        socketListener?.onEvent("startReceivingVideo", completion: { [weak self] (json) in
            
            if(self?.socketClient == nil){
                return
            }
            
            guard let json = json
                else{
                    return
            }
            
            let sender = json["sender"].stringValue
            
            guard let targetHashId = self?.targetHashId
                else{
                    return
            }
            
            if(sender != targetHashId){
                Log.echo(key: "startReceivingVideo", text: "Not for me -> \(sender)")
                return
            }else{
                Log.echo(key: "startReceivingVideo", text: "For me -> \(sender)")
            }
            
            self?.completeHandshake(targetHashedId: sender)
        })
    }
    
    
    func completeHandshake(targetHashedId : String){

        guard let selfId = SignedUserInfo.sharedInstance?.hashedId
            else{
                return
        }
        
        var params = [String : Any]()
        params["sender"] = targetHashedId
        params["receiver"] = selfId
        
        socketClient?.emit(id: "startConnecting", data: params)
    }
    
    private func markSignallingAsStarted(){
        signallingStartTimestamp = Date()
    }
    
    private func sendHandshakeMessage(slotInfo : SlotInfo){
        
        guard let targetId = slotInfo.user?.hashedId
            else{
                return
        }
        
        guard let selfId = SignedUserInfo.sharedInstance?.hashedId
            else{
                return
        }
        
        var params = [String : Any]()
        params["sender"] = targetId
        params["receiver"] = selfId
        
        socketClient?.emit(id: "receiveVideoRequest", data: params)
    }
}


