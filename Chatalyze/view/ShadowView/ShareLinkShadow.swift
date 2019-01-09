//
//  ShareLinkShadow.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class ShareLinkShadow: UIView {
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        
        var cornerSize:CGFloat = 3.0
        if UIDevice.current.userInterfaceIdiom == .pad{
            cornerSize = 5.0
        }
        self.layer.cornerRadius = cornerSize
        self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.layer.shadowRadius = 1.5
        self.layer.shadowOpacity = 0.4
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 3, height: 3)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
