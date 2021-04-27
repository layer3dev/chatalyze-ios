//
//  UserCallController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 27/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//
import UIKit
import SwiftyJSON
import TwilioVideo
import SDWebImage
import Analytics

class UserCallController: VideoCallController {
    
    private let TAG = "UserCallController"
    
    var isUserScreenLocked = false
    var isScrenUploaded :((Bool)->())?
    // Id's to manage the default Screenshot
    // Wait for web service approval then call process if required.
    
    var defaultSignatureTimer = DefaultTimerForSignature()
    var defaultSignatureInitiated = false
    var localSlotIdToManageDefaultScreenshot:Int? = nil
    
    var localSlotIdToManageAutograph:Int? = nil
    var localScreenShotAssociatedCallBookingId:Int? = nil
    
    var memoryImage:UIImage?
    var recordingLblTopAnchor: NSLayoutConstraint?
    
    //Animation Responsible
    var isAnimating = false
    var isSlefieScreenShotSaved = false
    var defaultImage : UIImage?
    var isPreConnected = false
    var isConnectionDroppedInBtw = false
    
    //variable and outlet responsible for the SelfieTimer
    var isSelfieTimerInitiated = false
    @IBOutlet var selfieTimerView:SelfieTimerView?
    @IBOutlet var countDountAttrTimerLbl:UILabel?
    @IBOutlet var futureSessionView:UIView?
    @IBOutlet var futureSessionBlackBox:UIView?
    @IBOutlet var futureSessionHeaderLbl:UILabel?
    @IBOutlet var futureSessionPromotionImage:UIImageView?
    
    // isScreenshotStatusLoaded variable will let us know after verifying that screenShot is saved or not through the webservice.
    
    var isScreenshotStatusLoaded = false
    
    private var isFetchingTwilioAccessToken = false
    
    //Ends
    //This is webRTC connection responsible for signalling and handling the reconnect
    
    override var roomType : UserInfo.roleType{
        return .user
    }
    
   
    
    var connection : UserCallConnection?
    private var screenshotInfo : ScreenshotInfo?
    private var canvasInfo : CanvasInfo?
    var isScreenshotPromptPage = false
    
    
    lazy var custumBckGrndImg  : UIImageView = {
        let ui = UIImageView()
        ui.backgroundColor = .clear
        ui.contentMode = .scaleAspectFill
        return ui
    }()
    
    lazy var recordingLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "  ● Recording  "
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
    var screenInfoDict:[String:Any] = ["id":"","isScreenShotSaved":false,"isScreenShotInitaited":false]
    
    
    override func processEventInfo(){
        super.processEventInfo()
        
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        loadDefaultImage(eventInfo: eventInfo)
        loadYoutubeVideo(eventInfo: eventInfo)
        loadbackgrndImg(eveninfo: eventInfo)
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
        
     let organization  =  eveninfo.user?.organization
        Log.echo(key: "dhimu", text: "\(organization)")
    }
    
    private func loadYoutubeVideo(eventInfo : EventScheduleInfo){
        guard let youtubeURL = eventInfo.youtubeURL
            else{
                return
        }
        userRootView?.youtubeContainerView?.load(rawUrl : youtubeURL)
       
    }
    
    func loadDefaultImage(eventInfo : EventScheduleInfo){
        guard let url = eventInfo.room_id
        else{
            return
        }
        downloadDefaultImage(with: url)
    }
    
   
    
    override func renderIdleMedia(){
        userRootView?.youtubeContainerView?.show()
    }
    
    override func stopIdleMedia(){
        userRootView?.youtubeContainerView?.hide()
    }
    
    
    var userRootView : UserVideoRootView?{
        return self.view as? UserVideoRootView
    }
    
    var isHangUp:Bool{
        
        return localMediaPackage?.isDisabled ?? true
    }
    
  
    override var localCameraPreviewView: VideoView?{
        return self.rootView?.localVideoView?.streamingVideoView
    }
    
    override var localVideoRenderer:VideoFrameRenderer?{
        return self.rootView?.localVideoView?.getRenderer()
    }
    
