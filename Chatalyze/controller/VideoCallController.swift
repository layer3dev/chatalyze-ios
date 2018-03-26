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
    var callId : UUID?
    
    fileprivate var timer : EventTimer = EventTimer()

    
    
    fileprivate var audioManager : AudioManager?
    var callController : CXCallController?
    
    private var captureController : ARDCaptureController?
    
    var sdpOffer : [String : Any]?
    var userInfo : UserInfo?
    var slotInfo : EventSlotInfo?
    
    /*
     @property (strong, nonatomic) RTCVideoTrack *localVideoTrack;
     @property (strong, nonatomic) RTCVideoTrack *remoteVideoTrack;
     */
    
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
        
        socketClient?.initializeSocketConnection(roomId: (self.slotInfo?.roomId ?? ""))
    
        switchToCallRequest()
    }
    
    
    func registerForPing(){
        timer.startTimer(withInterval: 1.0)
        timer.ping {
            self.refresh()
        }
    }
    
    private func refresh(){
        
    }
    
    private func registerForListeners(){
        
//        {"id":"joinedCall","data":{"name":"chedddiicdaibdia"}}
        socketClient?.confirmConnect(completion: { (success) in
            
            guard let selfUserId = SignedUserInfo.sharedInstance?.hashedId
                else{
                    return
            }
            var param = [String : Any]()
            param["id"] = "joinedCall"
            
            var data = [String : Any]()
            data["name"] = selfUserId
            param["data"] = data
            self.socketClient?.emit(param)
        })
        
        //call initiation
        socketClient?.onEvent("startSendingVideo", completion: { (json) in
            self.processCallInitiation(data : json)
        })
        
        socketClient?.onEvent("startConnecting", completion: { (json) in
            self.initiateCall()
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
        
        
        initiateCall()
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
        timer = EventTimer()
        socketClient = SocketClient.sharedInstance
        registerForListeners()
    }
    
    
    private func registerForListenerss(){
        socketClient?.onEvent("disconnect", completion: { (data) in
            
             Log.echo(key: "call", text: "disconnect video call listner " )
            
            guard let info = data?.dictionaryObject
                else{
                    return
            }
            
            guard let userId = SignedUserInfo.sharedInstance?.hashedId
                else{
                    return
            }
            
            guard let targetId = info["userId"] as? String
                else{
                    return
            }
            
            guard let selfTargetId = self.userInfo?.hashedId
                else{
                    return
            }
            
            if(targetId == selfTargetId){
                self.hangup()
            }
        })
        
        
        rootView?.hangupListener(listener: {
            self.hangupAction()
            self.rootView?.callOverlayView?.isHidden = true
        })
    }
    
    
    private func acceptCall(){
        SocketClient.sharedInstance?.confirmConnect(completion: { (success) in
            if(success){
                self.startAcceptCall()
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
        
//        self.connection = ARDAppClient(userId: userId, andReceiverId: targetId, andDelegate:self)
//        self.connection?.processRawSDPOffer(sdpOffer)
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
    /*
     (void)appClient:(ARDAppClient *)client
     didCreateLocalCapturer:(RTCCameraVideoCapturer *)localCapturer {
     _videoCallView.localVideoView.captureSession = localCapturer.captureSession;
     ARDSettingsModel *settingsModel = [[ARDSettingsModel alloc] init];
     _captureController =
     [[ARDCaptureController alloc] initWithCapturer:localCapturer settings:settingsModel];
     [_captureController startCapture];
     }
     */
    
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
    
    
    /*
     if (self.localVideoTrack) {
     [self.localVideoTrack removeRenderer:self.localView];
     self.localVideoTrack = nil;
     [self.localView renderFrame:nil];
     }
     self.localVideoTrack = localVideoTrack;
     [self.localVideoTrack addRenderer:self.localView];
     */
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        
        /*guard let localView = rootView?.localVideoView
            else{
                return
        }
        
        if let localTrack = self.localTrack{
            localTrack.remove(localView)
            self.localTrack = nil
        }
        
        
        self.localTrack = localVideoTrack
        self.localTrack?.add(localView)*/
    }
    
    
    /*
     if (_remoteVideoTrack == remoteVideoTrack) {
     return;
     }
     [_remoteVideoTrack removeRenderer:_videoCallView.remoteVideoView];
     _remoteVideoTrack = nil;
     [_videoCallView.remoteVideoView renderFrame:nil];
     _remoteVideoTrack = remoteVideoTrack;
     [_remoteVideoTrack addRenderer:_videoCallView.remoteVideoView];
     */
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
        updateEndCall()
        self.dismiss(animated: true) {
            
        }
    }
    
    
    fileprivate func updateEndCall(){
        guard let callId = self.callId
            else{
                return
        }
        
        
        
        Log.echo(key: "call", text: "uuidString -> inside VideoCallController \(callId.uuidString))" )
        
        
        let endCallAction = CXEndCallAction(call: callId)
        let transaction = CXTransaction(action: endCallAction)
        
        
        self.callController?.request(transaction) { (error) in
            Log.echo(key: "call", text: "error -> \(String(describing: error?.localizedDescription))" )
        }
        self.callId = nil
    }
}


/*
 -(void)startCallRing{
 [self stopCallRing];
 [[self ringSoundHandler] playAudio];
 self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(processData:) userInfo:nil repeats:true];
 }
 
 -(void)stopCallRing{
 [[self timer] invalidate];
 [self setTimer:nil];
 [[self ringSoundHandler] stopAudio];
 }
 
 -(void)processData:(NSTimer *)timer{
 [self stopCallRing];
 //    [client disconnect];
 }
 
 fileprivate var timer : Foundation.Timer?
 
 init(delegate : TimerProtocol){
 self.delegate = delegate
 }
 
 func startTimer(interval : TimeInterval = 1.0){
 pauseTimer()
 
 timer = Foundation.Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(processData(_:)), userInfo: nil, repeats: true)
 
 }
 
 @objc func processData(_ timer : Foundation.Timer){
 DispatchQueue.main.async(execute: {
 self.delegate?.refresh()
 })
 
 }
 
 
 
 func pauseTimer(){
 guard let timerUW = timer
 else{
 return
 }
 timerUW.invalidate()
 timer = nil
 }
 */
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
