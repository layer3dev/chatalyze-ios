
//
//  SocketListenerCallback.swift
//  Rumpur
//
//  Created by Sumant Handa on 12/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import Foundation
import SwiftyJSON

class SocketListenerCallback{
    var listener : ((_ json : JSON?)->())?
    var action : String
    
    
    init(action : String, listener : ((_ json : JSON?)->())?){
        self.listener = listener
        self.action = action
    }
}
