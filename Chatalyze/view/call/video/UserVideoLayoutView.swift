//
//  UserVideoLayoutView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 11/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class UserVideoLayoutView: VideoRootView {

    @IBOutlet var canvasContainer : CanvasContainer?
    
    var canvas : AutographyCanvas?{
        get{
            return canvasContainer?.canvas
        }
    }
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
