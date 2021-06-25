//
//  VideoActionView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class VideoActionView: ExtendedView {
    
    @IBOutlet var actionImg : UIButton?
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
        actionImg?.setImage(UIImage(named : "newDisableCamera"), for: .normal)
        self.layoutIfNeeded()
    }
    
    func unmute(){
        actionImg?.setImage(UIImage(named : "newCamera"), for: .normal)
        self.layoutIfNeeded()
    }
}
