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
   
    //user for animatingLable
    var label = UILabel()
    var isAnimate: Bool  = false
    let duration = 1.0
    let fontSizeSmall: CGFloat = 18
    var fontSizeBig: CGFloat = 45
    var isSmall: Bool = true
    //End
    
    var socketClient : SocketClient?
    private let eventSlotListener = EventSlotListener()
    private let streamCapturer = RTCSingletonStream()
    private var captureController : ARDCaptureController?
    var localMediaPackage : CallMediaTrack?
    
    private var accessManager : MediaPermissionAccess?
    
    private var localTrack : RTCVideoTrack?
    
    //used for tracking the call time and auto-connect process
    var timer : SyncTimer = SyncTimer()
    
    fileprivate var audioManager : AudioManager?
    
    var eventId : String? //Expected param
    var eventInfo : EventScheduleInfo?
    var eventExpiredHandler:((Bool,EventScheduleInfo?)->())?
    
    var peerInfos : [PeerInfo] = [PeerInfo]()
    

    let updatedEventScheduleListner = UpdateEventListener()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.fontSizeBig = 45
        }else{
            self.fontSizeBig = 28
        }
        // Do any additional setup after loading the view.
    }
    
    func eventScheduleUpdatedAlert(){
        
        updatedEventScheduleListner.setListener {
            self.fetchInfo(showLoader: false, completion: { (success) in
            })
        }
    }
    
    override func viewAppeared(){
        super.viewAppeared()
        
         processPermission()
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
     
        guard let localMediaPackage = self.localMediaPackage
        else{
            return
        }
        if(localMediaPackage.muteAudio){
            localMediaPackage.muteAudio = false
            actionContainer?.audioView?.unmute()
        }else{
            localMediaPackage.muteAudio = true
            actionContainer?.audioView?.mute()
        }
    }    
    
    @IBAction private func videoDisableAction(){
      
        guard let localMediaPackage = self.localMediaPackage
            else{
                return
        }
        if(localMediaPackage.muteVideo){
            localMediaPackage.muteVideo = false
            actionContainer?.videoView?.unmute()
        }else{
            localMediaPackage.muteVideo = true
            actionContainer?.videoView?.mute()
        }
    }
    
    @IBAction private func exitAction(){
        
        processExitAction()
    }
    
    func processExitAction(){
        
        timer.pauseTimer()
        self.exit()
        updateUserOfExit()
    }
    
    func exit(){
        
        self.dismiss(animated: false) {
            
            Log.echo(key: "yud", text: "Schedule iD is\(String(describing: self.eventInfo?.id))")
            //self.eventExpiredHandler?(self.isExpired(),self.eventInfo)
        }
    }
    
    func eventCompleted(){
        DispatchQueue.main.async {
            
            self.eventExpiredHandler?(self.isExpired(),self.eventInfo)
        }
    }
    
    func isExpired()->Bool{
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        //multipleVideoTabListner()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func processPermission(){
        
        let accessManager = MediaPermissionAccess(controller: self)
        self.accessManager = accessManager
        accessManager.verifyMediaAccess { (success) in
            if(!success){
                self.processExitAction()
                return
            }
            self.initialization()
        }
    }
    

    
     func initialization(){

        initializeVariable()
        audioManager = AudioManager()
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
    
    private func updateUserOfExit(){
       
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
            self.processExitAction()
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
        multipleVideoTabListner()
        startTimer()
        
        eventScheduleUpdatedAlert()
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
    //abstract
    func handleMultipleTabOpening(){
        
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
    
    func fetchInfoAfterActivatIngEvent(){
        
        self.fetchInfo(showLoader: true, completion: { (success) in
        })
    }
    
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
            
            //new event is updated with the old event local Parameters
            if let newSlotInfo = localEventInfo.slotInfos{
                for newinfo in newSlotInfo{
                    if let oldSlotInfo = self?.eventInfo?.slotInfos{
                        for oldInfo in oldSlotInfo{
                            if oldInfo.id == newinfo.id{
                                
                                //newinfo.isScreenshotSaved = oldInfo.isScreenshotSaved
                                newinfo.isSelfieTimerInitiated = oldInfo.isSelfieTimerInitiated
                            }
                        }
                    }
                }
            }
            
            self?.eventInfo = localEventInfo
            
            self?.verifyEventActivated()
            Log.echo(key: "yud", text: "Verification of the ScreenshotRequested id working!!")
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

extension VideoCallController{

    func mimicScreenShotFlash(){
        
        let flashView = UIView(frame: self.view.frame)
        flashView.backgroundColor = UIColor.white
        self.view.addSubview(flashView)
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {() -> Void in
           
            flashView.alpha = 0.0
        }, completion: { (done) -> Void in
            
            flashView.removeFromSuperview()
        })
    }
}

extension VideoCallController{
   
    func multipleVideoTabListner(){
        
        socketClient?.onEvent("multipleTabRequest", completion: { (json) in
            
            Log.echo(key : "socket_client", text : "Multiplexing Error: \(json)")
            
            if let dataDict = json?.dictionary{
                if let str = dataDict["id"]?.string{
                    if str == "multipleTabRequest"{
                        Log.echo(key: "socket_client", text: "Multiplexing Request accepted")
                        self.handleMultipleTabOpening()
                    }
                }
            }
        })
    }
    
   
    
    
//    So.socket?.onText = { (text: String) in
//    DispatchQueue.main.async {
//    Log.echo(key : "socket_client", text : "Received text: \(text)")
//    guard let data = text.data(using: .utf8)
//    else{
//    return
//    }
//
//    let json = try? JSON(data : data)
//    self.handleEventResponse(json: json)
//    return
//    }
//    }
    
}
extension VideoCallController{
    
    func startLableAnimating(label:UILabel?){
        
        guard let lable = label else{
            return
        }
        self.label = lable
        self.isAnimate = true
        self.label.textColor = UIColor.red
        enlarge()
    }
    
    func stopLableAnimation(){
        
        
        shrink()
        self.label.textColor = UIColor.white
        self.isAnimate = false
    }
    
    private func enlarge(){
        
        if !isAnimate{
            return
        }
        
        var biggerBounds = label.bounds
        label.font = label.font.withSize(fontSizeBig)
        biggerBounds.size = label.intrinsicContentSize
        label.transform = scaleTransform(from: biggerBounds.size, to: label.bounds.size)
        label.bounds = biggerBounds
        
        //        UIView.animate(withDuration: duration) {
        //            self.label.transform = .identity
        //        }
        //
        //Animated
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = .identity
            
        }) { (success) in
            self.shrink()
        }
    }
    
    private func shrink(){
        
        if !isAnimate{
            return
        }
        
        let labelCopy = label.copyLabel()
        var smallerBounds = labelCopy.bounds
        labelCopy.font = label.font.withSize(fontSizeSmall)
        smallerBounds.size = labelCopy.intrinsicContentSize
        
        let shrinkTransform = scaleTransform(from: label.bounds.size, to: smallerBounds.size)
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = shrinkTransform
        }, completion: { done in
            self.label.font = labelCopy.font
            self.label.transform = .identity
            self.label.bounds = smallerBounds
            self.enlarge()
        })
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
}
