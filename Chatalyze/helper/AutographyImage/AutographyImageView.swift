//
//  AutographyImageView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 13/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AutographyImageView: AspectHostImageView {
    
    var delegate : AutographyImageViewProtocol?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        delegate?.touchesBeganAutography(touches, with: event)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesMovedAutography(touches, with: event)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesEndedAutography(touches, with: event)
    }
    
}
