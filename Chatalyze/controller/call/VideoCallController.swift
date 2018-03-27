//
//  VideoCallControllerViewControl.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import CallKit
import Foundation
import SwiftyJSON


class VideoCallController : InterfaceExtendedController {

    private var connection : ARDAppClient?
    private var localTrack : RTCVideoTrack?
    private var remoteTrack : RTCVideoTrack?
    var socketClient : SocketClient?
    
    
    fileprivate var audioManager : AudioManager?
    
    private var captureController : ARDCaptureController?
    
    var sdpOffer : [String : Any]?
    var userInfo : UserInfo?
    var slotInfo : EventSlotInfo?
    

    
    var rootView : VideoRootView?{
        return self.view as? VideoRootView
    }
    
    var actionContainer : VideoActionContainer?{
        return rootView?.actionContainer
    }
    
    
    
    @IBAction private func audioMuteAction(){
       guard let connection = self.connection
        else{
            return
        }
        if(connection.isAudioMuted){
            connection.unmuteAudioIn()
            actionContainer?.audioView?.unmute()
        }else{
            connection.muteAudioIn()
            actionContainer?.audioView?.mute()
        }
    }
    
    
    @IBAction private func videoDisableAction(){
        
        guard let connection = self.connection
            else{
                return
        }
        
        if(connection.isVideoMuted){
            connection.unmuteVideoIn()
            actionContainer?.videoView?.unmute()
        }else{
            connection.muteVideoIn()
            actionContainer?.videoView?.mute()
        }
    }
    
    
    @IBAction private func hangupAction(){
        self.hangup()
        updateUserOfHangup()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        socketClient?.disconnect()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initialization(){
        
        initializeVariable()
        audioManager = AudioManager()
        
        socketClient?.connect(roomId: (self.slotInfo?.roomId ?? ""))
        
        switchToCallRequest()
    }
    
    private func updateUserOfHangup(){
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        
        guard let targetId = self.userInfo?.hashedId
            else{
                return
        }
        
        var data = [String : Any]()
        data["userId"] = userId
        data["receiverId"] = targetId
        data["message"] = "User hangup the call !"
        
        socketClient?.emit("disconnect", data)
        
    }

   
    
    
   
    
    private func registerForListeners(){
        
//        {"id":"joinedCall","data":{"name":"chedddiicdaibdia"}}
        socketClient?.confirmConnect(completion: { [weak self] (success)  in
            if(self?.socketClient == nil){
                return
            }
            guard let selfUserId = SignedUserInfo.sharedInstance?.hashedId
                else{
                    return
            }
            var param = [String : Any]()
            param["id"] = "joinedCall"
            
            var data = [String : Any]()
            data["name"] = selfUserId
            param["data"] = data
            self?.socketClient?.emit(param)
        })
        
        //call initiation
        socketClient?.onEvent("startSendingVideo", completion: { [weak self] (json) in
            if(self?.socketClient == nil){
                return
            }
            self?.processCallInitiation(data : json)
        })
        
        socketClient?.onEvent("startConnecting", completion: { [weak self] (json) in
            if(self?.socketClient == nil){
                return
            }
            self?.initiateCall()
        })
        
        rootView?.hangupListener(listener: {
            self.hangupAction()
            self.rootView?.callOverlayView?.isHidden = true
        })
    }
    
    //{"id":"startSendingVideo","data":{"receiver":"jgefjedaafbecahc"}}
    private func processCallInitiation(data : JSON?){
        
        guard let json = data
            else{
                return
        }
        
        let receiverId = json["receiver"].stringValue
        
        guard let targetId = self.userInfo?.hashedId
            else{
           return
        }
        
        if(targetId != receiverId){
            return
        }
        
        
        var params = [String : Any]()
        params["id"] = "startReceivingVideo"
        
        var data = [String : Any]()
        data["sender"] = SignedUserInfo.sharedInstance?.hashedId
        data["receiver"] = self.userInfo?.hashedId
        
        params["data"] = data
        
        socketClient?.emit(params)
    }
    
    
    //{"id":"startConnecting","data":{"sender":"jgefjedaafbecahc"}}
    private func processHandshakeResponse(data : JSON?){
        guard let json = data
            else{
                return
        }
        
        let receiverId = json["sender"].stringValue
        
        guard let targetId = self.userInfo?.hashedId
            else{
                return
        }
        
        if(targetId == receiverId){
            return
        }
        
        
        //initiateCall()
    }
    
    func switchToCallAccept(){
        self.rootView?.confirmViewLoad(listener: {
            self.rootView?.switchToCallAccept()
        })
    }
    
    func switchToCallRequest(){
        self.rootView?.confirmViewLoad(listener: {
            self.rootView?.switchToCallRequest()
        })
    }
    
    private func initializeVariable(){
        socketClient = SocketClient.sharedInstance
        registerForListeners()
    }
    

    
    private func acceptCall(){
        SocketClient.sharedInstance?.confirmConnect(completion: { [weak self] (success) in
            if(success){
                self?.startAcceptCall()
            }
        })
    }
    
    
    private func startAcceptCall(){
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        
        guard let targetId = self.userInfo?.hashedId
            else{
                return
        }
        

    }
    
    private func initiateCall(){
        guard let userId = SignedUserInfo.sharedInstance?.hashedId
            else{
                return
        }
        
        guard let targetId = self.userInfo?.hashedId
            else{
                return
        }
        
        guard let roomId = self.slotInfo?.roomId
            else{
                return
        }
        
        self.connection = ARDAppClient(userId: userId, andReceiverId: targetId, andRoomId : roomId, andDelegate:self)
        connection?.initiateCall()
        startCallRing()
    }
    
}

extension VideoCallController : ARDAppClientDelegate{
    
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
        Log.echo(key: "call", text: "call state --> \(state.rawValue)")
        
        if(state == .connected){
            acceptCallUpdate()
           
            return
        }
        
        if(state == .failed){
            stopCall()
            return
        }
    }
    
    
    func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        guard let localView = rootView?.localVideoView
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
        self.remoteTrack?.add(remoteView)

    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        
    }
    
    
    func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
        
    }
    
}


//actionButtons
extension VideoCallController{
    
    fileprivate func hangup(){
        self.remoteTrack = nil
        self.rootView?.localVideoView?.captureSession = nil
        self.captureController = nil
        
        self.connection?.disconnect()
        self.socketClient?.disconnect()
        
        self.connection = nil
        self.socketClient = nil
        self.dismiss(animated: true) {
            
        }
    }
    
}


extension VideoCallController{
    func startCallRing(){

    }
    
    func acceptCallUpdate(){
        stopCallRequest()
    }
    
    func stopCall(){
        self.hangupAction()
        stopCallRequest()
    }
    
    func stopCallRequest(){
         self.rootView?.switchToCallAccept()
    }
}


//instance
extension VideoCallController{
    class func instance()->VideoCallController?{
        let storyboard = UIStoryboard(name: "call_view", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "video_call") as? VideoCallController
        
        return controller
    }
}
