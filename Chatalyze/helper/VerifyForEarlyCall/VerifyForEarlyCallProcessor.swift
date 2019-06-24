//
//  VerifyForEarlyCallProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class VerifyForEarlyCallProcessor: NSObject {
    
    var listener = EventListener()
    var eventInfoArray:[EventInfo] = [EventInfo]()
    let eventDeletedListener = EventDeletedListener()
    
    override init() {
        super.init()
        
        initializeListener()
        self.fetchInfo()
        eventListener()
    }
    
    
    func eventListener(){
        
        eventDeletedListener.setListener {(deletedEventID) in
            
            for info in self.eventInfoArray {
                if ((info.startDate?.timeIntervalSince(Date()) ?? 0.0) < 900 && ((info.startDate?.timeIntervalSince(Date()) ?? 0.0) >= 0)) {

                    7
                    if info.id == Int(deletedEventID ?? "0"){
                        self.eventInfoArray.removeAll()
                        self.fetchInfo()
                    }
                    return
                }
            }
        }
    }

    func initializeListener(){
        
        listener.setListener {
            self.eventInfoArray.removeAll()
            self.fetchInfo()
        }
    }
    
    //****************
    
    func fetchInfo(){
        
        guard let roleId = SignedUserInfo.sharedInstance?.role else{
            return
        }
        
        if roleId == .user{
            return
        }
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return
        }
        
        Log.echo(key: "yud", text: "I hitted the webservice")
        
        FetchMySessionsProcessor().fetchInfo(id: id) { (success, info) in
            
            if success{
                if let array  = info {
                    if array.count > 0 {
                        self.eventInfoArray = array
                    }
                }
                return
            }
            return
        }
    }
    
    
    
    func verifyEarlyExistingCall(completion:(_ info:EventInfo?)->()) {
        
        for info in self.eventInfoArray {
            if ((info.startDate?.timeIntervalSince(Date()) ?? 0.0) < 900 && ((info.startDate?.timeIntervalSince(Date()) ?? 0.0) >= 0)) {
                completion(info)
                return
            }
        }
        completion(nil)
        return
    }
}
