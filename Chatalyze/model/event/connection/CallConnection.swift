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
    
    var eventInfo : EventInfo?
    var slotInfo : SlotInfo?
    var controller : VideoCallController?
    var localMediaPackage : CallMediaTrack?
    
    
    /*flags*/
    var isLinked = false
    
    /*Strong References*/
    private var captureController : ARDCaptureController?
    private var localTrack : RTCVideoTrack?
    private var remoteTrack : CallMediaTrack?
    
    var socketClient : SocketClient?
    
    //connection = ARDAppClient(userId: userId, andReceiverId: targetId, andRoomId : roomId, andDelegate:self)
    
    init(eventInfo : EventInfo?, slotInfo : SlotInfo?, localMediaPackage : CallMediaTrack?, controller : VideoCallController?){
        super.init()
        
        self.eventInfo = eventInfo
        self.slotInfo = slotInfo
        self.localMediaPackage = localMediaPackage
        self.controller = controller
        
        initialization()
    }
    
    var targetHashId : String?{
        get{
            return nil
        }
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
        registerForListeners()
    }
    
    private func initVariable(){
        self.connection = self.getWriteConnection()
        socketClient = SocketClient.sharedInstance
    }
    
    
    func registerForListeners(){
    }
    
    
    func getWriteConnection() ->ARDAppClient?{
       return nil
    }
    
    func callFailed(){
//        self.connection?.disconnect()
    }
    
    func disconnect(){
        self.connection?.disconnect()
        self.remoteTrack = nil
        self.captureController = nil
        self.socketClient = nil
    }
    
}


extension CallConnection : ARDAppClientDelegate{
    
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
        Log.echo(key: "call", text: "call state --> \(state.rawValue)")
        
        if(state == .connected){
            self.controller?.acceptCallUpdate()
            
            return
        }
        
        if(state == .failed){
            callFailed()
            return
        }
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalSourceDelegate source: RTCVideoSource!) {
        
    }
    
    
    func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        Log.echo(key: "render", text: "didCreateLocalCapturer")
        
        
    }
    
    
    
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
    
    }
    
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteMediaTrack remoteTrack: CallMediaTrack?) {
        
        Log.echo(key: "render", text: "didReceiveRemoteVideoTrack")
        
        
        self.remoteTrack = remoteTrack
        if(isLinked){
            renderRemoteTrack()
        }
    }
    
    
    func linkCall(){
        if(isLinked){
            return
        }
        isLinked = true
        renderRemoteTrack()
    }
    
    func renderRemoteTrack(){
        
        guard let remoteView = rootView?.remoteVideoView
            else{
                return
        }
        
//        self.remoteTrack?.remove(remoteView)
//        self.remoteTrack = nil
        remoteView.renderFrame(nil)
        
        Log.echo(key: "render", text: "renderRemoteVideo")
       
        self.remoteTrack?.videoTrack?.add(remoteView)
        self.remoteTrack?.audioTrack?.isEnabled = true
    }
    
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        
    }
    
    
    func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
        
    }
    
    
    func resetFlagsForReconnect(){
        isLinked = false
        
    }
    
    
}

