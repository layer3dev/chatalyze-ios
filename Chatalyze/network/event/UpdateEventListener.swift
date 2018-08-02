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
    
    var callScheduleId : String?
    private var listener : (()->())?
    
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
        
        Log.echo(key: "notification", text: "raw -> \(rawInfosString)")
        
        guard let data = rawInfosString.data(using: .utf8)
            else{
                return
        }
        
        Log.echo(key: "notification", text: "notification ==> \(rawInfosString)")
        
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
        
        Log.echo(key: "notification", text: "meta is  ==>\(activityType)")
        
        if !(activityType == .schedule_updated || activityType == .updatedCallSchedule){
            return
        }
        
        guard let receivedEventId = metaInfo.callScheduleId
            else{
                return
        }
        
        let receivedEventIdString = String(receivedEventId)
        
        if(receivedEventIdString != callScheduleId){
            return
        }
        listener?()
    }
}
