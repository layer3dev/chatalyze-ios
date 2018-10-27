//
//  VideoActionView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class VideoActionView: ExtendedView {
    
    @IBOutlet var actionImage : UIImageView?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func mute(){
        actionImage?.image = UIImage(named : "newDisableCamera")
    }
    
    func unmute(){
        actionImage?.image = UIImage(named : "newCamera")
    }
}
