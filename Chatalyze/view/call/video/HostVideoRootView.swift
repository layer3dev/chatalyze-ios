

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
        
        if self.headerView?.alpha == 0 {
            UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
            self.delegateCutsom?.visibleAnimateStatusBar()
            UIView.animate(withDuration: 0.45) {
                self.headerView?.alpha = 1
            }
            self.layoutIfNeeded()
            return
        }
        
        self.delegateCutsom?.hidingAnimateStatusBar()
        UIView.animate(withDuration: 0.45) {
            self.headerView?.alpha = 0
        }
        self.layoutIfNeeded()
    }
    
}
