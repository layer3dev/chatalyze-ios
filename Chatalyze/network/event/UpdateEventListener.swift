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
        
        //todo: fix analyst_joined bug
        UserSocket.sharedInstance?.socket?.on("analyst_joined", callback: { (data, emit) in
            
            self.listener?()
        })
    }
    
    private func processNotificationForNewSlot(info : [String : Any]){
        
        let rawInfosString = info.JSONDescription()
        
        Log.echo(key: "yud", text: "raw -> \(rawInfosString)")
        
        guard let data = rawInfosString.data(using: .utf8)
            else{
                return
        }
        
        Log.echo(key: "yud", text: "notification ==> \(rawInfosString)")
        
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
        
        Log.echo(key: "yud", text: "Schedules is updated\(activityType)")
        
        if !(activityType == .schedule_updated || activityType == .updatedCallSchedule || activityType == .analystJoined || activityType == .eventDelay){
            return
        }
        listener?()
    }
}