    override func initialization(){
        super.initialization()
        layoutCustomBackGrnd()
        layoutrecordingOption()
        initializeVariable()
        registerForAutographListener()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func interval(){
        super.interval()
        
        Log.echo(key: "yud", text: "Interval timer is working")
        trackCallTochatComplete()
        DispatchQueue.main.async {
            self.verifyIfExpired()
            self.processAutograph()
        }
        //TODO:- Insert below two functions in the main thread once the signature feature is enabled.
        self.updateCallHeaderInfo()
        self.updateLableAnimation()
        self.twillioCallSwitcher()
        if isPreConnected{
            checkforRecordingStatus()
        }else{
            recordingLbl.isHidden = true
        }
        
        self.connectToCallAndRender()
        resetAutographCanvasIfNewCallAndSlotExists()
        processDefaultSignature()
        //MISSING REFERSH STREAM LOCK
    }
    
    func trackCallTochatComplete(){
        
        guard let currentSlot = eventInfo?.mergeSlotInfo?.myValidSlot.slotInfo
            else{
                return
        }
        
        if let endDate = (currentSlot.endDate?.timeIntervalTillNow) {
            if endDate >= 1.0 && endDate < 2.0{
                self.isPreConnected = false
                trackCurrentChatCompleted()
                return
            }
        }
    }
    
    func twillioCallSwitcher(){
        
        guard let conn = self.connection else{
            return
        }
        conn.handleCallConnectionAndStreaming(info:self.myLiveUnMergedSlot)
    }
    
    func resetStaleConnection(){
        
        if self.connection == nil {
            print("Already stale connection")
            return
        }
        
        if self.myLiveUnMergedSlot == nil && self.eventInfo?.mergeSlotInfo?.preConnectSlot == nil{
         
            print("connection resetted")
            self.connection?.disconnect()
            self.connection = nil
        }
    }
    
    //MARK:- New socket connection
    func connectToCallAndRender(){
        
        //print("Usersocket status is \(String(describing: UserSocket.sharedInstance?.isRegisteredToServer))")
        //print("Current merged active slot iString(describing: d \(self.myActiveUserSlot)?.id) single unmerged slot iString(describing: d \(self.myLiveUnMergedSlot)?.id) and preconnectSlotId is  and real preconnect iString(describing: s \(self.eventInfo?.mergeSlotInfo?.preConnectSlot)?.id)")
        //Yet to give the support of resetting the session if no slot is present.
        
        
        if self.connection != nil {
            resetStaleConnection()
            Log.echo(key: "NewArch", text: "Connection already created.")
            checkforRecordingStatus()
            return
        }
        
        guard let eventInfo = self.eventInfo else{
            Log.echo(key: "NewArch", text: "Missing eventInfo ")
            return
        }
        
        if(isFetchingTwilioAccessToken){
            return
        }
        
        if let currentSlot = self.myLiveUnMergedSlot{
            initiateTwilioConnection(slotInfo: currentSlot)
            return
        }
        
        if let preconnectSlot = self.eventInfo?.mergeSlotInfo?.preConnectSlot {
            
            ///If preconnect slot exists. Need to verify too that it is exists or not.
            //(eventInfo : EventScheduleInfo?, localMediaPackage : CallMediaTrack?, controller : VideoCallController?,roomName:String,accessToken:String,remoteVideo:VideoView)
             let userId = String(preconnectSlot.userId ?? -1)
                if let id = SignedUserInfo.sharedInstance?.id{
                    if userId == id{
                        print("Yes I got the preconnect slot")
                        checkforRecordingStatus()
                        self.isPreConnected = true
                        isSlefieScreenShotSaved = false
                        initiateTwilioConnection(slotInfo: preconnectSlot)
                        return
                    }
                }
            
            
            print("Preconnect slot user id is \(String(describing: preconnectSlot.userId)) and self user id is \(SignedUserInfo.sharedInstance?.id)")
            
        }
        
        Log.echo(key: "vijay", text: "pre-Connect is nill")
        
        //print("Handling call connection with the slot info unmerges slot \(self.myLiveUnMergedSlot)")
        
    }
    func saveImage() {

            guard let selectedImage = self.memoryImage else {
                return
            }

            UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        //MARK: - Save Image callback
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

            if let error = error {

                print(error.localizedDescription)

            } else {
                
                print("Success")
            }
        }
    
    
    private func initiateTwilioConnection(slotInfo : SlotInfo){
        
        if(isFetchingTwilioAccessToken){
            return
        }
       
        guard let slotId = slotInfo.id
        else{
            return
        }
        
        isFetchingTwilioAccessToken = true
        
        fetchTwillioToken(slotId: slotId) {[weak self] (info) in
            
            self?.isFetchingTwilioAccessToken = false
            
            guard let info = info
            else{
                return
            }
            
            self?.createTwilioConnection(slotInfo: slotInfo, tokenInfo: info)
            
        }
        
    }
    
    
    func createTwilioConnection(slotInfo : SlotInfo, tokenInfo : TwillioTokenInfo){
        guard let localMediaPackage = self.localMediaPackage else{
            Log.echo(key: "NewArch", text: "Missing localMediapackage")
            return
        }
                
        guard let remoteVideoView = self.rootView?.remoteVideoView?.streamingVideoView else{
            Log.echo(key: "NewArch", text: "Missing remoteView")
            return
        }
        
        guard let accessToken = tokenInfo.token
        else {
            return
        }
        
        
        print("My slot is  running ")
        let connection = UserCallConnection()
        self.connection = connection
        connection.localMediaPackage = localMediaPackage
        connection.eventInfo = eventInfo
        connection.slotId = slotInfo.id
        connection.remoteView = remoteVideoView
        connection.slotInfo = slotInfo
        connection.renderer = self.rootView?.remoteVideoView?.getRenderer()
        
        connection.roomName = tokenInfo.room ?? ""
        connection.accessToken = accessToken
        connection.connectToRoom()
    }
    
    
    
    
    func processDefaultSignature(){
        
        // Log.echo(key: "yudi", text: " CallSchedule id is \(self.myLiveUnMergedSlot?.callscheduleId)")
        
        guard let id = self.myLiveUnMergedSlot?.id else{
            return
        }
        
        if self.eventInfo?.isScreenShotAllowed == "automatic"{
            return
        }
        
        if self.eventInfo?.isAutographAllow != "automatic"{
            return
        }
        
        // NOTE: Uncomment only if,client ask to restrict autograph in last few seconds..
        
        //        if let endtimeOfSlot = myLiveUnMergedSlot?.endDate{
        //            if endtimeOfSlot.timeIntervalTillNow <= 30.0{
        //
        //                Log.echo(key: "yud", text: "Returning because of less than 30 seconds.")
        //                return
        //            }
        //        }
        
        
        // In order to reset the process after the slot
        if localSlotIdToManageDefaultScreenshot != nil {
            
            //Log.echo(key: "yudi", text: " new id is \(id) saved id is \(localSlotIdToManageDefaultScreenshot)")
            
            if id != localSlotIdToManageDefaultScreenshot {
                
                Log.echo(key: "yudi", text: "default signature is initialized to false")
                defaultSignatureInitiated = false
            }
        }
        
        
        if defaultSignatureInitiated {
            return
        }
        
        localSlotIdToManageDefaultScreenshot = id
        
        defaultSignatureInitiated = true
        
        VerifyForSignatureImplementation().fetch(scheduleId: id) { (success, message, isSignedResponseIs,isRequested) in
            
            Log.echo(key: "yudi", text: "Response of the VerifyForSignatureImplementation for success is \(success) and for the isSignedResponse is \(isSignedResponseIs)")
            
            if !success{
                return
            }
            
            if isSignedResponseIs{
                return
            }
            
            if isRequested{
                
                Log.echo(key: "yudi", text: "I am also requesting the requested file")
                
                self.serviceRequestAutograph(info : self.eventInfo?.user?.defaultImage?.screenshotInfo())
                return
            }
            
            Log.echo(key: "yudi", text: "default signature process started")
            
            self.defaultSignatureTimer.requiredDate = Date()
            self.defaultSignatureTimer.start()
            self.defaultSignatureTimer.screenShotListner = {
                
                Log.echo(key: "yudi", text: "default signature process completed and ready to launch")
                self.defaultAutographRequest()
            }
        }
    }
    
    func checkforRecordingStatus(){
  
        self.speedHandler?.showBottomBanner = {[weak self] success in
            
            if success{
                //already shared the resolution
            }else{
//                self?.connection?.logResolution()
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
        
        if(!isSocketConnected){
            Log.echo(key: "dhi", text: "webSocket is disconnected")
            self.isConnectionDroppedInBtw = true
            setStatusMessage(type: .socketDisconnected)
            return
        }else{
            if isConnectionDroppedInBtw {
                isConnectionDroppedInBtw = false
                self.refreshScheduleInfo()
            }
        }
        
        
        //        if(!eventInfo.isPreconnectEligible){
        //            setStatusMessage(type: .ideal)
        //            return
        //        }
        
        if(!eventInfo.isWholeConnectEligible){
            setStatusMessage(type: .idealMedia)
            return
        }
        
        guard let activeSlot = eventInfo.mergeSlotInfo?.myValidSlot.slotInfo
            else{
                
                
                print("Invalid slot exists")
                setStatusMessage(type: .idealMedia)
                return
        }
        
        guard let hostId = hostHashId
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        if(!isAvailableInRoom(hashId: hostId)){
            setStatusMessage(type : .userDidNotJoin)
            return
        }
        
        if(activeSlot.isPreconnectEligible){
            setStatusMessage(type : .preConnectedSuccess)
            checkforRecordingStatus()
            return;
        }
        
        
        if(activeSlot.isLIVE && (connection?.isStreaming ?? false)){
            setStatusMessage(type: .connected)
            checkforRecordingStatus()
            return;
        }
        
        if(activeSlot.isBreak){
            Log.echo(key: "vijay", text: "Break Slot")
            setStatusMessage(type: .breakSlot)
            return;
        }
        
        guard let connection = connection
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        if(connection.isStreaming){
            setStatusMessage(type: .preConnectedSuccess)
            checkforRecordingStatus()
            return
        }
        setStatusMessage(type: .ideal)
    }
    
    
    override func setFuturePromotionImage(image: UIImage?) {
        self.futureSessionPromotionImage?.image = image
    }
    
    override func isExpired()->Bool{
        
        guard let _ = eventInfo?.mergeSlotInfo?.myUpcomingSlot
            else{
                return true
        }
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Log.echo(key: "yud", text: "The UserCallController is dismissing")
        
        Log.echo(key: "yud", text: "SelfieTimerInitiated in the viewWillDisappear \(String(describing: self.myLiveUnMergedSlot?.isSelfieTimerInitiated))")
        
        self.selfieTimerView?.reset()
        changeOrientationToPortrait()
        DispatchQueue.main.async {
            
            if !SlotFlagInfo.staticScreenShotSaved {
                SlotFlagInfo.staticIsTimerInitiated = false
            }
            guard let isScreenshotSaved = self.myLiveUnMergedSlot?.isScreenshotSaved else {
                return
            }
            if isScreenshotSaved == true{
                self.myLiveUnMergedSlot?.isSelfieTimerInitiated = true
            }else{
                self.myLiveUnMergedSlot?.isSelfieTimerInitiated = false
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        DispatchQueue.main.async {
            
            self.selfieTimerView?.reset()
        }
    }
    
    @IBAction private func requestAutograph(){
        
        resetPreviousAutograph()
        presentAutographAction()
    }
    
    private func resetPreviousAutograph(){
        
        guard let slot = myLiveUnMergedSlot
            else{
                return
        }
        
        if(!slot.isScreenshotSaved){
            self.screenshotInfo = nil
        }
        
        if(!slot.isAutographRequested){
            self.canvasInfo = nil
        }
    }
    
    private func initializeVariable(){
        
        initializeGetCommondForTakeScreenShot()
        registerForHostManualTriggeredTimeStamp()
        registerForListeners()
        self.selfieTimerView?.delegate = self
        self.userRootView?.delegateCutsom = self
    }
    
    
    
    
    override func registerForListeners(){
        super.registerForListeners()
        
        socketListener?.onEvent("hangUp", completion: { [weak self] (json) in
            
            if(self?.socketClient == nil){
                return
            }
            self?.processHangupEvent(data : json)
        })
        
    }
    
    private func processHangupEvent(data : JSON?){
        
        guard let json = data
            else{
                return
        }
        
        let value = json["value"].boolValue
        hangup(hangup: value)
    }
    
    @IBAction private func hangupCallAction(){
        
        processExitAction(code: .userAction)
    }
    
    
    override func processExitAction(code : exitCode){
        super.processExitAction(code : code)
        
        connection?.disconnect()
        connection = nil
        
        //temp
        
        // TODO:- Need to Comment
        //showExitScreen()
    }
    
    
    func hangup(hangup : Bool){
        
        if(!hangup){
            resetMuteActions()
        }
        
        //Reset the selfie timer if it is not initiated yet.
        if !isSlefieScreenShotSaved{
            Log.echo(key: "vijayTimer", text: "@748")
            self.selfieTimerView?.reset()
            SlotFlagInfo.staticIsTimerInitiated = false
        }else{
            Log.echo(key: "vijayTimer", text: "timer didnt get reset")
        }
        localMediaPackage?.isDisabled = hangup
    }
    
    private func processCallInitiation(data : JSON?){
        
        guard let json = data
            else{
                return
        }
        
        let receiverId = json["receiver"].stringValue
        guard let targetId = hostHashId
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
        data["receiver"] = hostHashId
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
        
        guard let targetId = hostHashId
            else{
                return
        }
        
        if(targetId == receiverId){
            return
        }
    }
    
    //    private func initiateCall(){
    //
    //        guard let slotInfo = myCurrentUserSlot
    //            else{
    //                return
    //        }
    //
    //        disposeCurrentConnection()
    //        self.connection = UserCallConnection(eventInfo: eventInfo, slotInfo: slotInfo, localMediaPackage : localMediaPackage, controller: self)
    //        connection?.initiateCall()
    //        startCallRing()
    //    }
    
    
    var myLiveUnMergedSlot : SlotInfo?{
        
        guard let slotInfo = eventInfo?.myCurrentSlotInfo?.slotInfo
            else{
                return nil
        }
        return slotInfo
    }
    
    //ONLY LIVE - MERGED
    private func disposeCurrentConnection(){
        
        guard let currentConnection = self.connection
            else{
                return
        }
        
        currentConnection.abort()
        self.connection = nil
    }
    
    var myActiveUserSlot : SlotInfo?{
        
        guard let slotInfo = eventInfo?.mergeSlotInfo?.myCurrentSlotInfo?.slotInfo
            else{
                return nil
        }
        return slotInfo
    }
    
    //whole connect (preconnect & LIVE)
    var myCurrentUserSlot : SlotInfo?{
        
        guard let slotInfo = eventInfo?.mergeSlotInfo?.myValidSlot.slotInfo
            else{
                return nil
        }
        return slotInfo
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
        if eventInfo.isMicroSlot{
            Log.echo(key: "vijaySlotDuration", text: "\(slotDuration)")
             requiredDate = calendar.date(byAdding: .second, value: 3, to: date)
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
    
    private func processAutograph(){
        
        Log.echo(key: "yud", text: "ScreenShot allowed is \(String(describing: self.eventInfo?.isScreenShotAllowed))")
        
        if self.eventInfo?.isScreenShotAllowed == nil{
            return
        }
        
        if(!TimerSync.sharedInstance.isSynced){
            return
        }
        
        if eventInfo?.isHostManualScreenshot ?? false{
            return
        }
        
        // NOTE: Uncomment only if,client ask to restrict selfie in last few seconds..
        
        //        if let endtimeOfSlot = myLiveUnMergedSlot?.endDate{
        //            if endtimeOfSlot.timeIntervalTillNow <= 10.0{
        //                return
        //            }
        //        }
        
        if !isScreenshotStatusLoaded{
            return
        }
        
        //don't take screenshot if don't have local stream
        guard let localMedia = localMediaPackage
            else{
                return
        }
        
        //don't take screenshot if hangedup
        if(localMedia.isDisabled){
            return
        }
        
        //if current slot id is nil then return
        if self.myLiveUnMergedSlot?.id == nil {
            Log.echo(key: "yud", text: "my unmerged slot is nil")
            return
        }
        
        
        Log.echo(key: TAG, text: "CheckmyLiveUnMergedSlot?.isScreenshotSaved")
        //Server response for screenShot saved
        if let isScreenShotSaved = self.myLiveUnMergedSlot?.isScreenshotSaved{
            if isScreenShotSaved {
                return
            }
        }
        
        Log.echo(key: TAG, text: "CheckSlotFlagInfo.staticSlotId")
        
        //if the lastActive Id is same and the saveScreenShotFromWebisSaved then return else let them pass.
        
        if let slotId = self.myLiveUnMergedSlot?.id {
            if ((slotId == SlotFlagInfo.staticSlotId) && SlotFlagInfo.staticIsTimerInitiated) {
                
                if !(isCallStreaming){
                    
                    if isSlefieScreenShotSaved {
                        Log.echo(key: "vijayTimer", text: "SlotFlagInfo.staticScreenShotSaved \(SlotFlagInfo.staticScreenShotSaved)")
                        return
                    }else{
                        
                        SlotFlagInfo.staticSlotId = -1
                        SlotFlagInfo.staticIsTimerInitiated = false
                        selfieTimerView?.reset()
                    }
                    Log.echo(key: "vijayTimer", text: "@917")
                    return
                }
                
//                Log.echo(key: "vijayTimer", text: "@920")
                Log.echo(key: "SelfieTimer", text: "@944")
                return
            }
        }
        
        
        // Once the selfie timer has been come
        // guard let isSelfieTimerInitiated = self.myActiveUserSlot?.isSelfieTimerInitiated else { return
        // guard let isScreenshotSaved = self.myActiveUserSlot?.isScreenshotSaved else { return  }
        
        Log.echo(key: TAG, text: "CheckisCallStreaming")
        
        if !(isCallStreaming){
            return
        }
        
        Log.echo(key: TAG, text: "CheckisSlefieScreenShotSaved")
//        // TODO:- If connection drops and connect number of times, this will saves from sending n number of selfie pings
        if connection?.isRoomConnected ?? false && isSlefieScreenShotSaved{
            return
        }
//        if isHangUp{
//            return
//        }
        
        
        Log.echo(key: TAG, text: "GetTimestamp")
        
        //here it is need to send the ping to host for the screenshot
        if let requiredTimeStamp =  getTimeStampAfterEightSecond(){
            
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
            data = ["id":"screenshotCountDown","name":self.eventInfo?.user?.hashedId ?? "","message":messageData]
            socketClient?.emit(data)
            callLogger?.logSelfieTimerAcknowledgment(timerStartsAt: requiredWebCompatibleTimeStamp)
            Log.echo(key: "yud", text: "Sent time stamp data is \(data)")
            
            //selfie timer will be initiated after giving command to selfie view for the animation.
            //isSelfieTimerInitiated = true
            isSlefieScreenShotSaved = false
            self.myLiveUnMergedSlot?.isSelfieTimerInitiated = true
            if let id = self.myLiveUnMergedSlot?.id {
                
                //UserDefaults.standard.set(id, forKey: "selfieTimerCurrentSlotId")
                SlotFlagInfo.staticSlotId = id
                SlotFlagInfo.staticIsTimerInitiated = true
            }
            
            //for testing
            selfieTimerView?.requiredDate = requiredTimeStamp
            
            if let eventInfo = self.eventInfo{
                selfieTimerView?.startAnimation(eventInfo : eventInfo)
            }
            
        }
    }
    
    private func initializeGetCommondForTakeScreenShot() {
        
        selfieTimerView?.screenShotListner = {
            
            Log.echo(key: "yud", text: "I got the scrrenshot listener response")
            _ = self.userRootView?.getSnapshot(info: self.eventInfo, completion: { [self](image) in
                
                Log.echo(key: "yud", text: "recieved memory image is \(String(describing: image))")
                
                self.memoryImage = image
                self.mimicScreenShotFlash()
                self.myLiveUnMergedSlot?.isScreenshotSaved = true
                self.myLiveUnMergedSlot?.isSelfieTimerInitiated = true
                SlotFlagInfo.staticScreenShotSaved = true
                isSlefieScreenShotSaved = true
                let slotInfo = self.myLiveUnMergedSlot
                
                
                Log.echo(key: "yud", text: "Memory image is nil \(self.memoryImage == nil ? true : false )")
               
                let backThread = DispatchQueue(label: "uploading", qos: .userInteractive)
                backThread.async {
                    
                    self.encodeImageToBase64(image: image, completion: { (encodedData) in
                        
                        Log.echo(key: "yud", text: "encoded image is \(String(describing: image))")
                        
                        DispatchQueue.main.async {
                            
                            self.uploadImage(encodedImage: encodedData, image: nil, completion: { (success, info) in
                                
                                Log.echo(key: "yud", text: "I got upload response")
                                self.showToastWithMessage(text: "Saving Memory..", time: 5.0)
                                saveImage()
                                isSlefieScreenShotSaved = false
                                
                                DispatchQueue.main.async {
                                    
                                    let isExpired = slotInfo?.isExpired ?? true
                                    if(!success && !isExpired){
                                        
                                        slotInfo?.isScreenshotSaved = false
                                        slotInfo?.isSelfieTimerInitiated = false
                                        SlotFlagInfo.staticScreenShotSaved = false
                                        return
                                    }
                                    
                                    self.screenshotInfo = info
                                    self.localScreenShotAssociatedCallBookingId = self.screenshotInfo?.callbookingId
                                    
                                    if self.eventInfo?.isAutographAllow ?? "" == "automatic" {
                                        
                                        Log.echo(key: "yud", text: "Requested foor the screenshot")
                                        
                                        self.selfieAutographRequest()
                                    }
                                    //self.defaultAutographRequest()
                                }
                            })
                        }
                    })
                }
            })
        }
    }
    
    func registerForHostManualTriggeredTimeStamp(){
        
        print("Registering socket with timer notification \(String(describing: socketListener)) nd the selfie timer is \(String(describing: selfieTimerView))")
        
        socketListener?.onEvent("screenshotCountDown", completion: { [self] (response) in
            
            print(" I got the reponse \(String(describing: response))")
            
            if let responseDict:[String:JSON] = response?.dictionary{
                if let dateDict:[String:JSON] = responseDict["message"]?.dictionary{
                    
                    if let date = dateDict["timerStartsAt"]?.stringValue{
                        var data:[String:Any] = [String:Any]()
                        var messageData:[String:Any] = [String:Any]()
                        messageData = ["timerStartsAt":"\(date)"]
                        //name : callServerId($scope.currentBooking.user.id)
                        data = ["id":"screenshotCountDown","name":self.eventInfo?.user?.hashedId ?? "","message":messageData]
                        self.socketClient?.emit(data)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        var requiredDate:Date?
                        
                        if let newdate = dateFormatter.date(from: date){
                            ///
                            requiredDate = newdate
                        }else{
                            
                            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss z"
                            requiredDate = dateFormatter.date(from: date)
                        }
                        
                        print("required date is \(date) and the sending ")
                        //for testing
                        selfieTimerView?.requiredDate = requiredDate
                        
                        if let eventInfo = self.eventInfo{
                            selfieTimerView?.startAnimation(eventInfo : eventInfo)
                        }
                        
                        
                    }
                }
            }
        })
    }
    
    
    private func updateCallHeaderInfo(){
        
        guard let currentSlot = eventInfo?.mergeSlotInfo?.myUpcomingSlot
            else{
                return
        }
        if(currentSlot.isFuture){
            
            updateNewHeaderInfoForSession(slot : currentSlot)
            // updateCallHeaderForFuture(slot : currentSlot)
            return
        }
        updateCallHeaderForLiveCall(slot: currentSlot)
    }
    
    
    func updateLableAnimation(){
        
        guard let currentSlot = eventInfo?.mergeSlotInfo?.myValidSlot.slotInfo
            else{
                
                //Log.echo(key: "animation", text: "stopAnimation")
                isAnimating = false
                stopLableAnimation()
                return
        }
        
        if let endDate = (currentSlot.endDate?.timeIntervalTillNow) {
//            checkforRecordingStatus()
            
            if endDate < 16.0 && endDate >= 1.0 && isAnimating == false {
                
                isAnimating = true
                startLableAnimating(label: userRootView?.callInfoContainer?.timer)
                return
            }
            if endDate <= 0.0{
                
                isAnimating = false
                stopLableAnimation()
                return
            }
            if endDate > 16.0{
                
                isAnimating = false
                stopLableAnimation()
                return
            }
            Log.echo(key: "animation", text: "StartAnimation and the time is \(endDate)")
        }
    }
    
    private func updateCallHeaderForLiveCall(slot : SlotInfo){
        
        userRootView?.callInfoContainer?.isHidden = false
        futureSessionView?.isHidden = true
        checkforRecordingStatus()
        guard let startDate = slot.endDate
            else{
                return
        }
        
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else{
                return
        }
        
        userRootView?.callInfoContainer?.timer?.text = "\(counddownInfo.time)"
        //userRootView?.callInfoContainer?.timer?.text = "\(counddownInfo.time)"
    }
    
    
    private func updateCallHeaderForFuture(slot : SlotInfo){
        
        guard let startDate = slot.startDate
            else{
                return
        }
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else{
                return
        }
        userRootView?.callInfoContainer?.timer?.text = "Call will start in : \(counddownInfo.time)"
    }
    
    
    private func verifyIfExpired(){
        
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        if let _ = eventInfo.mergeSlotInfo?.myUpcomingSlot{
            return
        }
        
        self.processExitAction(code : .expired)
    }
    
    override func onExit(code : exitCode){
        super.onExit(code: code)
        
        if(code == .contactUs){
            showContactUsScreen()
            return
        }
        
        if(code == .prohibited){
            showErrorScreen()
            return
        }
        
        guard let eventInfo = eventInfo
            else{
                dismissCallRoom()
                return
        }
        
        //don't show feedback if event not activated and stop processing it.
        if(!isActivated){
            dismissCallRoom()
            return
        }
        
        guard let _ = eventInfo.mergeSlotInfo?.myUpcomingSlot
            else{
                showExitScreen()
                return
        }
        
        if code == .userAction{
            dismissCallRoom()
            return
        }
    }
    
    func dismissCallRoom(){
        
        self.getRootPresentingController()?.dismiss(animated: true, completion: {
        })
        Log.echo(key: "SystemCheck", text: "@1222 dismiss")
    }
    
    override func showErrorScreen() {
        
        guard let controller = OpenCallAlertController.instance() else{
            return
        }
        
        guard let presentingController =  self.lastPresentingController as? ContainerController
            else{
                Log.echo(key: "_connection_", text: "presentingController is nil")
                return
        }
        presentingController.navController?.topViewController?.navigationController?.pushViewController(controller, animated: true)
        
        self.getRootPresentingController()?.dismiss(animated: true, completion: {
        })
        
    }
    
    func showContactUsScreen(){
        
        RootControllerManager().getCurrentController()?.showContactUs()
        
        guard let presented = self.lastPresentingController as? ContainerController else{
            return
        }
        
        guard let controller = ContactUsController.instance() else {
            return
        }
        presented.navController?.topViewController?.navigationController?.pushViewController(controller, animated: true)
        
        self.getRootPresentingController()?.dismiss(animated: true, completion: {
        })
    }
    
    private func showDonateScreen(){
        
        guard let presentingController = self.lastPresentingController as? ContainerController
            else{
                Log.echo(key: "_connection_", text: "presentingController is nil")
                return
        }
        
        guard let controller = TippingConfirmationController.instance()
            else{
                return
        }
        
        controller.scheduleInfo = eventInfo
        controller.slotId = eventInfo?.myLastCompletedSlot?.id ?? 0
        controller.memoryImage = self.memoryImage
        presentingController.navController?.topViewController?.navigationController?.pushViewController(controller, animated: true)
        
        self.getRootPresentingController()?.dismiss(animated: true, completion: {
        })
    }
    
    private func showFeedbackScreen(){
        
        guard let presentingController = self.lastPresentingController as? ContainerController
            else{
                Log.echo(key: "_connection_", text: "presentingController is nil")
                return
        }
        
        guard let controller = ReviewController.instance() else{
            return
        }
        
        controller.eventInfo = eventInfo
        presentingController.navController?.topViewController?.navigationController?.pushViewController(controller, animated: true)
        
        self.getRootPresentingController()?.dismiss(animated: true, completion: {
        })
        return
    }
    
    
    private func showMemoryScreen(){
        
        guard let presentingController = self.lastPresentingController as? ContainerController
            else{
                Log.echo(key: "_connection_", text: "presentingController is nil")
                return
        }
        
        guard let controller = MemoryAnimationController.instance() else{
            return
        }
        
        controller.eventInfo = eventInfo
        controller.memoryImage = self.memoryImage
        controller.userCall = self
        
        
        presentingController.navController?.topViewController?.navigationController?.pushViewController(controller, animated: true)
        
        self.getRootPresentingController()?.dismiss(animated: true, completion: {
        })
        return
    }
    
    func showExitScreen() {
        let isDonationEnabled = self.eventInfo?.tipEnabled ?? false
        if self.memoryImage != nil{
            showMemoryScreen()
        }
        else if(isDonationEnabled){
            showDonateScreen()
        }
        else {
            showFeedbackScreen()
        }
    }
    
    
    override func callFailed(){
        super.callFailed()
    }
    
    override func verifyEventActivated(info : EventScheduleInfo, completion : @escaping ((_ success : Bool, _ info  : EventScheduleInfo?)->())){
        let eventInfo = info
        
        //already activated
        if(eventInfo.started != nil){
            completion(true, eventInfo)
            return
        }
        
        completion(false, eventInfo)
    }
    
    
    override func verifyScreenshotRequested(){
        
        //Log.echo(key: "yud", text: "Cross Verify ScreenShot Requested is activeSlot\(myLiveUnMergedSlot) and the slotId is \(myLiveUnMergedSlot?.id)")
        
        guard let activeSlot = myLiveUnMergedSlot
            else{
                isScreenshotStatusLoaded = true
                return
        }
        
        guard let slotId = activeSlot.id
            else{
                isScreenshotStatusLoaded = true
                return
        }
        
        ScreenshotInfoFetch().fetchInfo(slotId: slotId) {[weak self] (success, infos)  in
            
            Log.echo(key: "yud", text: "Finally I am veryfying slot")
            self?.verifySlot(slotInfo: activeSlot, screenshotInfos: infos)
            self?.isScreenshotStatusLoaded = true
        }
    }
    
    private func verifySlot(slotInfo : SlotInfo, screenshotInfos : [ScreenshotInfo]){
        
        Log.echo(key: "yud", text: "I AM VERIFYING")
        
        for screenshotInfo in screenshotInfos {
            if(screenshotInfo.requestedAutograph ?? false){
                slotInfo.isAutographRequested = true
            }
            if(!(screenshotInfo.defaultImage ?? true)){
                slotInfo.isScreenshotSaved = true
            }
        }
        
        //        Log.echo(key: "yud", text: "My Active Slot screenShot saved Status having Id \(String(describing: myLiveUnMergedSlot?.id))\(String(describing: self.myLiveUnMergedSlot?.isScreenshotSaved))")
        //
        //        Log.echo(key: "yud", text: "My Active Slot screenShot saved Status timer status  \(myLiveUnMergedSlot?.id)\(self.myLiveUnMergedSlot?.isSelfieTimerInitiated)")
        
    }
    
    
    override func handleMultipleTabOpening(){
        self.processExitAction(code : .prohibited)
    }
    
    override func checkForDelaySupport(){
        
        guard let eventInfo = eventInfo
            else{
                return
        }
        
        if ((eventInfo.started ?? "") == "") && ((eventInfo.notified ?? "" ) == ""){
            
            setStatusMessage(type: .eventNotStarted)
            return
            // statusLbl?.text = "Session has not started yet."
        }
        
        if ((eventInfo.started ?? "") == "") && ((eventInfo.notified ?? "") == "delayed"){
            
            setStatusMessage(type: .eventDelay)
            return
            // statusLbl?.text = "This session has been delayed. Please stay tuned for an updated start time."
        }
        
        if ((eventInfo.started ?? "") != "") && ((eventInfo.notified ?? "") == "schedule_updated"){
            //Event has updated
        }
    }
    
    override func eventCancelled(){
        
        self.eventInfo = nil
        setStatusMessage(type: .eventCancelled)
        //Event Cancelled
    }
    
    override func viewDidRelease() {
        super.viewDidRelease()
        
    }
    
    override func hitEventOnSegmentIO(){
        
        SEGAnalytics.shared().track("Chat Enter Attendee")
    }
    
     override func trackCurrentChatCompleted(){
        
        guard let userId =   SignedUserInfo.sharedInstance?.id else {
            print("User id is missing in joinedroom")
            return
        }
        guard let chatId =  self.eventInfo?.mergeSlotInfo?.myValidSlot.slotInfo?.id else {
            print("User id is missing in joinedroom")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId] as [String : Any]
        print("Meta info in joinedroom is \(metaInfo)")
        let action = "chatCompleted"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
}

extension UserCallController{
    
    var hostId : String?{
        get{
            return self.eventInfo?.user?.id
        }
    }
    
    var hostHashId : String?{
        get{
            return self.eventInfo?.user?.hashedId
        }
    }
}

//Instance
extension UserCallController{
    
    class func instance()->UserCallController?{
        
        let storyboard = UIStoryboard(name: "call_view", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "user_video_call") as? UserCallController
        return controller
    }
}


extension UserCallController{
    
    func presentAutographAction(){
        
        guard let activeEvent = self.myActiveUserSlot
            else{
                return
        }
        
        let alertController = UIAlertController(title: "Autograph" , message: "What would you like to do ?", preferredStyle: .actionSheet)
        
        let takeScreenshot = UIAlertAction(title: "Take Screenshot", style: UIAlertAction.Style.default) { [weak self] (action) in
            self?.takeScreenshot()
            return
        }
        
        if(activeEvent.isScreenshotSaved){
            takeScreenshot.isEnabled = false
        }
        
        let requestAutograph = UIAlertAction(title: "Request Autograph", style: UIAlertAction.Style.default) {  [weak self] (action) in
            self?.requestAutographProcess()
            return
        }
        
        if(activeEvent.isAutographRequested){
            requestAutograph.isEnabled = false
        }
        
        let cancelAction = UIAlertAction (title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            return
        }
        
        alertController.addAction(takeScreenshot)
        alertController.addAction(requestAutograph)
        alertController.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY-200, width: 0, height: 0)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func resetAutographCanvasIfNewCallAndSlotExists(){
        
        //if current slot id is nil then return
        
        if self.myLiveUnMergedSlot?.id == nil {
            
            self.resetCanvas()
            self.localScreenShotAssociatedCallBookingId = nil
            releaseDeviceOrientation()
            return
        }
        
        if localSlotIdToManageAutograph == nil{
            localSlotIdToManageAutograph =  self.myLiveUnMergedSlot?.id
            return
        }
        
        if localSlotIdToManageAutograph != self.myLiveUnMergedSlot?.id {
            localSlotIdToManageAutograph = self.myLiveUnMergedSlot?.id
            
            self.releaseDeviceOrientation()
            self.resetCanvas()
            self.localScreenShotAssociatedCallBookingId = nil
            //reset the signature
            return
        }
    }
    
    private func requestAutographProcess(){
        
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        let defaultScreenshotInfo = eventInfo.user?.defaultImage?.screenshotInfo()
        let customScreenshotInfo = self.screenshotInfo
        
        let isCustom =  customScreenshotInfo == nil ? false : true
        var controller : RequestAutographController?
        
        if(isCustom){
            
            controller = RequestAutographController.customInstance()
        }else{
            
            controller = RequestAutographController.defaultInstance()
        }
        
        guard let processController = controller
            else{
                return
        }
        
        processController.defaultScreenshotInfo = defaultScreenshotInfo
        processController.customScreenshotInfo = customScreenshotInfo
        processController.setListener { (success, info, isDefault) in
            self.processRequestAutograph(isDefault : success, info : info)
        }
        
        self.present(processController, animated: true) {
        }
    }
    
    private func selfieAutographRequest(){
        
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        let customScreenshotInfo = self.screenshotInfo
        var info:ScreenshotInfo?
        
        info = customScreenshotInfo
        
        Log.echo(key: "yud", text: "Value of the screenshot info is \(String(describing: info)) and is Default is")
        
        self.processRequestAutograph(isDefault : false, info : info)
    }
    
    
    private func defaultAutographRequest(){
        
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        let defaultScreenshotInfo = eventInfo.user?.defaultImage?.screenshotInfo()
        var info:ScreenshotInfo?
        
        info = defaultScreenshotInfo
        
        self.processRequestAutograph(isDefault : true, info : info)
    }
    
    
    private func processRequestAutograph(isDefault : Bool, info : ScreenshotInfo?){
        
        if(!isDefault){
            
            Log.echo(key: "yudi", text: "Requesting autograph with live signature")
            self.serviceRequestAutograph(info : info)
            return
        }
        
        guard let screenshotInfo = info
            else{
                return
        }
        
        userRootView?.requestAutographButton?.showLoader()
        CacheImageLoader.sharedInstance.loadImage(screenshotInfo.screenshot, token: { () -> (Int) in
            return 0
        }) { [weak self] (success, image) in
            self?.userRootView?.requestAutographButton?.hideLoader()
            
            if(!success){
                return
            }
            guard let targetImage  = image
                else{
                    return
            }
            
            Log.echo(key: "yudi", text: "Request the default autograph")
            //self?.serviceRequestAutograph(info: screenshotInfo)
            self?.requestDefaultAutograph(image: targetImage,info: info,isDefaultImage: true)
        }
    }
    
    private func requestDefaultAutograph(image : UIImage,info:ScreenshotInfo? = nil,isDefaultImage:Bool = false){
        
        self.encodeImageToBase64(image: image) {(encodedImage) in
            
            self.uploadImage(encodedImage:encodedImage,image: image, isDefaultImage: isDefaultImage,info: info,completion: { [weak self] (success, screenshotInfo) in
                
                Log.echo(key: "yudi", text: "Final Request the default autograph")
                if(!success){
                    return
                }
                
                self?.localScreenShotAssociatedCallBookingId = screenshotInfo?.callbookingId
                self?.screenshotInfo = screenshotInfo
                self?.serviceRequestAutograph(info: screenshotInfo)
            })
        }
    }
    
    private func serviceRequestAutograph(info : ScreenshotInfo?){
        
        
        self.showLoader()
        
        myLiveUnMergedSlot?.isAutographRequested = true
        let screenshotId = "\(info?.id ?? 0)"
        let hostId = "\(info?.analystId ?? 0)"
        
        Log.echo(key: "yudi", text: "Requesting the screenshot offered")
        
        RequestAutograph().request(screenshotId: screenshotId, hostId: hostId) { (success, info) in
            
            self.stopLoader()
        }
    }
    
    
    func takeScreenshot(){
        
        userRootView?.getSnapshot(info: self.eventInfo, completion: {(image) in
            
            guard let controller = AutographPreviewController.instance()
                else{
                    return
            }
            controller.image = image
            controller.onResult { [weak self] (image) in
                
                self?.myLiveUnMergedSlot?.isScreenshotSaved = true
                
                self?.encodeImageToBase64(image: image, completion: { (encodedImage) in
                    
                    self?.uploadImage(image: image, completion: { (success, info) in
                        
                        self?.screenshotInfo = info
                    })
                })
            }
            self.present(controller, animated: true) {
            }
        })
    }
    
    
    
    
    private func uploadImage(encodedImage:String = "",image : UIImage?,isDefaultImage:Bool = false, info:ScreenshotInfo? = nil, completion : ((_ success : Bool, _ info : ScreenshotInfo?)->())?){
        
        var params = [String : Any]()
        params["userId"] = SignedUserInfo.sharedInstance?.id ?? "0"
        params["analystId"] = hostId
        params["callbookingId"] = self.myLiveUnMergedSlot?.id ?? 0
        params["callScheduleId"] = eventInfo?.id ?? 0
        params["defaultImage"] = isDefaultImage
        
        // let imageBase64 = "data:image/png;base64," +  data.base64EncodedString(options: .lineLength64Characters)
        
        if isDefaultImage{
            params["file"] = info?.screenshot ?? ""
        }else{
            params["file"] = encodedImage
        }
        
        //        Log.echo(key: "yudi", text: "Uploaded params are \(params)")
        
        //userRootView?.requestAutographButton?.showLoader()
        SubmitScreenshot().submitScreenshot(params: params) { (success, info) in
            //self?.userRootView?.requestAutographButton?.hideLoader()
            
            DispatchQueue.main.async {
                completion?(success, info)
                
            }
        }
    }
}

extension UserCallController {
    
    func registerForAutographListener(){
        
        socketListener?.onEvent("startedSigning", completion: { (json) in
            
            guard let currentSlot = self.myActiveUserSlot
                else{
                    return
            }
            let rawInfo = json?["message"]
            self.canvasInfo = CanvasInfo(info : rawInfo)
            guard let currentSlotId  = self.myLiveUnMergedSlot?.id else{
                return
            }
            //            guard let canvasCallBookingId = self.screenshotInfo?.callbookingId else{
            //                return
            //            }
            //
            //            if currentSlotId != canvasCallBookingId {
            //                return
            //            }
            self.lockDeviceOrientationInPortrait()
            self.prepateCanvas(info : self.canvasInfo)
        })
        
        socketListener?.onEvent("stoppedSigning", completion: { (json) in
            
            Log.echo(key: "UserCallController", text: "stoppedSigning")
            Log.echo(key: "UserCallController", text: json)
            
            
            print("user's current orientation after the stopping signature is \(UIDevice.current.orientation) ")
            
            self.resetCanvas()
            self.releaseDeviceOrientation()
            //self.setExistingDeviceOrientaion()
            //self.showToastWithMessage(text: "Autograph Saved..", time: 5.0)
        })
    }
    
    private func resetCanvas(){
        
        self.userRootView?.canvasContainer?.hide()
        self.userRootView?.remoteVideoContainerView?.isSignatureActive = false
        self.userRootView?.remoteVideoContainerView?.updateForCall()
    }
    
    private func registerForSelfieTimer(){
    }
    
    
    private func prepateCanvas(info : CanvasInfo?){
        
        guard let selfieImage = memoryImage
            else{
                return
        }
        
        if let slotidFromCanvas = info?.currentSlotId{
            if let currentId = self.myLiveUnMergedSlot?.id{
                if slotidFromCanvas != currentId{
                    return
                }
            }else{
                return
            }
        }else{

//            toDo:@abhisheK: we dont get any keyName "forSlotID" in "StartSigning" emit so it get
            return

        }
        
        if  let image = self.defaultImage{
            
            self.userRootView?.canvasContainer?.show(with: image,info:info)
            Log.echo(key: "panku", text: "defaultImage found")
        }else{
            Log.echo(key: "panku", text: "defaultImage not found")
            self.userRootView?.canvasContainer?.show(with: selfieImage,info:info)
        }
        self.userRootView?.remoteVideoContainerView?.isSignatureActive = true
        self.userRootView?.remoteVideoContainerView?.updateForSignature()
        self.updateScreenshotLoaded(info : info)
        
    }
    
    func downloadDefaultImage(with url : String){
        RequestDefaultImage().fetchInfo(id: url) { (success, response) in
            if success{
                
                if let info = response{
                    let defaulImage = info["user"]["defaultImage"]["url"].stringValue
                    SDWebImageDownloader().downloadImage(with: URL(string: defaulImage), options: SDWebImageDownloaderOptions.highPriority, progress: nil) { (image, imageData, error, result) in
                        guard let img = image else {
                            // No image handle this error
                            Log.echo(key: "vijayDefault", text: "no defaultImage Found")
                            return
                        }
                        self.defaultImage = img
                        Log.echo(key: "vijayDefault", text: "defaultImage Found")
                    }
                }
            }
        }
    }
    
    
    private func updateScreenshotLoaded(info : CanvasInfo?){
        
        guard let info = info
            else{
                return
        }
        
        guard let screenshotInfo = info.screenshot
            else{
                return
        }
        
        var params = [String : Any]()
        params["id"] = "screenshotLoaded"
        params["name"] = self.eventInfo?.user?.hashedId ?? ""
        let message = screenshotInfo.toDict()
        
        var childParam = [String:Any]()
        childParam["screenshot"] = message
        params["message"] = childParam
        print("Emitting the parameters in the screenShotLoaded \(params)")
        socketClient?.emit(params)
    }
    
    var isCallStreaming: Bool{
        return (self.connection?.isStreaming ?? false)
    }
}

extension UserCallController:GetisHangedUpDelegate{
    
    func restartSelfie(){
        SlotFlagInfo.staticIsTimerInitiated = false
    }
    
    func getHangUpStatus() -> Bool {
        return isHangUp || (!isCallStreaming)
    }
}

extension UserCallController {
    
    private func updateNewHeaderInfoForSession(slot : SlotInfo){
        
        DispatchQueue.main.async {
            
            self.userRootView?.callInfoContainer?.isHidden = true
            self.futureSessionView?.isHidden = false
            
            
            
            guard let startDate = slot.startDate
                else{
                    return
            }
            
            guard let counddownInfo = startDate.countdownTimeFromNowAppended()
                else{
                    return
            }
            
            let remainingTime = "\(counddownInfo.time)"
            var fontSize = 20
            if  UIDevice.current.userInterfaceIdiom == .pad {
                fontSize = 26
            }
            self.futureSessionBlackBox?.backgroundColor = .black
            self.futureSessionHeaderLbl?.text = "Chat starts in:"
            
            self.countDountAttrTimerLbl?.attributedText = remainingTime.toAttributedString(font: "Nunito-ExtraBold", size: fontSize, color: .white)
        }
    }
}


extension UserCallController{
    
    @IBAction func testAction(sender:UIButton){
        
        self.userRootView?.remoteVideoContainerView?.isSignatureActive = true
        self.userRootView?.remoteVideoContainerView?.updateForSignature()
        
        self.userRootView?.canvasContainer?.show(with: UIImage(named: "testingImage"), info: nil)
        //self.userRootView?.canvas?.image =
        
    }
    
    @IBAction func updateForCallFeature(){
    }
    
    @IBAction func updateForSignatureFeature(){
    }
    
    func handleAutographInMultipleSlots(){
    }
}


extension UserCallController{
    
    func lockDeviceOrientationInPortrait(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.isSignatureInCallisActive = true
        delegate?.signatureDirection = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    func releaseDeviceOrientation(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.isSignatureInCallisActive = false
    }
}

extension UserCallController{
    
    //    func setExistingDeviceOrientaion(){
    //
    //        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
    //
    //            print("Existing orienatoin is landscapeLeft")
    //            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    //        }
    //        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
    //
    //            print("Existing orienatoin is landscapeRight")
    //            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
    //        }
    //
    //        else if UIDevice.current.orientation == UIDeviceOrientation.faceDown{
    //
    //
    //            print("Existing orienatoin is faceDown")
    //            //UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    //        }
    //        else if UIDevice.current.orientation == UIDeviceOrientation.faceUp{
    //            print("Existing orienatoin is faceUp")
    //        }
    //
    //        else if UIDevice.current.orientation == UIDeviceOrientation.portrait{
    //
    //            print("Existing orienatoin is portrait")
    //            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    //        }
    //        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
    //
    //            print("Existing orienatoin is portraitUpsideDown")
    //            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    //        }
    //        releaseDeviceOrientation()
    //    }
    
}


//MARK:- Fetching the twillio access token
extension UserCallController{
    
    func fetchTwillioToken(slotId:Int, listener : @escaping((_ info : TwillioTokenInfo?) -> ())){
        
        
        FetchUserTwillioTokenProcessor().fetch(chatId: self.eventId, slotId: slotId) { (success, error, info) in
            
            if !success{
                listener(nil)
                return
            }
            
            guard let info = info
            else{
                listener(nil)
                return
            }
            
            listener(info)
        }
    }
}
