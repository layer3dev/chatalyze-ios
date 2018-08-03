//
//  SlotFlagInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 11/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

class SlotFlagInfo: NSObject {
    
    var isAutographRequested = false //local model info
    var isScreenshotSaved = false //local model info
    
    var isSelfieTimerInitiated = false // local model info
    var isHangedUp = false //when host hangup call on user
    
    func updateFlags(info : SlotFlagInfo){
        
        self.isAutographRequested = info.isAutographRequested
        self.isScreenshotSaved = info.isScreenshotSaved
        self.isSelfieTimerInitiated = info.isSelfieTimerInitiated
        self.isHangedUp = info.isHangedUp
    }
}
