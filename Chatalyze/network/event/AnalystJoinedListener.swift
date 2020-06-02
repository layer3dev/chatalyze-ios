//
//  AnalystJoinedListener.swift
//  Chatalyze
//
//  Created by mansa infotech on 02/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class AnalystJoinedListener{
    

    private let TAG = "AnalystJoinedListener"
    
    private var listener : ((Int?)->())?
    
    init(){
        initializeListener()
    }
    
    func setListener(listener : ((Int?)->())?){
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
        
        guard let callScheduleId  = metaInfo.callScheduleId
            else{
                return
        }
        
        
        if(activityType != .slotBooked){
            return
        }
        
        Log.echo(key: TAG, text: "notification -> \(rawInfo)")
        
        listener?(callScheduleId)
    }
}
