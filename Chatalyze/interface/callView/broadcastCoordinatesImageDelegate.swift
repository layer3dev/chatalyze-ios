//
//  broadcastCoordinatesImageDelegate.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 17/09/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

protocol broadcastCoordinatesImageDelegate {
    
    func broadcastCoordinate(x : CGFloat, y : CGFloat, isContinous : Bool, reset : Bool)
}
