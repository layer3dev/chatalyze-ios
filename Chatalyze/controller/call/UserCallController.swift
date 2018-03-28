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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    
    private func initialization(){
        initializeVariable()
    }
    
    private func initializeVariable(){
        registerForListeners()
    }
    
    
    private func registerForListeners(){
        
        //        {"id":"joinedCall","data":{"name":"chedddiicdaibdia"}}
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
            self?.renderRemoteVideo()
        })
        
        rootView?.hangupListener(listener: {
            self.processHangupAction()
            self.rootView?.callOverlayView?.isHidden = true
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
        guard let userId = SignedUserInfo.sharedInstance?.hashedId
            else{
                return
        }
        
        guard let targetId = hostHashId
            else{
                return
        }
        
        guard let roomId = self.roomId
            else{
                return
        }
        
        self.connection = ARDAppClient(userId: userId, andReceiverId: targetId, andRoomId : roomId, andDelegate:self)
        connection?.initiateCall()
        startCallRing()
    }

    override func interval(){
        super.interval()
        
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
