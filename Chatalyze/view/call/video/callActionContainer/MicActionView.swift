//
//  MicActionView.swift
//  Rumpur
//
//  Created by Sumant Handa on 20/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class MicActionView: UIView {
    
    
//    @IBOutlet var actionImage : UIImageView?
    @IBOutlet var actionImage : UIButton?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func mute(){
        actionImage?.setImage(UIImage(named : "newMute"), for: .normal)
        layoutIfNeeded()
    }
    
    func unmute(){
        actionImage?.setImage(UIImage(named : "newMic"), for: .normal)
        layoutIfNeeded()
    }


}
