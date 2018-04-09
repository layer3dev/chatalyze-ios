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
    
    var connection : UserCallConnection?
    private var screenshotInfo : ScreenshotInfo?
    private var canvasInfo : CanvasInfo?
    
    //public - Need to be access by child
    override var peerConnection : ARDAppClient?{
        get{
            return connection?.connection
        }
    }
    
    var userRootView : UserVideoRootView?{
        return self.view as? UserVideoRootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    
    @IBAction private func requestAutograph(){
        presentAutographAction()
    }
    
    
    private func initialization(){
        initializeVariable()
        registerForAutographListener()
    }
    
    
    private func initializeVariable(){
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
        
        
    }
    
    override func processHangupAction(){
        super.processHangupAction()
    }
    

    
    
    //{"id":"startSendingVideo","data":{"receiver":"jgefjedaafbecahc"}}
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
        
        self.connection = UserCallConnection(eventInfo: eventInfo, slotInfo: slotInfo, controller: self)
        connection?.initiateCall()
        startCallRing()
    }
    
    var myCurrentUserSlot : SlotInfo?{
        guard let slotInfo = eventInfo?.myValidSlot.slotInfo
            else{
                return nil
        }
        return slotInfo
    }
    

    override func interval(){
        super.interval()
        
        confirmCallLinked()
        verifyIfExpired()
        updateCallHeaderInfo()
        
    }
    
    private func updateCallHeaderInfo(){
        
        guard let currentSlot = myCurrentUserSlot
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
        
        
        userRootView?.callInfoContainer?.timer?.text = "Time Remaining : \(counddownInfo.time)"
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
        
        self.processHangupAction()
        
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
        
        let alertController = UIAlertController(title: "Autograph" , message: "What would you like to do ?", preferredStyle: .actionSheet)
        

        
        let takeScreenshot = UIAlertAction(title: "Take Screenshot", style: .default) { [weak self] (action) in
            self?.takeScreenshot()
            return
        }
        
        let requestAutograph = UIAlertAction(title: "Request Autograph", style: .default) {  [weak self] (action) in
            self?.requestAutographProcess()
            return
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            return
        }
        
        alertController.addAction(takeScreenshot)
        alertController.addAction(requestAutograph)
        alertController.addAction(cancelAction)
       
        
        
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
        params["callbookingId"] = eventInfo?.id ?? 0
        params["callScheduleId"] = myCurrentUserSlot?.id ?? 0
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
            self.userRootView?.hideCanvas()
        })
        
        
    }
    
    private func prepateCanvas(info : CanvasInfo?){
        
        userRootView?.showCanvas()
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


