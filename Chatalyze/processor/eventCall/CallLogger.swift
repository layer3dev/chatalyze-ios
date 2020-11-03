//
//  CallLogger.swift
//  Chatalyze
//
//  Created by Sumant Handa on 18/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON
import TwilioVideo

class CallLogger : NSObject {
    
    private var sessionId : String = "0"
    private var userId : String = "0"
    private var targetUserId : String = "0"
    private var userSocket : UserSocket? = UserSocket.sharedInstance
    
    private let TAG = "CallLogger"
    
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
    
    private func extractState(stats : [StatsReport]) ->  (local : String, remote : String)?{
        
        print("stats report Arrray is \(stats)")
        
//        for info in stats{
//            let rawInfo = info.values
//            let connectionState = rawInfo["googActiveConnection"]
//            if(connectionState != "true"){
//                continue
//            }
//            let remote = rawInfo["googRemoteCandidateType"] ?? ""
//            let local = rawInfo["googLocalCandidateType"] ?? ""
//            return (local, remote)
//            break
//        }
        return nil
    }

    func logConnectionState(slotId : Int, connectionState :Room.State , stats : [StatsReport]){
        
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
    
    private func parseStats(stats : [StatsReport]) -> [[String : String]]{
        var list = [[String : String]]()
        
        print("Count of the stats is \(stats)")
//        for info in stats{
//            print("Fetching the info in parse state")
//            
//            let rawInfo = info.values
//            list.append(rawInfo)
//        }
        
        return list
    }
    
    @objc func logStats(slotId : Int, stats : [StatsReport]){
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
    
    /*
     SocketService.emit('log', {
     height: height, width: width,
     chatId: chatId, sessionId: sessionId,
     log_type: 'videoResolution'
     });
     */
    func logVideoResolution(slotId : Int, size : CGSize){
       
        Log.echo(key : TAG, text : "logVideoResolution")
        
        var params = [String : Any]()
        params["chatId"] = slotId
        params["sessionId"] = sessionId
        
        params["width"] = size.width
        params["height"] = size.height
        params["log_type"] = "videoResolution"
        
        
        emit(info: params)
    }
    
    func logVideoResolutionHost( size : CGSize){
       
        Log.echo(key : TAG, text : "logVideoResolution")
        
        var params = [String : Any]()
        params["sessionId"] = sessionId
        
        params["width"] = size.width
        params["height"] = size.height
        params["log_type"] = "videoResolution"
        
        
        emit(info: params)
    }
    
    
    
    private func getRawConnectionState(state : Room.State)->String{
        let rawValue = state.rawValue

        switch rawValue {
        case 0:
            return "connecting"
        case 1:
            return "connected"
        case 2:
            return "disconnected"
        case 3:
            return "reconnecting"
        default:
            return "undefined"
        }
    }
    
    private func emit(info : [String : Any]){
        Log.echo(key: "json dict", text: info.JSONDescription())
        userSocket?.socket?.emit("log", info)
    }
}


    
extension CallLogger{
    
    //    1) trackAction(session.id, user.id, 'joinedroom', { userId: userId, chatId: cbId});
    //    2) trackAction(session.id, user.id, 'disconnected');
    //    3) LogTrackService.trackAction(session.id, user.id, 'remoteStreamDisplayed', { chatId: currentChat.id, userId: currentChat.userId });
    //    4) LogTrackService.trackAction(session.id, user.id, 'chatCompleted', { userId: currentChat.userId, chatId: currentChat.id}); -- call room
    //    5) LogTrackService.trackAction(session.id, user.id, 'websocketDisconnected'); -- leave call room
    //    6) LogTrackService.trackAction(session.id, user.id, 'gotRemoteTrack', { trackType: track.kind, userId: cb.userId, chatId: cb.id});
    //    7 )LogTrackService.trackAction(session.id, user.id, 'userConnected', {userId: cb.userId, chatId: cb.id});
    //    8) LogTrackService.trackAction(session.id, user.id, 'lostRemoteTrack', { trackType: track.kind, userId: cb.userId, chatId: cb.id});
    //    9) LogTrackService.trackAction(session.id, user.id, 'userDisconnected', {userId:cb.userId, chatId: cb.id});
    
    //        14 )LogTrackService.trackAction(session.id, user.id, 'userConnected', {userId: cb.userId, chatId: cb.id});
    //
    //        function trackAction (scheduleId, userId, action, meta){
    //         var data = merge({ action: action, date: (new Date()).toISOString() }, meta || {});
    //         var logText = {
    //           callbookingId: scheduleId,
    //           userId: userId,
    //           targetUserId: userId,
    //           log_type: 'call_logs',
    //           type : 'action_info',
    //           meta : data
    //         };
    //         SocketService.emit('log', logText);
    //        }
    
    
    
    func trackLogs(action:String,metaInfo:[String:Any]){
        
        var mainInfo = [String:Any]()
        var metaData = [String:Any]()
        metaData["date"] = "\(Date())"
        metaData["action"] = action
        
        let _ = metaInfo.filter({ metaData[$0.key] = $0.value
            return true
        })
        
        print("Partial data in trackLogs is \(mainInfo)")
        
        mainInfo["callbookingId"] = self.sessionId
        mainInfo["userId"] = self.userId
        mainInfo["targetUserId"] = targetUserId
        mainInfo["log_type"] = "call_logs"
        mainInfo["type"] = "action_info"
        mainInfo["meta"] = metaData
        
        print("Complete data in trackLogs is \(mainInfo)")
        emit(info: mainInfo)
    }
    
    
}
