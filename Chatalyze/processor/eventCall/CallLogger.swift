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
    
    private func extractState(stats : [RTCLegacyStatsReport]) ->  (local : String, remote : String)?{
        for info in stats{
            let rawInfo = info.values
            let connectionState = rawInfo["googActiveConnection"]
            if(connectionState != "true"){
                continue
            }
            let remote = rawInfo["googRemoteCandidateType"] ?? ""
            let local = rawInfo["googLocalCandidateType"] ?? ""
            return (local, remote)
            break
        }
        return nil
    }

    func logConnectionState(slotId : Int, connectionState : RTCIceConnectionState, stats : [RTCLegacyStatsReport]){
        
        let state = getRawConnectionState(state: connectionState)
        let connectionState = extractState(stats: stats)
        
        var statsInfo = [String : Any]()
        statsInfo["local"] = connectionState?.local
        statsInfo["remote"] = connectionState?.remote
        
        var meta = [String : Any]()
        meta["type"] = "state"
        meta["callbookingId"] = slotId
        meta["stats"] = statsInfo
        
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
    
    
    //var speedInfo = {maxSpeed : 0, minSpeed : 0, avgSpeed : 0};
    func logSpeed(speed : Double?){
        var speedInfo = [String : Any]()
        speedInfo["maxSpeed"] = speed
        speedInfo["minSpeed"] = speed
        speedInfo["avgSpeed"] = speed
        
        var info = [String : Any]()
        info["callbookingId"] = sessionId
        info["userId"] = userId
        info["targetUserId"] = userId
        info["log_type"] = "speed_logs"
        info["speed"] = speed
        info["meta"] = speedInfo
        
        emit(info: info)
    }
    
    @objc func logCandidate(candidate : [String : Any]){
        
        let type = "ice_candidate";
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
    
    private func parseStats(stats : [RTCLegacyStatsReport]) -> [[String : String]]{
        var list = [[String : String]]()
        for info in stats{
            let rawInfo = info.values
            list.append(rawInfo)
        }
        
        return list
    }
    
    @objc func logStats(slotId : Int, stats : [RTCLegacyStatsReport]){
        let parsedStats = parseStats(stats: stats)
        let type = "ice_stats"
        var meta = [String : Any]()
        meta["type"] = type
        meta["callbookingId"] = slotId
        
        let deviceInfo = DeviceApplicationInfo().rawInfo()

        var statsInfo = [String : Any]()
        statsInfo["plateform"] = deviceInfo
        statsInfo["data"] = parsedStats
        meta["stats"] = statsInfo
        
        
        
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
        Log.echo(key: "json dict", text: info.JSONDescription())
         userSocket?.socket?.emit("log", info)
    }
    
    
}
