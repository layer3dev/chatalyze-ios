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
    
    enum permissionsCheck:Int{
        
        case micPermission = 0
        case cameraPermission = 1
        case slowInternet  = 2
        case noInternet = 3
        case none = 4
    }
    
    enum exitCode {
        
        case userAction
        case expired
        case prohibited
        case mediaAccess
        case undefined
    }
    
    //In order to stop the continuos Internet Test.
    var shouldInternetTestStop = false
    
    //Required Permission.
    var requiredPermission:permissionsCheck?
    
    
    //Implementing the eventDeleteListener
    var eventDeleteListener = EventDeletedListener()
    
    //user for animatingLable
    var label = UILabel()
    var isAnimate: Bool  = false
    let duration = 0.5
    let fontSizeSmall: CGFloat = 16
    var fontSizeBig: CGFloat = 28
    var isSmall: Bool = true
    //End
    
    var socketClient : SocketClient?
    var socketListener : SocketListener?
    private let eventSlotListener = EventSlotListener()
    private let streamCapturer = RTCSingletonStream()
    private var captureController : ARDCaptureController?
    var localMediaPackage : CallMediaTrack?
    
    private var accessManager : MediaPermissionAccess?
    
    private var callLogger : CallLogger?
    
    private var localTrack : RTCVideoTrack?
    
    //used for tracking the call time and auto-connect process
    var timer : SyncTimer = SyncTimer()
    
    fileprivate var audioManager : AudioManager?
    
    var eventId : String? //Expected param
    var eventInfo : EventScheduleInfo?
    var feedbackListener : ((EventScheduleInfo?)->())?
    var peerInfos : [PeerInfo] = [PeerInfo]()
    
    let updatedEventScheduleListner = UpdateEventListener()
    
    
    //in case if user opens up 
    var isProhibited = false
    
    weak var lastPresentingController : UIViewController?
    
    @IBOutlet var chatalyzeLogo:UIImageView?
    @IBOutlet var preConnectLbl:UILabel?
    
    var roomType : UserInfo.roleType{
        return .user
    }
    
    var isSocketConnected : Bool{
        return (socketClient?.isConnected ?? false)
    }
    

    var appDelegate : AppDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            self.fontSizeBig = 24
        }else{
            
            self.fontSizeBig = 22
        }
        
        appDelegate =  UIApplication.shared.delegate as? AppDelegate
        initializeListenrs()
        // Do any additional setup after loading the view.
    }
    
    
    func initializeListenrs(){
        
        eventDeleteListener.setListener { (deletedEventID) in
            
            if self.eventId == deletedEventID{
                
                self.processExitAction(code: .userAction)
                Log.echo(key: "yud", text: "Matched Event Id is \(String(describing: deletedEventID))")
            }
        }
    }
    
    
    func eventScheduleUpdatedAlert(){
        
        updatedEventScheduleListner.setListener {
            
            self.loadActivatedInfo {[weak self] (isActivated, info) in
                
                Log.echo(key: "delay", text: "info received -> \(String(describing: info?.title))")
                
                guard let info = info
                    else{
                        return
                }
                


                //fixme: //why reconnecting to socket?
                //self?.connectToRoom(info: info)


                self?.eventInfo = info
                self?.processEventInfo()
                Log.echo(key: "delay", text: "processed")
                
                if(isActivated){
                    Log.echo(key: "delay", text: "event is activated")
                }
            }
        }
    }
    
    
    override func viewAppeared(){
        super.viewAppeared()
        
        Log.echo(key : "rotate", text : "viewAppeared in VideoCallController")
        processPermission()
    }
    
    
    override func viewDidRelease() {
        super.viewDidRelease()
        
        self.shouldInternetTestStop = true
        
        ARDAppClient.releaseLocalStream()
        captureController?.stopCapture()
        
        appDelegate?.allowRotate = false
        eventSlotListener.setListener(listener: nil)
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        
        timer.pauseTimer()
        socketClient?.disconnect()
        socketListener?.releaseListener()
        self.socketClient = nil
        self.socketListener = nil
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
    
    
    func resetMuteActions(){
        
        actionContainer?.audioView?.unmute()
        actionContainer?.videoView?.unmute()
        
        guard let localMediaPackage = self.localMediaPackage
            else{
                return
        }
        
        localMediaPackage.muteAudio = false
        localMediaPackage.muteVideo = false
    }
    
    
    @IBAction private func audioMuteAction(){
        
        guard let localMediaPackage = self.localMediaPackage
            else{
                return
        }
        
        if(localMediaPackage.isDisabled){
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
        if(localMediaPackage.isDisabled){
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
    

    func processExitAction(code : exitCode){
        
        timer.pauseTimer()
        self.exit(code : code)
        updateUserOfExit()
    }
    
    
    func exit(code : exitCode){
        
        self.dismiss(animated: false) {[weak self] in
            
            Log.echo(key: "log", text: "VideoCallController dismissed")
            self?.onExit(code : code)
        }
    }
    
    //This will be called after viewController is exited from the screen
    func onExit(code : exitCode){
    }
    
    func showErrorScreen(){
        
        guard let controller = OpenCallAlertController.instance() else{
            return
        }
        
        guard let presentingController =  self.lastPresentingController
            else{
                Log.echo(key: "_connection_", text: "presentingController is nil")
                return
        }
        presentingController.present(controller, animated: true, completion: nil)
    }
    
    func isExpired()->Bool{
        return false
    }
    
    func showFeedbackScreen(){
        
        guard let presentingController = self.lastPresentingController
            else{
                Log.echo(key: "_connection_", text: "presentingController is nil")
                return
        }
        guard let controller = ReviewController.instance() else{
            return
        }
        controller.eventInfo = eventInfo
        controller.dismissListner = {[weak self] in
            
            self?.feedbackListener?(self?.eventInfo)
        }
        presentingController.present(controller, animated: false, completion:{
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //multipleVideoTabListner()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func checkForInternet(){
        
        Log.echo(key: "yud", text: "CheckForInternet is calling")
        
        if !(InternetReachabilityCheck().isInternetAvailable()){
            
            self.requiredPermission = VideoCallController.permissionsCheck.noInternet
            self.showMediaAlert(alert:self.requiredPermission)
            return
        }
        
        CheckInternetSpeed().testDownloadSpeedWithTimeOut(timeOut: 10.0) { (speed, error) in
            
            DispatchQueue.main.async {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    
                    if self.shouldInternetTestStop{
                        return
                    }
                    self.checkForInternet()
                }
                
                if error == nil{
                    
                    let speedMb = (speed ?? 0.0) * 8
                    
                    //if (speed ?? 0.0) < 0.1875 {
                    //Due to frequent error of Poor Internet we are reducing our threshold speed 0.1875 to 0.13
                    
                    if (speedMb) < 1.5 {
                        
                        self.requiredPermission = VideoCallController.permissionsCheck.slowInternet
                        self.showMediaAlert(alert:self.requiredPermission)
                        return
                    }
                    self.requiredPermission = VideoCallController.permissionsCheck.none
                    return
                }
            }
        }
    }
    
    
    private func showMediaAlert(alert:permissionsCheck?){
        
        DispatchQueue.main.async {
            
            if self.presentedViewController as? MediaAlertController != nil{
                return
            }
            
            guard let controller = MediaAlertController.instance() else {
                return
            }
            
            controller.alert = self.requiredPermission ?? VideoCallController.permissionsCheck.none
            
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            
            self.present(controller, animated: true, completion: {
            })
        }        
    }
    
    private func processPermission(){
        
        let accessManager = MediaPermissionAccess(controller: self)
        self.accessManager = accessManager
        
        accessManager.verifyMediaAccess { (cameraAccess, micAccess) in
            
            if !cameraAccess{
                
                self.requiredPermission = VideoCallController.permissionsCheck.cameraPermission             
                self.showMediaAlert(alert:self.requiredPermission)
            }
            
            if !micAccess{
                
                self.requiredPermission = VideoCallController.permissionsCheck.micPermission
                self.showMediaAlert(alert:self.requiredPermission)
            }
            self.initialization()
            self.checkForInternet()
            Log.echo(key: "yud", text: "Access Manager permission for camera is \(cameraAccess) and for mic Access is \(micAccess)")
        }
        
    }
    
    var isActivated : Bool{
        
        guard let eventInfo = eventInfo
            else{
                return false
        }
        guard let _ = eventInfo.started
            else{
                return false
        }
        return true
    }
    
    
    //overridden
    func initialization(){
        
        Log.echo(key : "test", text : "who dared to initialize me ??")
        initializeVariable()
        audioManager = AudioManager()
        startLocalStream()
        showLoader()
        
        loadActivatedInfo {[weak self] (isActivated, info) in
            self?.stopLoader()
            
            Log.echo(key: "delay", text: "info received -> \(info?.title)")
            
            guard let info = info
                else{
                    return
            }
            
            self?.connectToRoom(info: info)
            self?.eventInfo = info
            
            self?.processEventInfo()
            
            Log.echo(key: "delay", text: "processed")
            
            self?.updateToReadyState()
            
            if(isActivated){
                
                Log.echo(key: "delay", text: "event is activated")
            }
        }
    }
    
    //overridden
    func processEventInfo(){

      
        self.checkForDelaySupport()

    }
    
    //This will still return info - even if call not activated.
    //if not activated - success will be false and info will have valid data
    private func loadActivatedInfo(completion : ((_ isActivated : Bool, _ info : EventScheduleInfo?)->())?){
        
        loadInfo {[weak self] (success, info) in
            if(!success){
                completion?(false, nil)
                return
            }
            
            guard let eventInfo = info
                else{
                    completion?(false, nil)
                    return
            }
            
            self?.verifyEventActivated(info: eventInfo, completion: { (success, info) in
                if(!success){                    
                    completion?(false, info)
                    return
                }
                //only the first time
                self?.verifyScreenshotRequested()
                completion?(true, info)
            })
            
        }
    }
    
    private func connectToRoom(info : EventScheduleInfo){
        
        socketClient?.connect(roomId: (info.roomId))
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
    
    
    private func updateToReadyState(){
        callLogger?.logSocketConnectionState()
        callLogger?.logDeviceInfo()
        
        
        socketListener?.newConnectionListener(completion: { [weak self] (success)  in
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
    
    func registerForListeners(){
        
        rootView?.hangupListener(listener: {
            
            self.processExitAction(code: .userAction)
            self.rootView?.callOverlayView?.isHidden = true
        })
        
        socketListener?.onEvent("updatePeerList", completion: { [weak self] (json) in
            
            if(self?.socketClient == nil){
                return
            }
            self?.callLogger?.logUpdatePeerList(rawInfo: json)
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
    
    
    func isPeerListFetched()->Bool{
        if(peerInfos.count == 0){
            return false
        }
        return true
    }
    
    //This method tells us, if target user is online and present in call room or not
    func isOnline(hashId : String)->Bool{
        for peerInfo in peerInfos {
            if(peerInfo.name == hashId && peerInfo.isBroadcasting){
                return true
            }
        }
        return false
    }
    
    //same as isOnline but won't check for isBroadcasting
    func isAvailableInRoom(hashId : String)->Bool{
        for peerInfo in peerInfos {
            if(peerInfo.name == hashId){
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
    
    
    //isolated from eventInfo
    private func initializeVariable(){
        
        callLogger = CallLogger(sessionId: eventId)
        appDelegate?.allowRotate = true
        lastPresentingController = self.presentingViewController
        
        eventSlotListener.eventId = self.eventId
        registerForEvent()
        
        socketClient = SocketClient.sharedInstance
        socketListener = socketClient?.createListener()
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
            self?.executeInterval()
        }
        
        timer.startTimer()
    }
    
    private func executeInterval(){
        
        if(!isActivated){
            return
        }
        interval()
    }
    
    func interval(){
        
        updateStatusMessage()
    }
    
    func updateStatusMessage(){
        
    }
    
    private func acceptCall(){
        
        socketListener?.confirmConnect(completion: { [weak self] (success) in
            
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
    func verifyEventActivated(info : EventScheduleInfo, completion : @escaping ((_ success : Bool, _ info  : EventScheduleInfo?)->())){
        
    }
    
    //abstract
    func handleMultipleTabOpening(){
        
    }
    
    func verifyScreenshotRequested(){
        
    }
    
    //to be overridden by child classes
    var isVideoCallInProgress : Bool{
        return false
    }
    
    //to be overridden by child classes
    var isSlotRunning:Bool{
        
        return false
    }
    
    //To be overridden
    func checkForDelaySupport(){
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
    
    func fetchInfoAfterActivatingEvent(){
        
        self.fetchInfo(showLoader: false, completion: { (success) in
        })
    }
    
    func loadInfo(completion : ((_ success : Bool, _ info : EventScheduleInfo? )->())?){
        
        guard let eventId = self.eventId
            else{
                return
        }
        
        CallEventInfo().fetchInfo(eventId: eventId) { (success, info) in
            
            if(!success){
                completion?(false, nil)
                return
            }
            
            guard var localEventInfo = info
                else{
                    completion?(false, nil)
                    return
            }
            
            Log.echo(key: "yud", text: "The fetched the call result is success")
            
            localEventInfo = self.transerState(info: localEventInfo)
            completion?(true, localEventInfo)
            return
        }
    }
    
    
    fileprivate func fetchInfo(showLoader : Bool, completion : ((_ success : Bool)->())?){
        
        if(showLoader){
            self.showLoader()
        }
        
        loadInfo {[unowned self] (success, info) in
            
            self.eventInfo = info
            completion?(true)
            return
        }
    }
    
    
    func transerState(info : EventScheduleInfo)->EventScheduleInfo{
        
        let localEventInfo = info
        //new event is updated with the old event local Parameters
        if let newSlotInfo = localEventInfo.slotInfos{
            for newinfo in newSlotInfo{
                if let oldSlotInfo = self.eventInfo?.slotInfos{
                    for oldInfo in oldSlotInfo{
                        if oldInfo.id == newinfo.id{
                            newinfo.isSelfieTimerInitiated = oldInfo.isSelfieTimerInitiated
                        }
                    }
                }
            }
        }
        return localEventInfo
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
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {() -> Void in
            
            flashView.alpha = 0.0
        }, completion: { (done) -> Void in
            
            flashView.removeFromSuperview()
        })
    }
}

extension VideoCallController{
    
    func multipleVideoTabListner(){
        
        socketListener?.onEvent("multipleTabRequest", completion: { (json) in
            
            Log.echo(key : "socket_client", text : "Multiplexing Error: \(String(describing: json))")
            
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
        
        UIView.animate(withDuration: duration, animations: {
            
            self.label.transform = .identity
        }) { (success) in
            self.shrink()
        }
        animateColorLable(label:self.label,color:.red)
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
            
            //self.label.textColor = UIColor.white
            self.label.font = labelCopy.font
            self.label.transform = .identity
            self.label.bounds = smallerBounds
            self.enlarge()
        })
        animateColorLable(label:self.label,color:.white)
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    func animateColorLable(label:UILabel?,color:UIColor){
        
        guard let label = label else {
            return
        }
        UIView.transition(with:label , duration: 0.5, options: .showHideTransitionViews, animations: {
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                label.textColor = color
            })
        }, completion:nil)
    }
}

extension VideoCallController{
    
    enum callStatusMessage:Int{
        
        case ideal = 0
        case preConnectedSuccess = 1
        case userDidNotJoin  = 2
        case connected = 3
        case eventDelay = 4
        case eventNotStarted = 5
    }
    
    func setStatusMessage(type : callStatusMessage){
        
        if(type == .ideal || type == .preConnectedSuccess){
            self.showChatalyzeLogo()
            self.hidePreConnectLabel()
            return
        }
        
        if(type == .connected){
            
            self.hideChatalyzeLogo()
            self.hidePreConnectLabel()
            return
        }
        
        self.hideChatalyzeLogo()
        self.showPreConnectLabel()
        
        var fontSize = 18
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            fontSize = 26
        }
        
        if type == .eventDelay{
            
            let requiredMessage = "Your chat has been delayed. You’ll see a countdown to your new chat time once the host joins."
            
            let secondAttributedString = requiredMessage.toAttributedString(font: "Questrial", size: fontSize, color: UIColor.white)
            
            preConnectLbl?.attributedText = secondAttributedString
            return
        }
        
        if type == .eventNotStarted{
            
            let requiredMessage = "Session is not started yet."
            
            let secondAttributedString = requiredMessage.toAttributedString(font: "Questrial", size: fontSize, color: UIColor.white)
            
            preConnectLbl?.attributedText = secondAttributedString
            return
        }
        
        if type == .userDidNotJoin {
            
            let firstStr = (roomType == .user) ? "Host" : "Participant"
            
            let firstMutableAttributedStr = firstStr.toMutableAttributedString(font: "Poppins", size: fontSize, color: UIColor(hexString: AppThemeConfig.themeColor))
            
            let secondStr = " hasn't joined the session."
            
            let secondAttributedString = secondStr.toAttributedString(font: "Poppins", size: fontSize, color: UIColor.white)
            
            firstMutableAttributedStr.append(secondAttributedString)
            
            Log.echo(key: "yud", text: "Required str is \(firstMutableAttributedStr)")
            
            preConnectLbl?.attributedText = firstMutableAttributedStr
            
            return
        }
        
        
        //        if type == .preConnectedSuccess{
        //
        //            let secondStr = "You've pre-connected successfully. \n\n Get ready to chat!"
        //
        //            let secondAttributedString = secondStr.toAttributedString(font: "Poppins", size: fontSize, color: UIColor.white)
        //
        //            preConnectLbl?.attributedText = secondAttributedString
        //
        //            return
        //        }
        
        
        if type == .connected {
            
            self.hideChatalyzeLogo()
            self.hidePreConnectLabel()
            return
        }
    }
    
    func hidePreConnectLabel(){
        
        self.preConnectLbl?.isHidden = true
    }
    
    private func showPreConnectLabel(){
        
        self.preConnectLbl?.isHidden = false
    }
    
    func hideChatalyzeLogo(){
        
        chatalyzeLogo?.isHidden = true
    }
    
    func showChatalyzeLogo(){
        
        chatalyzeLogo?.isHidden = false
        hidePreConnectLabel()
    }
}

extension VideoCallController{
}
