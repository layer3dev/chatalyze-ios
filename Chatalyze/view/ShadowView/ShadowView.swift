//
//  ShadowView.swift
//  Chatalyze
//
//  Created by Mansa on 05/11/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class ShadowView: ExtendedView {
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.layer.borderColor = UIColor(red: 232.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
    
//    override var bounds: CGRect{
//        didSet{
//            setupShadow()
//        }
//    }
//
//    private func setupShadow() {
//
//        self.layer.cornerRadius = 5
//        self.layer.shadowOffset = CGSize(width: 0, height: 3)
//        self.layer.shadowRadius = 2
//        self.layer.shadowOpacity = 0.4
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = UIScreen.main.scale
//    }
}
