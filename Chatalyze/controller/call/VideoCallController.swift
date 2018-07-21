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
   
    var socketClient : SocketClient?
    private let eventSlotListener = EventSlotListener()
    private let streamCapturer = RTCSingletonStream()
    private var captureController : ARDCaptureController?
    var localMediaPackage : CallMediaTrack?
    
    private var localTrack : RTCVideoTrack?
    
    //used for tracking the call time and auto-connect process
    var timer : SyncTimer = SyncTimer()
    
    fileprivate var audioManager : AudioManager?
    
    var eventId : String? //Expected param
    var eventInfo : EventScheduleInfo?
    var eventExpiredHandler:((Bool,EventScheduleInfo?)->())?
    
    var peerInfos : [PeerInfo] = [PeerInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialization()
    }
    
    override func viewDidRelease() {
        super.viewDidRelease()
        
        ARDAppClient.releaseLocalStream()
        captureController?.stopCapture()
        appDelegate?.allowRotate = false
        eventSlotListener.setListener(listener: nil)
    UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        
        timer.pauseTimer()
        socketClient?.disconnect()
        self.socketClient = nil
    }
    
    var rootView : VideoRootView?{
        return self.view as? VideoRootView
    }
    
    var actionContainer : VideoActionContainer?{
        return rootView?.actionContainer
    }
    
    //public - Need to be access by child
    var peerConnection : ARDAppClient?{
        get{
            return nil
        }
    }
    
    @IBAction private func audioMuteAction(){
       guard let peerConnection = self.peerConnection
        else{
            return
        }
        if(peerConnection.isAudioMuted){
            peerConnection.unmuteAudioIn()
            actionContainer?.audioView?.unmute()
        }else{
            peerConnection.muteAudioIn()
            actionContainer?.audioView?.mute()
        }
    }    
    
    @IBAction private func videoDisableAction(){
      
        guard let peerConnection = self.peerConnection
            else{
                return
        }
        
        if(peerConnection.isVideoMuted){
            peerConnection.unmuteVideoIn()
            actionContainer?.videoView?.unmute()
        }else{
            peerConnection.muteVideoIn()
            actionContainer?.videoView?.mute()
        }
    }
    
    @IBAction private func hangupAction(){
        
        processHangupAction()
    }
    
    func processHangupAction(){
        
        timer.pauseTimer()
        self.hangup()
        updateUserOfHangup()
    }
    
    
    
    func hangup(){
        
       
        self.dismiss(animated: false) {
            
            Log.echo(key: "yud", text: "Schedule iD is\(self.eventInfo?.id)")
            
            DispatchQueue.main.async {
                
                self.eventExpiredHandler?(self.isExpired(),self.eventInfo)
            }
            //self.eventExpiredHandler?(self.isExpired(),self.eventInfo)
        }
    }
    
    func isExpired()->Bool{
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialization(){
        
        initializeVariable()
        audioManager = AudioManager()
        switchToCallRequest()
        startLocalStream()
        
        fetchInfo(showLoader: true) { [weak self] (success) in
            
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
        data["message"] = "User hangup the call!"
        socketClient?.emit("disconnect", data)
    }
    
    func registerForListeners(){

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
        
        rootView?.hangupListener(listener: {
            self.processHangupAction()
            self.rootView?.callOverlayView?.isHidden = true
        })
        
        socketClient?.onEvent("updatePeerList", completion: { [weak self] (json) in
            if(self?.socketClient == nil){
                return
            }
            
            self?.processUpdatePeerList(json: json)
        })
    }

    
    
    private func processUpdatePeerList(json : JSON?){
        guard let json = json
            else{
                return
        }
        
        var peerInfos = [PeerInfo]()
        let rawPeerInfos = json.arrayValue
        
        for rawPeerInfo in rawPeerInfos {
            let peerInfo = PeerInfo(info : rawPeerInfo)
            peerInfos.append(peerInfo)
        }
        
        self.peerInfos = peerInfos
    }
    
    
    func isOnline(hashId : String)->Bool{
        for peerInfo in peerInfos {
            if(peerInfo.name == hashId && peerInfo.isBroadcasting){
                return true
            }
        }
        return false
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
    
    var appDelegate : AppDelegate?{
        get{
            guard let delegate =  UIApplication.shared.delegate as? AppDelegate
                else{
                    return nil
            }
            return delegate
        }
    }
    
    private func initializeVariable(){
        appDelegate?.allowRotate = true
        
        eventSlotListener.eventId = self.eventId
        registerForEvent()
        
        socketClient = SocketClient.sharedInstance
        startTimer()
        
    }
    
    private func registerForEvent(){
        
        eventSlotListener.setListener {
            self.fetchInfo(showLoader: false, completion: { (success) in
                
            })
        }
        
    
    }
    
    private func startTimer(){
        timer.ping { [weak self] in
            self?.interval()
        }
        
        timer.startTimer()
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
    
    func callFailed(){
    }    
    
    //abstract
    func verifyEventActivated(){
        
    }
    
    func verifyScreenshotRequested(){
        
    }
}



//actionButtons
extension VideoCallController{
}


extension VideoCallController{
    func startCallRing(){

    }
    
    func acceptCallUpdate(){
        self.rootView?.switchToCallAccept()
    }

}


//instance
extension VideoCallController{
    
    fileprivate func fetchInfo(showLoader : Bool, completion : ((_ success : Bool)->())?){
        guard let eventId = self.eventId
            else{
                return
        }
        if(showLoader){
            self.showLoader()
        }
        
        CallEventInfo().fetchInfo(eventId: eventId) { [weak self] (success, info) in
            if(showLoader){
                self?.stopLoader()
            }
            
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
            
            self?.verifyEventActivated()
            self?.verifyScreenshotRequested()
            
            let roomId = localEventInfo.id ?? 0
            Log.echo(key : "service", text : "eventId - > \(roomId)")
            
            completion?(true)
            return
            
        }
    }
    
    
}


extension VideoCallController{
    
    func startLocalStream(){
        localMediaPackage = streamCapturer.getMediaCapturer {[weak self] (capturer) in
            
            guard let localCapturer = capturer
            else{
                return
            }
            
            guard let localView = self?.rootView?.localVideoView
             else{
             return
             }
             
             
             let captureSession = localCapturer.captureSession
//             localView.captureSession = captureSession
            
            
             let settingsModel = ARDSettingsModel()
             settingsModel.storeVideoResolutionSetting("1280x720")
             self?.captureController = ARDCaptureController(capturer: localCapturer, settings: settingsModel)
             self?.captureController?.startCapture()
        }
        
        guard let localView = rootView?.localVideoView
            else{
                return
        }
        
        
        if let localTrack = self.localTrack{
            localTrack.remove(localView)
            self.localTrack = nil
            localView.renderFrame(nil)
        }
        
        Log.echo(key: "local stream", text: "got local stream")
        
        self.localTrack = localMediaPackage?.videoTrack
        self.localTrack?.add(localView)
        
    
    }
}
