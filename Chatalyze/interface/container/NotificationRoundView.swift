//
//  NotificationRoundView.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 01/06/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit

class NotificationRoundView: ExtendedView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        initialization()
    }
    
    private func initialization(){
        paintInterface()
    }
    
    private func paintInterface(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
    }
    
}

