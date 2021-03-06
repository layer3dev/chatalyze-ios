import UIKit
import CallKit
import Foundation
import SwiftyJSON
import Toast_Swift
import CRToast
import TwilioVideo
import SendBirdUIKit

import PubNub
//todo:
//refresh procedure is being written redundantly
class VideoCallController : InterfaceExtendedController {
    
    private let TAG = "VideoCallController"
    
    var callLogger : CallLogger?
    var callType = ""
    var isUserOnlineFlag = false
    
    //added this flag to prevent issue with thread race caused because of thread lock done by Twilio Disconnect - causing timer thread to choke and execute even after the invalidate process because it was already triggered but choked in queue.
    var isProcessTerminated = false
    
    var isStatusBarRequiredToHidden = false
    
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
        case contactUs
        case earlyExit
        case hostEarningScreen
    }
    
    // user for animating lable
    var label = UILabel()
    var isAnimate: Bool  = false
    let duration = 0.5
    let fontSizeSmall: CGFloat = 16
    var fontSizeBig: CGFloat = 28
    var isSmall: Bool = true
    // end
    
    var socketClient : SocketClient?
    var socketListener : SocketListener?
    
    
    
    private let streamCapturer = RTCSingletonStream()
    private var captureController : ARDCaptureController?
    var localMediaPackage : CallMediaTrack? = CallMediaTrack()
    
    private var accessManager : MediaPermissionAccess?
    
    private var localTrack : LocalVideoTrack?
    
    private let eventSlotListener = EventSlotListener()
    private var scheduleUpdateListener = ScheduleUpdateListener()

    //Implementing the eventDeleteListener
    
    private var eventDeleteListener = EventDeletedListener()
    private let updatedEventScheduleListener = UpdateEventListener()
    
    let applicationStateListener = ApplicationStateListener()
    
    //used for tracking the call time and auto-connect process
    let timer : SyncTimer = SyncTimer()
    
    fileprivate var audioManager : AudioManager?
    
    var eventId : String?
    
    //Expected param
    var eventInfo : EventScheduleInfo?
    
    //todo: fix it
    //there is no need of this callback
    var peerInfos : [PeerInfo] = [PeerInfo]()
    
     var speedHandler : InternetSpeedHandler?
    
    //in case if user opens up
    var isProhibited = false
    
    weak var lastPresentingController : UIViewController?
    
    @IBOutlet var chatalyzeLogo:UIImageView?
    @IBOutlet var preConnectLbl:UILabel?
    @IBOutlet var eventDelayAlertView:UIView?
    @IBOutlet var eventCancelledAlertView:UIView?
    @IBOutlet var eventCancelledAlertLbl:UILabel?
    @IBOutlet var alertContainerView:UIView?
    
    var roomType : UserInfo.roleType{
        return .user
    }
    
    var isSocketConnected : Bool{
        return (socketClient?.isConnected ?? false)
    }
    
    var appDelegate : AppDelegate?
    
    var isEventCancelled = false
    
    
    var camera:CameraSource?
    var localCameraPreviewView:VideoView?{
        return nil
    }
    
    func createUserId(room_id: String, id: String) -> String {
        return AppConnectionConfig.webServiceURL.contains("dev") ? "dev_\(room_id)_\(id)" : "live_\(room_id)_\(id)"
    }
    
    var localVideoRenderer:VideoFrameRenderer?{
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            self.fontSizeBig = 24
        }else{
            
            self.fontSizeBig = 22
        }
        appDelegate =  UIApplication.shared.delegate as? AppDelegate
        hitEventOnSegmentIO()
        // Do any additional setup after loading the view.
    }
    
    func hitEventOnSegmentIO(){
        //To be overriden
    }
    
    override func viewAppeared(){
        super.viewAppeared()
        
        processPermission()
    }
    
    override func viewDidRelease() {
        super.viewDidRelease()
        
        
        Log.echo(key: "yud", text: "View Did release killing the call")
        
        releaseListener()
        speedHandler?.release()
        ARDAppClient.releaseLocalStream()
        captureController?.stopCapture()
        self.localMediaPackage?.mediaTrack?.stop()
        eventSlotListener.setListener(listener: nil)
        if roomType == .user {
            eventSlotListener.setChatNumberListener(listener: nil)
        }
        timer.pauseTimer()
        socketClient?.disconnect()
        trackWebSocketDisconnected()
        socketListener?.releaseListener()
        self.socketClient = nil
        self.socketListener = nil
    }
    
    private func releaseListener(){
        
        eventSlotListener.releaseListener()
        self.scheduleUpdateListener.releaseListener()

        eventDeleteListener.releaseListener()
        updatedEventScheduleListener.releaseListener()
        applicationStateListener.releaseListener()
    }
    
    var rootView : VideoRootView?{
        return self.view as? VideoRootView
    }
    
    var actionContainer : VideoActionContainer?{
        return rootView?.actionContainer
    }
    
    func trackWebSocketDisconnected(){
        
        let metaInfo = [String:Any]()
        let action = "websocketDisconnected"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    //To be override
    func trackCurrentChatCompleted(){
    }
    
    @IBOutlet var poorInternetBannerView:UIView?
    
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
        Log.echo(key: TAG, text: "processExitAction -> \(code)")
        isProcessTerminated = true
        
        timer.pauseTimer()
        self.exit(code : code)
        updateUserOfExit()
    }
    
    func exit(code : exitCode){
        
        //        Log.echo(key: "yud", text: "exit code is \(code)")
        //        if SignedUserInfo.sharedInstance?.role == .user{
        //            if code == .expired{
        //
        //                if self.presentedViewController == nil {
        //                    self.onExit(code : code)
        //                    return
        //                }
        //                self.presentedViewController?.dismiss(animated: false, completion: {
        //                    self.onExit(code : code)
        //                    return
        //                })
        //                return
        //            }
        //            self.getRootPresentingController()?.dismiss(animated: false, completion: {[weak self] in
        //                self?.onExit(code : code)
        //            })
        //            return
        //        }else{
        //
        
        
        guard let roleType = SignedUserInfo.sharedInstance?.role else{
            return
        }
        
        if roleType == .user{
            
            self.onExit(code : code)
            return
        }
        
        self.getRootPresentingController()?.dismiss(animated: false, completion: {[weak self] in
            
            self?.onExit(code : code)
        })
        //            return
        //    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //multipleVideoTabListner()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func logInternetSpeed(){
        
        speedHandler?.setSpeedListener(listener: {[weak self] (speed) in
            self?.callLogger?.logSpeed(speed: speed)
        })
        
        speedHandler?.startSpeedProcessing()
    }
    
    
    private func showMediaAlert(alert : permissionsCheck?){
        
        DispatchQueue.main.async {
            
            if self.presentedViewController as? MediaAlertController != nil{
                return
            }
            
            guard let controller = MediaAlertController.instance() else {
                return
            }
            
            controller.alert = alert ?? .none
            
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
                
                let requiredPermission = VideoCallController.permissionsCheck.cameraPermission
                self.showMediaAlert(alert:requiredPermission)
            }
            
            if !micAccess{
                let requiredPermission = VideoCallController.permissionsCheck.micPermission
                self.showMediaAlert(alert:requiredPermission)
            }
            
            self.initialization()
            
            self.logInternetSpeed()
            Log.echo(key: "yud", text: "Access Manager permission for camera is \(cameraAccess) and for mic Access is \(micAccess)")
        }
        
    }
    
    //ready state to determine if interval is ready to execute
    //or if it should wait before everything is ready
    var isReady : Bool{
        if(!isActivated){
            return false
        }
        
        if(!TimerSync.sharedInstance.isSynced){
            return false
        }
        
        return true
    }
    
    //to check, if event is activated
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
            
            Log.echo(key: "delay", text: "info received -> \(String(describing: info?.title))")
            
            guard let info = info
                else{
                    return
            }
            
            self?.updateToReadyState()
            
            self?.connectToRoom(info: info)
            self?.eventInfo = info
            self?.processEventInfo()
            self?.startLocalStreaming()
            self?.registerForAppState()
            Log.echo(key: "delay", text: "processed")
            
            if(isActivated){
                Log.echo(key: "delay", text: "event is activated")
            }
        }
    }
    
    //overridden
    func processEventInfo(){
        self.checkForDelaySupport()
        cacheEventLogo()
    }
    
    private func cacheEventLogo(){
        guard let url = eventInfo?.eventBannerUrl
            else{
                return
        }
        CacheImageLoader.sharedInstance.loadImage(url, token: { () -> (Int) in
            return 0
        }) { (success, image) in
            if image == nil{
                return
            }
            self.rootView?.callInfoContainer?.logo?.image = image
            self.setFuturePromotionImage(image: image)
        }
    }
    //To be overridden
    func setFuturePromotionImage(image:UIImage?){
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
    
    //abstract
    func renderIdleMedia(){
        
    }
    
    func stopIdleMedia(){
        
    }
    
    
    private func connectToRoom(info : EventScheduleInfo){
        //<##>
        //socketClient?.connect(roomId: (callType == "green" ? info.greenRoomId : info.roomId))
//        socketClient?.socketDisconnect = {
//            self.trackWebSocketDisconnected()
//        }
        
       // joining room with pubnub
       self.registerForJoinRoom(roomId: (callType == "green" ? info.greenRoomId : info.room_id ?? "") )
        
    }
    
    
    func registerForJoinRoom(roomId: String) {
        UserSocket.sharedInstance?.pubnub.subscribe(to: ["ch:callroom:" + roomId], withPresence: true)
        let listener = SubscriptionListener()
        listener.didReceiveSubscription = { event in
        
         
         switch event {
         case let .messageReceived(message):
           print("Message Received: \(message) Publisher: \(message.publisher ?? "defaultUUID")")
//           guard let info = message.payload.rawValue as? [String : Any]
//           else{
//               return
//           }
           
         case let .connectionStatusChanged(status):
           print("Status Received: \(status)")
         case let .presenceChanged(presence):
           print("Presence Received: \(presence)")
         case let .subscribeError(error):
           print("Subscription Error \(error)")
         default:
           break
         }
       }
        
        UserSocket.sharedInstance?.pubnub.add(listener)
    }
    
    
    // listening for if any user joining or leaving the room
    func hereNow(completion: @escaping (_ data: [String])->()) {
        UserSocket.sharedInstance?.pubnub.hereNow(on: ["ch:callroom:" + (room_Id ?? "")]) {  result in
            
          switch result {
          case let .success(presenceByChannel):
            print("Total channels \(presenceByChannel.totalChannels)")
            print("Total occupancy across all channels \(presenceByChannel.totalOccupancy)")
            if let myChannelPresence = presenceByChannel["ch:callroom:" + (self.room_Id ?? "")] {
                let users = myChannelPresence.occupants // array of joined users as ids
                completion(users)
              print("The occupancy for `my_channel` is \(myChannelPresence.occupancy)")
                print("The list of occupants for `my_channel` are \(myChannelPresence.occupants)")
            }
          case let .failure(error):
            print("Failed hereNow Response: \(error.localizedDescription)")
          }
        }
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
        UserSocket.sharedInstance?.pubnub.unsubscribe(from: ["ch:callroom:" + (room_Id ?? "")], and: ["ch:callroom:" + (roomId ?? "")], presenceOnly: false)
//        var data = [String : Any]()
//        data["userId"] = userId
//        data["message"] = "User hangup the call!"
//        socketClient?.emit("disconnect", data)
        
    }
    
    
    private func updateToReadyState(){
        
        socketListener?.newConnectionListener(completion: { [weak self] (success)  in
            
            self?.callLogger?.logSocketConnectionState()
            
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
        
        registerForScheduleListener()
        
        rootView?.hangupListener(listener: {
            
            self.processExitAction(code: .userAction)
        })
        
        socketListener?.onEvent("updatePeerList", completion: { [weak self] (json) in
            
            if(self?.socketClient == nil){
                return
            }
            self?.callLogger?.logUpdatePeerList(rawInfo: json)
            self?.processUpdatePeerList(json: json)
        })
    }
    
    private func registerForScheduleListener(){
        
        eventSlotListener.setListener {[weak self] in
            
            self?.refreshScheduleInfo()
        }
        
        if roomType == .user {
            eventSlotListener.setChatNumberListener {[weak self] slotId in
                self?.alert(withTitle: "SLOT CHANGED", message: "Slot time is updated.", successTitle: "Ok", rejectTitle: "", showCancel: false, completion: { success in

                })
            }
        }
        
        eventDeleteListener.setListener { [weak self] (deletedEventID) in
            
            if self?.eventId == deletedEventID {
                
                self?.isEventCancelled = true
                self?.eventCancelled()
                
                Log.echo(key: "yud", text: "Matched Event Id is \(String(describing: deletedEventID))")
            }
        }
        
        updatedEventScheduleListener.setListener {[weak self] in
            self?.refreshScheduleInfo()
        }
        
        scheduleUpdateListener.setListener {
            
            self.refreshScheduleInfo()
        }
        
        applicationStateListener.setForegroundListener {[weak self] in
            self?.refreshScheduleInfo()
        }
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
    // currently not using
    func isOnline(hashId : String)->Bool{
        for peerInfo in peerInfos {
            if(peerInfo.name == hashId && peerInfo.isBroadcasting){
                return true
            }
        }
        return false
    }
    
    //<##>
    
    
    //same as isOnline but won't check for isBroadcasting
//    func isAvailableInRoom(hashId : String)->Bool{
//        for peerInfo in peerInfos {
//            if(peerInfo.name == hashId){
//                return true
//            }
//        }
//        return false
//    }
    
    
    func isAvailableInRoom(targetUserId : String)->Bool{
        
        hereNow(completion: { usersIds in
            if usersIds.contains(String(targetUserId)) {
                self.isUserOnlineFlag = true
                print("user is online \(targetUserId)")
            } else {
                print("user is offline \(targetUserId)")
                self.isUserOnlineFlag = false
            }
        })
        return self.isUserOnlineFlag
    }
    
    //isolated from eventInfo
    private func initializeVariable(){
        
        if let id = self.eventId{
            callLogger = CallLogger(sessionId: id)
        }
        
        speedHandler = InternetSpeedHandler(controller : self)
        appDelegate?.allowRotate = true
        lastPresentingController = self.presentingViewController
        
        //update listener eventId
        eventSlotListener.eventId = self.eventId
        
        socketClient = SocketClient.sharedInstance
        socketListener = socketClient?.createListener()
        multipleVideoTabListner()
        startTimer()
        self.initializeForLowSpeedBanner()
    }
    
    private func startTimer(){
        
        Log.echo(key: TAG, text: "startTimer")
        
        timer.shouldLog = true
        
        timer.ping { [weak self] in
            self?.executeInterval()
        }
        timer.startTimer()
    }
    
    
    private func executeInterval(){
        
        if(isReleased){
            return
        }
        if(isProcessTerminated){
            Log.echo(key: TAG, text: "isProcessTerminated -> TRUE - STOP RIGHT THERE")
            return
        }
        
    
        if(!isReady){
            Log.echo(key: TAG, text: "commenting return at 787")
            //return
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
            return callType == "green" ? self.eventInfo?.greenRoomId : self.eventInfo?.roomId
        }
    }
    
    
    var room_Id : String?{
        get{
            Log.echo(key: "vijayDedaults", text: "\(String(describing: (eventInfo?.room_id)))")
            return self.eventInfo?.room_id
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
    var isSlotRunning:Bool{
        return false
    }
    
    //To be overridden
    func checkForDelaySupport(){
    }
    
    func eventCancelled(){
        //To be overridden by the UserCallController and videoCallController
    }
    
    private func initializeForLowSpeedBanner(){
        
        self.poorInternetBannerView?.layer.cornerRadius = 17.5
        self.poorInternetBannerView?.layer.masksToBounds = true
        
        self.speedHandler?.showBottomBanner = {[weak self] success in
            
            if success{
                self?.poorInternetBannerView?.isHidden = false
                return
            }
            self?.poorInternetBannerView?.isHidden = true
        }
        
    }
}

//Action Buttons
extension VideoCallController{
}

extension VideoCallController{
    
    func startCallRing(){
    }
    
    
    
    
    func encodeImageToBase64(image : UIImage?,completion: @escaping (_ encodedData:String)->()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let image = image
                else{
                    completion("")
                    return
            }
            
            guard let data = image.jpegData(compressionQuality: 0.7)
                else{
                    completion("")
                    return
            }
            
            let bytes = data.count
            let MB = Double(bytes) / 1024.0 / 1024.0 // Note the difference
            
            Log.echo(key: "VideoCallController", text: "Image size -> \(MB)")
            
            let imageBase64 = "data:image/png;base64," +  data.base64EncodedString(options: .lineLength64Characters)
            
            DispatchQueue.main.async {[weak self] in
                completion(imageBase64)
            }
        }
    }
}

//instance
extension VideoCallController{
    
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
            
            Log.echo(key: "yud", text: "The fetched the call result is success.")
            
            localEventInfo = self.transerState(info: localEventInfo)
            completion?(true, localEventInfo)
            return
        }
    }
    
    
    fileprivate func fetchInfo(showLoader : Bool, completion : ((_ success : Bool)->())?){
        
        if(showLoader){
            self.showLoader()
        }
        
        loadInfo {[weak self] (success, info) in
            if(showLoader){
                self?.stopLoader()
            }
            self?.eventInfo = info
            completion?(true)
            return
        }
    }
    
    
    func transerState(info : EventScheduleInfo)->EventScheduleInfo{
        
        let localEventInfo = info
        //new event is updated with the old event local Parameters.
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
    
    func startLocalStream() {
        // Create a video track which captures from the camera.
        if (self.localMediaPackage?.mediaTrack == nil) {
            self.writeLocalVideoTrack()
        }
        
        
        //        localMediaPackage = streamCapturer.getMediaCapturer {[weak self] (capturer) in
        //
        //            DispatchQueue.main.async {
        //
        //
        //            guard let localCapturer = capturer
        //                else{
        //                    return
        //            }
        //
        //            guard let localView = self?.rootView?.localVideoView
        //                else{
        //                    return
        //            }
        //
        //            let captureSession = localCapturer.captureSession
        //            //localView.captureSession = captureSession
        //
        //            let settingsModel = ARDSettingsModel()
        //            settingsModel.storeVideoResolutionSetting("1280x720")
        //            self?.captureController = ARDCaptureController(capturer: localCapturer, settings: settingsModel)
        //            self?.captureController?.startCapture()
        //            }
        //        }
        
        //        DispatchQueue.main.async {
        //
        //
        //            guard let localView = self.rootView?.localVideoView
        //            else{
        //                return
        //        }
        //
        //        if let localTrack = self.localTrack{
        //            localTrack.remove(localView)
        //            self.localTrack = nil
        //            localView.renderFrame(nil)
        //        }
        //
        //        Log.echo(key: "local stream", text: "got local stream")
        //
        //            self.localTrack = self.localMediaPackage?.videoTrack
        //            self.localTrack?.add(localView)
        //        }
    }
    
    
    
    func writeLocalAudioTrack(){
        
        let options = AudioOptions(){(builder) in
            builder.isSoftwareAecEnabled = true
        }
        
        
        
    }
    
    
    func writeLocalVideoTrack() {
        
        let doesRequireMultipleTracks = (roomType == .analyst)

        let mediaTrack = LocalMediaVideoTrack(doesRequireMultipleTracks: doesRequireMultipleTracks)
        self.localMediaPackage?.mediaTrack = mediaTrack
        
        mediaTrack.start()
        
        // Add renderer to video track for local preview
        guard let localPreviewView = self.localCameraPreviewView else{
            Log.echo(key: "yud", text: "Empty localCameraPreviewView")
            return
        }
        
        guard let renderer = self.localVideoRenderer else{
            return
        }
        self.localMediaPackage?.mediaTrack?.previewTrack.videoTrack?.addRenderer(localPreviewView)
        self.localMediaPackage?.mediaTrack?.previewTrack.videoTrack?.addRenderer(renderer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCallController.flipCamera))
        //localPreviewView.addGestureRecognizer(tap)
        
       
    }
    
    
    
    
    
    //overridden
    func fetchTwillioRoomInfoFromServer(){
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
            
            if let dataDict = json?.dictionary{
                if let str = dataDict["id"]?.string{
                    if str == "multipleTabRequest"{
                        
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
    
    enum callStatusMessage:Int {
        
        case ideal = 0
        case preConnectedSuccess = 1
        case userDidNotJoin  = 2
        case connected = 3
        case eventDelay = 4
        case eventNotStarted = 5
        case eventCancelled = 6
        case idealMedia = 7
        case socketDisconnected = 8
        case breakSlot = 9
    }
    
    func setStatusMessage(type : callStatusMessage) {
        
        Log.echo(key: "yud", text: "Setting up a status type \(type)")
        
        if type == .idealMedia{
            self.showChatalyzeLogo()
            self.hidePreConnectLabel()
            if !isEventCancelled {
                self.hideAlertContainer()
            }
            renderIdleMedia()
            return
        }
        
   
        
        if(type == .ideal || type == .breakSlot) {
            
            self.showChatalyzeLogo()
            self.hidePreConnectLabel()
            if !isEventCancelled {
                self.hideAlertContainer()
            }
            return
        }
        
        
        
        if(type == .connected) {
            
            self.hideAlertContainer()
            self.hideChatalyzeLogo()
            self.hidePreConnectLabel()
            return
        }
        
        self.hideChatalyzeLogo()
        self.hidePreConnectLabel()
        if !isEventCancelled {
            self.hideDelayAndCancelAlert()
            self.hideAlertContainer()
        }
        
        var fontSize = 18
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            fontSize = 26
        }
        
        if type == .eventDelay {
            
            // New Alert is implemented now on the place of the earlier message. So we are hiding earlier alerts and showing the new one.
            self.showAlertContainer()
            self.showEventDelayAlert()
            return
        }
        
        if type == .eventCancelled {
            
            // Implemented alert for the cancel of the event.
            self.showAlertContainer()
            self.showCancelEventAlert()
            return
        }
        
        if type == .eventNotStarted {
            
            self.showAlertContainer()
            self.showPreConnectLabel()
            let requiredMessage = "Session has not started.".localized() ?? ""
            let secondAttributedString = requiredMessage.toAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor.white)
            preConnectLbl?.attributedText = secondAttributedString
            return
        }
        
        
        if (type == .socketDisconnected){
            self.showAlertContainer()
            self.showPreConnectLabel()
            
            
            let requiredMessage = "Unable to connect to video server. Trying to reconnect...".localized() ?? ""
            let secondAttributedString = requiredMessage.toMutableAttributedString(font: "Nunito-ExtraBold", size: fontSize, color: UIColor.white)
            
            
            preConnectLbl?.attributedText = secondAttributedString
            return
        }
        if type == .userDidNotJoin {
            
            self.showAlertContainer()
            self.showPreConnectLabel()
            let firstStr = (roomType == .user) ? "Host".localized() ?? "" : "Participant".localized() ?? ""
            let firstMutableAttributedStr = firstStr.toMutableAttributedString(font: "Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: AppThemeConfig.themeColor))
            let secondStr = " hasn't joined the session.".localized() ?? ""
            let secondAttributedString = secondStr.toAttributedString(font: "Nunito-ExtraBold", size: fontSize, color: UIColor.white)
            firstMutableAttributedStr.append(secondAttributedString)
            Log.echo(key: "yud", text: "Required str is \(firstMutableAttributedStr)")
            preConnectLbl?.attributedText = firstMutableAttributedStr
            return
        }
        
        if type == .connected {
            
            self.hideAlertContainer()
            self.hideChatalyzeLogo()
            self.hidePreConnectLabel()
            return
        }
        
        if type == .preConnectedSuccess {
            self.showAlertContainer()
            self.showPreConnectLabel()
            stopIdleMedia()
            let requiredMessage = "Get ready to chat!".localized() ?? ""
            let secondAttributedString = requiredMessage.toMutableAttributedString(font: "Nunito-ExtraBold", size: fontSize, color: UIColor.white)
            
            preConnectLbl?.attributedText = secondAttributedString
            return
        }
    }
    
    func hidePreConnectLabel() {
        
        self.preConnectLbl?.isHidden = true
    }
    
    private func showPreConnectLabel() {
        
        self.preConnectLbl?.isHidden = false
    }
    
    func hideChatalyzeLogo() {
        
        chatalyzeLogo?.isHidden = true
    }
    
    func hideAlertContainer() {
        
        self.alertContainerView?.isHidden = true
    }
    func showAlertContainer() {
        
        self.alertContainerView?.isHidden = false
    }
    
    func showEventDelayAlert() {
        
        self.eventDelayAlertView?.layer.borderWidth = 1
        self.eventDelayAlertView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.eventDelayAlertView?.layer.borderColor = UIColor(red: 255.0/225.0, green: 229.0/255.0, blue: 152.0/255.0, alpha: 1).cgColor
        self.eventDelayAlertView?.isHidden = false
    }
    
    func showCancelEventAlert() {
        
        let textOne = "We apologize. It looks like the host is unavailable today. You will receive a refund for your purchase. If you have any questions or concerns. Please ".localized() ?? ""
        let texttwo = "contact us.".localized() ?? ""
        let mutableAttrOne = textOne.toMutableAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 18, color: UIColor.white, isUnderLine: false)
        let attrTwo = texttwo.toMutableAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 18, color: UIColor.white, isUnderLine: true)
        mutableAttrOne.append(attrTwo)
        self.eventCancelledAlertView?.layer.borderWidth = 1
        self.eventCancelledAlertView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.eventCancelledAlertView?.layer.borderColor = UIColor(red: 224.2/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1).cgColor
        self.eventCancelledAlertLbl?.attributedText = mutableAttrOne
        self.eventCancelledAlertView?.isHidden = false
    }
    
    func hideDelayAndCancelAlert() {
        
        self.eventDelayAlertView?.isHidden = true
        self.eventCancelledAlertView?.isHidden = true
    }
    
    func showChatalyzeLogo() {
        
        chatalyzeLogo?.isHidden = false
        hidePreConnectLabel()
    }
}

extension VideoCallController {
    
    func refreshScheduleInfo() {
        
        self.loadActivatedInfo { [weak self] (isActivated, info) in
            
            Log.echo(key: "delay", text: "info received -> \(String(describing: info?.title))")
            guard let info = info
                else{
                    return
            }
            self?.eventInfo = info
            self?.processEventInfo()
            Log.echo(key: "delay", text: "processed")
            if(isActivated){
                Log.echo(key: "delay", text: "Event is activated")
            }
        }
    }
}


extension VideoCallController {
    
    @IBAction func goToContactUsScreen(sender:UIButton) {
        
        exit(code : .contactUs)
        /*self.dismiss(animated: false) {[weak self] in
         Log.echo(key: "log", text: "VideoCallController dismissed")
         self?.onExit(code : .contactUs)
         }*/
    }
}


extension VideoCallController:VideoViewStatusBarAnimationInterface{
    
    override var prefersStatusBarHidden: Bool{
        return isStatusBarRequiredToHidden
    }
    
    func visibleAnimateStatusBar() {
        
        //UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
        //self.isStatusBarRequiredToHidden = false
        UIApplication.shared.isStatusBarHidden = false
        //setNeedsStatusBarAppearanceUpdate()
        print("showing status bar \(self.prefersStatusBarHidden)")
        
    }
    
    func hidingAnimateStatusBar() {
        
        //UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
        //self.isStatusBarRequiredToHidden = true
        UIApplication.shared.isStatusBarHidden = true
        //setNeedsStatusBarAppearanceUpdate()
        print("showing status bar \(self.prefersStatusBarHidden)")
        
    }
    
    func showToastWithMessage(text:String,time:Double){
        
        let options = [kCRToastNotificationTypeKey : CRToastType.navigationBar,kCRToastUnderStatusBarKey:false,kCRToastTextKey : text,kCRToastNotificationPreferredHeightKey:4.0,kCRToastTextAlignmentKey:NSTextAlignment.center,kCRToastBackgroundColorKey:UIColor(hexString: "#FAA579"),kCRToastAnimationInTypeKey:kCRToastAnimationGravityMagnitudeKey,kCRToastAnimationOutTypeKey:kCRToastAnimationGravityMagnitudeKey,kCRToastAnimationInDirectionKey:CRToastAnimationDirection.left,kCRToastAnimationOutDirectionKey:CRToastAnimationDirection.right,kCRToastTimeIntervalKey:time] as [String : Any]
        
        CRToastManager.showNotification(options: options) {
        }
    }
}

extension VideoCallController{
    
    @objc func flipCamera() {
        var newDevice: AVCaptureDevice?
        
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        //self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        //self.previewView.shouldMirror = (captureDevice.position == .front)
                        
                        //self.previewView.shouldMirror = false
                    }
                }
            }
        }
    }
}





//MARK:- Running the global our camera

extension VideoCallController{
    
    
    // MARK:- Local Streaming methods
    func startLocalStreaming() {
        
        
        
        // Create a video track which captures from the camera.
        if (self.localMediaPackage?.mediaTrack == nil) {
            self.writeLocalVideoTrack()
        }
    }
    
    fileprivate func registerForAppState(){
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appMovedToBackground(){
        
        Log.echo(key: "Twill", text: "App is moving to the background in call room.")
        //self.disableCamera()
        self.disconnectManualConnection()
    }
    
    @objc func disconnectManualConnection(){
        //To be overridden
    }
    
    @objc func connectManualConnection(){
        //To be overridden
    }
    
    @objc func appMovedToForeground(){
        
        Log.echo(key: "Twill", text: "App is moving to the forground in call room.")
        self.connectManualConnection()
    }
    
    fileprivate func unregisterForAppState(){
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    func enableCamera(){
        
        self.startLocalStreaming()
    }
}


