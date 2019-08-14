//
//  AutographyImageViewProtocol.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 13/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

protocol AutographyImageViewProtocol {
    
    func touchesBeganAutography(_ touches: Set<UITouch>, with event: UIEvent?)
    
    func touchesMovedAutography(_ touches: Set<UITouch>, with event: UIEvent?)
        
    func touchesEndedAutography(_ touches: Set<UITouch>, with event: UIEvent?)
}
