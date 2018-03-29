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
    
    
    /*flags*/
    var isLinked = false

    
    /*Strong References*/
    private var captureController : ARDCaptureController?
    private var localTrack : RTCVideoTrack?
    private var remoteTrack : RTCVideoTrack?
    
    var socketClient : SocketClient?
    
    //connection = ARDAppClient(userId: userId, andReceiverId: targetId, andRoomId : roomId, andDelegate:self)
    
    
    init(eventInfo : EventInfo?, slotInfo : SlotInfo?, controller : VideoCallController?){
        super.init()
        
        self.eventInfo = eventInfo
        self.slotInfo = slotInfo
        
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
            self.controller?.stopCall()
            return
        }
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalSourceDelegate source: RTCVideoSource!) {
        
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        Log.echo(key: "render", text: "didCreateLocalCapturer")
        
        guard let localView = controller?.rootView?.localVideoView
            else{
                return
        }
        
        
        let captureSession = localCapturer.captureSession
        if(localView.captureSession == nil){
            Log.echo(key: "local", text: "nil earlier, assigning new one")
            localView.captureSession = captureSession
        }else{
            Log.echo(key: "local", text: "already assigned, not setting new one")
        }
        
        
        let settingsModel = ARDSettingsModel()
       
        captureController = ARDCaptureController(capturer: localCapturer, settings: settingsModel)
        captureController?.startCapture()
        

    }
    
    
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        
    }
    
    
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        
        Log.echo(key: "render", text: "didReceiveRemoteVideoTrack")
        
        guard let remoteView = rootView?.remoteVideoView
            else{
                return
        }
        
        self.remoteTrack?.remove(remoteView)
        self.remoteTrack = nil
        remoteView.renderFrame(nil)
        
        self.remoteTrack = remoteVideoTrack
        
        if(isLinked){
            renderRemoteVideo()
        }
        
    }
    
    
    
    func linkCall(){
        if(isLinked){
            return
        }
        isLinked = true
        renderRemoteVideo()
    }
    
    func renderRemoteVideo(){
        Log.echo(key: "render", text: "renderRemoteVideo")
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
