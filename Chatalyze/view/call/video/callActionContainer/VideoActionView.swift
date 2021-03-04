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
    @IBOutlet var extendBtnWidthAnchor: NSLayoutConstraint?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func hideBtn(){
        // extend chat button to hide off before call get randered
        extendBtnWidthAnchor =  self.widthAnchor.constraint(equalToConstant: 0)
        self.layoutIfNeeded()
    }
    
    
    func showExtendBtn(){
        extendBtnWidthAnchor = self.widthAnchor.constraint(equalToConstant: 100)
        self.layoutIfNeeded()
    }
    
    func mute(){
        actionImage?.image = UIImage(named : "newDisableCamera")
    }
    
    func unmute(){
        actionImage?.image = UIImage(named : "newCamera")
    }
}
