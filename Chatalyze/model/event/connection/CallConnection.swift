//
//  CallConnection.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class CallConnection: NSObject {
    var connection : ARDAppClient?
    
    var targetUserInfo : UserInfo?
    var eventInfo : EventInfo?
    var slotInfo : SlotInfo?
    var controller : VideoCallController?
    
    
    /*Strong References*/
    private var captureController : ARDCaptureController?
    private var localTrack : RTCVideoTrack?
    private var remoteTrack : RTCVideoTrack?
    
    //connection = ARDAppClient(userId: userId, andReceiverId: targetId, andRoomId : roomId, andDelegate:self)
    
    
    init(targetUserInfo : UserInfo, eventInfo : EventInfo?, slotInfo : SlotInfo?, controller : VideoCallController?){
        super.init()
        
        self.targetUserInfo = targetUserInfo
        self.eventInfo = eventInfo
        self.slotInfo = slotInfo
    }
    
    var roomId : String?{
        get{
            return self.eventInfo?.roomId
        }
    }
    
    
    var rootView : VideoRootView?{
        return controller?.rootView
    }
    
    override init() {
        super.init()
        
        initialization()
    }
    
    private func initialization(){
        initVariable()
    }
    
    private func initVariable(){
        self.connection = self.getWriteConnection()
    }
    
    
    private func getWriteConnection() ->ARDAppClient?{
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
        
        connection = ARDAppClient(userId: userId, andReceiverId: targetId, andRoomId : roomId, andDelegate:self)
        
        return connection
        
    }
    
    
}


extension CallConnection : ARDAppClientDelegate{
    
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
        Log.echo(key: "call", text: "call state --> \(state.rawValue)")
        
        if(state == .connected){
//            acceptCallUpdate()
            
            return
        }
        
        if(state == .failed){
//            stopCall()
            return
        }
    }
    
    
    func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        guard let localView = controller?.rootView?.localVideoView
            else{
                return
        }
        
        let captureSession = localCapturer.captureSession
        localView.captureSession = captureSession
        let settingsModel = ARDSettingsModel()
        captureController = ARDCaptureController(capturer: localCapturer, settings: settingsModel)
        captureController?.startCapture()
        
    }
    
    
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        
    }
    
    
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        
        guard let remoteView = rootView?.remoteVideoView
            else{
                return
        }
        
        self.remoteTrack?.remove(remoteView)
        self.remoteTrack = nil
        remoteView.renderFrame(nil)
        
        self.remoteTrack = remoteVideoTrack
        
    }
    
    func renderRemoteVideo(){
        guard let remoteView = rootView?.remoteVideoView
            else{
                return
        }
        self.remoteTrack?.add(remoteView)
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        
    }
    
    
    func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
        
    }
    
}

