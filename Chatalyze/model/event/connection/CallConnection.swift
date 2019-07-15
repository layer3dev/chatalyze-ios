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
    
    private var callLogger : CallLogger?
    
    //this variable will be used to speed up the re-connect. This will store last disconnect timestamp and will force to create a new connection after 2 seconds
    //For now, will be used at host's end, but could be used for user in future
    //no need to use synced time here
    var lastDisconnect : Date?
    
    //This will tell, if connection is in ACTIVE state. If false, then user is not connected to other user.
    //This is used for re-connect purposes as well
    var isConnected : Bool = false
    
    //isStreaming is different from isConnected.
    //This is used for tracking, if selfie-screenshot process can be initiated or not. Not used for re-connect purposes.
    var isStreaming : Bool = false
    
    //if connection had been released
    var isReleased : Bool = false
    
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
    
    //overridden
    var targetUserId : String?{
        
        get{
            return nil
        }
    }
    
    var connectionState : RTCIceConnectionState?{
        return connection?.getIceConnectionState();
    }
    
    //overridden
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
    
    var eventId : String?{
        let sessionId = eventInfo?.id ?? 0
        return "\(sessionId)"
        
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
        let eventId = eventInfo?.id ?? 0
        callLogger = CallLogger(sessionId: "\(eventId)", targetUserId: targetUserId)
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
        lastDisconnect = nil
        self.isReleased = true
        
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
        
        callLogger?.logConnectionState(connectionState: state)
        if(isAborted){
            return
        }
        
        Log.echo(key: "_connection_", text: "\(tempIdentifier)  call state --> \(state.rawValue)")
        connectionStateListener?.updateConnectionState(state : state, slotInfo : slotInfo)
        
        if(state == .connected){
           
            lastDisconnect = nil
            self.controller?.acceptCallUpdate()
            isConnected = true
            isStreaming = true
            isCallConnected?()
            renderIfLinked()
            resetVideoBounds()
            return
        }
        
        if(state == .disconnected){
            //no need to use synced time here
            lastDisconnect = Date()
            resetRemoteFrame()
            isStreaming = false
        }
        
        if(state == .failed){
            processCallFailure()
            return
        }
    }
    
    func processCallFailure(){
        if(isReleased){
            return
        }
        
         abort()
        
        /*isConnected = false
        isStreaming = false
        resetRemoteFrame()
        return*/
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
    
    //Needed to recover from black screen
    //once connection retreive from failure
    func resetVideoBounds(){
        if(!isLinked){
            return
        }
        
        if(isAborted){
            return
        }
        guard let remoteView = rootView?.remoteVideoView
            else{
                return
        }
        
        remoteView.resetBounds()
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
        
        //self.remoteTrack?.videoTrack?.source.
        
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
