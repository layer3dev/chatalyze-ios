//
//  AutographyCanvasProtocol.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 13/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

protocol AutographyCanvasProtocol{
    
    func touchesBegan(withPoint point : CGPoint)
    func touchesMoved(withPoint point : CGPoint)
    func touchesEnded(withPoint point : CGPoint)
    
}
