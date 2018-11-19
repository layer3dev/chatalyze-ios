//
//  UserCallController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 27/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserCallController: VideoCallController {
  
    //Animation Responsible
    var isAnimating = false
    
    //variable and outlet responsible for the SelfieTimer
    
    var isSelfieTimerInitiated = false
    @IBOutlet var selfieTimerView:SelfieTimerView?
    @IBOutlet var countDountAttrTimerLbl:UILabel?
    @IBOutlet var futureSessionView:UIView?
    
    
    //isScreenshotStatusLoaded variable will let us know after verifying that screenShot is saved or not through the webservice.
    var isScreenshotStatusLoaded = false

    //Ends
    //This is webRTC connection responsible for signalling and handling the reconnect
    

    override var roomType : UserInfo.roleType{
        return .user
    }
    
    var connection : UserCallConnection?
    private var screenshotInfo : ScreenshotInfo?
    private var canvasInfo : CanvasInfo?
    var isScreenshotPromptPage = false
    
    var screenInfoDict:[String:Any] = ["id":"","isScreenShotSaved":false,"isScreenShotInitaited":false]
    
    override var isVideoCallInProgress : Bool{
        guard let activeSlot = eventInfo?.mergeSlotInfo?.myValidSlot.slotInfo
            else{
                return false
        }
        
        if(activeSlot.isLIVE && (connection?.isConnected ?? false)){
            return true;
        }
        
        return false
    }
    
    //public - Need to be access by child
    override var peerConnection : ARDAppClient?{
        get{
            return connection?.connection
        }
    }
    
    var userRootView : UserVideoRootView?{
        return self.view as? UserVideoRootView
    }
    
    var isHangUp:Bool{
        
        return localMediaPackage?.isDisabled ?? true
    }
    
    override func initialization(){
        super.initialization()
        
        initializeVariable()
        registerForAutographListener()
    }
    
    override func interval(){
        super.interval()
        
        Log.echo(key: "yud", text: "Interval timer is working")
        
        confirmCallLinked()
        verifyIfExpired()
        updateCallHeaderInfo()
        processAutograph()
        updateLableAnimation()
    }
    
    override func updateStatusMessage(){
        super.updateStatusMessage()
        
        guard let eventInfo = eventInfo
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        if(!isSocketConnected){
            setStatusMessage(type: .ideal)
            return
        }
        
        if(!eventInfo.isWholeConnectEligible){
            setStatusMessage(type: .ideal)
            return
        }
        
        guard let activeSlot = eventInfo.mergeSlotInfo?.myValidSlot.slotInfo
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        guard let hostId = hostHashId
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        
        if(!isAvailableInRoom(hashId: hostId)){
            setStatusMessage(type : .userDidNotJoin)
            return;
        }
        
        if(activeSlot.isPreconnectEligible){
            setStatusMessage(type : .preConnectedSuccess)
            return;
        }
        
       
        if(activeSlot.isLIVE && (connection?.isStreaming ?? false)){
            setStatusMessage(type: .connected)
            return;
        }
        
       guard let connection = connection
        else{
            setStatusMessage(type: .ideal)
            return
        }
        
        if(connection.isStreaming){
            setStatusMessage(type: .preConnectedSuccess)
            return
        }
        
        setStatusMessage(type: .ideal)
    }
    
    override func isExpired()->Bool{
        
        guard let myValidSlot = eventInfo?.mergeSlotInfo?.myUpcomingSlot
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
        DispatchQueue.main.async {
            
            if !SlotFlagInfo.staticScreenShotSaved{
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
        registerForListeners()
        self.selfieTimerView?.delegate = self
    }
    
    override func registerForListeners(){
        super.registerForListeners()
        
        //call initiation
        
        socketListener?.onEvent("startSendingVideo", completion: { [weak self] (json) in
            if(self?.socketClient == nil){
                return
            }
            self?.hangup(hangup: false)
            self?.processCallInitiation(data : json)
        })
        
        socketListener?.onEvent("startConnecting", completion: { [weak self] (json) in
            if(self?.socketClient == nil){
                return
            }
            self?.initiateCall()
        })
        
        socketListener?.onEvent("linkCall", completion: {[weak self] (json) in
            if(self?.socketClient == nil){
                return
            }
            self?.connection?.linkCall()
        })
        
        //call initiation
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
    
    override func processExitAction(code : exitCode){
        super.processExitAction(code : code)
        
        connection?.disconnect()
    }
    
    
    func hangup(hangup : Bool){
        if(!hangup){
            resetMuteActions()
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
    
    private func initiateCall(){
        
        guard let slotInfo = myCurrentUserSlot
            else{
                return
        }
        
        disposeCurrentConnection()
        self.connection = UserCallConnection(eventInfo: eventInfo, slotInfo: slotInfo, localMediaPackage : localMediaPackage, controller: self)
        connection?.initiateCall()
        startCallRing()
    }
    
    
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
        
        let date = TimerSync.sharedInstance.getDate()
        Log.echo(key: "yud", text: "Synced date is \(date)")
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC") ?? TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        let components = calendar.dateComponents([.year,.month,.day,.hour,.second,.minute], from: date)
        let requiredDate = calendar.date(byAdding: .second, value: 8, to: date)
        Log.echo(key: "yud", text: "Current date is \(String(describing: calendar.date(from: components)))")
        Log.echo(key: "yud", text: "Required date is \(String(describing: requiredDate))")
        if let verifiedDate = requiredDate{
            return verifiedDate
        }
        return nil
    }
    
    private func processAutograph(){
        
        Log.echo(key: "yud", text: "In processAutograph screenShotStatusLoaded is \(isScreenshotStatusLoaded) and the local Media is \(String(describing: localMediaPackage)) is Local Media is disable \(localMediaPackage?.isDisabled) slot id is \(self.myLiveUnMergedSlot?.id) stored static store id is \(SlotFlagInfo.staticSlotId)is ScreenShot Saved \(self.myLiveUnMergedSlot?.isScreenshotSaved) is SelfieTimer initiated\(self.myLiveUnMergedSlot?.isSelfieTimerInitiated) isCallConnected is \(isCallConnected) isCallStreaming is \(isCallStreaming)")
        
        Log.echo(key: "yud", text: "ScreenShot allowed is \(self.eventInfo?.isScreenShotAllowed)")
        
        if self.eventInfo?.isScreenShotAllowed == nil{
            return
        }
        
        if(!TimerSync.sharedInstance.isSynced){
            return
        }
        
        if let endtimeOfSlot = myLiveUnMergedSlot?.endDate{
            if endtimeOfSlot.timeIntervalTillNow <= 30.0{
                return
            }
        }
        
        
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
        if self.myLiveUnMergedSlot?.id == nil{
            return
        }
        
        //Server response for screenShot saved
        if let isScreenShotSaved = self.myLiveUnMergedSlot?.isScreenshotSaved{
            if isScreenShotSaved{                
                return
            }
        }
        
        //if the lastActive Id is same and the saveScreenShotFromWebisSaved then return else let them pass.
        
        if let slotId = self.myLiveUnMergedSlot?.id{
            if ((slotId == SlotFlagInfo.staticSlotId) && SlotFlagInfo.staticIsTimerInitiated){
                return
            }
        }
        
//        //Once the selfie timer has been come
//        guard let isSelfieTimerInitiated = self.myActiveUserSlot?.isSelfieTimerInitiated else { return  }
//        guard let isScreenshotSaved = self.myActiveUserSlot?.isScreenshotSaved else { return  }
        
        if(!isCallConnected){ return }
        
        if !(isCallStreaming){
            return
        }
        
        if isHangUp{
           return
        }
        
        //here it is need to send the ping to host for the screenshot
        if let requiredTimeStamp =  getTimeStampAfterEightSecond(){
            
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
            Log.echo(key: "yud", text: "sent time stamp data is \(data)")
            //selfie timer will be initiated after giving command to selfie view for the animation.
            //isSelfieTimerInitiated = true
            self.myLiveUnMergedSlot?.isSelfieTimerInitiated = true
            if let id = self.myLiveUnMergedSlot?.id {
                
                //UserDefaults.standard.set(id, forKey: "selfieTimerCurrentSlotId")
                SlotFlagInfo.staticSlotId = id
                SlotFlagInfo.staticIsTimerInitiated = true
            }
            
            //for testing
            selfieTimerView?.requiredDate = requiredTimeStamp
            selfieTimerView?.startAnimation()
            
            //Log.echo(key: "yud", text: "Yes I am sending the animation request")
        }
    }
    
    private func initializeGetCommondForTakeScreenShot(){
        
        selfieTimerView?.screenShotListner = {
            
            let image = self.userRootView?.getSnapshot()
            self.mimicScreenShotFlash()
            self.myLiveUnMergedSlot?.isScreenshotSaved = true
            self.myLiveUnMergedSlot?.isSelfieTimerInitiated = true
            SlotFlagInfo.staticScreenShotSaved = true
            let slotInfo = self.myLiveUnMergedSlot
            self.uploadImage(image: image, completion: { (success, info) in
                
                let isExpired = slotInfo?.isExpired ?? true
                if(!success && !isExpired){
                    slotInfo?.isScreenshotSaved = false
                    slotInfo?.isSelfieTimerInitiated = false
                    SlotFlagInfo.staticScreenShotSaved = false
                    return
                }
                if success{
                }
                self.screenshotInfo = info
            })
        }
    }
    
    private func updateCallHeaderInfo(){
        
        guard let currentSlot = eventInfo?.mergeSlotInfo?.myUpcomingSlot
            else{
                return
        }
        if(currentSlot.isFuture){
            updateNewHeaderInfoForSession(slot : currentSlot)
//            updateCallHeaderForFuture(slot : currentSlot)
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
        
        guard let startDate = slot.endDate
            else{
                return
        }
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else{
                return
        }
        userRootView?.callInfoContainer?.timer?.text = "Time remaining: \(counddownInfo.time)"
    
        //userRootView?.callInfoContainer?.timer?.text = "\(counddownInfo.time)"
    }
    
    
    private func updateNewHeaderInfoForSession(slot : SlotInfo){
      
        userRootView?.callInfoContainer?.isHidden = true
        futureSessionView?.isHidden = false
        
        guard let startDate = slot.endDate
            else{
                return
        }
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else{
                return
        }
        
        let remainingTime = "\(counddownInfo.time)"
        var fontSize = 20
        if  UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 26
        }
        
        countDountAttrTimerLbl?.attributedText = remainingTime.toAttributedString(font: "Poppins", size: fontSize, color: UIColor(hexString: "#Faa579"),isUnderLine: false)
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
        
        if(code == .prohibited){
            showErrorScreen()
            return
        }
        
        guard let eventInfo = eventInfo
            else{
                return
        }
        
        guard let _ = eventInfo.mergeSlotInfo?.upcomingSlot
            else{
                showFeedbackScreen()
                return
        }
        
    }
    
    private func confirmCallLinked(){
                
        guard let slot = myCurrentUserSlot
            else{
                return
        }
        if(slot.isLIVE){
         
            self.connection?.linkCall()
        }
    }
    
    override func callFailed(){
        super.callFailed()
    }
    
    override func verifyEventActivated(){
    }
    
    override func verifyScreenshotRequested(){
        
        Log.echo(key: "yud", text: "Cross Verify ScreenShot Requested is activeSlot\(myLiveUnMergedSlot) and the slotId is \(myLiveUnMergedSlot?.id)")
        
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
        
        Log.echo(key: "yud", text: "My Active Slot screenShot saved Status having Id \(myLiveUnMergedSlot?.id)\(self.myLiveUnMergedSlot?.isScreenshotSaved)")
        
        Log.echo(key: "yud", text: "My Active Slot screenShot saved Status timer status  \(myLiveUnMergedSlot?.id)\(self.myLiveUnMergedSlot?.isSelfieTimerInitiated)")
    }
    
    override func handleMultipleTabOpening(){
        self.processExitAction(code : .prohibited)
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

//instance
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            return
        }
        
        alertController.addAction(takeScreenshot)
        alertController.addAction(requestAutograph)
        alertController.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY-200, width: 0, height: 0)
        }
        present(alertController, animated: true, completion: nil)
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
    
    private func processRequestAutograph(isDefault : Bool, info : ScreenshotInfo?){
        
        if(!isDefault){
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
            
            self?.requestDefaultAutograph(image: targetImage)
        }
    }
    
    private func requestDefaultAutograph(image : UIImage){
        
        self.uploadImage(image: image, completion: { [weak self] (success, screenshotInfo) in
            if(!success){
                return
            }
            self?.serviceRequestAutograph(info: screenshotInfo)
        })
    }
    
    private func serviceRequestAutograph(info : ScreenshotInfo?){
        
        //self.showLoader()
        myLiveUnMergedSlot?.isAutographRequested = true
        let screenshotId = "\(info?.id ?? 0)"
        let hostId = "\(info?.analystId ?? 0)"
        
        RequestAutograph().request(screenshotId: screenshotId, hostId: hostId) { (success, info) in
            //self.stopLoader()
        }
    }
    
    
    func takeScreenshot(){
        
        let image = userRootView?.getSnapshot()
        guard let controller = AutographPreviewController.instance()
            else{
                return
        }
        controller.image = image
        controller.onResult { [weak self] (image) in
            
            self?.myLiveUnMergedSlot?.isScreenshotSaved = true
            self?.uploadImage(image: image, completion: { (success, info) in
                self?.screenshotInfo = info
            })
        }
        self.present(controller, animated: true) {
        }
    }
    
    private func uploadImage(image : UIImage?, completion : ((_ success : Bool, _ info : ScreenshotInfo?)->())?){
        
        guard let image = image
            else{
                completion?(false, nil)
                return
        }
        guard let data = image.jpegData(compressionQuality: 1.0)
            else{
                completion?(false, nil)
                return
        }
        var params = [String : Any]()
        params["userId"] = SignedUserInfo.sharedInstance?.id ?? "0"
        params["analystId"] = hostId
        params["callbookingId"] = myCurrentUserSlot?.id ?? 0
        params["callScheduleId"] = eventInfo?.id ?? 0
        params["defaultImage"] = false
        let imageBase64 = "data:image/png;base64," +  data.base64EncodedString(options: .lineLength64Characters)
        params["file"] = imageBase64
        userRootView?.requestAutographButton?.showLoader()
        SubmitScreenshot().submitScreenshot(params: params) { [weak self] (success, info) in

            self?.userRootView?.requestAutographButton?.hideLoader()
            completion?(success, info)
        }
    }
}

extension UserCallController{
    
    func registerForAutographListener(){
        

        socketListener?.onEvent("startedSigning", completion: { (json) in
            let rawInfo = json?["message"]
            self.canvasInfo = CanvasInfo(info : rawInfo)
            self.prepateCanvas(info : self.canvasInfo)
        })
        

        socketListener?.onEvent("stoppedSigning", completion: { (json) in
            self.userRootView?.canvas?.image = nil
            self.userRootView?.canvasContainer?.hide()
        })
    }
    
    private func registerForSelfieTimer(){
    }
    
    private func prepateCanvas(info : CanvasInfo?){
        
        userRootView?.canvasContainer?.show()
        let canvas = self.userRootView?.canvas
        canvas?.canvasInfo = canvasInfo
        CacheImageLoader.sharedInstance.loadImage(canvasInfo?.screenshot?.screenshot, token: { () -> (Int) in
            
            return 0
        }) { (success, image) in
            
            canvas?.image = image
            self.updateScreenshotLoaded(info : info)
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
        params["message"] = message
        socketClient?.emit(params)
    }
    
    var isCallConnected : Bool{
         return (self.connection?.isConnected ?? false)
    }
    
    var isCallStreaming: Bool{
        return (self.connection?.isStreaming ?? false)
    }
}

extension UserCallController:GetisHangedUpDelegate{
    
    func restartSelfie() {
     
        SlotFlagInfo.staticIsTimerInitiated = false
    }
    
    func getHangUpStatus() -> Bool {
        return isHangUp || (!isCallStreaming)
    }
}

extension UserCallController{
    
    
}
