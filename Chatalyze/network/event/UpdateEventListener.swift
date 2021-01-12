//
//  UpdateEventListener.swift
//  Chatalyze
//
//  Created by Mansa on 02/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpdateEventListener{
    
    private let TAG = "UpdateEventListener"
    
    private var listener : (()->())?
    
    private var isReleased = false
    
    func releaseListener(){
        listener = nil
        isReleased = true
    }
    
    init(){
        initializeListener()
    }
    
    func setListener(listener : (()->())?){
        
        self.listener = listener
    }
    
    func initializeListener(){
        
        UserSocket.sharedInstance?.socket?.on("notification", callback: {[weak self] (data, emitter) in
           
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
        
        
        if !(activityType == .schedule_updated || activityType == .updatedCallSchedule || activityType == .eventDelay || activityType == .eventChatDurationUpdated){
            Log.echo(key: "vijayUpdate", text: "event type is\(activityType)")
            return
        }
        
        
        if(isReleased){
            return
        }
        
        Log.echo(key: TAG, text: "notification -> \(rawInfo)")
        
        
        listener?()
    }
}
