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
    //temp
    static private var temp = 0
    var tempIdentifier = 0
    
    var connection : ARDAppClient?
    
    var eventInfo : EventInfo?
    var slotInfo : SlotInfo?
    var controller : VideoCallController?
    var localMediaPackage : CallMediaTrack?
    
    var connectionStateListener : CallConnectionProtocol?
    
    //This will tell, if connection is in ACTIVE state. If false, then user is not connected to other user.
    var isConnected : Bool = false
    var isStreaming : Bool = false
    
    //flag to see, if this connection is aborted and replaced by another connection
    var isAborted = false
    
    var isRendered = false
    
    
    /*flags*/
    var isLinked = false
    
    /*Strong References*/
    private var captureController : ARDCaptureController?
    private var localTrack : RTCVideoTrack?
    private var remoteTrack : CallMediaTrack?
    var socketClient : SocketClient?
    var socketListener : SocketListener?
    
    //connection = ARDAppClient(userId: userId, andReceiverId: targetId, andRoomId : roomId, andDelegate:self)
    
    init(eventInfo : EventInfo?, slotInfo : SlotInfo?, localMediaPackage : CallMediaTrack?, controller : VideoCallController?){
        super.init()
        
        CallConnection.temp = CallConnection.temp + 1
        tempIdentifier = CallConnection.temp
        
        self.eventInfo = eventInfo
        self.slotInfo = slotInfo
        self.localMediaPackage = localMediaPackage
        self.controller = controller        
        initialization()
         Log.echo(key: "_connection_", text: "\(tempIdentifier)  new state --> \(RTCIceConnectionState.new.rawValue)")
        Log.echo(key: "_connection_", text: "\(tempIdentifier)  connected state --> \(RTCIceConnectionState.connected.rawValue)")
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
        socketListener = socketClient?.createListener()
    }
    
    func registerForListeners(){
    }
    
    func getWriteConnection() ->ARDAppClient?{
       return nil
    }
    
    func callFailed(){
//        self.connection?.disconnect()
    }
    
    //prevent screen reset
    //make connection disappear without effecting remote renderer
    func abort(){
        isAborted = true
        removeLastRenderer()
        disconnect()
    }
    
    //follow all protocols of disconnect
    func disconnect(){
        
        self.connection?.disconnect()
        self.remoteTrack = nil
        self.captureController = nil
        self.socketClient = nil
        self.socketListener?.releaseListener()
        self.socketListener = nil
        resetRemoteFrame()
    }
    
}


extension CallConnection : ARDAppClientDelegate{
    
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
        if(isAborted){
            return
        }
        
        Log.echo(key: "_connection_", text: "\(tempIdentifier)  call state --> \(state.rawValue)")
        connectionStateListener?.updateConnectionState(state : state, slotInfo : slotInfo)
        if(state == .connected){
            self.controller?.acceptCallUpdate()
            isConnected = true
            isStreaming = true
            isCallConnected?()
            renderIfLinked()
            return
        }
        
        if(state == .disconnected){
            resetRemoteFrame()
            isStreaming = false
        }
        
        if(state == .failed){
            callFailed()
            isConnected = false
            isStreaming = false
            resetRemoteFrame()
            return
        }
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalSourceDelegate source: RTCVideoSource!) {
        
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        
        Log.echo(key: "_connection_", text: "\(tempIdentifier) didCreateLocalCapturer")
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
    
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteMediaTrack remoteTrack: CallMediaTrack?) {
        
        Log.echo(key: "_connection_", text: "\(tempIdentifier) didReceiveRemoteVideoTrack")
        if(isAborted){
            Log.echo(key: "_connection_", text: "\(tempIdentifier) isAborted didReceiveRemoteVideoTrack")
            return
        }
        
        self.remoteTrack = remoteTrack
        isRendered = false
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
    
    //only render if linked, but not if only pre-connected
    func renderIfLinked(){
        
        if(!isLinked){
            return
        }
        
        renderRemoteTrack()
    }
    
    func renderRemoteTrack(){
        
        Log.echo(key: "_connection_", text: "\(tempIdentifier) renderRemoteTrack")
        
        if(isAborted){
            return
        }
        
        if(isRendered){
            return
        }
        
        guard let remoteView = rootView?.remoteVideoView
            else{
                return
        }
        
        resetRemoteFrame()
        
        Log.echo(key: "_connection_", text: "\(tempIdentifier) renderRemoteVideo")
       
        self.remoteTrack?.videoTrack?.add(remoteView)
        
        self.remoteTrack?.audioTrack?.isEnabled = true
        
        isRendered = true
    }
    
    private func removeLastRenderer(){
        
        guard let remoteView = rootView?.remoteVideoView
            else{
                return
        }
        self.remoteTrack?.videoTrack?.remove(remoteView)
    }
    
    
    private func resetRemoteFrame(){
        
        if(isAborted){
            return
        }
        if(!isLinked){
            return
        }
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
}
