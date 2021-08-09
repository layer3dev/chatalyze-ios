//
//  EventSlotListener.swift
//  Chatalyze
//
//  Created by Sumant Handa on 06/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventSlotListener{
    
    private let TAG = "EventSlotListener"
    
    var eventId : String?
    private var listener : (()->())?
    private var listenerChatMoved : ((Int)->())?

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
    
    func setChatNumberListener(listener : ((Int)->())?){
        self.listenerChatMoved = listener
    }

    func initializeListener(){
        
        UserSocket.sharedInstance?.socket?.on("notification", callback: {[weak self] (data, emitter) in
            
            Log.echo(key : "test", text : data)
            
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
        
        
        if(activityType == .slotBooked || activityType == .chatNumberMoved){
            Log.echo(key: TAG, text: "notification -> \(rawInfosString)")
            
            guard let eventId = self.eventId
            else{
                return
            }
            
            guard let receivedEventId = metaInfo.callScheduleId
            else{
                return
            }
            
            let receivedEventIdString = String(receivedEventId)
            
            if(receivedEventIdString != eventId){
                return
            }
            
            if(!isReleased){
                if activityType == .slotBooked {
                    listener?()
                } else if activityType == .chatNumberMoved {
                    listenerChatMoved?(receivedEventId)
                }
            }
        }
    }
}
