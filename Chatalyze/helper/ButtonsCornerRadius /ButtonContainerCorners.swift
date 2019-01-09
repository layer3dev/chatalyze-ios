//
//  ButtonContainerCorners.swift
//  Chatalyze
//
//  Created by Mansa on 29/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ButtonContainerCorners:UIView{
    
    var isLoaded = false
    override func layoutSubviews(){
        super.layoutSubviews()
        
        if isLoaded{
            return
        }
        isLoaded = true
        paintInterface()
        return
    }
    
    
    func paintInterface(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            self.layer.cornerRadius = 5
            //self.layer.masksToBounds = true
            return
        }
        self.layer.cornerRadius = 3
        //self.layer.masksToBounds = true
        return
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
       
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize = CGSize(width: -1, height: 1), radius: CGFloat = 1, scale: Bool = true) {
        
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
