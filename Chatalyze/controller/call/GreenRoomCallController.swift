//
//  HostCallController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 27/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Alamofire
import Toast_Swift
import CRToast
import TwilioVideo
import Analytics
import ChatSDK
import MessagingSDK
import PubNub

class GreenRoomCallController: VideoCallController {
    
    var currentTwillioRoom:HostCallConnection?
    var preconnectTwillioRoom:HostCallConnection?
    var roomParticipantsList = [HostRoomInfo]()
    var isMutalPointReceived = false
    var callback : (()->())?
    
    @IBOutlet var signaturAccessoryView:AutographSignatureReponseBottomView?
    
    private let TAG = "HostCallController"
    
    var localSlotIdToManageAutograph :Int? = nil
    var autoGraphInfo:AutographInfo?
    
    var isPreConnected = false
    var recordingLblTopAnchor: NSLayoutConstraint?
    var defaultImageUrl = String()
    var defaultImage : UIImage?
    var isSignatureActive = false
    var autographSlotInfo : SlotInfo? = nil
    var isExtendChatDisbaled = false
    var isAutograpaghinProcess = false
    var enableSelfieBtn = false
    var memoryImage:UIImage?
    var capturedSlefieSlotInfo : SlotInfo?
    
    //In order to maintain the refrence for the Early Controller.
    var earlyControllerReference : EarlyViewController?
    
    //Outlet for sessioninfo.
    @IBOutlet var sessionHeaderLbl:UILabel?
    @IBOutlet var sessionRemainingTimeLbl:UILabel?
    @IBOutlet var sessionCurrentSlotLbl:UILabel?
    @IBOutlet var sessionTotalSlotNumLbl:UILabel?
    @IBOutlet var sessionSlotView:UIView?
    @IBOutlet var breakView:breakFeatureView?
    @IBOutlet var earlyEndSessionView:UIView?
    @IBOutlet var upNextSlotInfoView:UpNextSlotInfoView?
    @IBOutlet var photoBothView : PhotoBoothView?
    @IBOutlet var selfieWindowView : HostSelfieBoothView?
    
    //For animation.
    var isAnimating = false
    
    @IBOutlet var selfieTimerView:SelfieTimerView?
    var connectionInfo : [String : HostCallConnection] =  [String : HostCallConnection]()
    
    // Using in order to prevent to showing the message "Participant did not join session before the slot start."
    override var isSlotRunning : Bool {
        
        guard let activeSlot = eventInfo?.mergeSlotInfo?.upcomingSlot
            else{
            recordingLbl.isHidden = true
                return false
        }
        if(activeSlot.isLIVE){
            return true
        }
        return false
    }
    
    override var roomType : UserInfo.roleType{
        return .analyst
    }
    
