//
//  MemoryAnimationView.swift
//  Chatalyze
//
//  Created by mansa infotech on 16/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class MemoryAnimationView:UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.paintGradientColorOnJoinSessionButton()
    }
    
    func paintGradientColorOnJoinSessionButton() {
        
        let reqLayer = CAGradientLayer()
        reqLayer.colors = [UIColor(red: 132.0/255.0, green: 42.0/255.0, blue: 254.0/255.0, alpha: 1).cgColor,UIColor(red: 154.0/255.0, green: 89.0/255.0, blue: 236.0/255.0, alpha: 1).cgColor,UIColor(red: 199.0/255.0, green: 108.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor]
        reqLayer.frame = self.bounds
        reqLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        reqLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.addSublayer(reqLayer)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }    
}
