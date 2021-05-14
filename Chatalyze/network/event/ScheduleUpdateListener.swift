//
//  AnalystJoinedAndScheduleUpdatedListener.swift
//  Chatalyze
//
//  Created by Mansa on 23/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class ScheduleUpdateListener{
    
    private var listener : (()->())?
    
    private var newEventInfo : (([EventInfo])->())?
    
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
    
    func setListenerForNewStartDate(newEventInfo : (([EventInfo])->())?){
           self.newEventInfo = newEventInfo
       }
    
    func initializeListener(){
        UserSocket.sharedInstance?.socket?.on("scheduled_call_updated", callback: {[weak self] (data, emitter) in
            
            guard let weakSelf = self
                else{
                    return
            }
            
            if(weakSelf.isReleased){
                return
            }
            weakSelf.listener?()
            let rawInfosString = data.JSONDescription()


                       guard let rawData = rawInfosString.data(using: .utf8)
                           else{
                               return
                       }


                       guard let jsonResponse = try? JSON(data : rawData)
                           else{
                               return
                       }

                      let rawInfo = jsonResponse.arrayValue

                       var eventArray:[EventInfo] = [EventInfo]()
                       for info in rawInfo{
                           let obj = EventInfo(info: info)
                           eventArray.append(obj)
                           weakSelf.newEventInfo?(eventArray)
                       }
        })
        

        //we don't need this
        /*UserSocket.sharedInstance?.socket?.on("analyst_joined", callback: {[weak self] (data, emitter) in
            
            self?.listener?()
        })*/
    }
}
