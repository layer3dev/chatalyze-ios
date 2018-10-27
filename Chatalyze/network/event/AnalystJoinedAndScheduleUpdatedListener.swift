//
//  AnalystJoinedAndScheduleUpdatedListener.swift
//  Chatalyze
//
//  Created by Mansa on 23/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class AnalystJoinedAndScheduleUpdatedListener{
    
    private var listener : (()->())?
    
    init(){
        initializeListener()
    }
    
    func setListener(listener : (()->())?){
        self.listener = listener
    }
    
    func initializeListener(){
        
        UserSocket.sharedInstance?.socket?.on("scheduled_call_updated", callback: {[weak self] (data, emitter) in
            
            self?.listener?()
        })
        
        
        UserSocket.sharedInstance?.socket?.on("analyst_joined", callback: {[weak self] (data, emitter) in
            
            self?.listener?()
        })
    }
    
}
