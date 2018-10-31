//
//  CallbackIdentifierInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 25/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class CallbackIdentifierInfo{
    private static var identifierCounter = 0
    private var callback : (()->())?
    private var identifier : Int = 0
    
    init(callback : @escaping (()->())) {
        self.callback = callback
        self.identifier = getUniqueIdentifier()
    }
    
    private func getUniqueIdentifier()->Int{
        CallbackIdentifierInfo.identifierCounter = CallbackIdentifierInfo.identifierCounter + 1
        return CallbackIdentifierInfo.identifierCounter
    }
    
    var uniqueIdentifier : Int{
        return identifier
    }
    
    var listener  : (()->())?{
        return callback
    }
    
}
