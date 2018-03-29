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
    var connectionInfo : [String : HostCallConnection] =  [String : HostCallConnection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    
    
    private func initialization(){
        initializeVariable()
    }
    
    
    private func initializeVariable(){
        self.registerForListeners()
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
        confirmCallLinked()
    }
    
    
    private func confirmCallLinked(){
        
        guard let slot = eventInfo?.currentSlot
            else{
                return
        }
        
        guard let connection = getWriteConnection(slotInfo: slot)
            else{
                return
        }
        
        if(slot.isLIVE){
            connection.linkCall()
        }
    }
    
    private func processEvent(){
        
        if(!(socketClient?.isConnected ?? false)){
            Log.echo(key: "processEvent", text: "processEvent -> socket not connected")
            return
        }
        else{
            Log.echo(key: "processEvent", text: "processEvent -> socket connected")
        }
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "processEvent", text: "processEvent -> eventInfo is nil")
                return
        }
    
        
        preconnectUser()
        connectLiveUser()
        disconnectStaleConnection()
        
    }
    
    private func disconnectStaleConnection(){
        for (_, connection) in connectionInfo {
            guard let slotInfo = connection.slotInfo
                else{
                    return
            }
            
            if(slotInfo.isExpired){
                connection.disconnect()
            }
        }
    }
    
    private func preconnectUser(){
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "processEvent", text: "preConnectUser -> eventInfo is nil")
                return
        }
        
        guard let preConnectSlot = eventInfo.preConnectSlot
            else{
                Log.echo(key: "processEvent", text: "preConnectUser -> preconnectSlot is nil")
                return
        }
        
        connectUser(slotInfo: preConnectSlot)
    }
    
    private func connectLiveUser(){
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "processEvent", text: "preConnectUser -> eventInfo is nil")
                return
        }
        
        guard let slot = eventInfo.currentSlot
            else{
                Log.echo(key: "processEvent", text: "preConnectUser -> preconnectSlot is nil")
                return
        }
        
        connectUser(slotInfo: slot)
    }
    
    private func connectUser(slotInfo : SlotInfo?){
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "processEvent", text: "connectUser -> eventInfo is nil")
                return
        }
        
        guard let slot = slotInfo
            else{
                Log.echo(key: "processEvent", text: "connectUser -> slot is nil")
                return
        }
        
        
        
        guard let connection = getWriteConnection(slotInfo : slot)
            else{
                Log.echo(key: "processEvent", text: "connectUser -> getWriteConnection is nil")
                return
        }
        
        guard let targetHashedId = slot.user?.hashedId
            else{
                Log.echo(key: "processEvent", text: "connectUser -> targetHashedId is nil")
                return
        }
        
        if(!isOnline(hashId: targetHashedId)){
            Log.echo(key: "processEvent", text: "connectUser -> user is offline")
            return
        }
        if(connection.isInitiated){
            return
        }
        Log.echo(key: "processEvent", text: "connectUser -> initateHandshake")
        connection.initateHandshake()
        
        
    }
    
    private func isOnline(hashId : String)->Bool{
        for peerInfo in peerInfos {
            if(peerInfo.name == hashId && peerInfo.isBroadcasting){
                return true
            }
        }
        return false
    }
    
    
    
    private func getWriteConnection(slotInfo : SlotInfo?) ->HostCallConnection?{
        guard let slotInfo = slotInfo
            else{
                return nil
        }
        
        guard let targetHashedId = slotInfo.user?.hashedId
            else{
                return nil
        }
        
        
        var connection = connectionInfo[targetHashedId]
        if(connection == nil){
            connection = HostCallConnection(eventInfo: eventInfo, slotInfo: slotInfo, controller: self)
        }
        connectionInfo[targetHashedId] = connection
        return connection
        
    }
    
    //{"id":"receiveVideoRequest","data":{"sender":"chedddiicdaibdia","receiver":"jgefjedaafbecahc"}}
    
    
    override func hangup(){
        super.hangup()
        
        for (_, connection) in connectionInfo {
            connection.disconnect()
        }
    }
    
    
}


//instance
extension HostCallController{
    class func instance()->HostCallController?{
        let storyboard = UIStoryboard(name: "call_view", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "host_video_call") as? HostCallController
        
        return controller
    }
}
