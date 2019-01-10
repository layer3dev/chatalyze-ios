//
//  SetScheduleSessionShadow.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SetScheduleSessionShadow: UIView {
    
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
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor(red: 213.0/255.0, green: 227.0/255.0, blue: 233.0/255.0, alpha: 1).cgColor
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 3, height: 3)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
