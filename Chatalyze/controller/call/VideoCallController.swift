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
    
    //public - Need to be access by child
    var connection : ARDAppClient?
    
    var socketClient : SocketClient?
    
    //used for tracking the call time and auto-connect process
    var timer : EventTimer = EventTimer()
    
    fileprivate var audioManager : AudioManager?

    var eventId : String? //Expected param
    var eventInfo : EventScheduleInfo?
    
    /*Strong References*/
    private var captureController : ARDCaptureController?
    private var localTrack : RTCVideoTrack?
    private var remoteTrack : RTCVideoTrack?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialization()
    }
    
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
        processHangupAction()
    }
    
    func processHangupAction(){
        self.hangup()
        updateUserOfHangup()
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
        switchToCallRequest()
        
        fetchInfo { [weak self] (success) in
            if(!success){
                return
            }
            self?.processEventInfo()
        }
        
    
    }
    
    private func processEventInfo(){
        socketClient?.connect(roomId: (self.eventInfo?.roomId ?? ""))
    }
    
    
    
    
    private func updateUserOfHangup(){
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        
        /*guard let targetId = self.slotInfo?.user?.hashedId
            else{
                return
        }*/
        
        var data = [String : Any]()
        data["userId"] = userId
//        data["receiverId"] = targetId
        data["message"] = "User hangup the call !"
        
        socketClient?.emit("disconnect", data)
        
    }

   
    
    func registerForListeners(){
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
        startTimer()
    }
    
    private func startTimer(){
        timer.ping { [weak self] in
            self?.interval()
        }
        
        timer.startTimer(withInterval: 1.0)
    }
    
    func interval(){
        
    }
    

    
    private func acceptCall(){
        SocketClient.sharedInstance?.confirmConnect(completion: { [weak self] (success) in
            if(success){
                //self?.startAcceptCall()
            }
        })
    }
    
    
    var roomId : String?{
        get{
            return self.eventInfo?.roomId
        }
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
    
    fileprivate func fetchInfo(completion : ((_ success : Bool)->())?){
        guard let eventId = self.eventId
            else{
                return
        }
        
        self.showLoader()
        CallEventInfo().fetchInfo(eventId: eventId) { [weak self] (success, info) in
            
            self?.stopLoader()
            if(!success){
                completion?(false)
                return
            }
            
            guard let localEventInfo = info
                else{
                    completion?(false)
                    return
            }
            
            self?.eventInfo = localEventInfo
            
            let roomId = localEventInfo.id ?? 0
            Log.echo(key : "service", text : "eventId - > \(roomId)")
            
            completion?(true)
            return
            
        }
    }
}
