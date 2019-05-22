//
//  StickerView.swift
//  Chatalyze
//
//  Created by mansa infotech on 21/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class StickerView:UIView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.paintGradientColorOnJoinSessionButton()
    }
    
    func paintGradientColorOnJoinSessionButton() {
        
        let reqLayer = CAGradientLayer()
        reqLayer.colors = [UIColor(red: 249.0/255.0, green: 185.0/255.0, blue: 154.0/255.0, alpha: 1).cgColor,UIColor(red: 248.0/255.0, green: 144.0/255.0, blue: 118.0/255.0, alpha: 1).cgColor,UIColor(red: 248.0/255.0, green: 103.0/255.0, blue: 100.0/255.0, alpha: 1).cgColor]
        reqLayer.frame = self.bounds
        reqLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        reqLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.addSublayer(reqLayer)
    }
}
