//
//  CallConnection.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit

//This is root class meant to be overriden by Host Connection and User Connection
//abstract:
class CallConnection: NSObject {
    
    var connection : ARDAppClient?
    
    var eventInfo : EventInfo?
    var slotInfo : SlotInfo?
    var controller : VideoCallController?
    var localMediaPackage : CallMediaTrack?
    
    var connectionStateListener : CallConnectionProtocol?
    
    //This will tell, if connection is in ACTIVE state. If false, then user is not connected to other user.
    var isConnected : Bool = false
    
    
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
    
    var isCallConnected:(()->())?
    
    
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
        connectionStateListener?.updateConnectionState(state : state, slotInfo : slotInfo)
        if(state == .connected){
            
            self.controller?.acceptCallUpdate()
            isConnected = true
            isCallConnected?()
            return
        }
        
        if(state == .disconnected){
            resetRemoteFrame()
        }
        
        if(state == .failed){
            callFailed()
            isConnected = false
            resetRemoteFrame()
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
        resetRemoteFrame()
//        self.remoteTrack?.remove(remoteView)
//        self.remoteTrack = nil
        
        
        Log.echo(key: "render", text: "renderRemoteVideo")
       
        self.remoteTrack?.videoTrack?.add(remoteView)
        self.remoteTrack?.audioTrack?.isEnabled = true
    }
    
    
    private func resetRemoteFrame(){
        
        guard let remoteView = rootView?.remoteVideoView
            else{
                return
        }
        remoteView.renderFrame(nil)
        remoteView.setSize(CGSize.zero)
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        
    }
    
    func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
        
    }
    
    func resetFlagsForReconnect(){
        isLinked = false
        
    }
}

