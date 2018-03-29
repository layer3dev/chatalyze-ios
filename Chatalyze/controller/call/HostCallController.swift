//
//  HostCallController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 27/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class HostCallController: VideoCallController {
    
    var peerInfos : [PeerInfo] = [PeerInfo]()
    var connectionInfo : [String : ARDAppClient] =  [String : ARDAppClient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    
    
    private func initialization(){
        initializeVariable()
    }
    
    
    private func initializeVariable(){
        
    }
    
    override func registerForListeners(){
        super.registerForListeners()
        
        socketClient?.onEvent("updatePeerList", completion: { [weak self] (json) in
            if(self?.socketClient == nil){
                return
            }
            
            self?.processUpdatePeerList(json: json)
        })
        
        
        //{"id":"startReceivingVideo","data":{"sender":"chedddiicdaibdia"}}
        socketClient?.onEvent("startReceivingVideo", completion: { [weak self] (json) in
            if(self?.socketClient == nil){
                return
            }
            
        })
        
    }
    
    private func processUpdatePeerList(json : JSON?){
        guard let json = json
            else{
                return
        }
        
        var peerInfos = [PeerInfo]()
        let rawPeerInfos = json.arrayValue
        
        for rawPeerInfo in rawPeerInfos {
            let peerInfo = PeerInfo(info : rawPeerInfo)
            peerInfos.append(peerInfo)
        }
        
        self.peerInfos = peerInfos
    }
    
    override func interval(){
        processEvent()
    }
    
    private func processEvent(){
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        if(!eventInfo.isPreconnectEligible){
            return
        }
        
    }
    
    
    private func preConnectUser(){
        
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        guard let preconnectSlot = eventInfo.preConnectSlot
            else{
                return
        }
        
        guard let connection = getWriteConnection(slotInfo : preconnectSlot)
            else{
                return
        }
        
        initateHandshake(slotInfo : preconnectSlot)
        
        
    }
    
    
    
    private func getWriteConnection(slotInfo : SlotInfo?) ->ARDAppClient?{
        guard let slotInfo = slotInfo
            else{
                return nil
        }
        
        guard let targetId = slotInfo.user?.id
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
        
        var connection = connectionInfo[targetId]
        if(connection == nil){
            connection = ARDAppClient(userId: userId, andReceiverId: targetId, andRoomId : roomId, andDelegate:self)
        }
        
        return connection
        
    }
    
    //{"id":"receiveVideoRequest","data":{"sender":"chedddiicdaibdia","receiver":"jgefjedaafbecahc"}}
    
    private func initateHandshake(slotInfo : SlotInfo){
        sendHandshakeMessage(action: "receiveVideoRequest", slotInfo: slotInfo)
    }
    
    private func completeHandshake(targetHashedId : String){
       
        guard let selfId = SignedUserInfo.sharedInstance?.hashedId
            else{
                return
        }
        

        var params = [String : Any]()
        params["sender"] = targetHashedId
        params["receiver"] = selfId
        
        socketClient?.emit(id: "startConnecting", data: params)
    }
    
    private func sendHandshakeMessage(action : String, slotInfo : SlotInfo){
        
        guard let targetId = slotInfo.user?.id
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

    
    
}
