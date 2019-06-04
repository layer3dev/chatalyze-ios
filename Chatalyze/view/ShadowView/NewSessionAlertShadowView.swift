//
//  NewSessionAlertShadowView.swift
//  Chatalyze
//
//  Created by mansa infotech on 04/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import QuartzCore

class NewSessionAlertShadowView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        self.setupShadow()
    }
    
    private func setupShadow() {
        
        let radius:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 5:5
        
        self.dropShadow(color: UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1), opacity: 1, offSet: CGSize.zero, radius: radius, scale: true)
    }
}
