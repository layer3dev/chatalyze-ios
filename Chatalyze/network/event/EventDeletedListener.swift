//
//  EventDeletedListener.swift
//  Chatalyze
//
//  Created by Mansa on 26/11/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventDeletedListener{
    
    private let TAG = "EventDeletedListener"
    
    private var listener : ((String?)->())?
    
    private var isReleased = false
    
    func releaseListener(){
        listener = nil
        isReleased = true
    }
    
    init(){
        initializeListener()
    }
    
    func setListener(listener : ((String?)->())?){
        self.listener = listener
    }
    
    func initializeListener(){
        
        let Myuuid = UserSocket.sharedInstance?.socket?.on("notification", callback: {[weak self] (data, emitter) in
            
            
            if(data.count <= 0){
                return
            }
            guard let info = data.first as? [String : Any]
                else{
                    return
            }
            self?.processNotificationForNewSlot(info: info)
        })
        
    }
    
    private func processNotificationForNewSlot(info : [String : Any]){
        
        
        let rawInfosString = info.JSONDescription()
        
        
        guard let data = rawInfosString.data(using: .utf8)
            else{
                return
        }
        
        
        guard let rawInfo = try? JSON(data : data)
            else{
                return
        }
        
        let info = NotificationInfo(info: rawInfo)
        
        guard let metaInfo = info.metaInfo
            else{
                return
        }
        
        guard let activityType = info.metaInfo?.type
            else{
                return
        }
        
        if(activityType != .eventDeleted){
            return
        }
        
        
        if(isReleased){
            return
        }
        
        Log.echo(key: TAG, text: "notification -> \(rawInfosString)")

        listener?(metaInfo.activityId)
    }
}
