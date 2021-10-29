//
//  SignatureCoordinatesInfo.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 23/09/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class SignatureCoordinatesInfo {
    
    var point = CGPoint()
    var isContinuos = false
    var isReset = false
    
    init(point:CGPoint,isContinous:Bool,isReset:Bool) {
        
        self.point = point
        self.isContinuos = isContinous
        self.isReset = isReset
    }
}
