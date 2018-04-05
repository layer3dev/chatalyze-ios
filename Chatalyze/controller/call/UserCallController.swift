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
        
        let requestAutograph = UIAlertAction(title: "Request Autograph", style: .default) { (action) in
            
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
    
    func takeScreenshot(){
        let image = userRootView?.getSnapshot()
        guard let controller = AutographPreviewController.instance()
            else{
                return
        }
        controller.image = image
        controller.onResult { [weak self] (image) in
            self?.uploadImage(image: image)
        }
        self.present(controller, animated: true) {
            
        }
        
        
    }
    
    
    private func uploadImage(image : UIImage?){
        guard let image = image
        else{
            return
        }
        guard let data = UIImageJPEGRepresentation(image, 1.0)
            else{
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
            self.screenshotInfo = info
            
        }
    }
}



