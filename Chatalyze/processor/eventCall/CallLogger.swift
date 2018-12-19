//
//  CallLogger.swift
//  Chatalyze
//
//  Created by Sumant Handa on 18/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class CallLogger : NSObject {
    
    private var sessionId : String = "0"
    private var userId : String = "0"
    private var targetUserId : String = "0"
    private var userSocket : UserSocket? = UserSocket.sharedInstance
    
    override init() {
        super.init()
    }
    
    @objc init(sessionId : String?, targetUserId : String? = nil){
        super.init()
        self.sessionId = sessionId ?? "0"
        let userId = SignedUserInfo.sharedInstance?.id ?? "0"
        self.userId = userId
        self.targetUserId = targetUserId ?? userId
    }
    
    
    
    func logDeviceInfo(){
        let deviceInfo = DeviceApplicationInfo().rawInfo()
        var meta = [String : Any]()
        meta["info"] = deviceInfo
        meta["type"] = "system_info"
        
        
        var info = [String : Any]()
        info["callbookingId"] = sessionId
        info["userId"] = userId
        info["targetUserId"] = userId
        info["log_type"] = "call_logs"
        info["type"] = "system_info"
        info["meta"] = meta
        
    
        emit(info: info)
    }

    func logConnectionState(connectionState : RTCIceConnectionState){
        
        let state = getRawConnectionState(state: connectionState)
        
        var meta = [String : Any]()
        meta["type"] = "state"
        meta["callbookingId"] = sessionId
        
        var info = [String : Any]()
        info["callbookingId"] = sessionId
        info["userId"] = userId
        info["targetUserId"] = targetUserId
        info["log_type"] = "ice_logs"
        info["connection_state"] = state
        info["meta"] = meta
        
        
        emit(info: info)
    }
    
    func logUpdatePeerList(rawInfo : JSON?){
        
        guard let rawInfo = rawInfo
            else{
                return
        }
        Log.echo(key: "json peerlist", text: "\(rawInfo.arrayValue)")
        let type = "update_peer_list"
        var meta = [String : Any]()
        meta["type"] = type
        meta["peer_infos"] = rawInfo.arrayObject
        
        var info = [String : Any]()
        info["callbookingId"] = sessionId
        info["userId"] = userId
        info["targetUserId"] = userId
        info["log_type"] = "call_logs"
        info["type"] = type
        info["meta"] = meta
        
        emit(info: info)
    }
    
    @objc func logCandidate(candidate : [String : Any]){
        
        let type = "candidate";
        var meta = [String : Any]()
        meta["info"] = candidate
        meta["type"] = type
        meta["callbookingId"] = sessionId
        
        
        var info = [String : Any]()
        info["callbookingId"] = sessionId
        info["userId"] = userId
        info["targetUserId"] = userId
        info["log_type"] = "call_logs"
        info["type"] = type
        info["meta"] = meta
        
        emit(info: info)
    }
    
    @objc func logSdp(type : String, sdp : [String : Any]){
        let type = "sdp";
        var meta = [String : Any]()
        meta["sdp_type"] = type
        meta["info"] = sdp
        meta["type"] = type
        meta["callbookingId"] = sessionId
        
        
        var info = [String : Any]()
        info["callbookingId"] = sessionId
        info["userId"] = userId
        info["targetUserId"] = userId
        info["log_type"] = "call_logs"
        info["type"] = type
        info["meta"] = meta
        
        emit(info: info)
    }
    
    func logSocketConnectionState(){
        
        let type = "websocket_connection_state"
        var meta = [String : Any]()
        meta["type"] = type
        meta["user_connection_state"] = "connected"
        
        var info = [String : Any]()
        info["callbookingId"] = sessionId
        info["userId"] = userId
        info["targetUserId"] = userId
        info["log_type"] = "call_logs"
        info["type"] = type
        info["meta"] = meta
        
        emit(info: info)
        
    }
    
    
    
    private func getRawConnectionState(state : RTCIceConnectionState)->String{
        switch state {
        case .checking:
            return "checking"
        case .closed:
            return "closed"
        case .connected:
            return "connected"
        case .completed:
            return "completed"
        case .disconnected:
            return "disconnected"
        case .failed:
            return "failed"
        case .new:
            return "new"
        default:
            return "undefined"
        }
    }
    
    private func emit(info : [String : Any]){
         Log.echo(key: "json dict", text: "\(info)")
         let param = info.JSONDescription()
        
        Log.echo(key: "json string", text: "\(param)")
        
        userSocket?.socket?.emit("log", param)
    }
    
    
}
