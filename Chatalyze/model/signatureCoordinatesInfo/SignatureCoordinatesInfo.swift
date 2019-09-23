//
//  SignatureCoordinatesInfo.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 23/09/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
class SignatureCoordinatesInfo {
    
    var currentPoint:CGPoint?
    var previousPoint:CGPoint?
    var previousPreviousPoint:CGPoint?
    var isSwiped = false
    var getBeginPoint = false
    var status = -1
    
    init(currentPoint:CGPoint?,previousPoint:CGPoint?,previousPreviousPoint:CGPoint?,isSwiped:Bool,getBeginPoint:Bool,status:Int) {
        
        
        self.currentPoint = currentPoint
        self.previousPoint = previousPoint
        self.previousPreviousPoint = previousPreviousPoint
        self.isSwiped = isSwiped
        self.getBeginPoint = getBeginPoint
        self.status = status
        
    }
    
    
}