    lazy var custumBckGrndImg  : UIImageView = {
           let ui = UIImageView()
           ui.backgroundColor = .clear
           ui.contentMode = .scaleAspectFill
           return ui
       }()
       
    
    lazy var recordingLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "  ● Recording  ".localized() ?? ""
        lbl.textColor = .white
        lbl.backgroundColor = .red
        lbl.isHidden = true
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            lbl.layer.cornerRadius = 8
            lbl.font = UIFont.systemFont(ofSize: 8, weight: .bold)
        }else{
            lbl.layer.cornerRadius = 12
            lbl.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        }
        return lbl
    }()
       
       func layoutCustomBackGrnd(){
           self.view.addSubview(custumBckGrndImg)
           self.recordingLbl.clipsToBounds = true
           self.view.sendSubviewToBack(custumBckGrndImg)
           custumBckGrndImg.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
       }
    
    
    func layoutrecordingOption(){
        self.view.addSubview(recordingLbl)
        self.view.bringSubviewToFront(recordingLbl)
        recordingLblTopAnchor = recordingLbl.topAnchor.constraint(equalTo: self.localCameraPreviewView?.bottomAnchor ?? NSLayoutAnchor(), constant: 2)
        recordingLblTopAnchor?.isActive = true
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            recordingLbl.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 16))
        }else{
            recordingLbl.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 24))
        }
        recordingLbl.centerX(inView: self.localCameraPreviewView ?? UIView())
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape{
            self.recordingLblTopAnchor?.isActive = false
            if UIDevice.current.userInterfaceIdiom == .phone{
                recordingLblTopAnchor = recordingLbl.topAnchor.constraint(equalTo: self.localCameraPreviewView?.bottomAnchor ?? NSLayoutAnchor(), constant: -90)
            }else{
                recordingLblTopAnchor = recordingLbl.topAnchor.constraint(equalTo: self.localCameraPreviewView?.bottomAnchor ?? NSLayoutAnchor(), constant: -153)
            }
            self.recordingLblTopAnchor?.isActive = true
            
        }else{
            self.recordingLblTopAnchor?.isActive = false
            recordingLblTopAnchor = recordingLbl.topAnchor.constraint(equalTo: self.localCameraPreviewView?.bottomAnchor ?? NSLayoutAnchor(), constant: 2)
            recordingLblTopAnchor?.isActive = true
        }
    }
    
    private func initializeGetCommondForTakeScreenShot(){
        selfieTimerView?.screenShotListner = {
            self.hostRootView?.getSnapshot(info:  self.eventInfo, completion: { [self](image) in
                self.memoryImage = image
                selfieWindowView?.setSelfieImage(with: image)
                self.registerForCapturedScreenshot()
                self.mimicScreenShotFlash()
            })
        }
    }
    
    
    
    private func loadbackgrndImg(eveninfo: EventScheduleInfo){
        guard let imgURL = eventInfo?.backgroundURL
            else{
                custumBckGrndImg.backgroundColor = UIColor(hexString: "#25282E")
                return
        }
        if let url = URL(string: imgURL){
            custumBckGrndImg.sd_setImage(with: url, placeholderImage: UIImage(named: "base_img"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
            })
        }
    }
    override func initialization(){
        super.initialization()
       
        initializeVariable()
        layoutrecordingOption()
         layoutCustomBackGrnd()
    }
    
    override func processEventInfo(){
        super.processEventInfo()
        
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        loadbackgrndImg(eveninfo: eventInfo)
    }
    
    override func onExit(code : exitCode){
        super.onExit(code: code)
        
        changeOrientationToPortrait()
        
        if(code == .prohibited){
            showErrorScreen()
            return
        }
        
        if(code == .earlyExit){
            showEarningInformationScreen()
            return
        }
        
        guard let eventInfo = eventInfo
            else{
                return
        }
        
        if(!eventInfo.isExpired){
            return
        }
        
        showEarningInformationScreen()
    }
    
    func showEarningInformationScreen(){
        
        if self.eventInfo?.slotInfos?.count ?? 0 == 0 {
            return
        }
        
        if self.eventInfo?.isPrivate ?? false{
            return
        }
        
        if self.eventInfo?.isFree ?? false{
            return
        }
        
        guard let controller = HostFeedbackController.instance() else{
            return
        }
        
        controller.sessionId = self.eventId
        
        guard let presentingController =  self.lastPresentingController
            else{
                return
        }
        
        presentingController.modalPresentationStyle = .fullScreen
        presentingController.present(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerForTimerNotification()
    }
    
    var hostActionContainer : HostVideoActionContainer?{
        get{
            return actionContainer as? HostVideoActionContainer
        }
    }
    
    func chatalyzeIconVisibility(){
    }
    
    override var localCameraPreviewView:VideoView?{
        return self.rootView?.localVideoView?.streamingVideoView
    }
    
    
    override var localVideoRenderer:VideoFrameRenderer?{
        return self.rootView?.localVideoView?.getRenderer()
    }
    
    var isCallHangedUp:Bool{
        if let hangUp = self.eventInfo?.mergeSlotInfo?.currentSlot?.isHangedUp{
            if hangUp{
                return true
            }
            return false
        }
    
        self.selfieTimerView?.reset()
        return true
    }
    
    @IBAction private func hangupAction(){
        
        var isDisableHangup = false
        
        if self.eventInfo?.mergeSlotInfo?.currentSlot == nil{
            isDisableHangup = true
        }
        
        guard let controller = HangupController.instance() else{
            return
        }
        
        controller.exit = {
            
            Log.echo(key: self.TAG, text: "Host Tapped on Exit")
            
            DispatchQueue.main.async {
                Log.echo(key: self.TAG, text: "call processExitAction")
                self.processExitAction(code : .userAction)
             
              guard let isCalledHangedUp =  self.eventInfo?.mergeSlotInfo?.currentSlot?.isHangedUp else {return}
              if  isCalledHangedUp{
                 self.toggleHangup()
              }
            }
        }
        
        controller.hangup = {
            
            DispatchQueue.main.async {
//                self.processAutographSelfie()
                self.toggleHangup()
            }
        }
        
        controller.isDisableHangup = isDisableHangup
        
        //self.eventInfo?.mergeSlotInfo?.currentSlot?.isHangedUp
        controller.isHungUp = SlotFlagInfo.isCallHangedUp
        
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: {
        })
    }
    
    
    @IBAction private func chatExtendAction(){
        if isExtendChatDisbaled{
            Log.echo(key: "isExtendChatDisbaled", text: "\(isExtendChatDisbaled)")
            return
        }
        Log.echo(key: self.TAG, text: "chatExtendAction")
        hostActionContainer?.extendChatView?.showExtending()
        self.extendChat()
    }
    
    @IBAction func btnJoinEventAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.callback?()
        }
    }
    
    @IBAction func sendSelfieReq(_ sender: Any) {
        changeOrientationToPortrait()
        lockDeviceOrientation()
        photoBothView?.disableBtn()
        guard let remotePreviewView = self.selfieWindowView?.remoteVideoView else{
            Log.echo(key: "yud", text: "Empty localCameraPreviewView")
            return
        }
        selfieWindowView?.show(with: self.localMediaPackage, remoteStream: nil)
        currentTwillioRoom?.addRenderer(remoteView: remotePreviewView)
//        selfieWindowView?.show(with: self.localMediaPackage, remoteStream:currentTwillioRoom?.currentStream)
        sendTimeStampToUser()
    }
    
    
    private func extendChat(){
        
        guard let sessionId = eventId else{
            Log.echo(key: "vijayExtend", text: "session id not found !!!")
            return
        }
        
        ExtendChatService().sendRequest(id: sessionId) { (success, message) in
            if success{
                self.hostActionContainer?.extendChatView?.showExtend()
                self.showToastWithMessage(text: "Chat Extended Successfully".localized() ?? "", time: 5.0)
                Log.echo(key: "vijayChatExtend", text: message)
            }
        }
    }
    
    private func toggleHangup(){
        
        //abhishek : the hangup status of current running slot is not being saved at server end,So we need have respactive record at local level.
        // As after extanding chat,the eventSlotInfo get reveised, so hanged up status get revised too.

        
        guard let slot = self.eventInfo?.mergeSlotInfo?.currentSlot
            else{
                return
        }
        
        let isHangedUp = !SlotFlagInfo.isCallHangedUp
        SlotFlagInfo.isCallHangedUp = isHangedUp
        
        isHangedUp ? hostActionContainer?.hangupView?.deactivate() : hostActionContainer?.activateFromHangup()
        
        if(!isHangedUp){
            SlotFlagInfo.isCallHangedUp = false
            resetMuteActions()
            if self.eventInfo?.isHostManualScreenshot ?? false{
                self.photoBothView?.showPhotoboothcanvas()
            }
        }else{
            SlotFlagInfo.isCallHangedUp = true
            if self.eventInfo?.isHostManualScreenshot ?? false{
            self.photoBothView?.hidePhotoboothcanvas()
            }
        }
        refreshStreamLock()
       
        let hashedUserId = slot.user?.hashedId ?? ""
        updateUserOfHangup(hashedUserId : hashedUserId, hangup : isHangedUp)
    }
    
    private func refreshStreamLock(){
        
        guard let _ = self.eventInfo?.mergeSlotInfo?.currentSlot
            else{
                localMediaPackage?.isDisabled = false
                return
        }
        localMediaPackage?.isDisabled = SlotFlagInfo.isCallHangedUp
    }
    
    private func updateUserOfHangup(hashedUserId : String, hangup : Bool){
        
        var param = [String : Any]()
        param["id"] = "hangUp"
        param["value"] = hangup
        param["name"] = hashedUserId
        socketClient?.emit(param)
    }
    
    var hostRootView : HostVideoRootView?{
        return self.view as? HostVideoRootView
    }
    
    private func initializeVariable(){
        
        self.hostRootView?.delegateCutsom = self
        self.registerForTimerNotification()
        self.registerForHangupRequest()
        self.registerForSignRequest()
        self.registerForListeners()
        self.selfieTimerView?.delegate = self
        self.signaturAccessoryView?.delegate = self
        hostActionContainer?.extendChatView?.hideExtendBtn()
        initializeGetCommondForTakeScreenShot()
    }
    
    private func registerForHangupRequest(){
        socketListener?.onEvent("hangUp", completion: { [weak self] (json) in
            
            if(self?.socketClient == nil){
                return
            }
            DispatchQueue.main.async {
//                self.processAutographSelfie()
                self?.toggleHangup()
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Log.echo(key: "dhi", text: "I am resetting the selfieTimer")
        selfieTimerView?.reset()
    }
    
    
    private func registerForTimerNotification(){
        
        // @abhishek: If host activated photobooth,this should get return
    
      
        print("Registering socket with timer notification \(String(describing: socketListener)) nd the selfie timer is \(String(describing: selfieTimerView))")
        
        socketListener?.onEvent("screenshotCountDown", completion: { (response) in
            
            print(" I got the reponse \(String(describing: response))")
            
            if let responseDict:[String:JSON] = response?.dictionary{
                if let dateDict:[String:JSON] = responseDict["message"]?.dictionary{
                    
                    if let date = dateDict["timerStartsAt"]?.stringValue{
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        var requiredDate:Date?
                        
                        if let newdate = dateFormatter.date(from: date){
                            
                            requiredDate = newdate
                        }else{
                            
                            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss z"
                            requiredDate = dateFormatter.date(from: date)
                        }
                        self.callLogger?.logSelfieTimerAcknowledgment(timerStartsAt: date)
                        print("required date is \(date) and the sending ")
                        self.selfieTimerView?.reset()
                        
                        if let eventInfo = self.eventInfo{
                            self.selfieTimerView?.startAnimationForHost(date: requiredDate, eventInfo: eventInfo)
                        }
                        
                        self.selfieTimerView?.screenShotListner = {[weak self] in
                            
                            print(" I got the mimic screenshot")
                            if let weakSelf = self {
                                weakSelf.photoBothView?.enableBtn()
                                weakSelf.mimicScreenShotFlash()
                                weakSelf.photoBothView?.isUserInteractionEnabled = true
                                weakSelf.selfieTimerView?.reset()
                                weakSelf.processAutographSelfie()
                            }
                        }
                    }
                }
            }
        })
    }
    
    
    @IBAction func photoboothSelfieAction(){
        Log.echo(key: TAG, text: "Photobooth selfie Action tapped!!")
        
        if let eventInfo = self.eventInfo{
            selfieTimerView?.takeInstantScreenshot(eventInfo:eventInfo)
        }
        // send captured selfie configation
        if let slotInfo = myLiveUnMergedSlot{
            self.capturedSlefieSlotInfo = slotInfo
        }
        registerForCaptureScreenshot()
    }
    
    @IBAction func retakeSelfieAction(){
        Log.echo(key: TAG, text: "Photobooth Re-Take selfie Action tapped!!")
        photoboothSelfieAction()
    }
    
    @IBAction func saveSelfieAction(){
        Log.echo(key: TAG, text: "Photobooth selfie save Action tapped!!")
        selfieWindowView?.hide()
        guard let slotInfo = capturedSlefieSlotInfo
            else{
                return
        }
        
        guard let image = self.memoryImage else {
            return
        }
        self.showToastWithMessage(text: "Saving Memory..", time: 5.0)
//        self.releaseDeviceOrientation()
        encodeImageToBase64(image: image) {[weak self] (encodedImage) in
            self?.uploadImage(encodedImage: encodedImage, autographSlotInfo: slotInfo) { (success, info) in
            }
        }
    }
    
    @IBAction func showChatDeskWindow(){
        Log.echo(key: TAG, text: "Chat view Controller tapped")
        Log.echo(key: self.TAG, text: "chatControllerShown called")
        do {
            let chatEngine = try ChatEngine.engine()
    
            let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [])
           self.presentModally(viewController)
//            self.navigationController?.present(viewController, animated: true, completion: nil)
        } catch {
            // handle error
        }
    }
    
    func sendTimeStampToUser(){
        if let requiredTimeStamp =  self.getTimeStampAfterEightSecond(){
            Log.echo(key: "yud", text: "Again restarting the screenshots")
            
            //In order to convert into the Web Format
            //E, d MMM yyyy HH:mm:ss z
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss z"
            let requiredWebCompatibleTimeStamp = dateFormatter.string(from: requiredTimeStamp)
            
            Log.echo(key: "yud", text: "Required requiredWebCompatibleTimeStamp is \(requiredWebCompatibleTimeStamp)")
            //End
            var data:[String:Any] = [String:Any]()
            var messageData:[String:Any] = [String:Any]()
            messageData = ["timerStartsAt":"\(requiredWebCompatibleTimeStamp)"]
            //name : callServerId($scope.currentBooking.user.id)
            data = ["id":"screenshotCountDown","name":self.eventInfo?.currentSlot?.user?.hashedId ?? "","message":messageData]
            socketClient?.emit(data)
            callLogger?.logSelfieTimerAcknowledgment(timerStartsAt: requiredWebCompatibleTimeStamp)
            Log.echo(key: "yud", text: "Sent time stamp data is \(data)")
        
        }
    }
    
    private func registerForCapturedScreenshot(){
        // send captured selfie configation
        var data:[String:Any] = [String:Any]()
        var messageData:[String:Any] = [String:Any]()
        messageData = ["capturedSelfie":true]
        data = ["id":"screenshotCountDown","name":self.eventInfo?.currentSlot?.user?.hashedId ?? "","message":messageData]
        socketClient?.emit(data)
    }
    
    private func registerForCaptureScreenshot(){
        var data:[String:Any] = [String:Any]()
        var messageData:[String:Any] = [String:Any]()
        messageData = ["captureSelfie":true]
        data = ["id":"screenshotCountDown","name":self.eventInfo?.currentSlot?.user?.hashedId ?? "","message":messageData]
        socketClient?.emit(data)
    }
    

    
    func getTimeStampAfterEightSecond()->Date?{
        
        guard let eventInfo = self.eventInfo
        else{
            return nil
        }
        
        let date = TimerSync.sharedInstance.getDate()
        Log.echo(key: "yud", text: "Synced date is \(date)")
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC") ?? TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        let components = calendar.dateComponents([.year,.month,.day,.hour,.second,.minute], from: date)
        let slotDuration = eventInfo.duration
        
        var requiredDate :Date?
        if eventInfo.isHostManualScreenshot{
            Log.echo(key: "vijaySlotDuration", text: "\(slotDuration)")
             requiredDate = calendar.date(byAdding: .second, value: 0, to: date)
        }else{
            Log.echo(key: "vijaySlotDuration", text: "\(slotDuration)")
            requiredDate = calendar.date(byAdding: .second, value: 5, to: date)
        }
        
        Log.echo(key: "yud", text: "Current date is \(String(describing: calendar.date(from: components)))")
        Log.echo(key: "yud", text: "Required date is \(String(describing: requiredDate))")
        if let verifiedDate = requiredDate{
            return verifiedDate
        }
        return nil
    }
    
    
    private func registerForSignRequest(){
        guard let userInfo = SignedUserInfo.sharedInstance else {
            Log.echo(key: "user_socket", text:"oh my God I am going back")
            return
        }
        let room = UserDefaults.standard.string(forKey: "room_id") ?? ""
        UserSocket.sharedInstance?.pubnub.subscribe(to: [("notification"+(userInfo.id ?? "")), "schedule_updated\(room)", "call_booked_success\(room)", "schedule_cancelled\(room)", "delayed\(room)", "NewChatalyzeEvent", "DeletedChatalyzeEvent"])
        // Create a new listener instance
        let listener = SubscriptionListener()

        // Add listener event callbacks
        listener.didReceiveSubscription = { event in
          switch event {
          case let .messageReceived(message):
            print("Message Received: \(message) Publisher: \(message.publisher ?? "defaultUUID")")
            guard let data = message.payload.rawValue as? [String : Any]
            else{
                return
            }
            let rawInfosString = data.JSONDescription()
            
            Log.echo(key: "vijayRegisterForSignRequest", text: "notification ==> \(rawInfosString)")
            var rawInfos:[JSON]?
            do{
                guard let data = rawInfosString.data(using: .utf8)
                    else{
                        return
                }
                rawInfos = try JSON(data : data).arrayValue
            }catch{

            }
            if((rawInfos?.count  ?? 0) <= 0){
                return
            }
            let rawInfo = rawInfos?[0]
            let info = NotificationInfo(info: rawInfo)

            if (info.metaInfo?.type == .signRequest){
                //@abhishek : This will return & won't execute if Host already got the selfie timer.
                if self.isMutalPointReceived{
                    self.stopLoader()
                    Log.echo(key: "vijayIsMutalPointReceived", text: "\(self.isMutalPointReceived)")
                    return
                }
                let activityid = info.metaInfo?.activityId
                self.fetchAutographInfo(screenShotId: activityid)

            }
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

        // Start receiving subscription events
        UserSocket.sharedInstance?.pubnub.add(listener)
    }

    
    private func processAutographSelfie(){
   
        Log.echo(key: "HostCallController", text: "processAutographSelfie")
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        if(!eventInfo.isAutographEnabled){
            return
        }
    
        Log.echo(key: "HostCallController", text: "getSnapshot")
        autographSlotInfo = myLiveUnMergedSlot
        
        guard let requestedAutographSlotInfo = autographSlotInfo
            else{
                return
        }
        self.hostRootView?.getSnapshot(info: self.eventInfo, completion: {(image) in
            guard let image = image
                else{
                    return
            }
            Log.echo(key: "HostCallController", text: "call renderCanvas")
            self.isAutograpaghinProcess = true
            self.photoBothView?.hidePhotoboothcanvas()
            self.renderCanvas(image : image, slotInfo : requestedAutographSlotInfo)
        })
    }
    
    
    
    override func registerForListeners(){
        super.registerForListeners()
    }
    
    override func isExpired()->Bool{
        
        if(eventInfo?.isExpired ?? true){
            return true
        }
        return false
    }
    
    override func interval(){
        super.interval()
        
        Log.echo(key: TAG, text: "interval")
        
        trackChatCompletedLog()
        verifyForEarlyFeature()
        triggerIntervalToChildConnections()
        
        processEvent()
//        photoBothView?.checkForAutomatedBothStyle(eventInfo: self.eventInfo)
        updateCallHeaderInfo()
        refresh()
        updateLableAnimation()
        
        self.preconnectTwillioRoom?.switchStream(info: self.eventInfo)
        self.currentTwillioRoom?.switchStream(info:self.eventInfo)
        self.resetAutographCanvasIfNewCallAndSlotExists()
    }
    
    func trackChatCompletedLog(){
        
        guard let currentSlot = self.eventInfo?.mergeSlotInfo?.currentSlot
            else{
                return
        }
        
        if let endDate = (currentSlot.endDate?.timeIntervalTillNow) {
            if endDate < 2.0 && endDate >= 1.0 {
                self.trackCurrentChatCompleted()
                return
            }
        }
    }
    
    func verifyForPostSessionEarningScreen() {
    }
    
    func verifyForEarlyFeature(){
        
        if self.eventInfo?.isLIVE ?? false == false {
            return
        }
        
        if self.eventInfo?.isValidSlotAvailable != false {
            
            if earlyControllerReference != nil {
                
                self.earlyControllerReference?.dismiss(animated: false, completion: nil)
                self.earlyControllerReference = nil
                return
            }
            self.earlyControllerReference = nil
            return
        }
        
        if earlyControllerReference != nil {
            return
        }
        
        guard let controller = EarlyViewController.instance() else {
            return
        }
        earlyControllerReference = controller
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.closeRegistration = {
            
            self.makeRegistrationClose()
        }
        controller.keepRegistration = {
        }
        self.getTopMostPresentedController()?.present(controller, animated: true, completion: {
        })
    }
    
    func checkforRecordingStatus(){
        
        self.speedHandler?.showBottomBanner = {[weak self] success in
            
            if success{
                //already shared the resolution
            }else{
                self?.currentTwillioRoom?.logResolution()
            }
            
        }
  
        if ((eventInfo?.isRecordingEnabled ?? false)){
            self.recordingLbl.isHidden = false
        }else{
            self.recordingLbl.isHidden = true
        }
    }

    
    override func updateStatusMessage(){
        super.updateStatusMessage()
        
        guard let eventInfo = eventInfo
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        //Is event strictly in preconnect state - startTime < 30 AND startTime > 0
        //if yes, Just show it as pre-connected
        
        if(eventInfo.isPreconnectEligible){
            setStatusMessage(type: .preConnectedSuccess)
            checkforRecordingStatus()
            return
        }
        
        //if event starttime is NOT < 30 seconds
        //we want to keep showing the logo, so do nothing
        if(!eventInfo.isWholeConnectEligible){
            setStatusMessage(type: .ideal)
            return
        }
        
        //Is there any slot booked
        //if no, return
        guard let activeSlot = eventInfo.mergeSlotInfo?.upcomingSlot
            else{
                setStatusMessage(type: .ideal)
                recordingLbl.isHidden = true
                return
        }
        
        
        if(activeSlot.isLIVE && (currentTwillioRoom?.isStreaming ?? false)){
            Log.echo(key: "vijay", text: "checkforRecordingStatus 564")
            setStatusMessage(type: .connected)
            if !self.isCallHangedUp{
                // @abhishek : the selfie button should not appear to HOSt, while signing the autograpgh
                if isAutograpaghinProcess{
                    return
                }
                if !eventInfo.isHostManualScreenshot{
                    return
                }
                
                if localMediaPackage?.isVideoMuted ?? false{
                    photoBothView?.hidePhotoboothcanvas()
                    return
                }
//                if !(self.currentTwillioRoom?.remoteView?.videoDimensions.height == 0) {
//                    photoBothView?.hidePhotoboothcanvas()
//                    return
//                }

                if !SlotFlagInfo.isCallHangedUp{
                    photoBothView?.checkForAutomatedBothStyle(eventInfo: self.eventInfo)
                }
                
            }
           
            return
        }
        
        if(activeSlot.isBreak){
            Log.echo(key: "vijay", text: "Break Slot")
            setStatusMessage(type: .breakSlot)
            photoBothView?.hidePhotoboothcanvas()
            hostActionContainer?.extendChatView?.hideExtendBtn()
            return
        }
        
        if(!isSocketConnected){
            setStatusMessage(type: .socketDisconnected)
            photoBothView?.hidePhotoboothcanvas()
            return
        }
        
        guard let activeUser = activeSlot.user
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        if(!isAvailableInRoom(targetUserId: activeUser.id ?? "") && isSlotRunning && !(eventInfo.isCurrentSlotIsBreak)){
            setStatusMessage(type : .userDidNotJoin)
            photoBothView?.hidePhotoboothcanvas()
            resetCanvas()
            return;
        }
        
        if(activeSlot.isPreconnectEligible){
            setStatusMessage(type: .preConnectedSuccess)
            Log.echo(key: "vijay", text: "checkforRecordingStatus 558")
            checkforRecordingStatus()
            return
        }
        
        
        setStatusMessage(type: .ideal)
    }
    
    private func refresh(){
        
        refreshStreamLock()
    }
    
    private func getActiveConnection()->HostCallConnection?{
        
        guard let slot = eventInfo?.mergeSlotInfo?.currentSlot
            else{
                return nil
        }
        guard let connection = getConnection(slotInfo: slot)
            else{
                return nil
        }
        return connection
    }
    
    private func getPreConnectConnection()->HostCallConnection? {
        
        guard let slot = eventInfo?.mergeSlotInfo?.preConnectSlot
            else{
                return nil
        }
        guard let connection = getConnection(slotInfo: slot)
            else{
                return nil
        }
        return connection
    }
    
    
    private func updateCallHeaderInfo(){
        
        
        guard let startDate = self.eventInfo?.startDate
            else{
                return
        }
        
        guard let countdownInfo = startDate.countdownTimeFromNow()
            else{
                return
        }
       
       
        if(!countdownInfo.isActive){
            
            // countdownLabel?.updateText(label: "Your chat is finished ", countdown: "finished")
           
            updateCallHeaderAfterEventStart()
            return
        }
        
        // Below code is responsible befor the event start.
        sessionHeaderLbl?.text = "Session starts in:".localized() ?? ""
        
        var fontSize = 18
        var remainingTimeFontSize = 20
        if  UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24
            remainingTimeFontSize = 26
        }
        
        //Editing For the remaining time
        var countdownTime = ""
//         countdownTime = "\(countdownInfo.minutes) : \(countdownInfo.seconds)"
        
        if countdownInfo.hours != "00"{
            countdownTime =  "\(countdownInfo.hours) : \(countdownInfo.minutes) : \(countdownInfo.seconds)"
        }else{
            countdownTime = "\(countdownInfo.minutes) : \(countdownInfo.seconds)"
        }
        
        let timeRemaining = countdownTime.toAttributedString(font: "Nunito-ExtraBold", size: remainingTimeFontSize, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        sessionRemainingTimeLbl?.attributedText = timeRemaining
        
        //Editing  for the current Chat
        
        let slotCount = ((self.eventInfo?.slotInfos?.count ?? 0) - (self.eventInfo?.emptySlotsArray?.count ?? 0))
        let currentSlot = (self.eventInfo?.upcomingSlotInfo?.index ?? 0)
        
        if slotCount <= 0{
            //This info will only be show if slots are greater than one.
            return
        }
        
        let currentSlotText = "Chat \(currentSlot+1): "
        
        let currentMutatedSlotText = currentSlotText.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        //new username without last name
        var username = ""
        
        if let array = self.eventInfo?.mergeSlotInfo?.upcomingSlot?.user?.firstName?.components(separatedBy: " "){
            
            if array.count >= 1{
                username = array[0]
            }else{
                
                if let name = self.eventInfo?.mergeSlotInfo?.upcomingSlot?.user?.firstName{
                    
                    username  = name
                }
            }
        }else{
            
            if let name = self.eventInfo?.mergeSlotInfo?.upcomingSlot?.user?.firstName{
                username  = name
            }
        }
        
        let slotUserNameAttrStr = username.toAttributedString(font: "Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        currentMutatedSlotText.append(slotUserNameAttrStr)
        sessionCurrentSlotLbl?.attributedText = currentMutatedSlotText
        
        //Editing for the total Chats
        let totatlNumberOfSlotsText = "Total chats: "
        let totalAttrText = totatlNumberOfSlotsText.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        let totalSlots = "\(slotCount)".toAttributedString(font:"Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        totalAttrText.append(totalSlots)
        
        sessionTotalSlotNumLbl?.attributedText = totalAttrText
        
        if eventInfo?.isPreconnectEligible ?? false{
            if let bufferSec = eventInfo?.bufferSeconds{
                if bufferSec > 0{
                    self.preConnectLbl?.text = ""
                    sessionTotalSlotNumLbl?.text = ""
                    self.photoBothView?.hidePhotoboothcanvas()
                    upNextSlotInfoView?.showUpComingSlotInfo(slotNo: "\(currentSlot + 1)", upComingUser: username, time: timeRemaining.string, totalSlots: totalSlots.string)
                    hostActionContainer?.extendChatView?.hideExtendBtn()
                    
                }
            }
        }
        
    }
    
    private func updateCallHeaderAfterEventStart(){
        
        //Editing For the remaining time
       
        //Above code is responsible for handling the status if event is not started yet.
        
        ///MergeSlotInfo includes both the break slots and the live call.
        
        guard let slotInfo = self.eventInfo?.mergeSlotInfo?.upcomingSlot
            else{
//                recordingLbl.isHidden = true
                updateCallHeaderForEmptySlot()
                return
        }
        
        if  self.eventInfo?.isCurrentSlotIsEmptySlot ?? false && slotInfo.id == nil {
            
            //this will execute only if we do not have the future tickets and current slot is not the break slot.
            recordingLbl.isHidden = true
            updateCallHeaderForEmptySlot()
            return
        }
        
        if self.eventInfo?.isCurrentSlotIsBreak ?? false && !(self.eventInfo?.isValidSlotAvailable ?? false ){
            recordingLbl.isHidden = true
            updateCallHeaderForEmptySlot()
            Log.echo(key: "Vijay", text: "breakSlot @ 715")
            return
        }
        
        if self.eventInfo?.isCurrentSlotIsBreak ?? false{
            if self.isPreConnected{
                checkforRecordingStatus()
            }else{
                recordingLbl.isHidden = true
            }
            
            Log.echo(key: "Vijay", text: "breakSlot @ 720")
            updateCallHeaderForBreakSlot()
            return
        }
        
        if let array = slotInfo.user?.firstName?.components(separatedBy: " "){
            if array.count >= 1{
                
                hostRootView?.hostCallInfoContainer?.slotUserName?.text = array[0]
            }else{
                
                hostRootView?.hostCallInfoContainer?.slotUserName?.text = slotInfo.user?.firstName
            }
        }else{
            
            hostRootView?.hostCallInfoContainer?.slotUserName?.text = slotInfo.user?.firstName
        }
        
        //Below method is implemented by Yud
        //updateNewHeaderInfoForSession(slot : slotInfo)
        
        if(slotInfo.isFuture){
            
            //when call is not running but we have the slot in the future
            updateTimeRamaingCallHeaderForUpcomingSlot()
            
            updateNewHeaderInfoForFutureSession(slot : slotInfo)
        }
        else{
            
            //Updating the info text when the call is live.
            updateFutureCallHeaderForEmptySlot()
            updateCallHeaderForLiveCall(slot: slotInfo)
            hostActionContainer?.extendChatView?.showExtendBtn()
        }
    }
    
    private func updateCallHeaderForEmptySlot(){
        
        updateForEmptyBreak()
        hostRootView?.hostCallInfoContainer?.slotUserName?.text = ""
        hostRootView?.hostCallInfoContainer?.timer?.text = ""
        hostRootView?.hostCallInfoContainer?.slotCount?.text = ""
        sessionCurrentSlotLbl?.text = ""
        sessionTotalSlotNumLbl?.text = ""
        selfieWindowView?.hide()
        
        guard let endDate = self.eventInfo?.endDate
            else{
                return
        }
        
        guard let countdownInfo = endDate.countdownTimeFromNow()
            else{
                return
        }
        
        // Below code is responsible befor the event start.
        sessionHeaderLbl?.text = "Session ends in:".localized() ?? ""
        
        var fontSize = 18
        var remainingTimeFontSize = 20
        if  UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24
            remainingTimeFontSize = 26
        }
        
        
        //Editing For the remaining time
        let countdownTime = "\(countdownInfo.hours) : \(countdownInfo.minutes) : \(countdownInfo.seconds)"
        
        let timeRemaining = countdownTime.toAttributedString(font: "Nunito-ExtraBold", size: remainingTimeFontSize, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        sessionRemainingTimeLbl?.attributedText = timeRemaining
        self.earlyEndSessionView?.isHidden = false
        self.photoBothView?.hidePhotoboothcanvas()
        self.selfieWindowView?.hide()
        self.hostActionContainer?.extendChatView?.hideExtendBtn()
        if countdownTime == "00 : 00 : 00" {
            upNextSlotInfoView?.hideUpNextSlotInfo()
            self.makeRegistrationClose()
            return
        }else{
            Log.echo(key: "vijay", text: "call not over yet")
        }
    }
    
    private func updateForEmptyBreak(){
        
        breakView?.disableBreakFeature()
    }
    
    private func updateCallHeaderForBreakSlot(){
        
        //let countdownTime = "\(slotInfo.endDate?.countdownTimeFromNowAppended())"
//        recordingLbl.isHidden = true
        hostRootView?.hostCallInfoContainer?.slotUserName?.text = ""
        hostRootView?.hostCallInfoContainer?.timer?.text = ""
        hostRootView?.hostCallInfoContainer?.slotCount?.text = ""
        sessionRemainingTimeLbl?.text = ""
        sessionCurrentSlotLbl?.text = ""
        sessionTotalSlotNumLbl?.text = ""
        sessionHeaderLbl?.text = ""
        self.earlyEndSessionView?.isHidden = true
        self.selfieWindowView?.hide()
        breakView?.startBreakShowing(time: "\(String(describing: self.eventInfo?.mergeSlotInfo?.currentSlot?.endDate?.countdownTimeFromNowAppended()?.time ?? ""))")
        upNextSlotInfoView?.hideUpNextSlotInfo()
    }
    
    private func updateTimeRamaingCallHeaderForUpcomingSlot(){
        
        updateForEmptyBreak()
        
        hostRootView?.hostCallInfoContainer?.slotUserName?.text = ""
        hostRootView?.hostCallInfoContainer?.timer?.text = ""
        hostRootView?.hostCallInfoContainer?.slotCount?.text = ""
        self.earlyEndSessionView?.isHidden = true
        upNextSlotInfoView?.hideUpNextSlotInfo()
    }
    
    private func updateFutureCallHeaderForEmptySlot(){
        
        updateForEmptyBreak()
        sessionRemainingTimeLbl?.text = ""
        sessionCurrentSlotLbl?.text = ""
        sessionTotalSlotNumLbl?.text = ""
        sessionHeaderLbl?.text = ""
        self.earlyEndSessionView?.isHidden = true
        upNextSlotInfoView?.hideUpNextSlotInfo()
    }
    
    
    private func updateCallHeaderForLiveCall(slot : SlotInfo){
        
        guard let startDate = slot.endDate
            else{
                return
        }
        
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else{
                return
        }
        
        Log.echo(key: "yud", text: "updating the live call")
        checkforRecordingStatus()
        //hostRootView?.callInfoContainer?.timer?.text = "Time remaining\(counddownInfo.time)"
        hostRootView?.hostCallInfoContainer?.timer?.text = "\(counddownInfo.time)"
        //don't use merged slot for count
        let slotCount = self.eventInfo?.slotInfos?.count ?? 0
        //don't use merged slot for count
        let currentSlot = (self.eventInfo?.currentSlotInfo?.index ?? 0)
        let breakSlots = self.eventInfo?.emptySlotsArray?.count ?? 0
        
        Log.echo(key: "yud", text: " Break slots are \(breakSlots) and the  slots are \(slotCount) and the current slot is \(currentSlot)")
        
        if getTotalNUmberOfSlots() > 0{
            
            let slotCountFormatted = "\(currentSlot + 1) of \(getTotalNUmberOfSlots())"
            hostRootView?.hostCallInfoContainer?.slotCount?.text = slotCountFormatted
        }else{
            
            let slotCountFormatted = "\(currentSlot + 1) of \(slotCount)"
            hostRootView?.hostCallInfoContainer?.slotCount?.text = slotCountFormatted
        }
        
        Log.echo(key: "yud", text: "Total number of slots are \(getTotalNUmberOfSlots())")
    }
    
    private func updateCallHeaderForFuture(slot : SlotInfo) {
        
        guard let startDate = slot.startDate
            else {
                return
        }
        
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else {
                return
        }
        
        hostRootView?.hostCallInfoContainer?.timer?.text = "Starts in : \(counddownInfo.time)"
        let slotCount = self.eventInfo?.mergeSlotInfo?.slotInfos?.count ?? 0
        let currentSlot = (self.eventInfo?.mergeSlotInfo?.upcomingSlotInfo?.index ?? 0)
        let slotCountFormatted = "\(currentSlot + 1) of \(slotCount)"
        hostRootView?.hostCallInfoContainer?.slotCount?.text = slotCountFormatted
    }
    
    
    func updateLableAnimation(){
        
        guard let currentSlot = self.eventInfo?.mergeSlotInfo?.currentSlot
            else{
                
                //Log.echo(key: "animation", text: "stopAnimation")
                isAnimating = false
                stopLableAnimation()
                return
        }
        
        if let endDate = (currentSlot.endDate?.timeIntervalTillNow) {
            
          
          if endDate < 12.0 && (eventInfo?.isAutographEnabled ?? false) {
            selfieTimerView?.reset()
                     }
          
            
            if endDate <= 10.0 && endDate >= 1.0{
                isExtendChatDisbaled = true
            }else{
                isExtendChatDisbaled = false
            }
            
            if endDate < 16.0 && endDate >= 1.0 && isAnimating == false {
                
                isAnimating = true
                startLableAnimating(label: hostRootView?.hostCallInfoContainer?.timer)
                return
            }
            
            if endDate <= 0.0{
                
                isAnimating = false
                Log.echo(key: "vijay", text: " call end @ 934")
                stopLableAnimation()
                return
            }
            
            if endDate > 16.0{
                
                //implemented in order to stop Animation if new slot comes and added so that new time slot becomes (120, 180, 300 ..etc.)//
                isAnimating = false
                stopLableAnimation()
                return
            }
            Log.echo(key: "animation", text: "StartAnimation and the time is \(endDate)")
        }
    }
    
    override func trackCurrentChatCompleted(){
        
        guard let userId =  self.eventInfo?.mergeSlotInfo?.currentSlot?.userId else {
            print("User id is missing in joinedroom")
            return
        }
        guard let chatId =  self.eventInfo?.mergeSlotInfo?.currentSlot?.id else {
            print("User id is missing in joinedroom")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId] as [String : Any]
        print("Meta info in joinedroom is \(metaInfo)")
        let action = "chatCompleted"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    private func processEvent(){
        
        Log.echo(key : "delay", text : "processEvent")
        
        if !(UserSocket.sharedInstance?.isRegisteredToServer ?? false){
            return
        }
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "ping", text: "evenInfo is nil")
                return
        }
        
        if(eventInfo.started == nil){
            Log.echo(key: "ping", text: "event is not started yet")
            return
        }
        
        //disconnectStaleConnection()
        callRoomSwitchingHandler()
        preconnectTwillioRoomHandler()
        Log.echo(key: "vijay", text: "checkforRecordingStatus 978")
    }
    
    func resetAllRooms(){
        Log.echo(key: TAG, text: "resetAllRooms")
          if let ctr = currentTwillioRoom{
              ctr.disconnect()
              self.currentTwillioRoom = nil
          }
          
          if let pcr = preconnectTwillioRoom{
              pcr.disconnect()
              self.preconnectTwillioRoom = nil
          }
      }
    
       func callRoomSwitchingHandler(){
            
            //case: Event does not exists
            guard let _ = self.eventInfo
                else{
                    resetAllRooms()
                    return
            }
        
            
            //case: No event exists
            guard let currentSlotId = self.eventInfo?.mergeSlotInfo?.currentSlot?.id else{
                resetCurrentRoom()
                return
            }
        Log.echo(key: "vijay", text: "PreCoonect @ 1106")
        checkforRecordingStatus()
            //case : when pre connect exists
            if let preconnectRoom = self.preconnectTwillioRoom{
                Log.echo(key: "vijay", text: "when pre connect exists @ 1021")
                //case: when preconnect becomes current room.
                if currentSlotId == preconnectRoom.slotInfo?.id ?? 0{
                    resetCurrentRoom()
                    self.currentTwillioRoom = preconnectTwillioRoom
                    //switch to new call through media
                    self.preconnectTwillioRoom = nil
                }
            }
            
            //case: Current room exits and verify its correct existence.
            if let currentRoom = self.currentTwillioRoom{
                //case when correct room is connected and call is working fine.
                
                if currentRoom.slotInfo?.id == self.eventInfo?.mergeSlotInfo?.currentSlot?.id{
                    return
                }
                resetCurrentRoom()
        }
        createNewTwillioRoom()
    }
    
    func resetCurrentRoom(){
        
        if let ctr = currentTwillioRoom{
            ctr.disconnect()
            self.currentTwillioRoom = nil
        }
    }
        
    func createNewTwillioRoom(){
        
        guard let _ = self.eventInfo
            else{
                return
        }
        
        guard let currentSlot = self.eventInfo?.mergeSlotInfo?.currentSlot else{
            return
        }
        
        guard let activeCurrentSlot = self.eventInfo?.currentSlot
        else{
            return
        }
        
        
        if self.currentTwillioRoom == nil{
            let currentTwillioRoom = HostCallConnection()
            
            self.currentTwillioRoom = currentTwillioRoom
            self.currentTwillioRoom?.eventInfo = self.eventInfo
            self.currentTwillioRoom?.slotInfo = currentSlot
            self.currentTwillioRoom?.localMediaPackage = self.localMediaPackage
            self.currentTwillioRoom?.remoteView = self.rootView!.remoteVideoView!.streamingVideoView!
            self.currentTwillioRoom?.renderer = self.rootView?.remoteVideoView?.getRenderer()
            
            Log.echo(key: self.TAG, text: "currentTwilioRoom - fetch FetchToken")
            fetchTwillioDeviceToken(twillioRoom: currentTwillioRoom, targetSlotInfo: activeCurrentSlot)
            //print("Creating the new call room from \(String(describing: createNewTwillioRoom))")
            return
        }
        
        guard let currentTwillioRoom = self.currentTwillioRoom
        else{
            return
        }
        
        if(currentTwillioRoom.accessToken == "" && !currentTwillioRoom.isFetchingTokenToServer){
            Log.echo(key: self.TAG, text: "currentTwilioRoom - refresh FetchToken")
            fetchTwillioDeviceToken(twillioRoom: currentTwillioRoom, targetSlotInfo: activeCurrentSlot)
        }
    }
    
        
        func preconnectTwillioRoomHandler(){
            
            guard let eventInfo = self.eventInfo
                else{
                    Log.echo(key: "NewArch", text: "Missing event ID")
                    return
            }
            
            
            guard let preConnectSlot = eventInfo.mergeSlotInfo?.preConnectSlot
                else{
                    Log.echo(key: "NewArch", text: "preConnectUser -> preconnectSlot is nil")
                     isPreConnected = false
                    return
            }
            if preconnectTwillioRoom == nil{
                //create a object with all info and sent to fetch the token for the call.
                Log.echo(key: "NewArch", text: "creating the preconnect room")
                
                if preConnectSlot.id != nil{
                    self.isPreConnected = true
                    checkforRecordingStatus()
                    
                    Log.echo(key: "vijay", text: "checkforRecordingStatus 1103")
                    let preconnectTwillioRoom = HostCallConnection()
                    self.preconnectTwillioRoom = preconnectTwillioRoom
                    self.preconnectTwillioRoom?.eventInfo = self.eventInfo
                    self.preconnectTwillioRoom?.slotInfo = preConnectSlot
                    self.preconnectTwillioRoom?.localMediaPackage = self.localMediaPackage
                    self.preconnectTwillioRoom?.remoteView = self.rootView!.remoteVideoView!.streamingVideoView!
                    self.preconnectTwillioRoom?.renderer = self.rootView?.remoteVideoView?.getRenderer()
                    
                    Log.echo(key: self.TAG, text: "preconnect - fetch FetchToken")
                    fetchTwillioDeviceToken(twillioRoom: preconnectTwillioRoom, targetSlotInfo: preConnectSlot)
                }
                
                return
            }
            
            guard let room = preconnectTwillioRoom
            else{
                return
            }
           
            if(room.accessToken == "" && !room.isFetchingTokenToServer){
                Log.echo(key: self.TAG, text: "preconnect - refresh FetchToken")
                fetchTwillioDeviceToken(twillioRoom: room, targetSlotInfo: preConnectSlot)
            }
        }
    
    private func verifyIfExpired(){
        
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        if(!eventInfo.isExpired){
            return
        }
        
        self.processExitAction(code : .expired)
    }
    
    //only two connections at maximum stay in queue at a time
    private func triggerIntervalToChildConnections(){
        for (_, connection) in connectionInfo {
            connection.interval()
        }
    }
    
    var myLiveUnMergedSlot : SlotInfo?{
        
        guard let slotInfo = eventInfo?.currentSlotInfo?.slotInfo
            else{
                return nil
        }
        return slotInfo
    }
    
    private func disconnectStaleConnection(){
        
        for (key, connection) in connectionInfo {
            //remove connection if aborted
            if(connection.isReleased){
                connectionInfo[key] = nil
                return
            }
            
            guard let slotInfo = connection.slotInfo
                else{
                    return
            }
            
            if(slotInfo.isExpired){
                connection.disconnect()
                connectionInfo[key] = nil
            }
        }
    }
    
//    private func preconnectUser(){
//
//        guard let eventInfo = self.eventInfo
//            else{
//                Log.echo(key: "processEvent", text: "preConnectUser -> eventInfo is nil")
//                return
//        }
//
//        guard let preConnectSlot = eventInfo.mergeSlotInfo?.preConnectSlot
//            else{
//
//                //Log.echo(key: "processEvent", text: "preConnectUser -> preconnectSlot is nil")
//                return
//        }
//
//        connectUser(slotInfo: preConnectSlot)
//    }
    
    
//    private func connectLiveUser(){
//
//        guard let eventInfo = self.eventInfo
//            else{
//                Log.echo(key: "handshake", text: "connectLiveUser -> eventInfo is nil")
//                return
//        }
//
//        guard let slot = eventInfo.mergeSlotInfo?.currentSlot
//            else{
//                Log.echo(key: "handshake", text: "connectLiveUser -> slot is nil")
//                return
//        }
//
//        connectUser(slotInfo: slot)
//    }
    
//    private func connectUser(slotInfo : SlotInfo?){
//
//        guard let eventInfo = self.eventInfo
//            else{
//                Log.echo(key: "handshake", text: "connectUser -> eventInfo is nil")
//                return
//        }
//
//        guard let slot = slotInfo
//            else{
//                Log.echo(key: "handshake", text: "connectUser -> slot is nil")
//                return
//        }
//
//        guard let targetHashedId = slot.user?.hashedId
//                   else{
//                       Log.echo(key: "handshake", text: "connectUser -> targetHashedId is nil")
//                       return
//               }
//
//        if(!isOnline(hashId: targetHashedId)){
//            Log.echo(key: "handshake", text: "isOnline NO -> targetHashedId")
//            return
//        }
//
//        guard let connection = getWriteConnection(slotInfo : slot)
//            else{
//                Log.echo(key: "handshake", text: "connectUser -> getConnection is nil")
//                return
//        }
//
//
//
//        if(connection.isInitiated){
//            Log.echo(key: "handshake", text: "connectUser -> isInitiated")
//            return
//        }
//
//
//        if(slot.isHangedUp){
//            Log.echo(key: "handshake", text: "connectUser -> isHangedUp")
//            return
//        }
//
//        Log.echo(key: "handshake", text: "connectUser -> initateHandshake")
//
//        connection.initateHandshake()
//    }
    
    private func getConnection(slotInfo : SlotInfo?) ->HostCallConnection?{
        
        guard let slotInfo = slotInfo
            else{
                return nil
        }
        
        guard let targetHashedId = slotInfo.user?.hashedId
            else{
                return nil
        }
        
        var connection = connectionInfo[targetHashedId]
        
        return connection
    }
    
    
//    private func getWriteConnection(slotInfo : SlotInfo?) ->HostCallConnection?{
//
//        guard let slotInfo = slotInfo
//            else{
//                return nil
//        }
//
//        guard let targetHashedId = slotInfo.user?.hashedId
//            else{
//                return nil
//        }
//
//        var connection = connectionInfo[targetHashedId]
//        if(connection == nil){
//            connection = HostCallConnection(eventInfo: eventInfo, slotInfo: slotInfo, localMediaPackage : localMediaPackage, controller: self)
//        }
//        connection?.setDisposeListener(disposeListener: { [weak self] in
//            self?.connectionInfo[targetHashedId] = nil
//        })
//        connectionInfo[targetHashedId] = connection
//        connection?.slotInfo = slotInfo
//        return connection
//    }
    
    //{"id":"receiveVideoRequest","data":{"sender":"chedddiicdaibdia","receiver":"jgefjedaafbecahc"}}
    
    override func exit(code : exitCode){
        super.exit(code : code)
        
        for (_, connection) in connectionInfo {
            connection.disconnect()
        }
    }
    
    override func verifyEventActivated(info : EventScheduleInfo, completion : @escaping ((_ success : Bool, _ info  : EventScheduleInfo?)->())){
        
        let eventInfo = info
        
        //already activated
        if(eventInfo.started != nil){
            completion(true, eventInfo)
            return
        }
        
        guard let eventId = eventInfo.id
            else{
                completion(false, eventInfo)
                return
        }
        
        let eventIdString = "\(eventId)"
        ActivateEvent().activate(eventId: eventIdString) {[weak self] (success, eventInfo) in
            
            //can't use eventInfo received from ActivateEvent because it lags slots information
            
            self?.refreshInfo(eventInfo : info, completion: completion)
            
        }
    }
    
    
    private func refreshInfo(eventInfo : EventScheduleInfo, completion : @escaping ((_ success : Bool, _ info  : EventScheduleInfo?)->())){
        
        self.loadInfo(completion: { (success, info) in
            
            if(!success){
                completion(false, eventInfo)
                return
            }
            guard let updateInfo = info
                else{
                    completion(false, eventInfo)
                    return
            }
            completion(true, updateInfo)
        })
    }
    
 
//    var isCallConnected : Bool{
//        return (self.connection?.isConnected ?? false)
//    }
    
    var isCallStreaming: Bool{
        return (self.currentTwillioRoom?.isStreaming ?? false)
    }
    
    
    override func handleMultipleTabOpening(){
        self.processExitAction(code : .prohibited)
        
    }
    
    override func processExitAction(code : exitCode){
        super.processExitAction(code: code)
        
        //print("disconnection is calling in host")
        //self.connection?.disconnect()
        
        resetAllRooms()
        
        //        if code != .prohibited{
        //            UserSocket.sharedInstance?.socket?.emit("callroom:close")
        //        }
        //self.connection = nil
    }
    
    override func eventCancelled(){
        self.processExitAction(code: .userAction)
        //Event Cancelled
    }
    
    override func hitEventOnSegmentIO(){
        SEGAnalytics.shared().track("Session Enter Host")
    }
    
}

//instance
extension GreenRoomCallController{
    
    class func instance()->GreenRoomCallController?{
        
        let storyboard = UIStoryboard(name: "greenroom", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GreenRoomCallController") as? GreenRoomCallController
        return controller
    }
}

extension GreenRoomCallController:GetisHangedUpDelegate{
    
    func restartSelfie() {
      
    }
    
    func getHangUpStatus() -> Bool {
        
        print("jfghjfhgjdf\(isCallHangedUp) and is straming \(isCallStreaming)")
        return isCallHangedUp || (!isCallStreaming)
    }
}


extension GreenRoomCallController {
    
    private func updateNewHeaderInfoForFutureSession(slot : SlotInfo){
        
        guard let startDate = slot.startDate
            else{
                return
        }
        
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else{
                return
        }
        
        
        sessionHeaderLbl?.text = "Chat starts in:".localized() ?? ""
        
        let slotCount =  ((self.eventInfo?.slotInfos?.count ?? 0) - (self.eventInfo?.emptySlotsArray?.count ?? 0))
        var currentSlot = (self.eventInfo?.upcomingSlotInfo?.index ?? 0)
        currentSlot = currentSlot - (self.eventInfo?.emptySlotsArray?.count ?? 0)
        
        var fontSize = 18
        var remainingTimeFontSize = 20
        if  UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24
            remainingTimeFontSize = 26
        }
        
        //Editing For the remaining time
        
        let timeRemaining = "\(counddownInfo.time)".toAttributedString(font: "Nunito-ExtraBold", size: remainingTimeFontSize, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        
        sessionRemainingTimeLbl?.attributedText = timeRemaining
        
        //Editing  for the current Chat
        
        let currentSlotText = "Chat \(currentSlot+1): "
        let currentMutatedSlotText = currentSlotText.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        //new username without last name
        
        var username = ""
        
        if let array = slot.user?.firstName?.components(separatedBy: " "){
            
            if array.count >= 1{
                
                username = array[0]
            }else{
                
                if let name = slot.user?.firstName{
                    username  = name
                }
            }
        }else{
            
            if let name = slot.user?.firstName{
                username  = name
            }
        }
        
        //End
        if let slotUserName = slot.user?.firstName{
            username = slotUserName
        }
        
        let slotUserNameAttrStr = username.toAttributedString(font: "Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        currentMutatedSlotText.append(slotUserNameAttrStr)
        sessionCurrentSlotLbl?.attributedText = currentMutatedSlotText
        
        //Editing for the total Chats
        
        let totatlNumberOfSlotsText = "Total chats: "
        let totalAttrText = totatlNumberOfSlotsText.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        let totalSlots = "\(slotCount ?? 0 )".toAttributedString(font:"Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        totalAttrText.append(totalSlots)
        
        sessionTotalSlotNumLbl?.attributedText = totalAttrText
        
        if eventInfo?.mergeSlotInfo?.upcomingSlot?.isPreconnectEligible ?? false{
                    if let bufferSec = eventInfo?.bufferSeconds{
                        if bufferSec > 0{
                            self.preConnectLbl?.text = ""
                            sessionCurrentSlotLbl?.text = ""
                            self.photoBothView?.hidePhotoboothcanvas()
                            upNextSlotInfoView?.showUpComingSlotInfo(slotNo: "\(currentSlot + 1)", upComingUser: username, time: timeRemaining.string, totalSlots: totalSlots.string)
                            hostActionContainer?.extendChatView?.hideExtendBtn()
        
                        }
                    }
                }
    }
}


extension GreenRoomCallController{
    
    func makeRegistrationClose(){
        
        self.showLoader()
        CloseRegistration().close(eventId: self.eventId ?? "") { (success) in
            self.stopLoader()
            
            if success{
                
                self.processExitAction(code : .earlyExit)
                return
            }
            return
        }
    }
}



extension GreenRoomCallController{
    
    // End session early button Action
    
    @IBAction func endSessionEarly(sender:UIButton?){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Are you sure you want to end your session?".localized() ?? "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "End session early".localized() ?? "", style: .default, handler: { (success) in
            
            self.makeRegistrationClose()
        }))
        
        alert.addAction(UIAlertAction(title: "Keep registration open".localized() ?? "", style: .cancel, handler: { (success) in
        }))
        
        self.present(alert, animated: true) {
        }
    }
}


extension GreenRoomCallController{
    
    func getTotalNUmberOfSlots()->Int{
        
        guard let startTime = self.eventInfo?.startDate else {
            return 0
        }
        
        guard let endTime = self.eventInfo?.endDate else {
            return 0
        }
        
        let timeDiffreneceOfSlots = endTime.timeIntervalSince(startTime)
        
        let totalminutes = (timeDiffreneceOfSlots/60)
        
        guard let duration = self.eventInfo?.duration else{
            return 0
        }
        
        let totalSlots = Int(totalminutes/duration)
        
        return totalSlots
    }
}

extension GreenRoomCallController{
    
    @IBAction func showCanvas(){
        
    }
}

extension GreenRoomCallController{
        
    func fetchAutographInfo(screenShotId:String?){
        
        guard let id = screenShotId else{
            return
        }
        
        self.showLoader()
        AutographyFetchInfo().fetchInfo(id: id) { (success, info) in
            self.stopLoader()
            
            if(!success){
                return
            }
            self.autoGraphInfo = info
            
            guard let infoCallBookingId  = info?.callBookingId else {
                return
            }
            
            guard let currentSlotId = self.eventInfo?.currentSlotInfo?.slotInfo?.id else{
                return
            }
            
            if String(infoCallBookingId) != String(currentSlotId){
                return
            }
            
            self.hostRootView?.canvas?.slotInfo = self.eventInfo?.currentSlotInfo?.slotInfo
            
            self.downLoadScreenShotImage()
            //Download image and send it to the canvas in order to set the image.
        }
    }
    
    fileprivate func downLoadScreenShotImage(){

        guard let info = self.autoGraphInfo else{
            return
        }
        
        guard let urlString = self.autoGraphInfo?.screenshot
            else{
                return
        }
        
        self.showLoader()
        SDWebImageDownloader().downloadImage(with: URL(string:urlString), options: SDWebImageDownloaderOptions.highPriority, progress: { (totalBytesSent, totalBytesExpectedToSend, url) in
            
            DispatchQueue.main.async(execute: {
                
                let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                let progressPercent = Int(uploadProgress*100)
                ///self.downloadLable?.text = "\(progressPercent) %"
                print(progressPercent)
            })
//            print("recieved Size is")
//            print(totalBytesSent)
//            print("Expected Size is")
//            print(totalBytesExpectedToSend)
            
        }) { (image, imageData, error, success) in
            
            DispatchQueue.main.async(execute: {
                
                self.stopLoader()

                Log.echo(key: "point", text: "Image Down loading is successfull \(String(describing: info)) and its frame is \(String(describing: image?.size.height)) and the width is \(String(describing: image?.size.width))")
                
                
                
                if(image == nil){
                    //oops something went wrong please try again
                    return
                }
                
                
                guard let infoCallBookingId  = self.autoGraphInfo?.callBookingId else {
                    return
                }
                
                guard let currentSlotId = self.eventInfo?.currentSlotInfo?.slotInfo?.id else{
                    return
                }
                
                if String(infoCallBookingId) != String(currentSlotId){
                    return
                }
                
                self.lockDeviceOrientation()
                self.hostRootView?.canvasContainer?.show(with:image)

                self.hostRootView?.remoteVideoContainerView?.isSignatureActive = true
                self.hostRootView?.remoteVideoContainerView?.updateForSignature()
                self.signaturAccessoryView?.isHidden = false
                self.isSignatureActive = true
                
                self.hostRootView?.localVideoView?.isSignatureActive = true
                self.hostRootView?.localVideoView?.updateLayoutRotation()
                self.sendScreenshotConfirmation()
                
            })
        }
    }
    
    
    private func renderCanvas(image : UIImage, slotInfo : SlotInfo){
        let currentSlot = slotInfo
        
        guard let activeSlot = myLiveUnMergedSlot
            else{
                return
        }
        
        if(activeSlot.id != currentSlot.id){
            return
        }
        
        
        self.hostRootView?.canvas?.slotInfo = currentSlot
        self.lockDeviceOrientation()
        self.hostRootView?.canvasContainer?.show(with:image)

        self.hostRootView?.remoteVideoContainerView?.isSignatureActive = true
        self.hostRootView?.remoteVideoContainerView?.updateForSignature()
        self.signaturAccessoryView?.isHidden = false
        self.isSignatureActive = true
        
        self.hostRootView?.localVideoView?.isSignatureActive = true
        self.hostRootView?.localVideoView?.updateLayoutRotation()
        
        Log.echo(key: "HostCallController", text: "send screenshot confirmation")
        isMutalPointReceived = true
        self.photoBothView?.hidePhotoboothcanvas()
        sendScreenshotConfirmation()
    }
     
    private func generateAutographInfo() -> [String : Any?]{
        
        var params = [String : Any?]()
        guard let currentSlot = autographSlotInfo
            else{
                return params
        }
        params["userId"] = currentSlot.userId
        params["analystId"] = eventInfo?.userId
        params["screenshot"] = ""
        params["signed"] = false
        params["id"] = 0
        params["color"] = ""
        params["text"] = ""
        params["paid"] = false
        return params
    }
    
    private func sendScreenshotConfirmation(){
        
        
        guard let currentSlot = autographSlotInfo
            else{
                return
        }
        
        self.view.layoutIfNeeded()
        var params = [String : Any]()
        let size = self.hostRootView?.canvas?.frame.size ?? CGSize()
        params["width"] = size.width
        params["height"] = size.height
        params["screenshot"] =  generateAutographInfo()
        
        if let currentSlotId = autographSlotInfo?.id {
            params["forSlotId"] = "\(currentSlotId)"
        }

        var mainParams  = [String : Any]()
        mainParams["id"] = "startedSigning"
        mainParams["name"] = currentSlot.user?.hashedId
        mainParams["message"] = params
        socketClient?.emit(mainParams)
        //@abhishek: This will enables host to sign autograpgh if screenshot failed to load on User side.
        removeBlurImageViewInfailure()
        
    }
    
    private func removeBlurImageViewInfailure(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            self.hostRootView?.canvasContainer?.removeBlurImageView()
        }
    }
    func stopSigning(){
        
        guard let currentSlot = autographSlotInfo
            else{
                return
        }
        
        var mainParams  = [String : Any]()
        mainParams["id"] = "stoppedSigning"
        mainParams["name"] = currentSlot.user?.hashedId
        socketClient?.emit(mainParams)
    }
    
    private func resetCanvas(){
        
        if(!isSignatureActive){
            return
        }
        
        self.releaseDeviceOrientation()
        self.stopSigning()
        self.hostRootView?.canvasContainer?.hide()
        self.signaturAccessoryView?.isHidden = true
        self.hostRootView?.remoteVideoContainerView?.isSignatureActive = false
        self.hostRootView?.remoteVideoContainerView?.updateForCall()
        
        self.hostRootView?.localVideoView?.isSignatureActive = false
        self.hostRootView?.localVideoView?.updateLayoutOnEndOfCall()
        self.isSignatureActive = false
        
    }

    private func resetAutographCanvasIfNewCallAndSlotExists(){
        
        //if current slot id is nil then return
        if self.myLiveUnMergedSlot?.id == nil {
            
            if self.isSignatureActive{
                Log.echo(key: "point", text: "Resetting the canvase")
                
                self.resetCanvas()
                self.isSignatureActive = false
            }
            return
        }
        
        if localSlotIdToManageAutograph == nil{
            
            Log.echo(key: "yud", text: "providing id to unmerged slot is nil")
            localSlotIdToManageAutograph = self.myLiveUnMergedSlot?.id
            return
        }
        
        if localSlotIdToManageAutograph != self.myLiveUnMergedSlot?.id {
            
            Log.echo(key: "yud", text: "Providing id is changed for new slot")
            localSlotIdToManageAutograph = self.myLiveUnMergedSlot?.id
            self.resetCanvas()
            selfieTimerView?.reset()
            isMutalPointReceived = false
            //reset the signature
            return
        }
        
    }
    
    
    private func uploadImage(encodedImage:String, autographSlotInfo : SlotInfo?, completion : ((_ success : Bool, _ info : ScreenshotInfo?)->())?){
                
        var params = [String : Any]()
        params["userId"] = autographSlotInfo?.userId
        params["analystId"] = SignedUserInfo.sharedInstance?.id ?? 0
        params["callbookingId"] = autographSlotInfo?.id ?? 0
        params["callScheduleId"] = eventInfo?.id ?? 0
        params["defaultImage"] = false
        params["file"] = encodedImage
        params["isImplemented"] = true
        params["signed"] = true
        
        SubmitScreenshot().submitScreenshot(params: params) { (success, info) in
            
            DispatchQueue.main.async {
                completion?(success, info)
            }
        }
    }
    
    
    private func uploadAutographImage(){

        guard let slotInfo = autographSlotInfo
            else{
                return
        }
        guard let image = self.hostRootView?.canvas?.getSnapshot()
            else{
                return
        }
        
        encodeImageToBase64(image: image) {[weak self] (encodedImage) in
            self?.uploadImage(encodedImage: encodedImage, autographSlotInfo: slotInfo) { (success, info) in
            }
        }
    }
}

extension GreenRoomCallController:AutographSignatureBottomResponseInterface{
    
    func doneAction(sender:UIButton?){
        
        print("done is calling")
        self.uploadAutographImage()
        self.resetCanvas()
        isAutograpaghinProcess = false
        if eventInfo?.isHostManualScreenshot ?? false{
            self.photoBothView?.showPhotoboothcanvas()
        }
        self.showToastWithMessage(text: "Saving Autograph..", time: 5.0)
    }
    
    func undoAction(sender:UIButton?){
        self.hostRootView?.canvas?.undo()
    }

    func pickerSelectedColor(color: UIColor?) {
        
        self.hostRootView?.canvas?.updateColorFromPicker(color:color)
        self.signaturAccessoryView?.ColorViewClass?.mainColorView?.isHidden = true
    }
    
    @IBAction func testOrientation(){
        
        self.hostRootView?.canvasContainer?.show(with: UIImage(named:"testingImage"))
        self.hostRootView?.remoteVideoContainerView?.isSignatureActive = true
        self.signaturAccessoryView?.isHidden = false
        self.isSignatureActive = true
        
        self.hostRootView?.localVideoView?.isSignatureActive = true
        self.hostRootView?.localVideoView?.updateLayoutRotation()
        self.hostRootView?.remoteVideoContainerView?.updateForSignature()
    }
    
    func lockDeviceOrientation(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if UIApplication.shared.statusBarOrientation.isLandscape{
            
            delegate?.isSignatureInCallisActive = true
            
            Log.echo(key: "HostCallController", text: "lockDeviceOrientation -> \(UIDevice.current.orientation)")
            
            if UIApplication.shared.statusBarOrientation == .landscapeLeft{
                Log.echo(key: "HostCallController", text: "lockDeviceOrientation -> left")
                delegate?.signatureDirection = .landscapeLeft
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                
            }else if UIApplication.shared.statusBarOrientation == .landscapeRight{
                
                Log.echo(key: "HostCallController", text: "lockDeviceOrientation -> right")
                
                delegate?.signatureDirection = .landscapeRight
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
        }else{
            
            delegate?.isSignatureInCallisActive = true
            delegate?.signatureDirection = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
        
    func releaseDeviceOrientation(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.isSignatureInCallisActive = false
        delegate?.allowRotate = true
        UIDevice.current.setValue(UIInterfaceOrientationMask.all.rawValue, forKey: "orientation")
    }
    
    private func presentModally(_ viewController: UIViewController,
                                presenationStyle: UIModalPresentationStyle = .overFullScreen) {
        
        let leftBarButtonItem = UIBarButtonItem(title: "RETURN TO CHAT", style: .done, target: self, action: #selector(dismissViewController))
        leftBarButtonItem.tintColor = UIColor(hexString: AppThemeConfig.themeColor)
        
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = presenationStyle
        present(navigationController, animated: true)
    }
    @objc private func dismissViewController() {
      dismiss(animated: true, completion: nil)
    }
}


//MARK:- Fetching the Twillio Access token
extension GreenRoomCallController{
    
    func fetchTwillioDeviceToken(twillioRoom:HostCallConnection, targetSlotInfo : SlotInfo?){
        
        print("calling the fetch Twillio Device token")
        
        twillioRoom.isFetchingTokenToServer = true
        FetchHostTwillioTokenProcessor().fetch(sessionId: eventId, chatID: targetSlotInfo?.id, greenRoom: true) { (success, error, info) in
            
            print("got the  the fetch Twillio Device token with the token \(String(describing: info?.room)) and the access Token  \(String(describing: info?.token))")
            twillioRoom.isFetchingTokenToServer = false
            if !success {
                return
            }
            
            guard let token = info?.token else{
                return
            }
            guard let room = info?.room else{
                return
            }
            
            twillioRoom.accessToken = token
            twillioRoom.roomName = room
            twillioRoom.connectCall()
        }
    }
}


