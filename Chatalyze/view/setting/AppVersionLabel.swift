//
//  AppVersionLabel.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AppVersionLabel: ExtendedLabel {

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
        self.text = "App Version " + AppInfoConfig.appversion
    }
    
}
