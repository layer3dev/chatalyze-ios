

//
//  HostVideoRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 07/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostVideoRootView: VideoRootView {
    
    @IBOutlet var callInfoContainer : HostCallInfoContainerView?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func animateHeader() {
        
        if isStatusBarhiddenDuringAnimation == false {
            
            self.delegateCutsom?.visibleAnimateStatusBar()
            isStatusBarhiddenDuringAnimation = true
            return
        }
        
        isStatusBarhiddenDuringAnimation = false
        self.delegateCutsom?.hidingAnimateStatusBar()
    }    
}
