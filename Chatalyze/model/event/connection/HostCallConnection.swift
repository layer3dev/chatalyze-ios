//
//  HostCallConnection.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostCallConnection: CallConnection {
    
    
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
        if(isReleased){
            return
        }
        
        resetIfBroken()
    }
    
    private func resetIfBroken(){
        let isSignallingBroken = isBroken()
        if(!isSignallingBroken){
            return
        }
        
        signallingStartTimestamp = nil
        initateHandshake()
    }
    
    //dropped in between signalling
    func isBroken() -> Bool{
        guard let connection = connection
            else{
                return false
        }
        
        //signalling not started
        guard let timestamp = signallingStartTimestamp
            else{
                return false
        }
        
        if(connection.isSignallingCompleted()){
           return false
        }
        
        if(timestamp.timeIntervalTillNow > 10){
            return true
        }
        
        return false
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
    
    override func getWriteConnection() ->ARDAppClient?{
        guard let slotInfo = slotInfo
            else{
                return nil
        }
        
        guard let targetId = slotInfo.user?.hashedId
            else{
                return nil
        }
        
        guard let userId = SignedUserInfo.sharedInstance?.hashedId
            else{
                return nil
        }
        
        guard let roomId = self.roomId
            else{
                return nil
        }
        
        connection = ARDAppClient(userId: userId, andReceiverId: targetId, andEventId : eventId, andDelegate:self, andLocalStream:self.localMediaPackage)
        
        return connection
        
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
        signallingStartTimestamp = TimerSync.sharedInstance.getDate()
    }
    
    func initateHandshake(){
        markSignallingAsStarted()
        guard let slotInfo = self.slotInfo
            else{
                return
        }
        isInitiated = true
        sendHandshakeMessage(slotInfo: slotInfo)
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
    
    override func disconnect(){
        super.disconnect()
    }
}
