//
//  HostCallConnection.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostCallConnection: CallConnection {
    var isInitiated = false
    
    private var disposeListener : (()->())?
    
    override func callFailed(){
        super.callFailed()
        
        isInitiated = false
    }
    
    func setDisposeListener(disposeListener : (()->())?){
        self.disposeListener = disposeListener
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
        
        connection = ARDAppClient(userId: userId, andReceiverId: targetId, andRoomId : roomId, andDelegate:self, andLocalStream:self.localMediaPackage)
        
        return connection
        
    }
    
    
    override func registerForListeners(){
        super.registerForListeners()
        
        socketClient?.onEvent("startReceivingVideo", completion: { [weak self] (json) in
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
    
    
    func initateHandshake(){
        guard let slotInfo = self.slotInfo
            else{
                return
        }
        isInitiated = true
        sendHandshakeMessage(action: "receiveVideoRequest", slotInfo: slotInfo)
    }
    
    
    private func sendHandshakeMessage(action : String, slotInfo : SlotInfo){
        
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
        
        socketClient?.emit(id: action, data: params)
    }
    
    override func disconnect(){
        super.disconnect()
    }
}
