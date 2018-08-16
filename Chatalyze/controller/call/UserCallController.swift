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
    
    //variable and outlet responsible for the SelfieTimer
    var isSelfieTimerInitiated = false
    @IBOutlet var selfieTimerView:SelfieTimerView?
    //isScreenshotStatusLoaded variable will let us know after verifying that screenShot is saved or not through the webservice.
    var isScreenshotStatusLoaded = false
    
    //Ends
    //This is webRTC connection responsible for signalling and handling the reconnect
    
    var connection : UserCallConnection?
    private var screenshotInfo : ScreenshotInfo?
    private var canvasInfo : CanvasInfo?
    var isScreenshotPromptPage = false
    
    
    //public - Need to be access by child
    override var peerConnection : ARDAppClient?{
        get{
            return connection?.connection
        }
    }
    
    var userRootView : UserVideoRootView?{
        return self.view as? UserVideoRootView
    }
    
    
    
    override func initialization(){
        super.initialization()
        
        initializeVariable()
        registerForAutographListener()
    }
    
   
    
    override func interval(){
        super.interval()
        
        confirmCallLinked()
        verifyIfExpired()
        updateCallHeaderInfo()
        processAutograph()        
    }
    
    override func isExpired()->Bool{
        
        guard let myValidSlot = eventInfo?.myValidSlot
            else{
                return true
        }
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Log.echo(key: "yud", text: "The UserCallController is dismissing")
        Log.echo(key: "yud", text: "SelfieTimerInitiated in the viewWillDisappear \(String(describing: self.myActiveUserSlot?.isSelfieTimerInitiated))")
        
        DispatchQueue.main.async {
            
            self.selfieTimerView?.reset()
            guard let isScreenshotSaved = self.myActiveUserSlot?.isScreenshotSaved else {
                return
            }
            if isScreenshotSaved == true{
                self.myActiveUserSlot?.isSelfieTimerInitiated = true
            }else{
                self.myActiveUserSlot?.isSelfieTimerInitiated = false
            }
        }
    }
    
    @IBAction private func requestAutograph(){
        
        resetPreviousAutograph()
        presentAutographAction()
    }
    
    private func resetPreviousAutograph(){
        
        guard let slot = myActiveUserSlot
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
    }
    
    override func registerForListeners(){
        super.registerForListeners()
        
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
        
        socketClient?.onEvent("linkCall", completion: {[weak self] (json) in
            if(self?.socketClient == nil){
                return
            }
            self?.connection?.linkCall()
        })
        
        //call initiation
        socketClient?.onEvent("hangUp", completion: { [weak self] (json) in
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
    
    override func processExitAction(){
        super.processExitAction()
        
        connection?.disconnect()
    }
    
    
    func hangup(hangup : Bool){
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
        
        self.connection = UserCallConnection(eventInfo: eventInfo, slotInfo: slotInfo, localMediaPackage : localMediaPackage, controller: self)
        connection?.initiateCall()
        startCallRing()
    }
    
    var myActiveUserSlot : SlotInfo?{
        
        guard let slotInfo = eventInfo?.myCurrentSlotInfo?.slotInfo
            else{
                return nil
        }
        return slotInfo
    }
    
    var myCurrentUserSlot : SlotInfo?{
        
        guard let slotInfo = eventInfo?.myValidSlot.slotInfo
            else{
                return nil
        }
        return slotInfo
    }
    
    func getTimeStampAfterEightSecond()->Date?{
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC") ?? TimeZone.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        let components = calendar.dateComponents([.year,.month,.day,.hour,.second,.minute], from: date)
        let requiredDate = calendar.date(byAdding: .second, value: 8, to: calendar.date(from: components) ?? date)
        Log.echo(key: "yud", text: "Current date is \(String(describing: calendar.date(from: components)))")
        Log.echo(key: "yud", text: "Required date is \(String(describing: requiredDate))")
        if let verifiedDate = requiredDate{
            return verifiedDate
        }
        return nil
    }
    
    private func processAutograph(){
        
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
        
        //Once the  selfie timer has been come
        guard let isSelfieTimerInitiated = self.myActiveUserSlot?.isSelfieTimerInitiated else { return  }
        
        guard let isScreenshotSaved = self.myActiveUserSlot?.isScreenshotSaved else { return  }
        
        guard let isConnectionConnected = self.connection?.isConnected else { return  }
        
        if isSelfieTimerInitiated{
            return
        }
        
        //return if call is not connected means video stream is not coming.
        if !(isConnectionConnected){
            return
        }
        
        //return if screenshot is already sent.
        if isScreenshotSaved{
            return
        }
        
        Log.echo(key: "yud", text: "Processs Autograph isSelfieTimerInitiated \(isSelfieTimerInitiated)")
        Log.echo(key: "yud", text: "Processs Autograph isScreenShotSaved \(isScreenshotSaved)")
        Log.echo(key: "yud", text: "Processs Autograph isConnection Connected \(isConnectionConnected)")
        
        //here it is need to send the ping to host for the screenshot
        if let requiredTimeStamp =  getTimeStampAfterEightSecond(){
            
            var data:[String:Any] = [String:Any]()
            var messageData:[String:Any] = [String:Any]()
            messageData = ["timerStartsAt":"\(requiredTimeStamp)"]
            //name : callServerId($scope.currentBooking.user.id)
            data = ["id":"screenshotCountDown","name":self.eventInfo?.user?.hashedId ?? "","message":messageData]
            socketClient?.emit(data)
            Log.echo(key: "yud", text: "sent time stamp data is \(data)")
            //selfie timer will be initiated after giving command to selfie view for the animation.
            //isSelfieTimerInitiated = true
            self.myActiveUserSlot?.isSelfieTimerInitiated = true
            selfieTimerView?.startAnimation()
            Log.echo(key: "yud", text: "Yes I am sending the animation request")
        }
    }
    
    private func initializeGetCommondForTakeScreenShot(){
        
        selfieTimerView?.screenShotListner = {
            
            let image = self.userRootView?.getSnapshot()
            self.myActiveUserSlot?.isScreenshotSaved = true
            self.mimicScreenShotFlash()
            self.uploadImage(image: image, completion: { (success, info) in
                self.screenshotInfo = info
            })
        }
    }
    
    private func updateCallHeaderInfo(){
        
        guard let currentSlot = eventInfo?.mergeSlotInfo?.myValidSlot.slotInfo
            else{
                return
        }
        
        if(currentSlot.isFuture){
            updateCallHeaderForFuture(slot : currentSlot)
            return
        }
        
        updateCallHeaderForLiveCall(slot: currentSlot)
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
        userRootView?.callInfoContainer?.timer?.text = "Time remaining: \(counddownInfo.time)"
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
        if let _ = myCurrentUserSlot{
            return
        }
        self.processExitAction()
        eventCompleted()
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
        
        guard let activeSlot = myActiveUserSlot
            else{
                return
        }
        
        guard let slotId = activeSlot.id
            else{
                return
        }
        
        ScreenshotInfoFetch().fetchInfo(slotId: slotId) {[weak self] (success, infos)  in
            self?.verifySlot(slotInfo: activeSlot, screenshotInfos: infos)
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
        isScreenshotStatusLoaded = true
       
        Log.echo(key: "yud", text: "My Active Slot screenShot saved Status having Id \(myActiveUserSlot?.id)\(self.myActiveUserSlot?.isScreenshotSaved)")
        
        Log.echo(key: "yud", text: "My Active Slot screenShot saved Status timer status  \(myActiveUserSlot?.id)\(self.myActiveUserSlot?.isSelfieTimerInitiated)")
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
        
        let takeScreenshot = UIAlertAction(title: "Take Screenshot", style: UIAlertActionStyle.default) { [weak self] (action) in
            self?.takeScreenshot()
            return
        }
        
        if(activeEvent.isScreenshotSaved){
            takeScreenshot.isEnabled = false
        }
        
        let requestAutograph = UIAlertAction(title: "Request Autograph", style: UIAlertActionStyle.default) {  [weak self] (action) in
            self?.requestAutographProcess()
            return
        }
        
        if(activeEvent.isAutographRequested){
            requestAutograph.isEnabled = false
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
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
        myActiveUserSlot?.isAutographRequested = true
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
            
            self?.myActiveUserSlot?.isScreenshotSaved = true
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
        guard let data = UIImageJPEGRepresentation(image, 1.0)
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
            completion?(true, info)
        }
    }
}

extension UserCallController{
    
    func registerForAutographListener(){
        
        socketClient?.onEvent("startedSigning", completion: { (json) in
            let rawInfo = json?["message"]
            self.canvasInfo = CanvasInfo(info : rawInfo)
            self.prepateCanvas(info : self.canvasInfo)
        })
        
        socketClient?.onEvent("stoppedSigning", completion: { (json) in
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
}
